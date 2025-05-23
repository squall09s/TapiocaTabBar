//
//  File.swift
//  TapiocaTabBar
//
//  Created by Nicolas Laurent on 24/04/2025.
//

import SwiftUI


public class TapiocaTabBarViewModel: ObservableObject {
    
    @Published public var selectedIndex: Int = 0
    @Published public var items: [TapiocaTabBarItem]

    public var selectedItem: TapiocaTabBarItem? {
        guard items.indices.contains(selectedIndex) else { return nil }
        return items[selectedIndex]
    }

    public init(items: [TapiocaTabBarItem]) {
        self.items = items
    }

    public func updateItem(at index: Int, title: String? = nil, icon: Image? = nil) {
        guard items.indices.contains(index) else { return }
        if let title = title {
            items[index].title = title
        }
        if let icon = icon {
            items[index].icon = icon
        }
    }
}
