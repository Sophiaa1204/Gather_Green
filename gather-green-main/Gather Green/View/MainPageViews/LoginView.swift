//
//  Login View.swift
//  Gather Green
//
//  Created by Yiyang Shao on 3/30/23.
//
/*
 Reference:
 https://github.com/indently/LoginScreen
 */

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var dataModel:DataModel
    @Environment(\.presentationMode) var presentationMode
    @State private var username = ""
    @State private var password = ""
    @State private var wrongUsername: Float = 0
    @State private var wrongPassword: Float  = 0
    @State private var showingLoginScreen = false
    
    
    var body: some View {
        NavigationView {
                VStack {
                    Image("GatherGreenLogo")
                        .resizable()
                        .frame(width:0.8*UIScreen.screenWidth,height:0.65*0.8*UIScreen.screenWidth)
                        .padding()
                    
                    TextField("Username/Email", text: $username)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .border(.red, width: CGFloat(wrongUsername))
                        
                    
                    SecureField("Password", text: $password)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .border(.red, width: CGFloat(wrongPassword))
                    
                    Button("Login") {
                        
                    }
                    .foregroundColor(.white)
                    .frame(width: 300, height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
                    
                    Button("Register"){
                        
                    }
                    .padding()
                    Button("Forgot Password?"){
                        
                    }
                    .padding()
                    
                    Button("Login as Tester") {
                        self.dataModel.user = User(type: "tester")
                        self.dataModel.uploadNewUser(user: self.dataModel.user)
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(.white)
                    .frame(width: 300, height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
                    
                
            }
        }
        .navigationTitle("Sign In")
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
