//
//  ProfileViewController.swift
//  E+
//
//  Created by Saransh Mittal on 21/10/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit
import Alamofire

// 657.5
class ProfileViewController: UIViewController {
    
    @IBOutlet weak var phoneNum: UILabel!
    @IBOutlet weak var emailField: UILabel!
    @IBOutlet weak var welcomeMessage: UILabel!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var registrationNumber: UILabel!
    @IBOutlet weak var backgroundView: UIScrollView!
    @IBOutlet weak var pageHeight: NSLayoutConstraint!
    @IBOutlet weak var historyHeight: NSLayoutConstraint!
    @IBOutlet weak var inventoryHeight: NSLayoutConstraint!
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var inventoryTableView: UITableView!
    @IBOutlet weak var cardView: UIView!
    
    var screenHeight:Int = 0
    var issued:[NSDictionary] = []
    var returned:[NSDictionary] = []
    
    func isStringAnInt(string: String) -> Bool {
        return Int(string) != nil
    }

    
    
    func fetchData(){
//        NetworkEngine.Member.getComponents(url: Constants.memberURL + "getIssuedComponents") { (success) in
//            if success {
//                NetworkEngine.Member.getBorrowHistory(url: Constants.memberURL + "getHistory", completion: { (success) in
//                    if success {
//                        self.inventoryTableView.reloadData()
//                        self.historyTableView.reloadData()
//                    } else {
//                        AlertView.showAlert(title: "Failed!", message: "Failed to connect to the server", buttonLabel: "OK", viewController: self)
//                    }
//                })
//            } else {
//                AlertView.showAlert(title: "Failed!", message: "Failed to connect to the server", buttonLabel: "OK", viewController: self)
//            }
//        }
        let url = Constants.memberURL + "getIssuedComponents"
        Alamofire.request(url, method: .post, parameters: ["token" : User.token]).responseJSON{
            response in
            if response.result.isSuccess{
                let x = response.result.value as! NSDictionary
                if x["success"] as! Bool == true{
                    self.issued = x["components"] as! [NSDictionary]
                    let URL = Constants.memberURL + "getHistory"
                    Alamofire.request(URL, method: .post, parameters: ["token" : User.token]).responseJSON{
                        response in
                        if response.result.isSuccess{
                            let a = response.result.value as! NSDictionary
                            if a["success"] as! Bool == true{
                                self.returned = a["components"] as! [NSDictionary]
                                self.inventoryTableView.reloadData()
                                self.historyTableView.reloadData()
                            } else {
                                AlertView.showAlert(title: "Failed!", message: "Failed to connect to the server", buttonLabel: "OK", viewController: self)
                            }
                        } else {
                            AlertView.showAlert(title: "Failed!", message: "Failed to connect to the server", buttonLabel: "OK", viewController: self)
                        }
                    }
                } else {
                    AlertView.showAlert(title: "Failed!", message: "Failed to connect to the server", buttonLabel: "OK", viewController: self)
                }
            } else {
                AlertView.showAlert(title: "Failed!", message: "Failed to connect to the server", buttonLabel: "OK", viewController: self)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        historyTableView.dataSource = self
        historyTableView.delegate = self
        inventoryTableView.delegate = self
        inventoryTableView.dataSource = self
        firstName.text = User.name
        registrationNumber.text = User.registrationNumber
        emailField.text = User.email
        phoneNum.text = User.phoneNumber
        screenHeight = Int(UIScreen.main.bounds.height)
        fetchData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == historyTableView{
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.2, animations: {
                self.historyHeight.constant = CGFloat(64 * self.returned.count)
                self.pageHeight.constant = 607.5 + (self.inventoryHeight.constant + self.historyHeight.constant)
                self.view.layoutIfNeeded()
            })
            return returned.count
        } else {
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.2, animations: {
                self.inventoryHeight.constant = CGFloat(64 * self.issued.count)
                self.pageHeight.constant = 607.5 + (self.inventoryHeight.constant + self.historyHeight.constant)
                self.view.layoutIfNeeded()
            })
            return issued.count
        }
    }
    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == historyTableView{
            let cell = historyTableView.dequeueReusableCell(withIdentifier: "historyTableCell", for: indexPath as IndexPath) as! HistoryTableViewCell
            cell.componentName.text = String(describing : returned[indexPath.row]["componentName"]!)
            cell.quantityNumber.text = String(describing: returned[indexPath.row]["quantity"]!)
            cell.date.text = String(describing: returned[indexPath.row]["date"]!)
            return cell
        } else {
            let cell = inventoryTableView.dequeueReusableCell(withIdentifier: "inventoryTableCell", for: indexPath as IndexPath) as! InventoryTableViewCell
            print(issued[indexPath.row])
            cell.componentName.text = String(describing : issued[indexPath.row]["componentName"]!)
            cell.quantityNumber.text = String(describing: issued[indexPath.row]["quantity"]!)
            cell.date.text = String(describing: issued[indexPath.row]["date"]!)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
