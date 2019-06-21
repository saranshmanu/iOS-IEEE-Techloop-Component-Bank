//
//  NetworkEngine.swift
//  Component Bank
//
//  Created by Saransh Mittal on 20/06/19.
//  Copyright © 2019 Saransh Mittal. All rights reserved.
//

import Foundation
import Alamofire

class NetworkEngine {
    // the class is for all the authentication network calls
    class Authentication {
        // the network call is for user login authentication
        public static func login(username: String, password: String, completion: @escaping (Bool) -> ()) {
            let params = [
                "email"     : username,
                "password"  : password
                ] as Parameters
            let url = NetworkRoutes.loginURL
            Alamofire.request(url, method: .post, parameters: params).responseJSON { response in
                if response.result.isSuccess {
                    let x = response.result.value! as! NSDictionary
                    print(x)
                    if x["success"] as! Bool {
                        User.name               = x["name"] as! String
                        User.registrationNumber = x["regno"] as! String
                        User.email              = x["email"] as! String
                        User.phoneNumber        = x["phoneno"] as! String
                        User.token              = x["token"] as! String
                        completion(true)
                    } else {
                        completion(false)
                    }
                } else {
                    completion(false)
                }
            }
        }
        // the network call is for user registration authentication
        public static func register(name: String, registrationNumber: String, email: String, password: String, phoneNumber: String, completion: @escaping (Bool) -> ()) {
            let params = [
                "name"      : name,
                "regno"     : registrationNumber,
                "email"     : email,
                "password"  : password,
                "phoneno"   : phoneNumber
                ] as Parameters
            let url = NetworkRoutes.registerURL
            Alamofire.request(url, method: .post, parameters: params).responseJSON { response in
                if response.result.isSuccess {
                    let x = response.result.value! as! NSDictionary
                    if x["success"] as! Bool {
                        completion(true)
                    } else {
                        completion(false)
                    }
                } else {
                    completion(false)
                }
            }
        }
    }
    // class is used for getting the details of the purchase historu of the user
    class Member {
        public static func getComponents(completion: @escaping (Bool) -> ()) {
            let params = [
                "token" : User.token
                ] as Parameters
            let url = NetworkRoutes.componentsURL
            Alamofire.request(url, method: .post, parameters: params).responseJSON { response in
                if response.result.isSuccess {
                    let x = response.result.value as! NSDictionary
                    if x["success"] as! Bool {
                        let components: [NSDictionary] = x["components"] as! [NSDictionary]
                        User.components = components
                        completion(true)
                    } else {
                        completion(false)
                    }
                } else {
                    completion(false)
                }
            }
        }
        public static func getBorrowHistory(completion: @escaping (Bool) -> ()) {
            let params = [
                "token" : User.token
                ] as Parameters
            let url = NetworkRoutes.historyURL
            Alamofire.request(url, method: .post, parameters: params).responseJSON { response in
                if response.result.isSuccess {
                    let x = response.result.value as! NSDictionary
                    if x["success"] as! Bool {
                        let history: [NSDictionary] = x["components"] as! [NSDictionary]
                        User.history = history
                        completion(true)
                    } else {
                        completion(false)
                    }
                } else {
                    completion(false)
                }
            }
        }
        public static func getInventory(completion: @escaping (Bool) -> ()) {
            let params = [
                "token" : User.token
                ] as Parameters
            let url = NetworkRoutes.inventoryURL
            Alamofire.request(url, method: .post, parameters: params).responseJSON { response in
                if response.result.isSuccess {
                    let x = response.result.value as! NSDictionary
                    if x["success"] as! Bool {
                        User.inventory = x["components"] as! [NSDictionary]
                        completion(true)
                    } else {
                        completion(false)
                    }
                } else {
                    completion(false)
                }
            }
        }
        public static func getComponentBorrowers(at: Int, completion: @escaping (Bool) -> ()) {
            let component = User.inventory[at] as NSDictionary
            let params = [
                "token" : User.token,
                "id": component["_id"] as! String
            ]
            let url = NetworkRoutes.inventoryIssuerURL
            Alamofire.request(url, method: .post, parameters: params).responseJSON { response in
                if response.result.isSuccess{
                    let x = response.result.value as! NSDictionary
                    if x["success"] as! Bool {
                        User.componentBorrowers = x["transactions"] as! [NSDictionary]
                        completion(true)
                    } else {
                        completion(false)
                    }
                } else {
                    completion(false)
                }
            }
        }
        public static func requestComponent(at: Int, quantity: String, completion: @escaping (Bool) -> ()) {
            let component = User.inventory[at] as NSDictionary
            let params = [
                "email" : User.email,
                "id" : component["_id"] as! String,
                "quantity" : quantity,
                "token" : User.token
                ] as Parameters
            let url = NetworkRoutes.requestComponentURL
            Alamofire.request(url, method: .post, parameters: params).responseJSON{
                response in
                if response.result.isSuccess{
                    let x = response.result.value as! NSDictionary
                    if x["success"] as! Bool == true{
                        completion(true)
                    } else {
                        completion(false)
                    }
                } else {
                    completion(false)
                }
            }
        }
    }
}
