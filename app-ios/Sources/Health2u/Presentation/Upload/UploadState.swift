import Foundation

public struct UploadState: Equatable {
    public var title: String = ""
    public var type: String = "Labs"
    public var date: Date = Date()
    public var notes: String = ""
    public var filename: String? = nil
    public var imageData: Data? = nil
    public var fileData: Data? = nil
    public var isUploading: Bool = false
    public var error: String? = nil
    public var didSucceed: Bool = false

    public init() {}
}
