//
//  ContentView.swift
//  Gather Green
//
//  Created by Yiyang Shao on 3/21/23.
//

import SwiftUI

enum Tab {
    case mainPage
    case shoppingCart
    case account
    case test
}

struct ContentView: View {
    @State private var selection: Tab = .mainPage
    
    
    
    
    var body: some View {
        TabView(selection:$selection){
            MainPageView(tab: $selection).tabItem {
                Label("Main", systemImage: "house.circle")
            }
            .tag(Tab.mainPage)

            ShoppingCartView()
                .tabItem {
                Label("Shopping Cart", systemImage: "cart.circle")

            }
            .tag(Tab.shoppingCart)
            
            AccountView()
                .tabItem {
                Label("Account", systemImage: "person.circle")

            }
            .tag(Tab.account)
            
//            TestView()
//                .tabItem {
//                Label("Test", systemImage: "hand.app")
//
//            }
//            .tag(Tab.test)
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(DataModel())
    }
}
