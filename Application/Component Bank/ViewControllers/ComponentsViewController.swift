//
//  componentsViewController.swift
//  E+
//
//  Created by Saransh Mittal on 21/10/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit
import Alamofire

class ComponentsViewController: UIViewController {
    
    @IBOutlet weak var loader: UIView!
    @IBOutlet weak var background: UIVisualEffectView!
    
    @IBAction func borrowButtonAction(_ sender: Any) {
        let alertController = UIAlertController(title: "Components", message: "Enter the number of components your want to borrow from the Component Bank reserves. Approval may depend on further decision made by the admin!", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            self.loaderStart()
            if let field = alertController.textFields![0] as? UITextField {
                if self.isStringAnInt(string: field.text!) == true {
                    let url = Constants.memberURL + "requestComponent"
                    let date = Date()
                    let calendar = Calendar.current
                    let year = calendar.component(.year, from: date)
                    let month = calendar.component(.month, from: date)
                    let day = calendar.component(.day, from: date)
                    let d = String(day) + "-" + String(month) + "-" + String(year)
                    if Int(field.text!)! > 0 {
                        Alamofire.request(url, method: .post, parameters: ["email" : User.email, "id" : String(describing: User.components[self.selected]["_id"]!), "quantity" : field.text!, "token" : User.token]).responseJSON{
                            response in
                            if response.result.isSuccess{
                                let x = response.result.value as! NSDictionary
                                print(x)
                                if x["success"] as! Bool == true{
                                    self.view.layoutIfNeeded()
                                    UIView.animate(withDuration: 1) {
                                        self.menuView.isHidden = true
                                        self.menuView.alpha = 0.0
                                        self.menuView.isUserInteractionEnabled = false
                                        self.view.layoutIfNeeded()
                                    }
                                    self.fetchData()
                                    self.loaderStop()
                                    AlertView.showAlert(title: "Success!", message: "Component request has been sent! Wait for the admin to approve your request", buttonLabel: "OK", viewController: self)
                                } else {
                                    self.loaderStop()
                                    AlertView.showAlert(title: "Failed!", message: "Failed to borrow", buttonLabel: "OK", viewController: self)
                                }
                            } else {
                                self.loaderStop()
                                AlertView.showAlert(title: "Failed!", message: "Failed to connect to the server", buttonLabel: "OK", viewController: self)
                            }
                        }
                    } else {
                        self.loaderStop()
                        AlertView.showAlert(title: "Please enter a numeric value", message: "The quantity you have entered is a non positive intergral value. Please enter a proper input", buttonLabel: "OK", viewController: self)
                    }
                } else {
                    self.loaderStop()
                    AlertView.showAlert(title: "Please enter a numeric value", message: "", buttonLabel: "OK", viewController: self)
                }
            } else {
                // user did not fill field
                self.loaderStop()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        alertController.addTextField { (textField) in
            textField.placeholder = "Quantity"
        }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    @IBAction func returnButtonAction(_ sender: Any) {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 1) {
            self.menuView.isHidden = true
            self.menuView.alpha = 0.0
            self.menuView.isUserInteractionEnabled = false
            self.view.layoutIfNeeded()
        }
    }
    
    @IBOutlet weak var issuedTableView: UITableView!
    @IBOutlet weak var menuView: UIVisualEffectView!
    @IBOutlet weak var componentsTableView: UITableView!
    
    var issuedTo:[NSDictionary] = []
    var selected = 0
    
    func loaderStart() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.loader.isHidden = false
            self.loader.alpha = 1.0
            self.view.layoutIfNeeded()
        })
    }
    
    func loaderStop() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.loader.isHidden = true
            self.loader.alpha = 0.0
            self.view.layoutIfNeeded()
        })
    }
    
    func isStringAnInt(string: String) -> Bool {
        return Int(string) != nil
    }
    
    func fetchData() {
        let url = Constants.memberURL + "getAllComponents"
        Alamofire.request(url, method: .post, parameters: ["token" : User.token]).responseJSON{
            response in
            if response.result.isSuccess{
                let x = response.result.value as! NSDictionary
                if x["success"] as! Bool == true{
                    User.components = x["components"] as! [NSDictionary]
                    self.componentsTableView.reloadData()
                } else {
                    AlertView.showAlert(title: "Failed", message: "Failed to connect to the server", buttonLabel: "OK", viewController: self)
                }
            } else {
                AlertView.showAlert(title: "Failed", message: "Failed to connect to the server", buttonLabel: "OK", viewController: self)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        componentsTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loader.isHidden = true
        loader.alpha = 0.0
        componentsTableView.dataSource = self
        componentsTableView.delegate = self
        issuedTableView.delegate = self
        issuedTableView.dataSource = self
        menuView.isHidden = true
        menuView.alpha = 0.0
        self.menuView.isUserInteractionEnabled = false
        fetchData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension ComponentsViewController: UITableViewDelegate, UITableViewDataSource {
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == componentsTableView{
            return User.components.count
        } else {
            return issuedTo.count
        }
    }
    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == componentsTableView{
            let cell = componentsTableView.dequeueReusableCell(withIdentifier: "components", for: indexPath as IndexPath) as! ComponentsTableViewCell
            cell.componentNameLabel.text = String(describing : User.components[indexPath.row]["name"]!)
            cell.availabilityLabel.text = String(describing : User.components[indexPath.row]["quantity"]!) + " Available"
            cell.indexNumber.text = String(indexPath.row + 1)
            return cell
        } else {
            let cell = issuedTableView.dequeueReusableCell(withIdentifier: "issued", for: indexPath as IndexPath) as! IssuedTableViewCell
            let memberDetails = issuedTo[indexPath.row]["memberId"] as! NSDictionary
            cell.name.text = String(describing : memberDetails["name"]!)
            cell.issuedDate.text = String(describing : issuedTo[indexPath.row]["date"]!)
            let numberOfIssuedComponents:Int = issuedTo[indexPath.row]["quantity"] as! Int
            cell.quantityIssued.text = String(describing : numberOfIssuedComponents)
            cell.status.isHidden = true
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == componentsTableView{
            selected = indexPath.row
            componentsTableView.deselectRow(at: indexPath as IndexPath, animated: true)
            let url = Constants.memberURL + "getIssuers"
            loaderStart()
            Alamofire.request(url, method: .post, parameters: ["token" : User.token, "id": String(describing: User.components[indexPath.row]["_id"]!)]).responseJSON{
                response in
                if response.result.isSuccess{
                    let x = response.result.value as! NSDictionary
                    if x["success"] as! Bool == true{
                        let y = x["transactions"] as! [NSDictionary]
                        if y.count != 0{
                            self.issuedTo.removeAll()
                            for i in 0...y.count-1{
                                if y[i]["returned"] as! String == "0"{
                                    self.issuedTo.append(y[i])
                                }
                            }
                        }
                        self.loaderStop()
                        self.issuedTableView.reloadData()
                    } else {
                        self.loaderStop()
                        AlertView.showAlert(title: "Failed", message: "Failed to connect to the server", buttonLabel: "OK", viewController: self)
                    }
                } else {
                    self.loaderStop()
                    AlertView.showAlert(title: "Failed", message: "Failed to connect to the server", buttonLabel: "OK", viewController: self)
                }
            }
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.75) {
                self.menuView.isHidden = false
                self.menuView.alpha = 1.0
                self.menuView.isUserInteractionEnabled = true
                self.view.layoutIfNeeded()
            }
        } else {
            issuedTableView.deselectRow(at: indexPath as IndexPath, animated: true)
            let memberDetails = issuedTo[indexPath.row]["memberId"] as! NSDictionary
            let number = String(describing : memberDetails["phoneno"]!)
            print(number)
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string: "tel://" + number)!, options: [:], completionHandler: nil)
            } else {
                print("calling feature not available")
            }
        }
    }
    
}
