import Foundation

@MainActor
public final class EmergencyContactsViewModel: ObservableObject {
    @Published public var state = EmergencyContactsState()

    private let emergencyContactRepository: any EmergencyContactRepository

    public init(emergencyContactRepository: any EmergencyContactRepository) {
        self.emergencyContactRepository = emergencyContactRepository
    }

    public func load() async {
        state.isLoading = true
        state.error = nil

        let result = await emergencyContactRepository.getEmergencyContacts()

        switch result {
        case .success(let contacts):
            state.contacts = contacts
        case .failure(let err):
            state.error = Self.errorMessage(err)
        }

        state.isLoading = false
    }

    public func addContact() async {
        guard !state.newName.isEmpty, !state.newPhone.isEmpty else {
            state.error = "Name and phone are required."
            return
        }

        state.isSaving = true
        state.error = nil

        let contact = EmergencyContact(
            id: UUID().uuidString,
            userId: "",
            name: state.newName,
            relationship: state.newRelationship,
            phone: state.newPhone,
            email: state.newEmail.isEmpty ? nil : state.newEmail,
            isPrimary: state.contacts.isEmpty,
            order: state.contacts.count
        )

        let result = await emergencyContactRepository.addEmergencyContact(contact)

        switch result {
        case .success(let saved):
            state.contacts.append(saved)
            state.showAddSheet = false
            resetForm()
        case .failure(let err):
            state.error = Self.errorMessage(err)
        }

        state.isSaving = false
    }

    public func deleteContact(id: String) async {
        let result = await emergencyContactRepository.deleteEmergencyContact(id: id)
        if case .success = result {
            state.contacts.removeAll { $0.id == id }
        }
    }

    private func resetForm() {
        state.newName = ""
        state.newRelationship = ""
        state.newPhone = ""
        state.newEmail = ""
    }

    private static func errorMessage(_ err: APIError) -> String {
        switch err {
        case .offline: return "You appear to be offline."
        case .server(_, _, let msg): return msg
        default: return "An error occurred."
        }
    }
}
