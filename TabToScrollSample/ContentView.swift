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

  var redPath = NavigationPath()
  var bluePath = NavigationPath()

  var tabHandler: Binding<Tabs> {
    Binding(
      get: { self.tabSelection },
      set: { newTab in
        if newTab == self.tabSelection {
          // 같은 탭이 2번 눌렸다면
          // TODO: 스로틀링 0.35초 적용 필요 있음. 애니메이션 끝나기 전에 pop 시키면 문제 생김
          // TODO: https://github.com/boraseoksoon/Throttler 이거 써보기
          switch newTab {
          case .red:
            guard self.redPath.isEmpty else {
              // 뎁스가 있다면, 하나 빠져나온다.
              self.redPath.removeLast()
              break
            }
            // 뎁스가 없다면 root 화면 스크롤 투 탑
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
        NavigationStack(path: $tabManager.redPath) {
          RedView()
            .onChange(of: tabManager.redTabbedTwice) { _, tapped in
              if tapped {
                withAnimation {
                  proxy.scrollTo("TOP", anchor: .bottom)
                }
                tabManager.redTabbedTwice = false
              }
            }
            .navigationDestination(for: Color.self) { _ in
              RedView()
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
    ScrollView {
      VStack(spacing: .zero) {
        ForEach(1...100, id: \.self) { num in
          NavigationLink(value: Color.red) {
            Color.red.opacity(Double(num) / 100)
              .frame(height: 30)
              .overlay {
                if num == 1 {
                  Text("TOP")
                    .id("TOP")
                } else if num == 100 {
                  Text("BOTTOM")
                } else {
                  Text("\(num)")
                    .font(.callout)
                }
              }
              .font(.title.bold())
          }
        }
      }
    }
  }
}

struct BlueView: View {

  var body: some View {
    ScrollView {
      VStack(spacing: .zero) {
        ForEach(1...100, id: \.self) { num in
          Color.blue.opacity(Double(num) / 100)
            .frame(height: 30)
            .overlay {
              if num == 1 {
                Text("TOP")
                  .id("TOP")
              } else if num == 100 {
                Text("BOTTOM")
              } else {
                Text("\(num)")
                  .font(.callout)
              }
            }
            .font(.title.bold())
        }
      }
    }
  }
}

#Preview {
  ContentView()
}
