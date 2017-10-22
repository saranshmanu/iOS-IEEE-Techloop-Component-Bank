//
//  cardViewController.swift
//  E+
//
//  Created by Saransh Mittal on 21/10/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit
import Firebase

// 657.5

class cardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var cardImage: UIImageView!
    @IBOutlet weak var welcomeMessage: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var registrationNumber: UILabel!
    @IBOutlet weak var searchView: UISearchBar!
    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == historyTableView{
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.2, animations: {
                self.historyHeight.constant = CGFloat(64 * history.count)
                self.pageHeight.constant = 657.5 + (self.inventoryHeight.constant + self.historyHeight.constant)
                self.view.layoutIfNeeded()
            })
            return history.count
        }
        else{
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.2, animations: {
                self.inventoryHeight.constant = CGFloat(64 * inventory.count)
                self.pageHeight.constant = 657.5 + (self.inventoryHeight.constant + self.historyHeight.constant)
                self.view.layoutIfNeeded()
            })
            return inventory.count
        }
    }
    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == historyTableView{
            let cell = historyTableView.dequeueReusableCell(withIdentifier: "historyTableCell", for: indexPath as IndexPath) as! HistoryTableViewCell
            for i in components{
                if String(describing: history[indexPath.row]["code"]) == String(describing: i["code"]){
                    cell.componentName.text = String(describing: i["name"]!)
                    break
                }
            }
            cell.quantityNumber.text = String(describing: history[indexPath.row]["number"]!)
            cell.date.text = String(describing: history[indexPath.row]["date"]!)
            if (history[indexPath.row]["status"] as! Int) == 0{
                cell.status.backgroundColor = UIColor.green
            }
            else{
                cell.status.backgroundColor = UIColor.red
            }
            return cell
        }
        else{
            let cell = inventoryTableView.dequeueReusableCell(withIdentifier: "inventoryTableCell", for: indexPath as IndexPath) as! InventoryTableViewCell
            for i in components{
                if String(describing: inventory[indexPath.row]["code"]) == String(describing: i["code"]){
                    cell.componentName.text = String(describing: i["name"]!)
                    break
                }
            }
            cell.quantityNumber.text = String(describing: inventory[indexPath.row]["number"]!)
            return cell
        }
        
    }
    
    func isStringAnInt(string: String) -> Bool {
        return Int(string) != nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("toggle")
        if tableView == historyTableView{
            print("history")
            historyTableView.deselectRow(at: indexPath as IndexPath, animated: true)
        }
        else{
            print("inventory")
            inventoryTableView.deselectRow(at: indexPath as IndexPath, animated: true)
            let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Please select", message: "Option to select", preferredStyle: .actionSheet)
            let saveActionButton = UIAlertAction(title: "Return Component", style: .default) { _ in
                let alertController = UIAlertController(title: "", message: "Number of components to return", preferredStyle: .alert)
                let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
                    if let field = alertController.textFields![0] as? UITextField {
                        if self.isStringAnInt(string: field.text!) == true {
                            let available = String(describing: inventory[indexPath.row]["number"]!)
                            if Int(field.text!)! <= Int(available)!{
                                print("processing request")
                                let temp = Int(available)! - Int(field.text!)!
                                //to get the current date and time
                                let date = Date()
                                let calendar = Calendar.current
                                let currentDate:String = String(calendar.component(.day, from: date)) + "/" + String(calendar.component(.month, from: date)) + "/" + String(calendar.component(.year, from: date))
                                let currentTime:String = String(calendar.component(.hour, from: date)) + ":" + String(calendar.component(.minute, from: date)) + ":" + String(calendar.component(.second, from: date))
                                FIRDatabase.database().reference().child("inventory/" + uid + "/" + String(indexPath.row) + "/number").setValue(String(temp))
                                history.append(["code" : inventory[indexPath.row]["code"]!, "date" : currentDate + " " + currentTime, "number" : field.text!, "status" : 1])
                                FIRDatabase.database().reference().child("history/" + String(uid)).setValue(history)
                                var count = 0
                                for i in components{
                                    print(String(describing: i["code"]!), String(describing: inventory[indexPath.row]["code"]!))
                                    if String(describing: i["code"]!) == String(describing: inventory[indexPath.row]["code"]!){
                                        break
                                    }
                                    count += 1
                                }
                                FIRDatabase.database().reference().child("components/" + String(count) + "/available").observeSingleEvent(of: .value , with: { (snap) in
                                    let b:Int = snap.value! as! Int
                                    FIRDatabase.database().reference().child("components/" + String(count) + "/available").setValue(b + Int(field.text!)!)
                                })
                            }
                            else{
                                let alertController = UIAlertController(title: "Failed!", message: "Number of components requested exceed than available in inventory", preferredStyle: .alert)
                                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                alertController.addAction(defaultAction)
                                self.present(alertController, animated: true, completion: nil)
                            }

                        }
                        else{
                            let alertController = UIAlertController(title: "Please enter a numeric value", message: "", preferredStyle: .alert)
                            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            alertController.addAction(defaultAction)
                            self.present(alertController, animated: true, completion: nil)
                        }
                    } else {
                        // user did not fill field
                    }
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
                alertController.addTextField { (textField) in
                    textField.placeholder = "Number of components to request for!"
                }
                alertController.addAction(confirmAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
            actionSheetControllerIOS8.addAction(cancel)
            actionSheetControllerIOS8.addAction(saveActionButton)
            self.present(actionSheetControllerIOS8, animated: true, completion: nil)
        }
        
    }
    
    @IBOutlet weak var pageHeight: NSLayoutConstraint!
    @IBOutlet weak var historyHeight: NSLayoutConstraint!
    @IBOutlet weak var inventoryHeight: NSLayoutConstraint!
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var inventoryTableView: UITableView!
    @IBOutlet weak var cardView: UIView!
    
    @objc func dismissKeyboard() {
        searchView.resignFirstResponder()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cardViewController.dismissKeyboard)))
        
        historyTableView.dataSource = self
        historyTableView.delegate = self
        inventoryTableView.delegate = self
        inventoryTableView.dataSource = self
        
        FIRDatabase.database().reference().child("users/" + String(uid)).observeSingleEvent(of: .value , with: { (snapshot) in
            // Get user value
            if let value = snapshot.value as? NSDictionary{
                print(value)
                self.firstName.text = String(describing: value["firstName"]!)
                self.lastName.text = String(describing: value["lastName"]!)
                self.city.text = String(describing: value["place"]!)
                self.registrationNumber.text = String(uid)
            }
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        FIRDatabase.database().reference().child("components").observeSingleEvent(of: .value , with: { (snapshot) in
            // Get user value
            if let value = snapshot.value as? [NSDictionary]{
                print(value)
                components = value as! [NSMutableDictionary]
                FIRDatabase.database().reference().child("inventory/" + String(uid)).observeSingleEvent(of: .value , with: { (snapshot) in
                    // Get user value
                    if let value = snapshot.value as? [NSDictionary]{
                        print(value)
                        inventory = value as! [NSMutableDictionary]
                        self.inventoryTableView.reloadData()
                    }
                    // ...
                }) { (error) in
                    print(error.localizedDescription)
                }
                FIRDatabase.database().reference().child("history/" + String(uid)).observeSingleEvent(of: .value , with: { (snapshot) in
                    // Get user value
                    if let value = snapshot.value as? [NSDictionary]{
                        print(value)
                        history = value as! [NSMutableDictionary]
                        self.historyTableView.reloadData()
                    }
                    // ...
                }) { (error) in
                    print(error.localizedDescription)
                }
            }
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
        FIRDatabase.database().reference().child("history/" + String(uid)).observe(.childChanged, with: {_ in
            print("changedHistory")
            FIRDatabase.database().reference().child("history/" + String(uid)).observeSingleEvent(of: .value , with: { (snapshot) in
                // Get user value
                if let value = snapshot.value as? [NSDictionary]{
                    print(value)
                    history = value as! [NSMutableDictionary]
                    self.historyTableView.reloadData()
                }
                // ...
            }) { (error) in
                print(error.localizedDescription)
            }
        })
        FIRDatabase.database().reference().child("history/" + String(uid)).observe(.childAdded, with: {_ in
            print("changedHistory")
            FIRDatabase.database().reference().child("history/" + String(uid)).observeSingleEvent(of: .value , with: { (snapshot) in
                // Get user value
                if let value = snapshot.value as? [NSDictionary]{
                    print(value)
                    history = value as! [NSMutableDictionary]
                    self.historyTableView.reloadData()
                }
                // ...
            }) { (error) in
                print(error.localizedDescription)
            }
        })
        FIRDatabase.database().reference().child("inventory/" + String(uid)).observe(.childChanged, with: {_ in
            print("changedInventory")
            FIRDatabase.database().reference().child("inventory/" + String(uid)).observeSingleEvent(of: .value , with: { (snapshot) in
                // Get user value
                if let value = snapshot.value as? [NSDictionary]{
                    print(value)
                    inventory = value as! [NSMutableDictionary]
                    self.inventoryTableView.reloadData()
                }
                // ...
            }) { (error) in
                print(error.localizedDescription)
            }
        })
        FIRDatabase.database().reference().child("inventory/" + String(uid)).observe(.childAdded, with: {_ in
            print("changedInventory")
            FIRDatabase.database().reference().child("inventory/" + String(uid)).observeSingleEvent(of: .value , with: { (snapshot) in
                // Get user value
                if let value = snapshot.value as? [NSDictionary]{
                    print(value)
                    inventory = value as! [NSMutableDictionary]
                    self.inventoryTableView.reloadData()
                }
                // ...
            }) { (error) in
                print(error.localizedDescription)
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
