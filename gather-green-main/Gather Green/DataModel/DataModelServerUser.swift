//
//  DataModelServerUpload.swift
//  Gather Green
//
//  Created by Yiyang Shao on 4/6/23.
//
/*
 This file contains a class ServerUser and an extension of DataModel. The extension contains the "get", "put", "post", and "delete" method of User.
 */

import Foundation

class ServerUser: Codable{
    var id: UUID
    var role:UserPermission
    var firstname: String
    var lastname: String
    var username: String
    var email: String
    var password: String // the password stored here has already been hashed
    var address: String
    var payment: String // at least for now, it is a dummy field
    
    init(){
        self.id = UUID()
        self.role = .premium
        self.firstname = "John"
        self.lastname = "Doe"
        self.username = "johndoe123"
        self.email = "johndoe123@gmail.com"
        self.password = "password"
        self.address = "123 Science Dr."
        self.payment = "Apple Pay"
    }
    
    init(user:User){
        self.id = user.userId
        self.role = user.permission
        self.firstname = user.firstName
        self.lastname = user.lastName
        self.username = user.userName
        self.email = user.email
        self.password = user.password
        self.address = user.address
        self.payment = user.paymentInfo
    }
}


extension DataModel{
    
    func downloadUser(){
        let serverURL:String = "https://sw572.colab.duke.edu/users/get"
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
                    self.loadUsersFromData(post)
                } catch let error {
                    print("json error: \(error)")
                }
            }
            
        }
        httprequest.resume()
    }
    
    
    func loadUsersFromData(_ post:[AnyObject]){
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: post)
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([ServerUser].self, from: jsonData) {
                print("download user succeed, \(decoded.count) users are downloaded")
            }
        }catch{
            print(error)
        }
    }
    
    func deleteAllUsers(users:[ServerUser]){
        users.forEach({user in
            self.deleteUser(userId: user.id)
        })
        
    }
    
    func uploadNewUser(user:User){
        // or the payload is too large
        let serverUser = ServerUser(user: user)
        let serverString = "https://sw572.colab.duke.edu/users/post"
        let requestURL = URL(string: serverString)!
        var request = URLRequest(url: requestURL)
        var encodedProduct = Data()
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(serverUser) {
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
            if let response = response as? HTTPURLResponse,
               response.statusCode != 200 {
                print("Error")
                print(response)
                print(response.statusCode)
            }
        }
        task.resume()
    }
    
    func deleteUser(userId: UUID){
        let serverString = "https://sw572.colab.duke.edu/users/\(userId)"
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
            do {
                if data != nil{
                    let post = try JSONSerialization.jsonObject(with: data!, options: []) as AnyObject
                    print(post)
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
    
    func updateUser(user: User){
        let serverUser = ServerUser(user: user)
        let serverString = "https://sw572.colab.duke.edu/users/put"
        let requestURL = URL(string: serverString)!
        var request = URLRequest(url: requestURL)
        var encodedProduct = Data()
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(serverUser) {
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
                    print("update user success")
                }
            }
        }
        task.resume()
    }
}
