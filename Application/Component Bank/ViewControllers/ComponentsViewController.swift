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
            let field = alertController.textFields![0] as UITextField
            self.borrowComponent(field: field)
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
        User.componentBorrowers.removeAll()
        hideMenu()
    }
    
    @IBOutlet weak var issuedTableView: UITableView!
    @IBOutlet weak var menuView: UIVisualEffectView!
    @IBOutlet weak var componentsTableView: UITableView!
    var selected = 0
    
    func borrowComponent(field: UITextField) {
        self.showLoader()
        if self.isStringAnInt(string: field.text!) == false {
            self.hideLoader()
            AlertView.showAlert(title: "Please enter a numeric value", message: "", buttonLabel: "OK", viewController: self)
            return
        }
        if Int(field.text!)! <= 0 {
            self.hideLoader()
            AlertView.showAlert(title: "Please enter a numeric value", message: "The quantity you have entered is a non positive intergral value. Please enter a proper input", buttonLabel: "OK", viewController: self)
            return
        }
        NetworkEngine.Member.requestComponent(at: self.selected, quantity: field.text!, completion: { (success) in
            if success {
                self.getInventory()
                self.hideLoader()
                self.hideMenu()
                AlertView.showAlert(title: "Success!", message: "Component request has been sent! Wait for the admin to approve your request", buttonLabel: "OK", viewController: self)
            } else {
                self.hideLoader()
                AlertView.showAlert(title: "Failed!", message: "Failed to borrow", buttonLabel: "OK", viewController: self)
            }
        })
    }
    
    func showLoader() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.loader.isHidden = false
            self.loader.alpha = 1.0
            self.view.layoutIfNeeded()
        })
    }
    
    func hideLoader() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.loader.isHidden = true
            self.loader.alpha = 0.0
            self.view.layoutIfNeeded()
        })
    }
    
    func showMenu() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.75) {
            self.menuView.isHidden = false
            self.menuView.alpha = 1.0
            self.menuView.isUserInteractionEnabled = true
            self.view.layoutIfNeeded()
        }
    }
    
    func hideMenu() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 1) {
            self.menuView.isHidden = true
            self.menuView.alpha = 0.0
            self.menuView.isUserInteractionEnabled = false
            self.view.layoutIfNeeded()
        }
    }
    
    func isStringAnInt(string: String) -> Bool {
        return Int(string) != nil
    }
    
    func getInventory() {
        NetworkEngine.Member.getInventory { (success) in
            if success {
                self.componentsTableView.reloadData()
            } else {
                AlertView.showAlert(title: "Failed", message: "Failed to connect to the server", buttonLabel: "OK", viewController: self)
            }
        }
    }
    
    func getComponentBorrowers(at: Int) {
        NetworkEngine.Member.getComponentBorrowers(at: at) { (success) in
            self.hideLoader()
            if success {
                self.issuedTableView.reloadData()
            } else {
                AlertView.showAlert(title: "Failed", message: "Failed to connect to the server", buttonLabel: "OK", viewController: self)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        getInventory()
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
        getInventory()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ComponentsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == componentsTableView{
            return User.inventory.count
        } else {
            return User.componentBorrowers.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == componentsTableView {
            let component = User.inventory[indexPath.row] as NSDictionary
            let cell = tableView.dequeueReusableCell(withIdentifier: "components", for: indexPath as IndexPath) as! ComponentsTableViewCell
            cell.availabilityLabel.text = "\(component["quantity"]!)"
            cell.componentNameLabel.text = "\(component["name"]!)"
            cell.indexNumberLabel.text = "#\(indexPath.row + 1)"
            return cell
        } else {
            let componentBorrower = User.componentBorrowers[indexPath.row] as NSDictionary
            let member = componentBorrower["memberId"] as! NSDictionary
            let cell = tableView.dequeueReusableCell(withIdentifier: "issued", for: indexPath as IndexPath) as! IssuedTableViewCell
            cell.quantityIssuedLabel.text = "\(componentBorrower["quantity"]!)"
            cell.issuedDateLabel.text = "\(componentBorrower["date"]!)"
            cell.name.text = "\(member["name"]!)"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        if tableView == componentsTableView {
            showLoader()
            selected = indexPath.row
            getComponentBorrowers(at: indexPath.row)
            showMenu()
        } else {
            let memberDetails = User.componentBorrowers[indexPath.row]["memberId"] as! NSDictionary
            let number = String(describing : memberDetails["phoneno"]!)
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string: "tel://" + number)!, options: [:], completionHandler: nil)
            } else {
                // calling feature not available
            }
        }
    }
}
