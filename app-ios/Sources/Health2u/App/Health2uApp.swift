import SwiftUI

#if os(iOS)
@main
public struct Health2uApp: App {
    @StateObject private var container = AppContainer()

    public init() {}

    public var body: some Scene {
        WindowGroup {
            RootNavigationView()
                .environmentObject(container)
        }
    }
}
#endif
