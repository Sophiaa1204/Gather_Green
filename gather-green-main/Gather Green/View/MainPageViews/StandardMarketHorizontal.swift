//
//  StandardMarketHorizontal.swift
//  Gather Green
//
//  Created by Yiyang Shao on 3/27/23.
//

import SwiftUI

struct StandardMarketHorizontal: View {
    @EnvironmentObject var dataModel:DataModel
    let width = UIScreen.screenWidth
    @Binding var search: String
    @Binding var filter: String
    var products:[Product]{
        if search == ""{
            return self.dataModel.products
        }else{
            return self.dataModel.products.filter({product in
                product.searchKey.localizedCaseInsensitiveContains(search)
            })
        }
    }
    var productsPopular:[Product]{
        products.filter({product in
            product.price > 10 && product.permission == .premium
        })
    }
    var productsBestSeller:[Product]{
        products.filter({product in
            product.price <= 10 && product.permission == .premium
        })
    }
    var size:CGFloat{width/2 - 5}
    var body: some View {
        VStack{
            Text("Popular")
                .font(.custom("PlayfairDisplay-Bold", size: 24))
                .padding(.horizontal)
            
            ScrollView (.horizontal, showsIndicators: false) {
                HStack {
//                    ForEach(0 ..< (products.count+1)/2){i in
//                        ProductCardView(product: products[2*i], size: width/2)
//                    }
                    ForEach(productsPopular,id:\.self){
                        product in
                        ProductCardView(product: product, size: size)
                    }
                }
                .padding()
            }
            
            Text("Best-Sellers")
                .font(.custom("PlayfairDisplay-Bold", size: 24))
                .padding(.horizontal)
            
            ScrollView (.horizontal, showsIndicators: false) {
                HStack {
//                    ForEach(0 ..< (products.count+1)/2){i in
//                        if products.count > 2 * i + 1{
//                             ProductCardView(product: products[2*i + 1], size: width/2)
//                        }
//                    }
                    ForEach(productsBestSeller,id:\.self){
                        product in
                        ProductCardView(product: product, size: size)
                    }
                }
                .padding()
            }
            
        }
    }
}

struct StandardMarketHorizontal_Previews: PreviewProvider {
    @State static var search = ""
    @State static var filter = ""
    static var previews: some View {
        StandardMarketHorizontal(search:$search, filter:$filter)
            .environmentObject(DataModel())
    }
}
