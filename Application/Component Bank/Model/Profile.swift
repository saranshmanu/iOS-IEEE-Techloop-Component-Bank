//
//  Profile.swift
//  Component Bank
//
//  Created by Saransh Mittal on 20/06/19.
//  Copyright © 2019 Saransh Mittal. All rights reserved.
//

import Foundation

class User {
    public static var uid = ""
    public static var history:[NSDictionary] = []
    public static var components:[NSDictionary] = []
    public static var inventory:[NSDictionary] = []
    public static var componentBorrowers:[NSDictionary] = []
    public static var customToken = String()
    
    public static var name = ""
    public static var token = ""
    public static var registrationNumber = ""
    public static var email = ""
    public static var phoneNumber = ""
}
