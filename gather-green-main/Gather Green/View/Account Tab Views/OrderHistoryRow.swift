//
//  OrderHistoryRow.swift
//  Gather Green
//
//  Created by Yiyang Shao on 4/16/23.
//

import SwiftUI

extension String {
    func toDate() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: self)!
    }
}


struct OrderHistoryRow: View {
    let height: CGFloat = 120
    let order: Order
    var product: Product{order.product}
    var estimatedDate: Date{Calendar.current.date(byAdding: .day, value: 2, to: order.orderTime.toDate())!}
    var body: some View {
        
        HStack{
            product.imageDecoded
                .resizable()
                .frame(width: height * 1.05, height: height)
                .cornerRadius(20.0)
                .padding(.horizontal)
            VStack(alignment: .leading){
                if estimatedDate < Date(){
                    Text("Delivered \(createDateString(estimatedDate))")
                        .font(.title2)
                        .padding(15)
                }else{
                    Text("Estimated Delivery: \(createDateString(estimatedDate))")
                        .font(.title2)
                        .padding(15)
                }
                Text("\(product.name)")
                    .font(.title3)
                    .padding(.leading, 15)
                Text("$ \(String(format: "%.2f", self.product.price))")
                    .font(.title3)
                    .padding(.leading, 15)
                
            }
            Spacer()
        }
    }
}

struct OrderHistoryRow_Previews: PreviewProvider {
    static var previews: some View {
        OrderHistoryRow(order: Order())
    }
}
