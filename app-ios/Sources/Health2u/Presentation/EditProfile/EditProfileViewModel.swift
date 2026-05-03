import Foundation

@MainActor
public final class EditProfileViewModel: ObservableObject {
    @Published public var state = EditProfileState()

    private let userRepository: any UserRepository

    public init(userRepository: any UserRepository) {
        self.userRepository = userRepository
    }

    public func load() async {
        state.isLoading = true
        state.error = nil

        let result = await userRepository.getProfile()

        switch result {
        case .success(let user):
            state.userId = user.id
            state.name = user.name
            state.email = user.email
            state.phone = user.phone ?? ""
            state.dateOfBirth = user.dateOfBirth
            state.gender = user.gender ?? ""
            state.heightCm = user.heightCm.map { String($0) } ?? ""
            state.weightKg = user.weightKg.map { String($0) } ?? ""
            state.bloodType = user.bloodType ?? ""
        case .failure(let err):
            state.error = Self.errorMessage(err)
        }

        state.isLoading = false
    }

    public func save() async {
        guard !state.name.isEmpty else {
            state.error = "Name is required."
            return
        }

        state.isSaving = true
        state.error = nil

        let updatedUser = User(
            id: state.userId,
            email: state.email,
            name: state.name,
            dateOfBirth: state.dateOfBirth,
            phone: state.phone.isEmpty ? nil : state.phone,
            gender: state.gender.isEmpty ? nil : state.gender,
            heightCm: Double(state.heightCm),
            weightKg: Double(state.weightKg),
            bloodType: state.bloodType.isEmpty ? nil : state.bloodType
        )

        let result = await userRepository.updateProfile(updatedUser)

        switch result {
        case .success:
            state.didSave = true
        case .failure(let err):
            state.error = Self.errorMessage(err)
        }

        state.isSaving = false
    }

    public func uploadPhoto(imageData: Data) async {
        state.isUploadingPhoto = true
        let result = await userRepository.uploadProfilePhoto(imageData: imageData, filename: "profile-photo.jpg")
        switch result {
        case .success(let user):
            state.name = user.name
            state.email = user.email
            state.phone = user.phone ?? ""
            state.dateOfBirth = user.dateOfBirth
        case .failure:
            state.error = "Failed to upload photo."
        }
        state.isUploadingPhoto = false
    }

    private static func errorMessage(_ err: APIError) -> String {
        switch err {
        case .offline: return "You appear to be offline."
        case .server(_, _, let msg): return msg
        default: return "An error occurred."
        }
    }
}
