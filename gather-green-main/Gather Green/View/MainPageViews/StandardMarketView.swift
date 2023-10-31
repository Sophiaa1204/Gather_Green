//
//  StandardMarketView.swift
//  Gather Green
//
//  Created by Yiyang Shao on 3/27/23.
//


import SwiftUI

func filterProducts(products:[Product], filter: String)-> [Product]{
    if filter == "paper"{
        return products.filter({product in
            product.type == .Paper
        })
    }
    else if filter == "glass"{
        return products.filter({product in
            product.type == .Glass
        })
    }
    else if filter == "plastic"{
        return products.filter({product in
            product.type == .Plastic
        })
    }
    else{
        return products
    }
}


struct StandardMarketView: View {
    @EnvironmentObject var dataModel:DataModel
    let width = UIScreen.screenWidth
    var standardProducts: [Product]{
        return self.dataModel.products.filter({ product in
            product.permission == .standard
        })
    }
    
    var products:[Product]{
        if search == ""{
            return standardProducts
        }else{
            return standardProducts.filter({product in
                product.searchKey.localizedCaseInsensitiveContains(search)
            })
        }
    }
    var productRows:Int{
        (products.count + 1)/2
    }
    @Binding var search: String
    @Binding var filter: String
    
    var size:CGFloat{width/2 - 5}
    
    var body: some View {
        VStack{
            if productRows >= 1{
                ForEach(1 ... productRows,id:\.self){row in
                    HStack{
                        if products.count > 2 * row - 1{
                            ProductCardView(product: products[2*row-2], size: size)
                            ProductCardView(product: products[2*row-1], size: size)
                        }else{
                            ProductCardView(product: products[2*row-2], size: size)
                                .offset(x:-size/2)
                        }
                    }
                }
            }else{
                Text("There is nothing here.")
            }
//            ForEach(0 ..< (products.count+1)/2){i in
//                HStack{
//                    ProductCardView(product: products[2*i], size: width/3)
//                    if products.count > 2 * i + 1{
//                        ProductCardView(product: products[2*i+1], size: width/3)
//                    }
//                }
//            }
        }
        .background(Color.gray.opacity(0.2))
    }
}

struct StandardMarketView_Previews: PreviewProvider {
    @State static var search = ""
    @State static var filter = ""
    static var previews: some View {
        StandardMarketView(search:$search, filter:$filter)
            .environmentObject(DataModel())
    }
}
