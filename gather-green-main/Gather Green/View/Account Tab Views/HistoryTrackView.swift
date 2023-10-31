//
//  HistoryTrackView.swift
//  Gather Green
//
//  Created by Yiyang Shao on 4/4/23.
//
/*
 Reference:
 https://betterprogramming.pub/build-pie-charts-in-swiftui-822651fbf3f2
 */

import SwiftUI

struct HistoryTrackView: View {
    
    @EnvironmentObject var dataModel:DataModel
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Binding var isOrderHistoryPresent: Bool
    @Binding var isHistoryTrackPresent: Bool
    
    var categorySpendValues: [Double]{
        var values:[Double] = [0,0,0,0]
        self.dataModel.orderHistory.forEach({order in
            let product = order.product
            switch product.type{
            case .Paper:
                values[0] += Double(product.price * order.quantity)
            case .Glass:
                values[1] += Double(product.price * order.quantity)
            case .Plastic:
                values[2] += Double(product.price * order.quantity)
            default:
                values[3] += Double(product.price * order.quantity)
            }
        })
        return values
    }
    
    
    var body: some View {
        NavigationView{
            if self.dataModel.orderHistory.count != 0{
                VStack{
                    Divider()
                    PieChartView(values: categorySpendValues, names: ["Paper", "Glass", "Plastic", "Other"], formatter: {value in String(format: "$%.2f", value)})
                    
                    Button("See Order Details"){
                        isOrderHistoryPresent = true
                        isHistoryTrackPresent = false
                    }
                }
                .navigationTitle("History Track")
            }else{
                ScrollView{
                    Text("You don't have any order.")
                    Button("Go shopping now!"){
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
                .navigationTitle("History Track")
            }
        }
        .refreshable {
            self.dataModel.downloadOneOrders()
        }
    }
}

struct HistoryTrackView_Previews: PreviewProvider {
    @State static var isOrderHistoryPresent = false
    @State static var isHistoryTrackPresent = false
    static var previews: some View {
        HistoryTrackView(isOrderHistoryPresent: $isOrderHistoryPresent, isHistoryTrackPresent: $isHistoryTrackPresent)
            .environmentObject(DataModel())
    }
}
