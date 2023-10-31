//
//  Gather_GreenApp.swift
//  Gather Green
//
//  Created by Yiyang Shao on 3/21/23.
//

import SwiftUI

@main
struct Gather_GreenApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(DataModel.shared)
        }
    }
}
