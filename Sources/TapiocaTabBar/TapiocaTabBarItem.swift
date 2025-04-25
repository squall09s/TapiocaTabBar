//
//  File.swift
//  TapiocaTabBar
//
//  Created by Nicolas Laurent on 24/04/2025.
//

import SwiftUI

public struct TapiocaTabBarItem: Identifiable {
    public let id = UUID()
    let icon: Image
    let title: String
    
    
    public init(icon: Image, title: String) {
        self.icon = icon
        self.title = title
    }
}
