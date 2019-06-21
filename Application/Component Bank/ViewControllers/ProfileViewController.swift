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
    
    var screenHeight:Int = 0
    
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
    
    func isStringAnInt(string: String) -> Bool {
        return Int(string) != nil
    }
    
    func getBorrowHistory() {
        NetworkEngine.Member.getBorrowHistory(completion: { (success) in
            if success {
                self.inventoryTableView.reloadData()
                self.historyTableView.reloadData()
            } else {
                AlertView.showAlert(title: "Failed!", message: "Failed to connect to the server", buttonLabel: "OK", viewController: self)
            }
        })
    }
    
    func getComponents() {
        NetworkEngine.Member.getComponents() { (success) in
            if success {
                self.getBorrowHistory()
            } else {
                AlertView.showAlert(title: "Failed!", message: "Failed to connect to the server", buttonLabel: "OK", viewController: self)
            }
        }
    }

    func fetchData(){
        getComponents()
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == historyTableView{
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.2, animations: {
                self.historyHeight.constant = CGFloat(64 * User.history.count)
                self.pageHeight.constant = 607.5 + (self.inventoryHeight.constant + self.historyHeight.constant)
                self.view.layoutIfNeeded()
            })
            return User.history.count
        } else {
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.2, animations: {
                self.inventoryHeight.constant = CGFloat(64 * User.components.count)
                self.pageHeight.constant = 607.5 + (self.inventoryHeight.constant + self.historyHeight.constant)
                self.view.layoutIfNeeded()
            })
            return User.components.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == historyTableView {
            let component = User.history[indexPath.row] as NSDictionary
            let cell = historyTableView.dequeueReusableCell(withIdentifier: "historyTableCell", for: indexPath as IndexPath) as! HistoryTableViewCell
            cell.componentName.text = component["componentName"] as? String
            cell.quantityNumber.text = "\(component["quantity"] as! Int)"
            cell.date.text = component["date"] as? String
            return cell
        } else {
            let component = User.components[indexPath.row] as NSDictionary
            let cell = inventoryTableView.dequeueReusableCell(withIdentifier: "inventoryTableCell", for: indexPath as IndexPath) as! InventoryTableViewCell
            cell.componentName.text = component["componentName"] as? String
            cell.quantityNumber.text = "\(component["quantity"] as! Int)"
            cell.date.text = component["date"] as? String
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
}
