//
//  UserProfileView.swift
//  Gather Green
//
//  Created by Yiyang Shao on 3/30/23.
//

import SwiftUI

struct RoundPictureView: View {
    var picture:Image
    var body: some View {
        VStack{
            picture
                .resizable()
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                .frame(width: 200,height: 200)
                .shadow(radius: 7)
        }
        
    }
}

struct UserProfileView: View {
    
    @EnvironmentObject var dataModel: DataModel
    
    var body: some View {
        NavigationView{
            VStack{
                ZStack {
                    Color("accentColor2").opacity(0.3)
                        .ignoresSafeArea()
                    RoundPictureView(picture: self.dataModel.user.imageDecoded)
                }
                .offset(y:20)
                
                HStack{
                    Text("Your name")
                        .padding(20)
                    Spacer()
                }
                Text("\(dataModel.user.firstName) \(dataModel.user.lastName)")
                    .multilineTextAlignment(.center)
                    .padding()
                    .frame(width: 350, height: 50)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(radius: 3))
                HStack{
                    Text("Date of Birth")
                        .padding(20)
                    Spacer()
                }
                if dataModel.user.birthday != nil {
                    Text("\(dataModel.user.birthday!)")
                        .multilineTextAlignment(.center)
                        .padding()
                        .frame(width: 350, height: 50)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(radius: 3))
                }else{
                    Text("birthday Unknown")
                        .multilineTextAlignment(.center)
                        .padding()
                        .frame(width: 350, height: 50)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(radius: 3))
                }
                HStack{
                    Text("Your job")
                        .padding(20)
                    Spacer()
                }
                if dataModel.user.profession != nil {
                    Text("\(dataModel.user.profession!)")
                        .multilineTextAlignment(.center)
                        .padding()
                        .frame(width: 350, height: 50)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(radius: 3))
                }else{
                    Text("profession Unknown")
                        .multilineTextAlignment(.center)
                        .padding()
                        .frame(width: 350, height: 50)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(radius: 3))
                }
                HStack{
                    Text("Your gender")
                        .padding(20)
                    Spacer()
                }
                if dataModel.user.gender != nil {
                    if dataModel.user.gender == 1{
                        Text("Male")
                            .multilineTextAlignment(.center)
                            .padding()
                            .frame(width: 350, height: 50)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(radius: 3))
                    }else{
                        Text("Female")
                            .multilineTextAlignment(.center)
                            .padding()
                            .frame(width: 350, height: 50)
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(radius: 3))
                    }
                }else{
                    Text("gender Unknown")
                        .multilineTextAlignment(.center)
                        .padding()
                        .frame(width: 350, height: 50)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(radius: 3))
                }
            }
            .navigationTitle("User Profile")
        }
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
            .environmentObject(DataModel())
    }
}
