//
//  DataModelServerOrder.swift
//  Gather Green
//
//  Created by Yiyang Shao on 4/10/23.
//
/*
 This file contains a class ServerOrder and an extension of DataModel. The extension contains the "get", "put", "post", and "delete" method of Order.
 */

import Foundation

class ServerUserId: Codable{
    var id: UUID
    
    init(id: UUID){
        self.id = id
    }
}

class ServerOneOrder: Codable{
    var id: UUID
    var paymentinfo: String
    var product: ServerProduct
    var purchasedtime:String
    var quantity:Float
    var user:ServerUserId
    
    init(){
        self.id = UUID()
        self.paymentinfo = "Apple Pay"
        self.product = ServerProduct()
        self.purchasedtime = "2023-03-31"
        self.quantity = 1
        self.user = ServerUserId(id: UUID())
    }
    
    init(order: Order){
        self.id = order.orderId
        self.paymentinfo = order.paymentInfo
        self.product = ServerProduct(product: order.product)
        self.purchasedtime = order.orderTime
        self.quantity = order.quantity
        self.user = ServerUserId(id: order.user.userId)
    }
}

class ServerOrder: Codable{
    var id: UUID
    var paymentinfo: String
    var product: ServerProduct
    var purchasedtime:String
    var quantity:Float
    var user:ServerUser
    
    init(){
        self.id = UUID()
        self.paymentinfo = "Apple Pay"
        self.product = ServerProduct()
        self.purchasedtime = "2023-03-31"
        self.quantity = 1
        self.user = ServerUser()
    }
    
    init(order: Order){
        self.id = order.orderId
        self.paymentinfo = order.paymentInfo
        self.product = ServerProduct(product: order.product)
        self.purchasedtime = order.orderTime
        self.quantity = order.quantity
        self.user = ServerUser(user: order.user)
    }
}


extension DataModel{
    func downloadAllOrders(){
        let serverURL:String = "https://sw572.colab.duke.edu/orders/getall"
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
                    self.loadAllOrdersFromData(post)
                } catch let error {
                    print("json error: \(error)")
                }
            }
            
        }
        httprequest.resume()
    }
    
    func downloadOneOrders(){
        let serverURL:String = "https://sw572.colab.duke.edu/orders/getone"
        let url = URL(string: serverURL)!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(ServerUser(user: self.user))
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
                    let post = try JSONSerialization.jsonObject(with: data!, options: []) as! [AnyObject]
                    self.loadOneOrdersFromData(post)
                } catch let error {
                    print("json error: \(error)")
                }
            }
            
        }
        httprequest.resume()
    }
    
//    func deleteAllOrders(order:[ServerOrder]){
//        orders.forEach({user in
//            self.deleteOrder(orderId: <#T##UUID#>)
//        })
//
//    }
    
    func loadOneOrdersFromData(_ post:[AnyObject]){
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: post)
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([ServerOneOrder].self, from: jsonData) {
                var newOrders:[Order] = []
                for serverOrder in decoded{
                    let newOrder = Order(serverOrder: serverOrder)
                    newOrders.append(newOrder)
                }
                newOrders = newOrders.sorted(by: {
                    $0.orderTime > $1.orderTime
                })
                self.orderHistory = newOrders
                print("load \(newOrders.count) server order succeed")
                // TODO:
                // load order to datamodel
            }
        }catch{
            print(error)
        }
    }
    
    func loadAllOrdersFromData(_ post:[AnyObject]){
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: post)
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([ServerOrder].self, from: jsonData) {
                var newOrders:[Order] = []
                for serverOrder in decoded{
                    let newOrder = Order(serverOrder: serverOrder)
                    newOrders.append(newOrder)
                }
                self.orderHistory = newOrders
                print("load \(newOrders.count) server order succeed")
                // TODO:
                // load order to datamodel
            }
        }catch{
            print(error)
        }
    }
    
    func uploadNewOrder(order:Order){
        // or the payload is too large
        let serverOrder = ServerOrder(order: order)
        
        let serverString = "https://sw572.colab.duke.edu/orders/post"
        let requestURL = URL(string: serverString)!
        var request = URLRequest(url: requestURL)
        var encodedProduct = Data()
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(serverOrder) {
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
            do {
                let post = try JSONSerialization.jsonObject(with: data!, options: []) as AnyObject
                print("data: \(post)")
            } catch let error {
                print("json error: \(error)")
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
    
    func deleteOrder(orderId: UUID){
        let serverString = "https://sw572.colab.duke.edu/products/\(orderId)"
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
    
    func updateOrder(order: Order){
        let serverOrder = ServerOrder(order: order)
        let serverString = "https://sw572.colab.duke.edu/products/put"
        let requestURL = URL(string: serverString)!
        var request = URLRequest(url: requestURL)
        var encodedProduct = Data()
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(serverOrder) {
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
