//
//  CheckoutView.swift
//  Gather Green
//
//  Created by Yiyang Shao on 3/30/23.
//

import SwiftUI
import PassKit

func createDateString(_ date: Date) -> String{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YYYY/MM/dd"
    return dateFormatter.string(from: date)
}


func createOrderByCart(item:ShoppingCartItem, dataModel:DataModel)->Order{
    let newOrder = Order()
    newOrder.user = dataModel.user
    newOrder.product = item.product
    newOrder.orderId = UUID()
    newOrder.orderTime = createDateString(Date())
    newOrder.quantity = item.count
    newOrder.paymentInfo = "Apple Pay"
    return newOrder
}

struct CheckoutView: View {
    @EnvironmentObject var dataModel:DataModel
    let paymentHandler = PaymentHandler()
    var total: Float{
        var s: Float = 0
        self.dataModel.shoppingCart.forEach({item in
            s += item.product.price * Float(item.count)
        })
        return s
    }
    var body: some View {
        NavigationView{
            ScrollView {
                Text("Subtotal: $\(String(format: "%.2f", total))")
                    .font(.title2)
                    .padding()
                Button("Checkout"){
                    print("checkout")
                    paymentHandler.startPaymentCheckout(shoppingCart: self.dataModel.shoppingCart) { (success) in
                        print("Payment Success")
                        self.dataModel.shoppingCart.forEach({item in
                            let newOrder = createOrderByCart(item: item, dataModel: dataModel)
                            self.dataModel.uploadNewOrder(order: newOrder)
                            self.dataModel.deleteCartItem(shoppingCartItemId: item.shoppingCartItemId)
                        })
                        self.dataModel.downloadOneOrders()
                        self.dataModel.shoppingCart = []
                    }
                }
                .frame(width: 350,height:50)
                .background(Color(red: 0, green: 0, blue: 0.5))
                .foregroundColor(.white)
                .clipShape(Capsule())
                .padding()
                
                Divider()
                ForEach(self.dataModel.shoppingCart,id:\.self){item in
                    CheckOutRow(order: createOrderByCart(item: item, dataModel: dataModel))
                    Divider()
                }
                
            }
            .navigationTitle("Check Out")
        }
    }

}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView()
            .environmentObject(DataModel.shared)
    }
}
