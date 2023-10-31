//
//  DataModel2.swift
//  Gather Green
//
//  Created by Yiyang Shao on 3/26/23.
//

import Foundation
import SwiftUI


enum ProductType : String, Codable{
    case Paper = "Paper"
    case Glass = "Glass"
    case Plastic = "Plastic"
    case Cardboard = "Cardboard"
    case Unknown = "Unknown"
}

enum ProductStatue: String, Codable{
    case unAuthorized = "unauthorized" // should be authorized by admin, can’t be seen in both markets
    case onsale = "onsale"
    case sold = "sold"
}

enum ProductPermission : String, Codable{
    case admin = "admin"
    case standard = "standard"
    case premium = "premium"
}

enum UserPermission: String, Codable {
    case admin = "admin"
    case standard = "standard"
    case premium = "premium"
}

enum ShipStatue: String {
    case unShipped = "unshipped" // should be authorized by admin
    case shipping = "shipping"
    case shipped = "shipped"
}

class Product:CustomStringConvertible, Codable, Hashable{
    var productId: UUID
    var name: String
    var type: ProductType
    var price: Float
    var image: String // Base64
    var permission: ProductPermission
    var statue: ProductStatue
    var volumePerNumber: Float
    var description: String{
        return "This is \(self.name) of type \(self.type), id \(self.productId), price \(self.price), and permission \(self.permission)"
    }
    var searchKey:String{
        "\(self.name) \(self.type)"
    }
    var productDescription:String
    
    var imageDecoded:Image{
        if let dataDecoded:Data = Data(base64Encoded: (self.image), options: Data.Base64DecodingOptions(rawValue: 0)){
            if let image:UIImage = UIImage(data: dataDecoded){
                return Image(uiImage: image)
            }
        }
        if self.image == ""{
            return Image("placeholder")
        }
        return Image(self.image)
    }
    
    static func == (lhs: Product, rhs: Product) -> Bool {
            return lhs.productId == rhs.productId
        }

    func hash(into hasher: inout Hasher) {
        hasher.combine(productId)
    }
    
    init(){
        self.productId = UUID()
        self.name = "card board"
        self.type = .Cardboard
        self.price = 10
        self.image = ""
        self.statue = .onsale
        self.permission = .standard
        self.productDescription = "This is a card board."
        self.volumePerNumber = 10
    }
    
    init(productId:UUID, name:String, type:ProductType, price: Float, image:String, statue:ProductStatue, permission: ProductPermission, productDescription:String,volume: Float){
        self.productId = productId
        self.name = name
        self.type = type
        self.price = price
        self.image = image
        self.statue = statue
        self.permission = permission
        self.productDescription = productDescription
        self.volumePerNumber = volume
    }
    
    init(serverProduct:ServerProduct){
        self.productId = serverProduct.id
        self.name = serverProduct.name
        self.type = serverProduct.type
        self.price = serverProduct.price
        self.image = serverProduct.image
        self.statue = serverProduct.statue
        self.permission = serverProduct.permission
        self.productDescription = serverProduct.description
        self.volumePerNumber = serverProduct.volume
    }
}

enum UserType{
    case normal
    case tester
    case guest
}

class User: Codable, CustomStringConvertible{
    var userId: UUID
    var permission:UserPermission
    var image:String
    var firstName: String
    var lastName: String
    var userName: String
    var gender: Int?
    var birthday: String?
    var profession: String?
    var email: String
    var password: String // the password stored here has already been hashed
    var address: String
    var paymentInfo: String // at least for now, it is a dummy field
    
    var type:UserType{
        if self.userName == "guestuser"{
            return .guest
        }else if self.userName == "rictelford123"{
            return .tester
        }else{
            return .normal
        }
    }
    
    var fullName: String{
        return "\(self.firstName) \(self.lastName)"
    }
    
    var imageDecoded:Image{
        if let dataDecoded:Data = Data(base64Encoded: (self.image), options: Data.Base64DecodingOptions(rawValue: 0)){
            if let image:UIImage = UIImage(data: dataDecoded){
                return Image(uiImage: image)
            }
        }
        if self.image == ""{
            return Image("placeholder")
        }
        return Image(self.image)
    }
    
    var description:String{
        return "\(firstName) \(lastName) has username \(userName), permission \(permission) and user id \(userId)"
    }
    
    init(){
        self.userId = UUID()
        self.permission = .standard
        self.image = "placeholder"
        self.firstName = "Guest"
        self.lastName = "User"
        self.userName = "guest user"
        self.profession = "Professor"
        self.email = "guestuser@gmail.com"
        self.password = "guest"
        self.gender = 1
        self.birthday = "2000-01-01"
        self.address = "."
        self.paymentInfo = "Apple Pay"
    }
    
    init(type: String){
        if type == "tester"{
            self.userId = UUID(uuidString: "200F7489-30DF-4919-A824-CFC02EA7A9BD")!
            print(self.userId)
            self.permission = .premium
            self.image = "ric"
            self.firstName = "Ric"
            self.lastName = "Telford"
            self.userName = "rictelford123"
            self.profession = "Professor"
            self.email = "ric.telford@duke.edu"
            self.password = "rt113"
            self.gender = 1
            self.birthday = "Unknown"
            self.address = "101 Science Dr., Durham, NC"
            self.paymentInfo = "Apple Pay"
        }else{
            self.userId = UUID(uuidString: "CC7D2A98-819D-40AB-B97F-6392E56DC73A")!
            self.permission = .standard
            self.image = "placeholder"
            self.firstName = "Guest"
            self.lastName = "User"
            self.userName = "guestuser"
            self.profession = "Professor"
            self.email = "guestuser@gmail.com"
            self.password = "password"
            self.gender = 1
            self.birthday = "2000-01-01"
            self.address = "123 Science Dr."
            self.paymentInfo = "Apple Pay"
        }
        
    }
    
