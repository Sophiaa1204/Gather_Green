//
//  ShoppingCartRow.swift
//  Gather Green
//
//  Created by Yiyang Shao on 4/17/23.
//

import SwiftUI

struct ShoppingCartRow: View {
    let shoppingCartItem: ShoppingCartItem
    @EnvironmentObject var dataModel:DataModel
    @State var count: Float = 0
    @Binding var checkout: Bool
    var body: some View {
        ZStack{
            Color("accentColor2").opacity(0.2)
                .frame(maxHeight: 300)
            HStack{
                VStack{
                    shoppingCartItem.product.imageDecoded
                        .resizable()
                        .cornerRadius(15)
                        .scaledToFit()
                        .shadow(radius: 5)
                        .frame(maxHeight: 130)
                    HStack{
                        Button(){
                            if count > 0{
                                count -= 1
                                shoppingCartItem.count -= 1
                                self.dataModel.updateShoppingCart(shoppingCartItem: shoppingCartItem, quantity: shoppingCartItem.count)
                            }
                                self.dataModel.downloadShoppingCart()
                        }label: {
                            Text("-")
                                .frame(width: 40,height: 25)
                                .font(.headline)
                        }.buttonStyle(GrowingButton())
                        Text("\(String(format: "%.2f", self.count))")
                        //                                .background(Color.cyan)
                            .font(.headline)
                        Button(){
                            count += 1
                            shoppingCartItem.count += 1
                            self.dataModel.updateShoppingCart(shoppingCartItem: shoppingCartItem, quantity: shoppingCartItem.count)
                            self.dataModel.downloadShoppingCart()
                        }label: {
                            Text("+")
                                .frame(width: 40,height: 25)
                                .font(.headline)
                        }.buttonStyle(GrowingButton())
                            .foregroundColor(.pink)
                    }
                }
                .padding()
                VStack{
                    Text("\(shoppingCartItem.product.name)")
                        .frame(width: 200,height: 60)
                        .font(.headline)
                        .background(Color("accentColor2"))
                        .cornerRadius(15)
                    Text("In stock: $\(String(format: "%.2f", shoppingCartItem.product.price*shoppingCartItem.count))")
                        .frame(width: 200,height: 60)
                        .font(.headline)
                        .background(Color("accentColor2"))
                        .cornerRadius(15)
                    HStack{
//                        Button(){
//                            checkout = true
//                        }label: {
//                            Text("Buy")
//                                .frame(width: 80,height: 40)
//                                .font(.headline)
//                        }.buttonStyle(GrowingButton())
                        
                        Button(){
                            dataModel.shoppingCart = dataModel.shoppingCart.filter { $0 != shoppingCartItem}
                            self.dataModel.deleteCartItem(shoppingCartItemId: shoppingCartItem.shoppingCartItemId)
                        }label: {
                            Text("Delete")
                                .frame(width: 80,height: 40)
                                .font(.headline)
                        }.buttonStyle(GrowingButton())
                        
                    }
                }
            }.padding()
        }
        .onAppear(perform: {
            self.count = shoppingCartItem.count
        })
    }
}

struct ShoppingCartRow_Previews: PreviewProvider {
    @State static var checkout = false
    static var previews: some View {
        ShoppingCartRow(shoppingCartItem: ShoppingCartItem(), checkout: $checkout)
            .environmentObject(DataModel.shared)
    }
}
