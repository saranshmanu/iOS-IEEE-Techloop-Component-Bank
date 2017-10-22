//
//  componentsViewController.swift
//  E+
//
//  Created by Saransh Mittal on 21/10/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit
import Firebase

class componentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    override func viewWillAppear(_ animated: Bool) {
        componentsTableView.reloadData()
    }
    
    @IBOutlet weak var componentsTableView: UITableView!
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return components.count
    }
    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = componentsTableView.dequeueReusableCell(withIdentifier: "components", for: indexPath as IndexPath) as! componentsTableViewCell
        cell.componentNameLabel.text = String(describing : components[indexPath.row]["name"]!)
        cell.availabilityLabel.text = String(describing : components[indexPath.row]["available"]!) + " Available"
        cell.componentImageView.image = UIImage.init(named: "grey")
        return cell
    }
    
    func isStringAnInt(string: String) -> Bool {
        return Int(string) != nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        componentsTableView.deselectRow(at: indexPath as IndexPath, animated: true)
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Please select", message: "Option to select", preferredStyle: .actionSheet)
        let saveActionButton = UIAlertAction(title: "Request Component", style: .default) { _ in
            let alertController = UIAlertController(title: "Email?", message: "Please input your email:", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
                if let field = alertController.textFields![0] as? UITextField {
                    if self.isStringAnInt(string: field.text!) == true {
                        FIRDatabase.database().reference().child("components/" + String(indexPath.row) + "/available").observeSingleEvent(of: .value , with: { (snapshot) in
                            let available = snapshot.value as! Int
                            if Int(field.text!)! <= available{
                                print("processing request")
                                let temp = available - Int(field.text!)!
                                components[indexPath.row]["available"] = temp
                                //to get the current date and time
                                let date = Date()
                                let calendar = Calendar.current
                                let currentDate:String = String(calendar.component(.day, from: date)) + "/" + String(calendar.component(.month, from: date)) + "/" + String(calendar.component(.year, from: date))
                                let currentTime:String = String(calendar.component(.hour, from: date)) + ":" + String(calendar.component(.minute, from: date)) + ":" + String(calendar.component(.second, from: date))
                                FIRDatabase.database().reference().child("components/" + String(indexPath.row) + "/available").setValue(temp)
                                history.append(["code" : components[indexPath.row]["code"]!, "date" : currentDate + " " + currentTime, "number" : field.text!, "status" : 0])
                                FIRDatabase.database().reference().child("history/" + String(uid)).setValue(history)
                                var count = 0
                                var flag = 0
                                for i in inventory{
                                    print(String(describing: i["code"]!), String(describing: components[indexPath.row]["code"]!))
                                    if String(describing: i["code"]!) == String(describing: components[indexPath.row]["code"]!){
                                        let a = Int(String(describing: inventory[count]["number"]!))! + Int(field.text!)!
                                        inventory[count]["number"] = String(a)
                                        flag = 1
                                        break
                                    }
                                    count += 1
                                }
                                if flag == 0{
                                    inventory.append(["code" : components[indexPath.row]["code"]!, "number" : field.text!])
                                }
                                FIRDatabase.database().reference().child("inventory/" + String(uid)).setValue(inventory)
                            }
                            else{
                                let alertController = UIAlertController(title: "Failed!", message: "Number of components requested exceed than available", preferredStyle: .alert)
                                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                                alertController.addAction(defaultAction)
                                self.present(alertController, animated: true, completion: nil)
                            }
                        })
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
    
    override func viewDidAppear(_ animated: Bool) {
        componentsTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        componentsTableView.dataSource = self
        componentsTableView.delegate = self
        FIRDatabase.database().reference().child("components").observe(.childChanged, with: {_ in
            print("changed")
            FIRDatabase.database().reference().child("components").observeSingleEvent(of: .value , with: { (snapshot) in
                // Get user value
                if let value = snapshot.value as? [NSDictionary]{
                    //print(value)
                    components = value as! [NSMutableDictionary]
                    self.componentsTableView.reloadData()
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
