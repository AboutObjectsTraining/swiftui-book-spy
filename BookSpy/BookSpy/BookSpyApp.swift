import SwiftUI

@main
struct BookSpyApp: App {
    
    var body: some Scene {
        WindowGroup {
            MainTabBar()
        }
    }
    
    init() {
        configureNavigationBarAppearance()
        configureTabBarAppearance()
    }
}

struct MainTabBar: View {
    @StateObject var searchViewModel = SearchView.ViewModel()

    var body: some View {
        TabView {
            SearchView(viewModel: searchViewModel)
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            LibraryView(viewModel: searchViewModel)
                .tabItem {
                    Image(systemName: "building")
                    Text("Library")
                }
        }
    }
}

// MARK: - Global Appearance Configuration
extension BookSpyApp {
    
    static let titleTextAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.didotBold(size: 20),
        .foregroundColor: UIColor.systemBrown,
    ]
    
    static let largeTitleTextAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.didotBold(size: 36),
        .kern: 0.5,
    ]
    
    private func configureNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        appearance.titleTextAttributes = Self.titleTextAttributes
        appearance.largeTitleTextAttributes = Self.largeTitleTextAttributes
        
        let proxy = UINavigationBar.appearance()
        proxy.standardAppearance = appearance
        proxy.scrollEdgeAppearance = appearance
    }
    
    private func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.backgroundEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        
        let proxy = UITabBar.appearance()
        proxy.standardAppearance = appearance
        proxy.scrollEdgeAppearance = appearance
    }
}


// MARK: Fonts
extension UIFont {
    static func palatinoBold(size: CGFloat) -> UIFont {
        return UIFont(name: "Palatino-Bold", size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }
    
    static func didotBold(size: CGFloat) -> UIFont {
        return UIFont(name: "Didot-Bold", size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }

    static func zapfino(size: CGFloat) -> UIFont {
        return UIFont(name: "Zapfino", size: size) ?? UIFont.boldSystemFont(ofSize: size)
    }
}
