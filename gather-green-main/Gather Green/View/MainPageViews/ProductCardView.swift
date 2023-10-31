//
//  ProductCardView.swift
//  Gather Green
//
//  Created by Yiyang Shao on 3/27/23.
//


import SwiftUI


struct ProductCardView: View {
    let product: Product
    var image:Image {
        product.imageDecoded
    }
    let size: CGFloat
    
    var body: some View {
        NavigationLink(destination: ProductDetailView(product: product)){
            VStack {
                image
                    .resizable()
                    .frame(width: size, height: 200 * (size/210))
                    .cornerRadius(20.0)
                Text(self.product.name)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                HStack (spacing: 2) {
//                    ForEach(0 ..< 5) { item in
//                        Image(systemName: "star.fill")
//                            .foregroundColor(.yellow)
//                    }
                    Text("$\(String(format: "%.2f", self.product.price))")
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.leading)
                }
            }
            .frame(width: size)
                .background(Color.white)
                .cornerRadius(20.0)
            .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.gray, lineWidth: 1)
                )
        }
    }
}

struct ProductCardView_Previews: PreviewProvider {
    static var previews: some View {
        ProductCardView(product: DataModel().products[1],size:210)
    }
}
