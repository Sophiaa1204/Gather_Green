//
//  MainPageView.swift
//  Gather Green
//
//  Created by Yiyang Shao on 3/21/23.
//
/*
 Reference:
  https://github.com/abuanwar072/Furniture-Shop-App-UI-SwiftUI
 */

import SwiftUI

extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}




struct MainPageView: View {
    @EnvironmentObject var dataModel:DataModel
    @State var search:String = ""
    @State var filter:String = ""
    @State private var selectedIndex: Int = 0
    @Binding var tab: Tab
    
    private let permission = ["Standard", "Premium"]
    
    @State private var isShowFilterSheet = false
    @State private var isShowingLoginView = false
    
    let backgroundGradient = LinearGradient(
        colors: [Color.red, Color.blue],
        startPoint: .top, endPoint: .bottom)
    
    var body: some View {
        NavigationView{
            ScrollView{
                
                VStack{
                    HStack{
                        NavigationLink{
                            InfoView()
                        }label: {
                            Text("Info")
                                .padding(.trailing)
                        }
                        .padding(.leading,20)
                        Spacer()
                        if self.dataModel.user.userName == "guestuser"{
                            NavigationLink{
                                LoginView()
                            }label: {
                                Text("Log In").padding(.trailing)
                            }
                        }else{
                            Button{
                                self.tab = .account
                            }label: {
                                Text("Hi, \(self.dataModel.user.firstName)").padding(.trailing)
                            }
                        }
                    }
                    .offset(y:40)
                    HStack {
                        Image("search")
                            .padding(.trailing, 8)
                        TextField("Search Products", text: $search)
                        Button(action: {
                            self.isShowFilterSheet = true
                        }, label: {
                            Image(systemName: "hourglass")
                        })
                        .actionSheet(isPresented: $isShowFilterSheet) {
                            ActionSheet(title: Text("Filter All Products"),
                                        message: Text("choose a category of products"),
                                        buttons: [
                                            .cancel(),
                                            .default(
                                                Text("Paper"),
                                                action: {self.filter = "paper"}
                                            ),
                                            .default(
                                                Text("Glass"),
                                                action: {self.filter = "glass"}
                                            ),
                                            .default(
                                                Text("Plastic"),
                                                action: {self.filter = "plastic"}
                                            ),
                                            .default(
                                                Text("All"),
                                                action: {self.filter = ""}
                                            )
                                        ]
                            )
                        }
                    }
                    .padding(.all, 20)
                    .offset(y:20)
                    
                    HStack {
                        ForEach(0 ..< 2) { i in
                            Button(action: {
                                
                                if i == 1 && self.dataModel.user.type == .guest{
                                    self.isShowingLoginView = true
                                }else{
                                    selectedIndex = i
                                }
                            }) {
                                CategoryView(isActive: selectedIndex == i, text: permission[i])
                            }
                        }
                    }
                    .padding()
                }
                .edgesIgnoringSafeArea(.top)
                .background(Color("accentColor2"), in: Rectangle())
                
                
//                NavigationLink(destination: LoginView(), isActive: $isShowingLoginView) { EmptyView() }

                                
                if(selectedIndex == 0){
                    StandardMarketView(search:$search,filter:$filter)
                }else{
//                    if self.dataModel.user.type == .guest{
//                        LoginView()
//                    }
                    if self.dataModel.user.permission == .standard{
                        SubscriptionView()
                    }else{
                        StandardMarketHorizontal(search:$search,filter:$filter)
                    }
                }
            }
            
            .edgesIgnoringSafeArea(.top)
//            .navigationTitle("Navigation Title")
//            .toolbarBackground(
//                Color.green,
//                for: .navigationBar)
//            .toolbarBackground(.visible, for: .navigationBar)
//
        }
        .refreshable {
            self.dataModel.downloadProduct()
            self.dataModel.downloadUser()
        }
    }
}

struct MainPageView_Previews: PreviewProvider {
    @State static var tab:Tab = .mainPage
    static var previews: some View {
        MainPageView(tab: $tab)
            .environmentObject(DataModel())
    }
}
