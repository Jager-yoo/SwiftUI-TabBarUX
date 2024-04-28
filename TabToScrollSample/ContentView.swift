//
//  ContentView.swift
//  TabToScrollSample
//
//  Created by 유재호 on 4/27/24.
//

import SwiftUI

final class TabManager: ObservableObject {

  @Published private var tabSelection: Tabs = .red
  @Published var redTabbedTwice: Bool = false
  @Published var blueTabbedTwice: Bool = false

  var tabHandler: Binding<Tabs> {
    Binding(
      get: { self.tabSelection },
      set: { newTab in
        if newTab == self.tabSelection {
          // 이전과 똑같으면
          switch newTab {
          case .red:
            self.redTabbedTwice = true
          case .blue:
            self.blueTabbedTwice = true
          }
        }
        self.tabSelection = newTab
      }
    )
  }

  enum Tabs: Hashable {
    case red
    case blue
  }
}

struct ContentView: View {

  @StateObject private var tabManager = TabManager()

  var body: some View {
    TabView(selection: tabManager.tabHandler) {
      // RED TAB
      ScrollViewReader { proxy in
        RedView()
          .onChange(of: tabManager.redTabbedTwice) { _, tapped in
            if tapped {
              withAnimation {
                proxy.scrollTo("TOP", anchor: .bottom)
              }
              tabManager.redTabbedTwice = false
            }
          }
      }
      .tabItem {
        Label("RED", systemImage: "flame")
      }
      .tag(TabManager.Tabs.red)

      // BLUE TAB
      ScrollViewReader { proxy in
        BlueView()
          .onChange(of: tabManager.blueTabbedTwice) { _, tapped in
            if tapped {
              withAnimation {
                proxy.scrollTo("TOP", anchor: .bottom)
              }
              tabManager.blueTabbedTwice = false
            }
          }
      }
      .tabItem {
        Label("BLUE", systemImage: "drop")
      }
      .tag(TabManager.Tabs.blue)
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
                      .id("TOP")
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
                      .id("TOP")
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
