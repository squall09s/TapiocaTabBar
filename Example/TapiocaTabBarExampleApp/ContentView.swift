//
//  ContentView.swift
//  TapiocaTabBarExampleApp
//
//  Created by Nicolas Laurent on 24/04/2025.
//

import SwiftUI
import TapiocaTabBar


enum DemoTab: Int, CaseIterable, Identifiable {
    
    case home
    case favorites
    case messages
    case friends
    case profile
    
    var id: Int { rawValue }
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .favorites:
            return "Favorites"
        case .messages:
            return "Messages"
        case .friends:
            return "Friends"
        case .profile:
            return "Profile"
        }
    }
    
    var icon: Image {
        switch self {
        case .home:
            return Image("tab_ic_0")
        case .favorites:
            return Image("tab_ic_1")
        case .messages:
            return Image("tab_ic_2")
        case .friends:
            return Image("tab_ic_3")
        case .profile:
            return Image("tab_ic_4")
        }
    }
    
    var item: TapiocaTabBarItem {
        TapiocaTabBarItem(icon: icon, title: title)
    }
}


struct ContentView: View {
    
    
    @State private var selectedTab: DemoTab = .home
    
    let tabs = DemoTab.allCases.map(\.item)
    
    var body: some View {
        
        ZStack {
            
            
            selectedView(for: selectedTab)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            TapiocaTabBar(
                selectedIndex: Binding(
                    get: { selectedTab.rawValue },
                    set: { newValue in
                        if let newTab = DemoTab(rawValue: newValue) {
                            selectedTab = newTab
                        }
                    }
                ),
                items: tabs
            )
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
    }
    
    @ViewBuilder
    private func selectedView(for tab: DemoTab) -> some View {
        
        switch tab {
        case .home:
            HomeView()
        case .favorites:
            FavoritesView()
        case .profile:
            ProfileView()
        case .friends:
            FriendsView()
        case .messages:
            MessageView()
        
        }
    }
    
}

#Preview {
    ContentView()
}


struct HomeView: View {
    var body: some View {
        Text("🏠 Home")
    }
}

struct FavoritesView: View {
    var body: some View {
        Text("⭐️ Favorites")
    }
}

struct ProfileView: View {
    var body: some View {
        Text("👤 Profile")
    }
}

struct FriendsView: View {
    var body: some View {
        Text("👤 Friends")
    }
}

struct MessageView: View {
    var body: some View {
        Text("👤 Message")
    }
}
