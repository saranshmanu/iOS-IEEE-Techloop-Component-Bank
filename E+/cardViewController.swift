//
//  cardViewController.swift
//  E+
//
//  Created by Saransh Mittal on 21/10/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit
import Alamofire

// 657.5

class cardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var phoneNum: UILabel!
    @IBOutlet weak var emailField: UILabel!
    @IBOutlet weak var welcomeMessage: UILabel!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var registrationNumber: UILabel!
    
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
        }
        else{
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.2, animations: {
                self.inventoryHeight.constant = CGFloat(64 * self.notreturned.count)
                self.pageHeight.constant = 607.5 + (self.inventoryHeight.constant + self.historyHeight.constant)
                self.view.layoutIfNeeded()
            })
            return notreturned.count
        }
    }
    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == historyTableView{
            let cell = historyTableView.dequeueReusableCell(withIdentifier: "historyTableCell", for: indexPath as IndexPath) as! HistoryTableViewCell
            cell.componentName.text = String(describing : returned[indexPath.row]["name"]!) + " - " + String(describing : returned[indexPath.row]["code"]!)
            cell.quantityNumber.text = String(describing: returned[indexPath.row]["quantity"]!)
            cell.date.text = String(describing: returned[indexPath.row]["date"]!)
            return cell
        }
        else{
            let cell = inventoryTableView.dequeueReusableCell(withIdentifier: "inventoryTableCell", for: indexPath as IndexPath) as! InventoryTableViewCell
            print(notreturned[indexPath.row])
            cell.componentName.text = String(describing : notreturned[indexPath.row]["name"]!) + " - " + String(describing : notreturned[indexPath.row]["code"]!)
            cell.quantityNumber.text = String(describing: notreturned[indexPath.row]["quantity"]!)
            cell.date.text = String(describing: notreturned[indexPath.row]["date"]!)
            return cell
        }
    }
    
    func isStringAnInt(string: String) -> Bool {
        return Int(string) != nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    @IBOutlet weak var backgroundView: UIScrollView!
    @IBOutlet weak var pageHeight: NSLayoutConstraint!
    @IBOutlet weak var historyHeight: NSLayoutConstraint!
    @IBOutlet weak var inventoryHeight: NSLayoutConstraint!
    @IBOutlet weak var historyTableView: UITableView!
    @IBOutlet weak var inventoryTableView: UITableView!
    @IBOutlet weak var cardView: UIView!
    
    @objc func dismissKeyboard() {
    }
    
    var notreturned:[NSDictionary] = []
    var returned:[NSDictionary] = []
    
    func fetchData(){
        returned.removeAll()
        notreturned.removeAll()
        let url = baseUrl + "currentlyIssuedComponents"
        Alamofire.request(url, method: .post, parameters: ["email" : Email]).responseJSON{
            response in
            if response.result.isSuccess{
                let x = response.result.value as! NSDictionary
                if x["success"] as! Bool == true{
                    let z = x["componentsIssued"] as! [NSDictionary]
                    if z.count != 0{
                        for i in 0...z.count-1{
                            if z[i]["returned"] as! String == "true"{
                                self.returned.append(z[i])
                            }
                            else{
                                self.notreturned.append(z[i])
                            }
                        }
                    }
                    self.notreturned.remove(at: 0)
                    self.inventoryTableView.reloadData()
                    self.historyTableView.reloadData()
                }
                else {
                    let alertController = UIAlertController(title: "Failed!", message: "Failed to connect to the server", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            else{
                let alertController = UIAlertController(title: "Failed!", message: "Failed to connect to the server", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        historyTableView.dataSource = self
        historyTableView.delegate = self
        inventoryTableView.delegate = self
        inventoryTableView.dataSource = self
        
        firstName.text = Name
        registrationNumber.text = RegistrationNum
        emailField.text = Email
        phoneNum.text = phoneNumber
        fetchData()
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
