//
//  OrderHistoryView.swift
//  Gather Green
//
//  Created by Loaner on 4/5/23.
//

import SwiftUI

struct OrderHistoryView: View {
    @EnvironmentObject var dataModel:DataModel
//    let dict = ["test1": 1, "test2": 2, "test3": 3]
    let width = UIScreen.screenWidth / 3
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        NavigationView{
            ScrollView {
                ForEach(dataModel.orderHistory, id:\.self) {
                    order in
                    Divider()
                    OrderHistoryRow(order: order)
                }
                Divider()
                
                if dataModel.orderHistory.count == 0{
                    Text("You don't have any order.")
                    Button("Go shopping now!"){
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .navigationTitle("Order History")
        }
    }
}

struct OrderHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        OrderHistoryView()
            .environmentObject(DataModel())
    }
}
