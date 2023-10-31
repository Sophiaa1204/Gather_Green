//
//  TestView.swift
//  Gather Green
//
//  Created by Yiyang Shao on 3/30/23.
//

import SwiftUI

struct TestView: View {
    @EnvironmentObject var dataModel:DataModel
    let image1 = Image("chair_1")
    let image2 = Image("chair_5")
    var body: some View {
        VStack{
            Group{
                Button("test download user"){
                    self.dataModel.downloadUser()
                }
                Divider()
                Button("test download product"){
                    self.dataModel.downloadProduct()
                }
                Divider()
                Button("test download all order"){
                    self.dataModel.downloadAllOrders()
                }
                Divider()
                Button("test download one order"){
                    self.dataModel.downloadOneOrders()
                }
                Divider()
                Button("test download shopping cart"){
                    self.dataModel.downloadShoppingCart()
                }
                Divider()
            }
            Group{
                Divider()
                Button("test upload product"){
                    self.dataModel.uploadNewProduct(product: Product())
                }
                Divider()
                Button("test upload all product"){
                    self.dataModel.products.forEach({ product in
                        self.dataModel.uploadNewProduct(product: product)
                    })
                }
                Divider()
                Button("test upload order"){
                    let newOrder = Order()
                    newOrder.user = dataModel.user
                    newOrder.product = dataModel.products[03]
                    newOrder.orderId = UUID()
                    self.dataModel.uploadNewOrder(order: newOrder)
                }
                Divider()
                Button("test upload shopping cart"){
                    let serverShoppingCartItemNoId = ServerShoppingCartItemNoId()
                    serverShoppingCartItemNoId.quantity = 1
                    serverShoppingCartItemNoId.user = ServerUser(user: dataModel.user)
                    serverShoppingCartItemNoId.product = ServerProduct(product: dataModel.products[0])
                    self.dataModel.uploadNewShoppingCartItemServer(serverShoppingCartItemNoId: serverShoppingCartItemNoId)
                }
                Divider()
                Button("test upload user"){
                    let user = self.dataModel.user
                    user.userId = UUID()
                    self.dataModel.uploadNewUser(user: user)
                }
            }
            Group{
                Divider()
                Button("test update product"){
                    self.dataModel.updateProduct(product: Product())
                }
                Divider()
                Button("test update order"){
                    let newOrder = Order()
                    newOrder.orderId = UUID()
                    self.dataModel.updateOrder(order: newOrder)
                }
                Divider()
                Button("test update shopping cart"){
                    self.dataModel.updateShoppingCart(shoppingCartItem: ShoppingCartItem(), quantity: 2)
                }
                Divider()
                Button("test update user"){
                    self.dataModel.updateUser(user: self.dataModel.user)
                }
            }
            Divider()
            Button("update test product"){
                let products:[Product] = self.dataModel.products
                let paper: Product = products.first(where: {$0.name == "draft paper"})!
                paper.name = "Draft Paper"
                paper.productDescription = "1 ream (100 sheets) of 8.5 x 11 white draft paper for home or office use"
                self.dataModel.updateProduct(product: paper)
            }
        }
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
            .environmentObject(DataModel())
    }
}
