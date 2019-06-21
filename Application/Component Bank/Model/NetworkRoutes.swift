//
//  NetworkRoutes.swift
//  Component Bank
//
//  Created by Saransh Mittal on 20/06/19.
//  Copyright © 2019 Saransh Mittal. All rights reserved.
//

import Foundation

class NetworkRoutes {
    public static let loginURL = Constants.authenticationURL + "login"
    public static let registerURL = Constants.authenticationURL + "register"
    public static let componentsURL = Constants.memberURL + "getIssuedComponents"
    public static let historyURL = Constants.memberURL + "getHistory"
    public static let inventoryURL = Constants.memberURL + "getAllComponents"
    public static let inventoryIssuerURL = Constants.memberURL + "getIssuers"
    public static let requestComponentURL = Constants.memberURL + "requestComponent"
}
