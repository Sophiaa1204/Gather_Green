import SwiftUI

struct BuyNowView: View {
    let paymentHandler = PaymentHandler()
    let product:Product
    var productNumber:Int
    
    var body: some View {
        ScrollView{
            Text("Check Out")
                .font(.title)
                .fontWeight(.bold)
            Image("\(product.image)")
                .resizable()
                .aspectRatio(1,contentMode: .fit)
                .edgesIgnoringSafeArea(.top)
            
            Text("Subtotal: $\(String(format: "%.2f", product.price*Float(productNumber) ))")
                .padding()
            Button("Checkout"){
                paymentHandler.startPaymentProduct(product: product, count: productNumber){success in
                }
            }
            .frame(width: 350,height:50)
            .background(Color(red: 0, green: 0, blue: 0.5))
            .foregroundColor(.white)
            .clipShape(Capsule())
            .padding()
        }
    }
}


