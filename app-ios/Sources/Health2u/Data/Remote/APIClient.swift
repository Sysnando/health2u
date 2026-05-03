import Foundation

public actor APIClient {
    private let baseURL: URL
    private let session: URLSession
    private let tokenProvider: @Sendable () async -> String?

    public init(
        baseURL: URL,
        session: URLSession = .shared,
        tokenProvider: @escaping @Sendable () async -> String? = { nil }
    ) {
        self.baseURL = baseURL
        self.session = session
        self.tokenProvider = tokenProvider
    }

    // MARK: - Auth

    public func login(email: String, password: String) async -> Result<AuthResponseDTO, APIError> {
        let body = LoginRequestDTO(email: email, password: password)
        guard let request = try? buildRequest(method: "POST", path: "auth/login", body: body) else {
            return .failure(.invalidResponse)
        }
        return await perform(request)
    }

    public func refresh(refreshToken: String) async -> Result<AuthResponseDTO, APIError> {
        let body = RefreshTokenRequestDTO(refreshToken: refreshToken)
        guard let request = try? buildRequest(method: "POST", path: "auth/refresh", body: body) else {
            return .failure(.invalidResponse)
        }
        return await perform(request)
    }

    public func logout() async -> Result<Void, APIError> {
        guard let request = await buildAuthorizedRequest(method: "POST", path: "auth/logout") else {
            return .failure(.invalidResponse)
        }
        return await performVoid(request)
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

        // Step 1: Get presigned upload URL
        struct PhotoUploadURLRequest: Encodable {
            let filename: String
            let content_type: String
        }
        struct PhotoUploadURLResponse: Decodable {
            let upload_url: String
            let key: String
            let expires_in: Int
        }

        guard let urlRequest = await buildAuthorizedRequest(
            method: "POST",
            path: "user/profile/photo-upload-url",
            body: PhotoUploadURLRequest(filename: filename, content_type: contentType)
        ) else {
            return .failure(.invalidResponse)
        }

        let uploadURLResult: Result<PhotoUploadURLResponse, APIError> = await perform(urlRequest)
        let uploadInfo: PhotoUploadURLResponse
        switch uploadURLResult {
        case .success(let info): uploadInfo = info
        case .failure(let error): return .failure(error)
        }

        // Step 2: PUT image directly to R2
        guard let r2URL = URL(string: uploadInfo.upload_url) else {
            return .failure(.invalidResponse)
        }
        var r2Request = URLRequest(url: r2URL)
        r2Request.httpMethod = "PUT"
        r2Request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        r2Request.httpBody = imageData

        do {
            let (_, r2Response) = try await session.data(for: r2Request)
            guard let httpResponse = r2Response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                return .failure(.network(code: (r2Response as? HTTPURLResponse)?.statusCode ?? -1))
            }
        } catch let error as URLError where error.code == .notConnectedToInternet || error.code == .networkConnectionLost {
            return .failure(.offline)
        } catch {
            return .failure(.network(code: (error as? URLError)?.errorCode ?? -1))
        }

        // Step 3: Update profile with the photo key as profile_picture_url
        struct ProfilePhotoUpdate: Encodable {
            let profile_picture_url: String
        }
        guard let updateRequest = await buildAuthorizedRequest(
            method: "PUT",
            path: "user/profile",
            body: ProfilePhotoUpdate(profile_picture_url: uploadInfo.key)
        ) else {
            return .failure(.invalidResponse)
        }
        return await perform(updateRequest)
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

        // Step 1: Get presigned upload URL
        struct UploadURLRequest: Encodable {
            let filename: String
            let content_type: String
        }
        struct UploadURLResponse: Decodable {
            let upload_url: String
            let key: String
            let expires_in: Int
        }

        guard let urlRequest = await buildAuthorizedRequest(
            method: "POST",
            path: "exams/upload-url",
            body: UploadURLRequest(filename: filename, content_type: contentType)
        ) else {
            return .failure(.invalidResponse)
        }

        let uploadURLResult: Result<UploadURLResponse, APIError> = await perform(urlRequest)
        let uploadInfo: UploadURLResponse
        switch uploadURLResult {
        case .success(let info): uploadInfo = info
        case .failure(let error): return .failure(error)
        }

        // Step 2: PUT file directly to R2 presigned URL
        guard let r2URL = URL(string: uploadInfo.upload_url) else {
            return .failure(.invalidResponse)
        }
        var r2Request = URLRequest(url: r2URL)
        r2Request.httpMethod = "PUT"
        r2Request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        r2Request.httpBody = fileData

        do {
            let (_, r2Response) = try await session.data(for: r2Request)
            guard let httpResponse = r2Response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                return .failure(.network(code: (r2Response as? HTTPURLResponse)?.statusCode ?? -1))
            }
        } catch let error as URLError where error.code == .notConnectedToInternet || error.code == .networkConnectionLost {
            return .failure(.offline)
        } catch {
            return .failure(.network(code: (error as? URLError)?.errorCode ?? -1))
        }

        // Step 3: Create exam record with the uploaded file key
        struct CreateExamRequest: Encodable {
            let title: String
            let type: String
            let date: Int64
            let notes: String?
            let key: String
        }

        let createBody = CreateExamRequest(
            title: metadata.title,
            type: metadata.type,
            date: Int64(metadata.date.timeIntervalSince1970 * 1000),
            notes: metadata.notes,
            key: uploadInfo.key
        )

        guard let createRequest = await buildAuthorizedRequest(method: "POST", path: "exams", body: createBody) else {
            return .failure(.invalidResponse)
        }

        return await perform(createRequest)
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

    private func perform<T: Decodable>(_ request: URLRequest) async -> Result<T, APIError> {
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

            let decoded = try JSONDecoder.health2u.decode(T.self, from: data)
            return .success(decoded)
        } catch let error as URLError where error.code == .notConnectedToInternet || error.code == .networkConnectionLost {
            return .failure(.offline)
        } catch is DecodingError {
            return .failure(.decoding("Failed to decode \(T.self)"))
        } catch {
            return .failure(.network(code: (error as? URLError)?.errorCode ?? -1))
        }
    }

    private func performVoid(_ request: URLRequest) async -> Result<Void, APIError> {
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

            return .success(())
        } catch let error as URLError where error.code == .notConnectedToInternet || error.code == .networkConnectionLost {
            return .failure(.offline)
        } catch {
            return .failure(.network(code: (error as? URLError)?.errorCode ?? -1))
        }
    }

    private func decodeErrorEnvelope<T>(data: Data, status: Int) -> Result<T, APIError> {
        if let envelope = try? JSONDecoder.health2u.decode(APIErrorEnvelope.self, from: data) {
            return .failure(.server(status: status, code: envelope.error.code, message: envelope.error.message))
        }
        return .failure(.network(code: status))
    }
}
