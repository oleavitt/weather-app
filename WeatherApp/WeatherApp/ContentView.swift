//
//  ContentView.swift
//  WeatherApp
//
//  Created by Oren Leavitt on 11/20/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "cloud.sun")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, weather!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
