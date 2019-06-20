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
        public static func login(username: String, password: String, url: String, completion: @escaping (Bool) -> ()) {
            let params = [
                "email"     : username,
                "password"  : password
                ] as Parameters
            Alamofire.request(url, method: .post, parameters: params).responseJSON { response in
                if response.result.isSuccess {
                    let x = response.result.value! as! NSDictionary
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
        public static func register(name: String, registrationNumber: String, email: String, password: String, phoneNumber: String, url: String, completion: @escaping (Bool) -> ()) {
            let params = [
                "name"      : name,
                "regno"     : registrationNumber,
                "email"     : email,
                "password"  : password,
                "phoneno"   : phoneNumber
                ] as Parameters
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
        public static func getComponents(url: String, completion: @escaping (Bool) -> ()) {
            let params = [
                "token" : User.token
                ] as Parameters
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
        public static func getBorrowHistory(url: String, completion: @escaping (Bool) -> ()) {
            let params = [
                "token" : User.token
                ] as Parameters
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
    }
}
