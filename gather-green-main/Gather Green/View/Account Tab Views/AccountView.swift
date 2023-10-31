//
//  AccountView.swift
//  Gather Green
//
//  Created by Yiyang Shao on 3/21/23.
//

import SwiftUI

struct AccountView: View {
    @State private var isAccountInfoPresent = false
    @State private var isOrderHistoryPresent = false
    @State private var isHistoryTrackPresent = false
    @State private var isSubscriptionPresent = false
    @State private var isHelpPresent = false
    @State private var isLoginPresent = false
    @EnvironmentObject var dataModel:DataModel
    var body: some View {
        
        ZStack{
            Color("accentColor2").opacity(0.3)
                .ignoresSafeArea(edges:.top)
//            Color("accentColor2").opacity(0.3)
//                .frame(height: 1000)
//                .ignoresSafeArea()
//            Color.green.opacity(0.7)
//                .offset(y:150)
//                .safeAreaInset(edge: .bottom, alignment: .center, spacing: 0) {
//                    Color.clear
//                        .frame(height: 20)
//                        .background(Color.white)
//                }
            VStack{
                ZStack{
                    VStack{
                        Text("Hi, \(dataModel.user.firstName)")
                            .font(.title)
                        dataModel.user.imageDecoded
                            .resizable()
                            .cornerRadius(15)
                            .scaledToFit()
                            .shadow(radius: 5)
                            .frame(maxHeight: 200)
                            .clipShape(Circle())
                            .padding()
                    }
                }
                Divider()
                Button(){
                    if dataModel.user.type != .guest{
                        isAccountInfoPresent = true
                    }else{
                        isLoginPresent = true
                    }
                }label: {
                    Text("User Profile")
                        .frame(width: 200,height: 60)
                        .font(.headline)
                    
                }
                .sheet(isPresented: $isAccountInfoPresent){
                    UserProfileView()
                }
                .sheet(isPresented: $isLoginPresent){
                    LoginView()
                }
                .buttonStyle(GrowingButton())
                .padding()
                    
                Button(){
                    if dataModel.user.type != .guest{
                        isOrderHistoryPresent = true
                    }else{
                        isLoginPresent = true
                    }
                }label: {
                    Text("Order History")
                        .frame(width: 200,height: 60)
                        .font(.headline)
                }
                .sheet(isPresented: $isOrderHistoryPresent){
                    OrderHistoryView()
                }
                .buttonStyle(GrowingButton())
                    .padding()
                
                Button(){
                    if dataModel.user.type != .guest{
                        isHistoryTrackPresent = true
                    }else{
                        isLoginPresent = true
                    }
                }label: {
                    Text("History Track")
                        .frame(width: 200,height: 60)
                        .font(.headline)
                }.sheet(isPresented: $isHistoryTrackPresent){
                    HistoryTrackView(isOrderHistoryPresent: $isOrderHistoryPresent, isHistoryTrackPresent: $isHistoryTrackPresent)
                }
                .buttonStyle(GrowingButton())
                    .padding()
                Button(){
                    if dataModel.user.type != .guest{
                        isSubscriptionPresent = true
                    }else{
                        isLoginPresent = true
                    }
                }label: {
                    Text("Subscription")
                        .frame(width: 200,height: 60)
                        .font(.headline)
                }.sheet(isPresented: $isSubscriptionPresent){
                    SubscriptionView()
                }
                .buttonStyle(GrowingButton())
                    .padding()
                Button(){
                    if dataModel.user.type != .guest{
                        isHelpPresent = true
                    }else{
                        isLoginPresent = true
                    }
                }label: {
                    Text("Contact Us")
                        .frame(width: 200,height: 60)
                        .font(.headline)
                }.sheet(isPresented: $isHelpPresent){
                    EmailView()
                }
                .buttonStyle(GrowingButton())
                    .padding()
            }
            
            
        }
    }
}

struct sample: View {
    var body: some View {
        Text("This is a sample window for display!")
            .frame(width: 200,height: 80)
            .font(.headline)
            .frame(alignment: .center)
    }
}

struct GrowingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.black)
            .background(Color.blue.opacity(0.5))
            .cornerRadius(10)
//            .frame(width: 250, height: 150)
            .frame(maxWidth: 150)
            .frame(height: 50)
//            .padding()
//            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct GrowingButtonBlue: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(.black)
            .background(Color(red: 0, green: 0, blue: 0.5).opacity(0.5))
            .cornerRadius(10)
//            .frame(width: 250, height: 150)
            .frame(maxWidth: 150)
            .frame(height: 50)
//            .padding()
//            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView()
            .environmentObject(DataModel())
    }
}
