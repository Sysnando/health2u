import Foundation

@MainActor
public final class AllergiesViewModel: ObservableObject {
    @Published public var state = AllergiesState()
    private let allergyRepository: any AllergyRepository

    public init(allergyRepository: any AllergyRepository) {
        self.allergyRepository = allergyRepository
    }

    public func load() async {
        state.isLoading = true
        state.error = nil
        switch await allergyRepository.getAllergies() {
        case .success(let list): state.allergies = list
        case .failure: state.error = "Failed to load allergies."
        }
        state.isLoading = false
    }

    public func add() async {
        guard !state.newName.isEmpty else { return }
        state.isSaving = true
        let result = await allergyRepository.createAllergy(
            name: state.newName,
            severity: state.newSeverity.isEmpty ? nil : state.newSeverity,
            notes: state.newNotes.isEmpty ? nil : state.newNotes
        )
        if case .success(let allergy) = result {
            state.allergies.append(allergy)
            state.newName = ""
            state.newSeverity = ""
            state.newNotes = ""
            state.showAddSheet = false
        }
        state.isSaving = false
    }

    public func delete(id: String) async {
        if case .success = await allergyRepository.deleteAllergy(id: id) {
            state.allergies.removeAll { $0.id == id }
        }
    }
}
