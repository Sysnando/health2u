import Foundation

public protocol AllergyRepository: Sendable {
    func getAllergies() async -> Result<[Allergy], APIError>
    func createAllergy(name: String, severity: String?, notes: String?) async -> Result<Allergy, APIError>
    func updateAllergy(id: String, name: String?, severity: String?, notes: String?) async -> Result<Allergy, APIError>
    func deleteAllergy(id: String) async -> Result<Void, APIError>
}
