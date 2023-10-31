//
//  DataModelServer.swift
//  Gather Green
//
//  Created by Yiyang Shao on 4/1/23.
//
/*
 This file contains a class ServerProduct and an extension of DataModel. The extension contains the "get", "put", "post", and "delete" method of Product. 
 */

import Foundation



class ServerProduct:CustomStringConvertible, Codable{
    var id: UUID
    var name: String
    var type: ProductType
    var price: Float
    var image: String // Base64
    var permission: ProductPermission
    var statue: ProductStatue
    var description: String
    var volume: Float
    
    init(){
        self.id = UUID()
        self.name = "card board"
        self.type = .Cardboard
        self.price = 10
        self.image = ""
        self.statue = .onsale
        self.permission = .standard
        self.description = "This is a card board."
        self.volume = 10
    }
    
    init(id:UUID, name:String, type:ProductType, price: Float, image:String, statue:ProductStatue, permission: ProductPermission, description:String,volume:Float){
        self.id = id
        self.name = name
        self.type = type
        self.price = price
        self.image = image
        self.statue = statue
        self.permission = permission
        self.description = description
        self.volume = volume
    }
    
    init(product:Product){
        self.id = product.productId
        self.name = product.name
        self.type = product.type
        self.price = product.price
        self.image = product.image
        self.statue = product.statue
        self.permission = product.permission
        self.description = product.productDescription
        self.volume = product.volumePerNumber
    }
}





extension DataModel{
    
    func downloadProduct(){
        let serverURL:String = "https://sw572.colab.duke.edu/products/get"
        let url = URL(string: serverURL)!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
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
                    let post = try JSONSerialization.jsonObject(with: data!, options: []) as! [AnyObject]
                    self.loadProductsFromData(post)
                } catch let error {
                    print("json error: \(error)")
                }
            }
            
        }
        httprequest.resume()
    }
    
    func loadProductsFromData(_ post:[AnyObject]){
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: post)
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([ServerProduct].self, from: jsonData) {
                var newProducts:[Product] = []
                for serverProduct in decoded{
                    let newProduct = Product(serverProduct: serverProduct)
                    newProducts.append(newProduct)
                }
                self.products = newProducts
                print("Load products succeed, \(newProducts.count) products are loaded")
            }
        }catch{
            print(error)
        }
    }
    
    func uploadNewProduct(product:Product){
        let serverProduct = ServerProduct(product: product)
        let serverString = "https://sw572.colab.duke.edu/products/post"
        let requestURL = URL(string: serverString)!
        var request = URLRequest(url: requestURL)
        var encodedProduct = Data()
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(serverProduct) {
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
            if let response = response as? HTTPURLResponse{
                if response.statusCode != 200 {
                    print("Error")
                    print(response)
                    print(response.statusCode)
                }else{
                    print("upload product success")
                }
            }
        }
        task.resume()
    }
    
    func deleteProduct(productid: UUID){
        let serverString = "https://sw572.colab.duke.edu/products/\(productid)"
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
            if let response = response as? HTTPURLResponse{
                if response.statusCode != 200 {
                    print("Error")
                    print(response)
                    print(response.statusCode)
                }else{
                    print("delete product success")
                }
            }
        }
        task.resume()
    }
    
    func updateProduct(product: Product){
        let serverProduct = ServerProduct(product: product)
        let serverString = "https://sw572.colab.duke.edu/products/put"
        let requestURL = URL(string: serverString)!
        var request = URLRequest(url: requestURL)
        var encodedProduct = Data()
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(serverProduct) {
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
            if let response = response as? HTTPURLResponse{
                if response.statusCode != 200 {
                    print("Error")
                    print(response)
                    print(response.statusCode)
                }else{
                    print("update product success")
                }
            }
        }
        task.resume()
    }
    
    
    
    
}
