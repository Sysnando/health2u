import Foundation

public protocol EmergencyContactRepository: Sendable {
    func getEmergencyContacts() async -> Result<[EmergencyContact], APIError>
    func getEmergencyContact(id: String) async -> Result<EmergencyContact, APIError>
    func addEmergencyContact(_ contact: EmergencyContact) async -> Result<EmergencyContact, APIError>
    func updateEmergencyContact(_ contact: EmergencyContact) async -> Result<EmergencyContact, APIError>
    func deleteEmergencyContact(id: String) async -> Result<Void, APIError>
    func observeEmergencyContacts() -> AsyncStream<[EmergencyContact]>
}
