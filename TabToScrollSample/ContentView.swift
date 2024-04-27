//
//  ContentView.swift
//  TabToScrollSample
//
//  Created by 유재호 on 4/27/24.
//

import SwiftUI

struct ContentView: View {

  var body: some View {
    TabView {
      RedView()
        .tabItem {
          Label("RED", systemImage: "flame")
        }

      BlueView()
        .tabItem {
          Label("BLUE", systemImage: "drop")
        }
    }
  }
}

struct RedView: View {

  var body: some View {
    NavigationStack {
      ScrollView {
        VStack(spacing: .zero) {
          ForEach(1...100, id: \.self) { num in
            NavigationLink(destination: RedView()) {
              Color.red.opacity(Double(num) / 100)
                .frame(height: 30)
                .overlay {
                  if num == 1 {
                    Text("TOP")
                  } else if num == 100 {
                    Text("BOTTOM")
                  }
                }
                .font(.title.bold())
            }
          }
        }
      }
    }
  }
}

struct BlueView: View {

  var body: some View {
    NavigationStack {
      ScrollView {
        VStack(spacing: .zero) {
          ForEach(1...100, id: \.self) { num in
            NavigationLink(destination: BlueView()) {
              Color.blue.opacity(Double(num) / 100)
                .frame(height: 30)
                .overlay {
                  if num == 1 {
                    Text("TOP")
                  } else if num == 100 {
                    Text("BOTTOM")
                  }
                }
                .font(.title.bold())
            }
          }
        }
      }
    }
  }
}

#Preview {
  ContentView()
}
