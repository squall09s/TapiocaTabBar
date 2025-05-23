//
//  File.swift
//  TapiocaTabBar
//
//  Created by Nicolas Laurent on 24/04/2025.
//

import SwiftUI

public class TapiocaTabBarItem: ObservableObject, Identifiable {
    public let id = UUID()
    @Published public var icon: Image
    @Published public var title: String
    
    
    public init(icon: Image, title: String) {
        self.icon = icon
        self.title = title
    }
}