    init(serverUser:ServerUser){
        self.userId = serverUser.id
        self.permission = serverUser.role
        self.image = "placeholder"
        self.firstName = serverUser.firstname
        self.lastName = serverUser.lastname
        self.userName = serverUser.username
        self.email = serverUser.email
        self.password = serverUser.password
        self.address = serverUser.address
        self.paymentInfo = serverUser.payment
    }
}

class Order: Hashable{
    var orderId: UUID
    var product: Product
    var user: User
    var shipStatue: ShipStatue?
    var orderTime:String
    var quantity:Float
    var paymentInfo:String
    var orderDate:Date? // time when the order happens
    var from: String? // who donated it, for tracking purpose
    var to: String? // who bought it, for tracking purpose weight: Float
    var location: String? // where you can pick the product
    
    static func == (lhs: Order, rhs: Order) -> Bool {
            return lhs.orderId == rhs.orderId
        }

    func hash(into hasher: inout Hasher) {
        hasher.combine(orderId)
    }
    
    
    init(){
        self.orderId = UUID()
        self.product = Product()
        self.user = User()
        self.shipStatue = .shipped
        self.orderDate = Date()
        self.from = "Duke University"
        self.to = "John Doe"
        self.location = "123 Science Dr."
        self.paymentInfo = "Apple Pay"
        self.quantity = 1
        self.orderTime = "03-31-2023"
    }
    
    init(serverOrder:ServerOrder){
        self.orderId = serverOrder.id
        self.product = Product(serverProduct: serverOrder.product)
        self.user = User(serverUser: serverOrder.user)
        self.orderTime = serverOrder.purchasedtime
        self.quantity = serverOrder.quantity
        self.paymentInfo = serverOrder.paymentinfo
    }
    
    init(serverOrder:ServerOneOrder){
        self.orderId = serverOrder.id
        self.product = Product(serverProduct: serverOrder.product)
        self.user = DataModel.shared.user
        self.orderTime = serverOrder.purchasedtime
        self.quantity = serverOrder.quantity
        self.paymentInfo = serverOrder.paymentinfo
    }
}

class OrderHistory{
    
}

class ShoppingCartItem: Hashable, Codable{
    var product: Product = Product()
    var count: Float = 1
    var shoppingCartItemId: UUID = UUID()
    
    init(){
    }
    
    init(serverShoppingCartItem:ServerShoppingCartItem){
        self.shoppingCartItemId = serverShoppingCartItem.id
        self.product = Product(serverProduct: serverShoppingCartItem.product)
        self.count = serverShoppingCartItem.quantity
    }
    
    static func == (lhs: ShoppingCartItem, rhs: ShoppingCartItem) -> Bool {
        return lhs.shoppingCartItemId == rhs.shoppingCartItemId
        }

    func hash(into hasher: inout Hasher) {
        hasher.combine(shoppingCartItemId)
    }
}

class DataModel:ObservableObject{
    
    static let shared = DataModel()
    
    @Published var products: [Product] = []
    @Published var shoppingCart: [ShoppingCartItem] = []
    @Published var orders:[orders] = []
    @Published var user = User(type:"tester")
    @Published var orderHistory:[Order] = []
    
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    let ArchiveURL = DocumentsDirectory.appendingPathComponent("ProductJSONFile")
    let initArchiveURL:URL = Bundle.main.url(forResource: "InitProduct", withExtension: "json")!
    
    init(){
        self.loadInitProducts()
        self.downloadShoppingCart()
        self.downloadProduct()
        self.downloadOneOrders()
    }
}


// DataModel Methods

extension DataModel{
    func findProductById(productId:UUID) -> Product?{
        let validProduct = self.products.filter({ product in
            product.productId == productId
        })
        if validProduct.count == 0{
            return nil
        }else{
            return validProduct[0]
        }
    }
    
    func createNewUser(){
        
    }
    
    func subScribe(){
        self.user.permission = .premium
        self.updateUser(user: self.user)
    }
    
    func computeCartTotal()->Float{
        var total:Float = 0
        self.shoppingCart.forEach({item in
            total += item.count * item.product.price
        })
        return total
    }
    
    public var shoppingCartTotal: Float{
        var total:Float = 0
        self.shoppingCart.forEach({item in
            total += item.count * item.product.price
        })
        return total
    }
}


// Loading init json into Datamodel
extension DataModel{
    func loadInitProducts(){
        let decoder = JSONDecoder()
        let tempData: Data
        print("loading init json")
        
        do {
            tempData = try Data(contentsOf: initArchiveURL)
        } catch let error as NSError {
            print(error)
            return
        }
        if let decoded = try? decoder.decode([Product].self, from: tempData) {
            self.products = decoded
        }
        self.saveProductsJson()
    }
    
    func saveProductsJson(){
        var outputData = Data()
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self.products) {
            if String(data: encoded, encoding: .utf8) != nil {
                outputData = encoded
            }
            else {return}
            
            do {
                    try outputData.write(to: ArchiveURL)
            } catch let error as NSError {
                print (error)
                return
            }
            return
        }
        else { return }
    }
    
    func addProduct(){
        self.products.append(Product())
    }
}
