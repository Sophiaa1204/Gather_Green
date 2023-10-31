//
//  ShoppingCartView.swift
//  Gather Green
//
//  Created by Yiyang Shao on 3/21/23.
//

import SwiftUI

struct ShoppingCartView: View {
    @EnvironmentObject var dataModel:DataModel
    @State var num = 0
    @State var numtwo = 0
    @State private var search = ""
    var perpaper = 5
    var perpal = 2
    @State private var selectedIndex: Int = 0
    
    @State var ordered = [orders]()
    @State var cart = [ShoppingCartItem]()
    @State private var checkout = false
    
    var count:Int{
        self.dataModel.shoppingCart.count
    }
    
    var cartItems:[ShoppingCartItem]{
        if search == ""{
            return self.dataModel.shoppingCart
        }else{
            let cartItems = self.dataModel.shoppingCart.filter({item in
                item.product.searchKey.localizedCaseInsensitiveContains(search)
            })
            return cartItems
        }
    }
    
    private let permission = ["Shopping Cart", "Order History"]
    
    var body: some View {
        ScrollView{
            
            VStack{
                HStack {
                    Image("search")
                        .padding(.horizontal, 8)
                    TextField("Search Shopping Cart", text: $search)
                }
                .padding(.all, 20)
                .offset(y:20)
                
                HStack {
                    CategoryView(isActive: selectedIndex == 0, text: permission[0])
//                    ForEach(0 ..< 2) { i in
//                        Button(action: {
//                            selectedIndex = i
//                            print(permission[selectedIndex])
//                        }) {
//                            CategoryView(isActive: selectedIndex == i, text: permission[i])
//                        }
//
//                    }
                    
                }
                .frame(width: UIScreen.screenWidth)
                .padding()
                .background(Color("accentColor2"), in: Rectangle())
                
                
                
                if selectedIndex == 0{
                    ZStack{
                        Color("accentColor2").opacity(0.2)
                            .frame(maxHeight: 220)
                        VStack(spacing: 5){
                            Text("Subtotal: $\(String(format: "%.2f", dataModel.shoppingCartTotal))(\(dataModel.shoppingCart.count) Items)")
                                .frame(width: 350,height: 60)
                                .font(.headline)
                                .background(Color("accentColor2"))
                                .cornerRadius(20)
                                .lineLimit(1)
                            
                            //                        .offset(y:)
                            
                            Button(){
                                checkout = true
                            }label: {
                                Text("Proceed to checkout")
                                    .frame(width: 200,height: 60)
                                    .font(.headline)
                            }.buttonStyle(GrowingButton())
                            .padding()
                            .sheet(isPresented: $checkout){
                                    CheckoutView()
                                }
                            //                        .offset(y:18)
                        }
                    }
                    if count >= 1{
                        ForEach(cartItems, id: \.self) { item in
                            ShoppingCartRow(shoppingCartItem: item, checkout: $checkout)
                        }
                    }
                }
                else {
                    OrderHistoryView()
                }
                
                
            }
            .searchable(text: $search)
        }
        .refreshable {
            self.dataModel.downloadShoppingCart()
            self.dataModel.downloadOneOrders()
        }
    }
}

struct orders: Hashable {
    var count: Int = 0
    var name: String = ""
    var price: Float = 0
    var image: String = ""
//    var product: Product
}


struct ShoppingCartView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingCartView()
            .environmentObject(DataModel.shared)
    }
}
