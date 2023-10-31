//
//  EmailView.swift
//  Gather Green
//
//  Created by Sophia Wang on 4/3/23.
//

import SwiftUI

struct EmailView: View {
    @State var name: String = " SpongeBob"
    @State var subject: String = " Donation Request"
    @State var Emailbody: String = " I have some used cardboard.."
    @State var isAlert: Bool = false
    
    var body: some View {
        VStack{
            Group {
                HStack{
                    Image("GatherGreen1")
                        .resizable()
                        .frame(width:70,height:50)
                    Text("Contact Gather Green")
                        .font(.title)
                        .fontWeight(.bold)
                }
                Spacer()
                HStack{
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 30))
                        .fontWeight(.bold)
                        .padding(.leading,20)
                    Text("Name:")
                        .font(.title2)
                    Spacer()
                }
                HStack{
                    Spacer()
                    TextField("Name", text: $name)
                        .font(.title2)
                        .frame(width:340, height: 40)
                        .background(Color.accentColor)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1))
                    Spacer()
                }
                Spacer()
                HStack{
                    Image(systemName: "book.circle")
                        .font(.system(size: 30))
                        .fontWeight(.bold)
                        .padding(.leading,20)
                    Text("Subject:")
                        .font(.title2)
                    Spacer()
                }
                HStack{
                    Spacer()
                    
                    TextField("Subject", text: $subject)
                        .font(.title2)
                        .frame(width:340, height: 40)
                        .background(Color.accentColor)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1))
                    Spacer()
                }
                Spacer()
                HStack{
                    Image(systemName: "doc.text.fill")
                        .font(.system(size: 30))
                        .fontWeight(.bold)
                        .padding(.leading,24)
                    Text("Body:")
                        .font(.title2)
                    Spacer()
                }
                HStack{
                    Spacer()
                    
                    TextField("Body", text: $Emailbody, axis: .vertical)
//                        .lineLimit(5...10)
                        .font(.title2)
                        .frame(width:340, height: 350)
                        .background(Color.accentColor)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1))
                    Spacer()
                }
            }
            Spacer()
            // An alert will present if there's no Email config
            Button(action: {
                var result:Bool = EmailHelper.shared.sendEmail(subject: subject, body: "I am \(name)" + Emailbody)
                if !result {
                    isAlert = true
                }
             }) {
                 HStack{
                     Image(systemName: "paperplane.fill")
                         .font(.system(size: 30))
                         .fontWeight(.bold)
                         .foregroundColor(Color.black)
                     Text("Submit")
                         .font(.system(size: 30))
                         .fontWeight(.bold)
                         .foregroundColor(Color.black)
                 }
             }
             .frame(width: 360, height: 60.0)
             .background(Color.white)
             .alert("Please configure your email first.", isPresented: $isAlert) {
                         Button("OK", role: .cancel) { }
                     }
//             Spacer()
        }
    }
}

struct EmailView_Previews: PreviewProvider {
    static var previews: some View {
        EmailView()
    }
}
