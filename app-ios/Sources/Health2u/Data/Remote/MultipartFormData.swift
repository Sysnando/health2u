import Foundation

public struct MultipartFormData: Sendable {
    public let boundary: String
    public private(set) var bodyData: Data = Data()

    public init() {
        self.boundary = "Boundary-\(UUID().uuidString)"
    }

    public mutating func append(name: String, value: String) {
        let fieldData = "--\(boundary)\r\nContent-Disposition: form-data; name=\"\(name)\"\r\n\r\n\(value)\r\n"
        bodyData.append(fieldData.data(using: .utf8)!)
    }

    public mutating func append(name: String, filename: String, mimeType: String, data: Data) {
        var header = "--\(boundary)\r\n"
        header += "Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(filename)\"\r\n"
        header += "Content-Type: \(mimeType)\r\n\r\n"
        bodyData.append(header.data(using: .utf8)!)
        bodyData.append(data)
        bodyData.append("\r\n".data(using: .utf8)!)
    }

    public mutating func finalize() {
        bodyData.append("--\(boundary)--\r\n".data(using: .utf8)!)
    }

    public var contentType: String {
        "multipart/form-data; boundary=\(boundary)"
    }
}
