//
//  OrderHistoryRow.swift
//  Gather Green
//
//  Created by Yiyang Shao on 4/16/23.
//

import SwiftUI

struct CheckOutRow: View {
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
                Text("Estimated Delivery: \(createDateString(estimatedDate))")
                    .font(.title3)
                    .padding(15)
                Text("\(product.name)")
                    .font(.footnote)
                    .padding(.leading, 15)
                Text("$ \(String(format: "%.2f", self.product.price)) x \(Int(self.order.quantity))")
                    .font(.footnote)
                    .padding(.leading, 15)
                
            }
            Spacer()
        }
    }
}

struct CheckOutRow_Previews: PreviewProvider {
    static var previews: some View {
        CheckOutRow(order: Order())
    }
}
