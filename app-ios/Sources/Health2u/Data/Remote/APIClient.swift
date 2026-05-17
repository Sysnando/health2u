import Foundation
import os.log

private let log = Logger(subsystem: "com.health2u.ios", category: "APIClient")

public actor APIClient {
    private let baseURL: URL
    private let session: URLSession
    private let tokenProvider: @Sendable () async -> String?
    private let sessionStore: SessionStore?
    private var isRefreshing = false

    public init(
        baseURL: URL,
        session: URLSession = .shared,
        sessionStore: SessionStore? = nil,
        tokenProvider: @escaping @Sendable () async -> String? = { nil }
    ) {
        self.baseURL = baseURL
        self.session = session
        self.sessionStore = sessionStore
        self.tokenProvider = tokenProvider
        log.info("APIClient initialized with baseURL: \(baseURL.absoluteString)")
    }

    // MARK: - Auth

    public func login(email: String, password: String) async -> Result<AuthResponseDTO, APIError> {
        log.info("🔐 Login attempt for email: \(email)")
        let body = LoginRequestDTO(email: email, password: password)
        guard let request = try? buildRequest(method: "POST", path: "auth/login", body: body) else {
            log.error("🔐 Login failed: could not build request")
            return .failure(.invalidResponse)
        }
        let result: Result<AuthResponseDTO, APIError> = await perform(request)
        if case .failure(let err) = result { log.error("🔐 Login failed: \(String(describing: err))") }
        else { log.info("🔐 Login succeeded") }
        return result
    }

    public func refresh(refreshToken: String) async -> Result<AuthResponseDTO, APIError> {
        log.info("🔄 Refreshing access token")
        let body = RefreshTokenRequestDTO(refreshToken: refreshToken)
        guard let request = try? buildRequest(method: "POST", path: "auth/refresh", body: body) else {
            log.error("🔄 Token refresh failed: could not build request")
            return .failure(.invalidResponse)
        }
        let result: Result<AuthResponseDTO, APIError> = await perform(request)
        if case .failure(let err) = result { log.error("🔄 Token refresh failed: \(String(describing: err))") }
        else { log.info("🔄 Token refresh succeeded") }
        return result
    }

    public func logout() async -> Result<Void, APIError> {
        log.info("🚪 Logout requested")
        guard let request = await buildAuthorizedRequest(method: "POST", path: "auth/logout") else {
            return .failure(.invalidResponse)
        }
        let result = await performVoid(request)
        if case .failure(let err) = result { log.error("🚪 Logout failed: \(String(describing: err))") }
        else { log.info("🚪 Logout succeeded") }
        return result
    }

    // MARK: - User Profile

    public func getProfile() async -> Result<UserDTO, APIError> {
        guard let request = await buildAuthorizedRequest(method: "GET", path: "user/profile") else {
            return .failure(.invalidResponse)
        }
        return await perform(request)
    }

    public func updateProfile(_ dto: UserDTO) async -> Result<UserDTO, APIError> {
        guard let request = await buildAuthorizedRequest(method: "PUT", path: "user/profile", body: dto) else {
            return .failure(.invalidResponse)
        }
        return await perform(request)
    }

    public func uploadProfilePhoto(imageData: Data, filename: String) async -> Result<UserDTO, APIError> {
        let contentType = filename.hasSuffix(".png") ? "image/png" : "image/jpeg"
        let boundary = "Health2u-\(UUID().uuidString)"

        let url = baseURL.appendingPathComponent("user/profile/photo-upload")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        if let token = await tokenProvider() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(contentType)\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        return await perform(request)
    }

    // MARK: - Exams

    public func getExams(filter: String?) async -> Result<[ExamDTO], APIError> {
        var path = "exams"
        if let filter, !filter.isEmpty {
            path += "?filter=\(filter.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? filter)"
        }
        guard let request = await buildAuthorizedRequest(method: "GET", path: path) else {
            return .failure(.invalidResponse)
        }
        return await perform(request)
    }

    public func getExam(id: String) async -> Result<ExamDTO, APIError> {
        guard let request = await buildAuthorizedRequest(method: "GET", path: "exams/\(id)") else {
            return .failure(.invalidResponse)
        }
        return await perform(request)
    }

    public func uploadExam(metadata: ExamUploadMetadata, fileData: Data, filename: String) async -> Result<ExamDTO, APIError> {
        let contentType = Self.mimeType(for: filename)
        let boundary = "Health2u-\(UUID().uuidString)"

        let url = baseURL.appendingPathComponent("exams/upload")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        // Backend runs OpenAI analysis synchronously before inserting the exam,
        // which on a multi-page PDF can take 60+ seconds. Default URLSession
        // timeout (60s) is too tight — give the request 3 minutes.
        request.timeoutInterval = 180
        if let token = await tokenProvider() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        // Build multipart body
        var body = Data()
        let dateMs = String(Int64(metadata.date.timeIntervalSince1970 * 1000))

        for (name, value) in [("title", metadata.title), ("type", metadata.type), ("date", dateMs)] {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        if let notes = metadata.notes {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"notes\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(notes)\r\n".data(using: .utf8)!)
        }

        // File part
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(contentType)\r\n\r\n".data(using: .utf8)!)
        body.append(fileData)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        let bodySize = body.count
        log.info("📤 [API] POST exams/upload — body=\(bodySize) bytes, file=\(fileData.count) bytes, timeout=\(request.timeoutInterval)s, title='\(metadata.title)', type='\(metadata.type)'")
        let t0 = Date()

        // We do bespoke handling here so a 422 NOT_A_MEDICAL_DOCUMENT envelope
        // surfaces as a dedicated APIError instead of a generic .server(...).
        do {
            let (data, response) = try await session.data(for: request)
            let elapsed = Date().timeIntervalSince(t0)
            guard let httpResponse = response as? HTTPURLResponse else {
                log.error("📤 [API] No HTTPURLResponse after \(String(format: "%.2f", elapsed))s")
                return .failure(.invalidResponse)
            }
            log.info("📤 [API] HTTP \(httpResponse.statusCode) after \(String(format: "%.2f", elapsed))s — \(data.count) bytes")

            if httpResponse.statusCode == 401 {
                log.warning("📤 [API] 401 unauthorized")
                return .failure(.unauthorized)
            }

            if httpResponse.statusCode == 422 {
                if let envelope = try? JSONDecoder.health2u.decode(APIErrorEnvelope.self, from: data),
                   envelope.error.code == "NOT_A_MEDICAL_DOCUMENT" {
                    log.warning("📤 [API] 422 NOT_A_MEDICAL_DOCUMENT: \(envelope.error.message)")
                    return .failure(.notAMedicalDocument(reason: envelope.error.message))
                }
                log.error("📤 [API] 422 (other) — body=\(String(data: data, encoding: .utf8) ?? "<binary>")")
                return decodeErrorEnvelope(data: data, status: httpResponse.statusCode)
            }

            guard (200..<300).contains(httpResponse.statusCode) else {
                log.error("📤 [API] non-2xx \(httpResponse.statusCode) — body=\(String(data: data, encoding: .utf8) ?? "<binary>")")
                return decodeErrorEnvelope(data: data, status: httpResponse.statusCode)
            }

            do {
                let decoded = try JSONDecoder.health2u.decode(ExamDTO.self, from: data)
                log.info("📤 [API] ✅ Decoded ExamDTO — id=\(decoded.id) title='\(decoded.title)'")
                return .success(decoded)
            } catch {
                log.error("📤 [API] Decode ExamDTO failed: \(String(describing: error)) — raw=\(String(data: data, encoding: .utf8) ?? "<binary>")")
                return .failure(.decoding("Failed to decode ExamDTO"))
            }
        } catch let error as URLError where error.code == .notConnectedToInternet || error.code == .networkConnectionLost {
            let elapsed = Date().timeIntervalSince(t0)
            log.error("📤 [API] Offline after \(String(format: "%.2f", elapsed))s")
            return .failure(.offline)
        } catch let error as URLError where error.code == .timedOut {
            let elapsed = Date().timeIntervalSince(t0)
            log.error("📤 [API] ⏰ Timeout after \(String(format: "%.2f", elapsed))s (limit was \(request.timeoutInterval)s) — backend may still complete and save the exam")
            return .failure(.network(code: URLError.timedOut.rawValue))
        } catch {
            let elapsed = Date().timeIntervalSince(t0)
            let urlErr = error as? URLError
            log.error("📤 [API] Network error after \(String(format: "%.2f", elapsed))s — code=\(urlErr?.errorCode ?? -1) desc=\(error.localizedDescription)")
            return .failure(.network(code: urlErr?.errorCode ?? -1))
        }
    }

    public func reanalyzeExam(id: String) async -> Result<ExamDTO, APIError> {
        guard let request = await buildAuthorizedRequest(method: "POST", path: "exams/\(id)/analyze") else {
            return .failure(.invalidResponse)
        }
        return await perform(request)
    }

    private static func mimeType(for filename: String) -> String {
        let ext = (filename as NSString).pathExtension.lowercased()
        switch ext {
        case "pdf": return "application/pdf"
        case "jpg", "jpeg": return "image/jpeg"
        case "png": return "image/png"
        default: return "application/octet-stream"
        }
    }

    public func getExamFile(id: String) async -> Result<URL, APIError> {
        guard let request = await buildAuthorizedRequest(method: "GET", path: "exams/\(id)/file") else {
            return .failure(.invalidResponse)
        }

        do {
            let (data, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(.invalidResponse)
            }

            if httpResponse.statusCode == 401 {
                return .failure(.unauthorized)
            }

            guard (200..<300).contains(httpResponse.statusCode) else {
                return decodeErrorEnvelope(data: data, status: httpResponse.statusCode)
            }

            struct FileURLResponse: Decodable { let url: String }
            guard let decoded = try? JSONDecoder.health2u.decode(FileURLResponse.self, from: data),
                  let url = URL(string: decoded.url) else {
                return .failure(.decoding("Failed to decode file URL response"))
            }
            return .success(url)
        } catch let error as URLError where error.code == .notConnectedToInternet || error.code == .networkConnectionLost {
            return .failure(.offline)
        } catch {
            return .failure(.network(code: (error as? URLError)?.errorCode ?? -1))
        }
    }

    public func deleteExam(id: String) async -> Result<Void, APIError> {
        guard let request = await buildAuthorizedRequest(method: "DELETE", path: "exams/\(id)") else {
            return .failure(.invalidResponse)
        }
        return await performVoid(request)
    }

    // MARK: - Appointments

    public func getAppointments() async -> Result<[AppointmentDTO], APIError> {
        guard let request = await buildAuthorizedRequest(method: "GET", path: "appointments") else {
            return .failure(.invalidResponse)
        }
        return await perform(request)
    }

    public func createAppointment(_ dto: AppointmentDTO) async -> Result<AppointmentDTO, APIError> {
        guard let request = await buildAuthorizedRequest(method: "POST", path: "appointments", body: dto) else {
            return .failure(.invalidResponse)
        }
        return await perform(request)
    }

    public func updateAppointment(id: String, _ dto: AppointmentDTO) async -> Result<AppointmentDTO, APIError> {
        guard let request = await buildAuthorizedRequest(method: "PUT", path: "appointments/\(id)", body: dto) else {
            return .failure(.invalidResponse)
        }
        return await perform(request)
    }

    public func deleteAppointment(id: String) async -> Result<Void, APIError> {
        guard let request = await buildAuthorizedRequest(method: "DELETE", path: "appointments/\(id)") else {
            return .failure(.invalidResponse)
        }
        return await performVoid(request)
    }

    // MARK: - Insights

    public func getInsights() async -> Result<[HealthInsightDTO], APIError> {
        guard let request = await buildAuthorizedRequest(method: "GET", path: "insights") else {
            return .failure(.invalidResponse)
        }

        do {
            let (data, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(.invalidResponse)
            }

            if httpResponse.statusCode == 401 {
                return .failure(.unauthorized)
            }

            guard (200..<300).contains(httpResponse.statusCode) else {
                return decodeErrorEnvelope(data: data, status: httpResponse.statusCode)
            }

            let envelope = try JSONDecoder.health2u.decode(HealthInsightsResponseDTO.self, from: data)
            return .success(envelope.insights)
        } catch let error as URLError where error.code == .notConnectedToInternet || error.code == .networkConnectionLost {
            return .failure(.offline)
        } catch is DecodingError {
            return .failure(.decoding("Failed to decode HealthInsightsResponseDTO"))
        } catch {
            return .failure(.network(code: (error as? URLError)?.errorCode ?? -1))
        }
    }

    // MARK: - Emergency Contacts

    public func getEmergencyContacts() async -> Result<[EmergencyContactDTO], APIError> {
        guard let request = await buildAuthorizedRequest(method: "GET", path: "emergency-contacts") else {
            return .failure(.invalidResponse)
        }
        return await perform(request)
    }

    public func createEmergencyContact(_ dto: EmergencyContactDTO) async -> Result<EmergencyContactDTO, APIError> {
        guard let request = await buildAuthorizedRequest(method: "POST", path: "emergency-contacts", body: dto) else {
            return .failure(.invalidResponse)
        }
        return await perform(request)
    }

    public func updateEmergencyContact(id: String, _ dto: EmergencyContactDTO) async -> Result<EmergencyContactDTO, APIError> {
        guard let request = await buildAuthorizedRequest(method: "PUT", path: "emergency-contacts/\(id)", body: dto) else {
            return .failure(.invalidResponse)
        }
        return await perform(request)
    }

    public func deleteEmergencyContact(id: String) async -> Result<Void, APIError> {
        guard let request = await buildAuthorizedRequest(method: "DELETE", path: "emergency-contacts/\(id)") else {
            return .failure(.invalidResponse)
        }
        return await performVoid(request)
    }

    // MARK: - Allergies

    public func getAllergies() async -> Result<[AllergyDTO], APIError> {
        guard let request = await buildAuthorizedRequest(method: "GET", path: "allergies") else { return .failure(.invalidResponse) }
        return await perform(request)
    }

    public func createAllergy(name: String, severity: String?, notes: String?) async -> Result<AllergyDTO, APIError> {
        struct Body: Encodable { let name: String; let severity: String?; let notes: String? }
        guard let request = await buildAuthorizedRequest(method: "POST", path: "allergies", body: Body(name: name, severity: severity, notes: notes)) else { return .failure(.invalidResponse) }
        return await perform(request)
    }

    public func updateAllergy(id: String, name: String?, severity: String?, notes: String?) async -> Result<AllergyDTO, APIError> {
        struct Body: Encodable { let name: String?; let severity: String?; let notes: String? }
        guard let request = await buildAuthorizedRequest(method: "PUT", path: "allergies/\(id)", body: Body(name: name, severity: severity, notes: notes)) else { return .failure(.invalidResponse) }
        return await perform(request)
    }

    public func deleteAllergy(id: String) async -> Result<Void, APIError> {
        guard let request = await buildAuthorizedRequest(method: "DELETE", path: "allergies/\(id)") else { return .failure(.invalidResponse) }
        return await performVoid(request)
    }

    // MARK: - Private Helpers

    private func buildRequest<T: Encodable>(method: String, path: String, body: T) throws -> URLRequest {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder.health2u.encode(body)
        return request
    }

    private func buildAuthorizedRequest(method: String, path: String) async -> URLRequest? {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.httpMethod = method
        if let token = await tokenProvider() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        return request
    }

    private func buildAuthorizedRequest<T: Encodable>(method: String, path: String, body: T) async -> URLRequest? {
        let url = baseURL.appendingPathComponent(path)
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = await tokenProvider() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        do {
            request.httpBody = try JSONEncoder.health2u.encode(body)
        } catch {
            return nil
        }
        return request
    }

    private func perform<T: Decodable>(_ request: URLRequest, isRetry: Bool = false) async -> Result<T, APIError> {
        let method = request.httpMethod ?? "?"
        let path = request.url?.path ?? "?"
        log.debug("📡 \(method) \(path) → sending\(isRetry ? " (retry)" : "")")
        do {
            let (data, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                log.error("📡 \(method) \(path) → no HTTPURLResponse")
                return .failure(.invalidResponse)
            }
            log.debug("📡 \(method) \(path) → HTTP \(httpResponse.statusCode) (\(data.count) bytes)")

            if httpResponse.statusCode == 401 && !isRetry {
                log.warning("📡 \(method) \(path) → 401, attempting token refresh")
                if await attemptRefresh() {
                    var retryRequest = request
                    if let token = await tokenProvider() {
                        retryRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                    }
                    return await perform(retryRequest, isRetry: true)
                }
                return .failure(.unauthorized)
            }

            if httpResponse.statusCode == 401 {
                log.error("📡 \(method) \(path) → 401 after retry, unauthorized")
                return .failure(.unauthorized)
            }

            guard (200..<300).contains(httpResponse.statusCode) else {
                log.error("📡 \(method) \(path) → server error \(httpResponse.statusCode)")
                return decodeErrorEnvelope(data: data, status: httpResponse.statusCode)
            }

            let decoded = try JSONDecoder.health2u.decode(T.self, from: data)
            return .success(decoded)
        } catch let error as URLError where error.code == .notConnectedToInternet || error.code == .networkConnectionLost {
            log.error("📡 \(method) \(path) → offline")
            return .failure(.offline)
        } catch is DecodingError {
            log.error("📡 \(method) \(path) → decoding failed for \(String(describing: T.self))")
            return .failure(.decoding("Failed to decode \(T.self)"))
        } catch {
            log.error("📡 \(method) \(path) → network error: \(error.localizedDescription)")
            return .failure(.network(code: (error as? URLError)?.errorCode ?? -1))
        }
    }

    private func performVoid(_ request: URLRequest, isRetry: Bool = false) async -> Result<Void, APIError> {
        let method = request.httpMethod ?? "?"
        let path = request.url?.path ?? "?"
        log.debug("📡 \(method) \(path) → sending (void)\(isRetry ? " (retry)" : "")")
        do {
            let (data, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse else {
                log.error("📡 \(method) \(path) → no HTTPURLResponse")
                return .failure(.invalidResponse)
            }
            log.debug("📡 \(method) \(path) → HTTP \(httpResponse.statusCode)")

            if httpResponse.statusCode == 401 && !isRetry {
                log.warning("📡 \(method) \(path) → 401, attempting token refresh")
                if await attemptRefresh() {
                    var retryRequest = request
                    if let token = await tokenProvider() {
                        retryRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                    }
                    return await performVoid(retryRequest, isRetry: true)
                }
                return .failure(.unauthorized)
            }

            if httpResponse.statusCode == 401 {
                log.error("📡 \(method) \(path) → 401 after retry, unauthorized")
                return .failure(.unauthorized)
            }

            guard (200..<300).contains(httpResponse.statusCode) else {
                log.error("📡 \(method) \(path) → server error \(httpResponse.statusCode)")
                return decodeErrorEnvelope(data: data, status: httpResponse.statusCode)
            }

            return .success(())
        } catch let error as URLError where error.code == .notConnectedToInternet || error.code == .networkConnectionLost {
            log.error("📡 \(method) \(path) → offline")
            return .failure(.offline)
        } catch {
            log.error("📡 \(method) \(path) → network error: \(error.localizedDescription)")
            return .failure(.network(code: (error as? URLError)?.errorCode ?? -1))
        }
    }

    private func attemptRefresh() async -> Bool {
        guard let sessionStore, !isRefreshing else {
            log.debug("🔄 Refresh skipped (no store or already refreshing)")
            return false
        }
        isRefreshing = true
        defer { isRefreshing = false }

        guard let rt = await sessionStore.refreshToken() else {
            log.warning("🔄 No refresh token available")
            return false
        }
        switch await refresh(refreshToken: rt) {
        case .success(let resp):
            do {
                try await sessionStore.setSession(
                    userId: resp.user.id,
                    accessToken: resp.accessToken,
                    refreshToken: resp.refreshToken
                )
                log.info("🔄 Token refresh succeeded, session updated")
                return true
            } catch {
                log.error("🔄 Token refresh succeeded but session save failed: \(error.localizedDescription)")
                return false
            }
        case .failure:
            log.error("🔄 Token refresh failed, clearing session")
            try? await sessionStore.clear()
            return false
        }
    }

    private func decodeErrorEnvelope<T>(data: Data, status: Int) -> Result<T, APIError> {
        if let envelope = try? JSONDecoder.health2u.decode(APIErrorEnvelope.self, from: data) {
            return .failure(.server(status: status, code: envelope.error.code, message: envelope.error.message))
        }
        return .failure(.network(code: status))
    }
}
