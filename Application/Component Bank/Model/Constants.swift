//
//  Constant.swift
//  E+
//
//  Created by Saransh Mittal on 21/10/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import Foundation

class Constants {
    public static let baseURL = "https://componentbank.herokuapp.com/api/"
    public static let authenticationURL = "https://componentbankredefined.herokuapp.com/authenticate/"
    public static let memberURL = "https://componentbankredefined.herokuapp.com/member/"
    public static let adminURL = "https://componentbankredefined.herokuapp.com/admin/"
    
    func getDate() -> String{
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        return String(day) + "-" + String(month) + "-" + String(year)
    }
}
