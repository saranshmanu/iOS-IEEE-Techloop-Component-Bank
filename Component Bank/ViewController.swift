//
//  ViewController.swift
//  E+
//
//  Created by Saransh Mittal on 21/10/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit
import Alamofire

var customToken = String()

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottonConstraint: NSLayoutConstraint!
    @IBOutlet weak var loader: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    var constant:CGFloat = 180.0
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.27) {
            self.topConstraint.constant -= self.constant
            self.bottonConstraint.constant += self.constant
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if !(self.usernameTextField.isEditing || self.passwordTextField.isEditing) {
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.27, animations: {
                self.topConstraint.constant += self.constant
                self.bottonConstraint.constant -= self.constant
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc func dismissKeyboard() {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    @IBAction func loginAction(_ sender: Any) {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.loader.alpha = 1.0
            self.loader.isHidden = false
            self.view.layoutIfNeeded()
        })
        var url = authenticateUrl + "login"
        var username = usernameTextField.text as! String
        var password = passwordTextField.text as! String
        print(username, password)
        Alamofire.request(url, method: .post, parameters: ["email" : username, "password" : password]).responseJSON{
            response in print(response)
            if response.result.isSuccess == true{
                let x = response.result.value! as! NSDictionary
                if x["success"] as! Bool == true{
                    Name = x["name"] as! String
                    RegistrationNum = x["regno"] as! String
                    Email = x["email"] as! String
                    phoneNumber = x["phoneno"] as! String
                    token = x["token"] as! String
                    print("Authentication successfull")
                    print(x)
                    self.view.layoutIfNeeded()
                    UIView.animate(withDuration: 0.2, animations: {
                        self.loader.alpha = 0.0
                        self.loader.isHidden = true
                        self.view.layoutIfNeeded()
                    })
                    //Go to the HomeViewController if the login is sucessful
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController")
                    self.present(vc!, animated: true, completion: nil)
                }
                else{
                    print("Authentication Failed")
                    self.view.layoutIfNeeded()
                    UIView.animate(withDuration: 0.2, animations: {
                        self.loader.alpha = 0.0
                        self.loader.isHidden = true
                        self.view.layoutIfNeeded()
                    })
                    //to initiate alert if login is unsuccesfull
                    let alertController = UIAlertController(title: "Failed!", message: "Authentication Failed!", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            else{
                print("Authentication Failed")
                self.view.layoutIfNeeded()
                UIView.animate(withDuration: 0.2, animations: {
                    self.loader.alpha = 0.0
                    self.loader.isHidden = true
                    self.view.layoutIfNeeded()
                })
                //to initiate alert if login is unsuccesfull
                let alertController = UIAlertController(title: "Failed!", message: "Authentication Failed!", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        loader.alpha = 0.0
        loader.isHidden = true
        usernameTextField.text = ""
        passwordTextField.text = ""
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard)))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

