import SwiftUI

public struct EmergencyContactsView: View {
    @StateObject private var viewModel: EmergencyContactsViewModel

    public init(viewModel: EmergencyContactsViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }

    public var body: some View {
        Group {
            if viewModel.state.isLoading && viewModel.state.contacts.isEmpty {
                LoadingIndicator(message: "Loading contacts...")
            } else if let error = viewModel.state.error, viewModel.state.contacts.isEmpty {
                EmptyState(
                    icon: "person.2",
                    title: "Unable to load contacts",
                    message: error,
                    actionTitle: "Retry",
                    action: { Task { await viewModel.load() } }
                )
            } else if viewModel.state.contacts.isEmpty {
                emptyState
            } else {
                content
            }
        }
        .background(Color.background)
        .navigationTitle("Emergency Contacts")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button { viewModel.state.showAddSheet = true } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
            }
        }
        .sheet(isPresented: $viewModel.state.showAddSheet) {
            addContactSheet
        }
        .task { await viewModel.load() }
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: Dimensions.Space.l) {
            Spacer()

            Circle()
                .fill(Color.surfaceContainerLow)
                .frame(width: 96, height: 96)
                .overlay(
                    Image(systemName: "person.2.slash")
                        .font(.system(size: 36))
                        .foregroundColor(.outlineVariant)
                )

            VStack(spacing: Dimensions.Space.s) {
                Text("No Emergency Contacts")
                    .font(Typography.titleMedium)
                    .foregroundColor(.onSurface)
                Text("Add your emergency contacts so they can be reached quickly when needed.")
                    .font(Typography.bodyMedium)
                    .foregroundColor(.onSurfaceVariant)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Dimensions.Space.xl)
            }

            Button {
                viewModel.state.showAddSheet = true
            } label: {
                HStack(spacing: Dimensions.Space.s) {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .semibold))
                    Text("Add Contact")
                        .font(Typography.button)
                }
                .foregroundColor(.surfaceContainerLowest)
                .padding(.horizontal, Dimensions.Space.l)
                .frame(height: Dimensions.Size.button)
                .background(Color.secondary)
                .clipShape(RoundedRectangle(cornerRadius: Dimensions.CornerRadius.xl))
            }

            Spacer()
        }
    }

    // MARK: - Content

    private var content: some View {
        ScrollView {
            LazyVStack(spacing: Dimensions.Space.s) {
                ForEach(viewModel.state.contacts) { contact in
                    contactCard(contact)
                }
            }
            .padding(Dimensions.Space.m)
        }
    }

    // MARK: - Contact Card

    private func contactCard(_ contact: EmergencyContact) -> some View {
        HStack(spacing: Dimensions.Space.m) {
            // Avatar
            Circle()
                .fill(avatarColor(contact.name))
                .frame(width: 48, height: 48)
                .overlay(
                    Text(contactInitials(contact.name))
                        .font(Typography.titleMedium)
                        .foregroundColor(.surfaceContainerLowest)
                )

            // Info
            VStack(alignment: .leading, spacing: Dimensions.Space.xxs) {
                HStack(spacing: Dimensions.Space.s) {
                    Text(contact.name)
                        .font(Typography.titleMedium)
                        .foregroundColor(.onSurface)

                    if contact.isPrimary {
                        Text("Primary")
                            .font(Typography.labelSmall)
                            .foregroundColor(.onTertiaryContainer)
                            .padding(.horizontal, Dimensions.Space.s)
                            .padding(.vertical, Dimensions.Space.xxs)
                            .background(Color.tertiaryFixed.opacity(0.3))
                            .cornerRadius(Dimensions.CornerRadius.s)
                    }
                }

                Text(contact.relationship)
                    .font(Typography.labelSmall)
                    .foregroundColor(.onSurfaceVariant)
                    .padding(.horizontal, Dimensions.Space.s)
                    .padding(.vertical, Dimensions.Space.xxs)
                    .background(Color.surfaceContainerLow)
                    .cornerRadius(Dimensions.CornerRadius.s)

                Text(contact.phone)
                    .font(Typography.bodySmall)
                    .foregroundColor(.onSurfaceVariant)
            }

            Spacer()

            // Delete button
            Button {
                Task { await viewModel.deleteContact(id: contact.id) }
            } label: {
                Image(systemName: "trash")
                    .font(.system(size: 16))
                    .foregroundColor(.error)
            }
        }
        .padding(Dimensions.Space.m)
        .background(Color.surfaceContainerLowest)
        .cornerRadius(Dimensions.CornerRadius.l)
    }

    // MARK: - Add Contact Sheet

    private var addContactSheet: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Dimensions.Space.l) {
                    // Header illustration
                    Circle()
                        .fill(Color.secondaryFixed.opacity(0.3))
                        .frame(width: 72, height: 72)
                        .overlay(
                            Image(systemName: "person.badge.plus")
                                .font(.system(size: 28))
                                .foregroundColor(.secondary)
                        )
                        .padding(.top, Dimensions.Space.m)

                    VStack(spacing: Dimensions.Space.m) {
                        H2UTextField(
                            title: "Name",
                            text: $viewModel.state.newName,
                            placeholder: "Contact name"
                        )
                        H2UTextField(
                            title: "Relationship",
                            text: $viewModel.state.newRelationship,
                            placeholder: "e.g. Spouse, Parent, Sibling"
                        )
                        H2UTextField(
                            title: "Phone",
                            text: $viewModel.state.newPhone,
                            placeholder: "Phone number",
                            keyboardType: .phone
                        )
                        H2UTextField(
                            title: "Email",
                            text: $viewModel.state.newEmail,
                            placeholder: "Email (optional)",
                            keyboardType: .email
                        )
                    }

                    if let error = viewModel.state.error {
                        Text(error)
                            .font(Typography.labelSmall)
                            .foregroundColor(.error)
                    }

                    PrimaryButton(
                        title: "Add Contact",
                        isLoading: viewModel.state.isSaving
                    ) {
                        Task { await viewModel.addContact() }
                    }
                }
                .padding(Dimensions.Space.m)
            }
            .background(Color.background)
            .navigationTitle("Add Contact")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { viewModel.state.showAddSheet = false }
                        .foregroundColor(.secondary)
                }
            }
        }
    }

    // MARK: - Helpers

    private func contactInitials(_ name: String) -> String {
        let parts = name.split(separator: " ")
        if parts.count >= 2 {
            return "\(parts[0].prefix(1))\(parts[1].prefix(1))".uppercased()
        }
        return String(name.prefix(2)).uppercased()
    }

    private func avatarColor(_ name: String) -> Color {
        let colors: [Color] = [.secondary, .onTertiaryContainer, .surfaceTint, .warningOrange]
        let index = abs(name.hashValue) % colors.count
        return colors[index]
    }
}
