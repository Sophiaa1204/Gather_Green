//
//  DataModelServerCart.swift
//  Gather Green
//
//  Created by Yiyang Shao on 4/10/23.
//
/*
 This file contains a class ServerShoppingCart and an extension of DataModel. The extension contains the "get", "put", "post", and "delete" method of ShoppingCart.
 */

import Foundation

class ServerShoppingCartUser: Codable{
    var id:UUID = UUID()
}

class ServerShoppingCartProduct: Codable{
    var id:UUID = UUID()
}

class ServerShoppingCartItem: Codable{
    var quantity: Float
    var id: UUID
    var product: ServerProduct
    var user: ServerShoppingCartUser
    
    init(){
        self.quantity = 1
        self.id = UUID()
        self.product = ServerProduct()
        self.user = ServerShoppingCartUser()
    }
}

class ServerShoppingCartItemNoId: Codable{
    var quantity: Float
    var product: ServerProduct
    var user: ServerUser
    
    init(){
        self.quantity = 1
        self.product = ServerProduct()
        self.user = ServerUser()
    }
    
    init(shoppingCartItem:ShoppingCartItem){
        self.quantity = shoppingCartItem.count
        self.product = ServerProduct(product: shoppingCartItem.product)
        self.user = ServerUser(user: DataModel.shared.user)
    }
}

class ServerShoppingCartItemUpdate: Codable{
    var quantity: Float = 1
    var id: UUID = UUID()
    var product: ServerShoppingCartProduct = ServerShoppingCartProduct()
    var user: ServerShoppingCartUser = ServerShoppingCartUser()
}


extension DataModel{
    func downloadShoppingCart(){
        let serverURL:String = "https://sw572.colab.duke.edu/shoppingcarts/get"
        let url = URL(string: serverURL)!
        var request = URLRequest(url: url)
        
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(ServerUser(user: self.user))
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData!
        let session : URLSession = {
            let config = URLSessionConfiguration.ephemeral
            config.allowsCellularAccess = false
            let session = URLSession(configuration: config, delegate: nil, delegateQueue: .main)
            return session
        }()
        let httprequest = session.dataTask(with: request){ (data, response, error) in
            if error != nil
            {
                print("error calling GET")
            }
            else
            {
                do {
                    if let post = try JSONSerialization.jsonObject(with: data!, options: []) as? [AnyObject]{
                        self.loadShoppingCartFromData(post)
                    }
                } catch let error {
                    print("json error: \(error)")
                }
            }
            
        }
        httprequest.resume()
    }
    
    func loadShoppingCartFromData(_ post:[AnyObject]){
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: post)
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([ServerShoppingCartItem].self, from: jsonData) {
                var newShoppingCart:[ShoppingCartItem] = []
                decoded.forEach({serverShoppingCartItem in
                    let newShoppingCartItem = ShoppingCartItem(serverShoppingCartItem: serverShoppingCartItem)
                    newShoppingCart.append(newShoppingCartItem)
                })
                self.shoppingCart = newShoppingCart
                print("Load Shopping Cart succeed")
            }
        }catch{
            print(error)
        }
    }
    
    func uploadNewShoppingCartItem(shoppingCartItem:ShoppingCartItem){
        let serverShoppingCartItemNoId = ServerShoppingCartItemNoId()
        serverShoppingCartItemNoId.product = ServerProduct(product: shoppingCartItem.product)
        serverShoppingCartItemNoId.user = ServerUser(user: self.user)
        serverShoppingCartItemNoId.quantity = shoppingCartItem.count
        self.uploadNewShoppingCartItemServer(serverShoppingCartItemNoId:serverShoppingCartItemNoId)
    }
    
    func uploadNewShoppingCartItemServer(serverShoppingCartItemNoId:ServerShoppingCartItemNoId){
        // or the payload is too large
        let serverString = "https://sw572.colab.duke.edu/shoppingcarts/post"
        let requestURL = URL(string: serverString)!
        var request = URLRequest(url: requestURL)
        var encodedProduct = Data()
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(serverShoppingCartItemNoId) {
            if let json = String(data: encoded, encoding: .utf8) {
                request.httpBody = Data(json.utf8)
                encodedProduct = Data(json.utf8)
            }
            else {
                print("JSON Encoding failed.")
                return
            }
        }
        
        let task = URLSession.shared.uploadTask(with: request, from: encodedProduct) { data,
            response, error in
            if error != nil
            {
                print("error calling GET on /posts/, error is \(String(describing: error))")
                return
            }
            do {
                if data != nil{
                    _ = try JSONSerialization.jsonObject(with: data!, options: []) as AnyObject
                }
            } catch {
                print("JSONSerialization error:", error)
            }
            
            
            if let response = response as? HTTPURLResponse,
               response.statusCode != 200 {
                print("Error")
                print(response)
                print(response.statusCode)
            }
        }
        task.resume()
    }
    
    func deleteCartItem(shoppingCartItemId: UUID){
        let serverString = "https://sw572.colab.duke.edu/shoppingcarts/\(shoppingCartItemId)"
        let requestURL = URL(string: serverString)!
        var request = URLRequest(url: requestURL)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil
            {
                print("error calling DELETE on /posts/, error is \(String(describing: error))")
                return
            }
            if let response = response as? HTTPURLResponse,
               response.statusCode != 200 {
                print("Error")
                print(response)
                print(response.statusCode)
            }
        }
        task.resume()
    }
    
    func updateShoppingCart(shoppingCartItem: ShoppingCartItem, quantity: Float){
        let serverShoppingCartItemUpdate = ServerShoppingCartItemUpdate()
        serverShoppingCartItemUpdate.id = shoppingCartItem.shoppingCartItemId
        serverShoppingCartItemUpdate.user.id = self.user.userId
        serverShoppingCartItemUpdate.product.id = shoppingCartItem.product.productId
        serverShoppingCartItemUpdate.quantity = quantity
        let serverString = "https://sw572.colab.duke.edu/shoppingcarts/put"
        let requestURL = URL(string: serverString)!
        var request = URLRequest(url: requestURL)
        var encodedProduct = Data()
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(serverShoppingCartItemUpdate) {
            if let json = String(data: encoded, encoding: .utf8) {
                print("JSON Body: \(json)")
                request.httpBody = Data(json.utf8)
                encodedProduct = Data(json.utf8)
            }
            else {
                print("JSON Encoding failed.")
                return
            }
        }
        
        let task = URLSession.shared.uploadTask(with: request, from: encodedProduct) { data,
            response, error in
            if error != nil
            {
                print("error calling GET on /posts/, error is \(String(describing: error))")
                return
            }
            if let response = response as? HTTPURLResponse,
               response.statusCode != 200 {
                print("Error")
                print(response)
                print(response.statusCode)
            }
        }
        task.resume()
    }
}
