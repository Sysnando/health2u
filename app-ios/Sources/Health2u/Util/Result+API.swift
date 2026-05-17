import Foundation

public enum APIError: Error, Equatable, Sendable {
    case network(code: Int)
    case decoding(String)
    case server(status: Int, code: String, message: String)
    case unauthorized
    case offline
    case invalidResponse
    case notAMedicalDocument(reason: String)
}

public extension JSONDecoder {
    static var health2u: JSONDecoder {
        let d = JSONDecoder()
        d.keyDecodingStrategy = .convertFromSnakeCase
        d.dateDecodingStrategy = .millisecondsSince1970
        return d
    }
}

public extension JSONEncoder {
    static var health2u: JSONEncoder {
        let e = JSONEncoder()
        e.keyEncodingStrategy = .convertToSnakeCase
        e.dateEncodingStrategy = .millisecondsSince1970
        return e
    }
}

public struct APIErrorEnvelope: Decodable, Sendable {
    public let error: APIErrorBody
}

public struct APIErrorBody: Decodable, Sendable {
    public let code: String
    public let message: String
}
