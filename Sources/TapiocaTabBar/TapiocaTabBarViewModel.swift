//
//  File.swift
//  TapiocaTabBar
//
//  Created by Nicolas Laurent on 24/04/2025.
//

import SwiftUI

class TapiocaTabBarViewModel: ObservableObject {
    @Published var selectedIndex: Int = 0
    let items: [TapiocaTabBarItem]
    
    init(items: [TapiocaTabBarItem]) {
        self.items = items
    }
}
