//
//  MainView.swift
//  NASA APOD
//
//  Created by Israel Manzo on 3/25/25.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
        }
    }
}

#Preview {
    MainView()
}
