//
//  ProductDetailView.swift
//  Gather Green
//
//  Created by Yiyang Shao on 3/26/23.
//
/*
 https://github.com/abuanwar072/Furniture-Shop-App-UI-SwiftUI
 */

import SwiftUI

struct ProductDetailView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let product:Product
    var body: some View {
        ZStack{
            ScrollView  {
                    product.imageDecoded
                        .resizable()
                        .aspectRatio(1,contentMode: .fit)
                        .edgesIgnoringSafeArea(.top)
                DescriptionView(product:product)
            }
        }
//        .navigationBarBackButtonHidden(true)
//        .navigationBarItems(leading: BackButton(action: {presentationMode.wrappedValue.dismiss()}), trailing: Image("threeDot"))
    }
}

struct BackButton: View {
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Image(systemName: "chevron.backward")
                .foregroundColor(.black)
                .padding(.all, 12)
                .background(Color.white)
                .cornerRadius(8.0)
        }
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct ColorDotView: View {
    let color: Color
    var body: some View {
        color
            .frame(width: 24, height: 24)
            .clipShape(Circle())
    }
}


struct DescriptionView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var dataModel:DataModel
    let product:Product
    @State var productNumber:Int = 1
    @State var checkout:Bool = false
    let paymentHandler = PaymentHandler()
    
    
    var body: some View {
        VStack{
            VStack (alignment: .leading) {
                HStack{
                    Text(product.name)
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer()
                    Text("$ \(String(format: "%.2f", self.product.price))")
                        .font(.title2)
                        .foregroundColor(.black)
                        .padding(.trailing, 20)
                }
                HStack (spacing: 4) {
                    ForEach(0 ..< 5) { item in
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                    }
                    Text("(4.9)")
                        .opacity(0.5)
                        .padding(.leading, 8)
                    Spacer()
                }
                
                Text("Description")
                    .fontWeight(.medium)
                    .padding(.vertical, 8)
                Text(product.autoDescription)
                    .lineSpacing(8.0)
                    .opacity(0.6)
                
                //                Info
//                HStack (alignment: .top) {
//                    VStack (alignment: .leading) {
//                        Text("Size")
//                            .font(.system(size: 16))
//                            .fontWeight(.semibold)
//                        Text("Height: 10 inches")
//                            .opacity(0.6)
//                        Text("Wide: 8 inches")
//                            .opacity(0.6)
//                        Text("Diameter: 0.12 inches")
//                            .opacity(0.6)
//                    }
//
//                    .frame(maxWidth: .infinity, alignment: .leading)
//
//                    Spacer()
//
//                    VStack (alignment: .leading) {
//                        Text("Product Source")
//                            .font(.system(size: 16))
//                            .fontWeight(.semibold)
//                        Text("Duke University")
//                            .opacity(0.6)
//                    }
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                }
//                .padding(.vertical)
                
                
                
                VStack (alignment: .leading) {
                    VStack (alignment: .leading) {
                        Text("Size")
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
                        Text(String(format: "%.2f x %.2f x %.2f inches", self.product.autoSize.length, self.product.autoSize.width, self.product.autoSize.height))
                            .opacity(0.6)
                    }
                    
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                    
                    VStack (alignment: .leading) {
                        Text("Product Origin")
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
                        Text("\(product.autoSource)")
                            .opacity(0.6)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                    
                    VStack (alignment: .leading) {
                        Text("Weight")
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
                        Text("\(String(format: "%.2f", self.product.autoWeight)) Pounds")
                            .opacity(0.6)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.vertical)
                
                //                Colors and Counter
                HStack {
                    Spacer()
                    HStack {
                        //                        Minus Button
                        Button(action: {productNumber -= 1}) {
                            Image(systemName: "minus")
                                .padding(.all, 8)
                            
                        }
                        .frame(width: 30, height: 30)
                        .overlay(Rectangle().stroke())
                        .foregroundColor(.black)
                        
                        Text("\(productNumber)")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 8)
                        
                        //                        Plus Button
                        Button(action: {productNumber += 1}) {
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .padding(.all, 8)
                                .background(Color.green)
                                .clipShape(Circle())
                        }
                    }
                    
                }
            }
                VStack(alignment: .center){
                    Button("Add to Cart"){
                        let newCartItem = ShoppingCartItem()
                        newCartItem.count = Float(productNumber)
                        newCartItem.product = product
                        var productExist = false
                        dataModel.shoppingCart.forEach({item in
                            if item.product.productId == product.productId{
                                item.count += newCartItem.count
                                productExist = true
                            }
                        })
                        if !productExist{
                            dataModel.shoppingCart.append(newCartItem)
                            self.dataModel.uploadNewShoppingCartItem(shoppingCartItem: newCartItem)
                            self.dataModel.downloadShoppingCart()
                        }
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    .frame(width: 350,height:50)
                    .background(Color(red: 0, green: 0, blue: 0.5))
                    .foregroundColor(.white)
                    .clipShape(Capsule())


//                    Button("Buy Now"){
//                        paymentHandler.startPaymentProduct(product: product, count: productNumber){success in
//                        }
////                        checkout = true
////                        paymentHandler.startPayment(){success in
////                        }
//                    }
//                    .frame(width: 350,height:50)
//                    .background(Color(red: 0, green: 0, blue: 0.5))
//                    .foregroundColor(.white)
//                    .clipShape(Capsule())
//                    .sheet(isPresented: $checkout){
//                            BuyNowView(product: product, productNumber: Int(productNumber))
//                        }
                }
        }
        .padding()
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}


struct ProductDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProductDetailView(product: DataModel().products[2])
    }
}
