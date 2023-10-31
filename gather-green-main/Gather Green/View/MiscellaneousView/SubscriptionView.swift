//
//  SubscriptionView.swift
//  Gather Green
//
//  Created by Sophia Wang on 4/3/23.
//

import SwiftUI

struct SubscriptionView: View {
    @EnvironmentObject var dataModel:DataModel
    var body: some View {
        VStack{
            Group{
                HStack{
                    Text("Gather Green Premium")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.leading,20)
                    Spacer()
                }
                HStack{
                    Text("$7.99/mo")
                        .font(.title2)
                        .foregroundColor(Color.gray)
                        .padding(.leading,20)
                    Text("1 month free")
                        .font(.title2)
                    Spacer()
                }
                Spacer()
                if dataModel.user.permission != .standard{
                    Text("Your Premium Privileges:")
                        .font(.system(size: 30))
                        .fontWeight(.bold)
                }
                HStack{
                    Image(systemName: "dollarsign.circle")
                        .font(.system(size: 30))
                        .fontWeight(.bold)
                    Text("$0 Delivery Fee on eligible products")
                        .font(.title3)
                }
                .padding(.bottom,5)
                HStack{
                    Image(systemName: "tag.fill")
                        .font(.system(size: 30))
                        .fontWeight(.bold)
                        .padding(.leading,15)
                    Text("Additional product options")
                        .font(.title3)
                    Spacer()
                }
                .padding(.bottom,5)
                HStack{
                    Image(systemName: "cart.fill.badge.minus")
                        .font(.system(size: 30))
                        .fontWeight(.bold)
                        .padding(.leading,15)
                    Text("7-day return and cancellation policy")
                        .font(.title3)
                    Spacer()
                }
                .padding(.bottom,5)
                HStack{
                    Image(systemName: "person.crop.circle.fill.badge.checkmark")
                        .font(.system(size: 30))
                        .fontWeight(.bold)
                        .padding(.leading,18)
                    Text("Priority customer support")
                        .font(.title3)
                    Spacer()
                }
                .padding(.bottom,5)
                HStack{
                    Image(systemName: "heart.fill")
                        .font(.system(size: 30))
                        .fontWeight(.bold)
                        .padding(.leading,18)
                    Text("Rewards and loyalty programs")
                        .font(.title3)
                    Spacer()
                }
                .padding(.bottom,5)
            }
            Spacer()
            Image("GatherGreen1")
                .resizable()
                .frame(width:270,height: 180)
            Spacer()
            
            if dataModel.user.permission == .standard{
                Button{
                    self.dataModel.subScribe()
                } label: {
                    Text("Subscribe")
                        .font(.system(size: 30))
                        .fontWeight(.bold)
                        .foregroundColor(Color.black)
                }
                .frame(width: 360, height: 60.0)
                .background(Color.accentColor)
                Spacer()
            }
        }
    }
        
}

struct SubscriptionView_Previews: PreviewProvider {
    static var previews: some View {
        SubscriptionView()
            .environmentObject(DataModel())
    }
}

