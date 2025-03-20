//
//  ContentView.swift
//  NASA APOD
//
//  Created by Israel Manzo on 3/20/25.
//

import SwiftUI

// https://api.nasa.gov/planetary/apod?api_key=tXNvkBhAvgNMi8HR7pJX3PXbxUx3df95cMwiT2g0

struct ContentView: View {
    var body: some View {
        NavigationView {
            Text("Hello World!")
                .navigationTitle("NASA APOD")
        }
    }
}

#Preview {
    ContentView()
}
