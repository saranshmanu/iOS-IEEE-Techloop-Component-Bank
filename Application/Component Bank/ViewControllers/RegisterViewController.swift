//
//  RegisterViewController.swift
//  E+
//
//  Created by Saransh Mittal on 27/12/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit
import Alamofire

class RegisterViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottonConstraint: NSLayoutConstraint!
    
    @IBAction func register(_ sender: Any) {
        loaderStart()
        if name.text! == "" || password.text! == "" || email.text! == "" || phone.text! == "" || registrationNum.text! == ""{
            loaderStop()
            AlertView.showAlert(title: "Failed!", message: "Fields Empty!", buttonLabel: "OK", viewController: self)
            return
        }
        let URL =  Constants.authenticationURL + "register"
        if isStringAnInt(string: phone.text!) {
            NetworkEngine.Authentication.register(name: name.text!, registrationNumber: registrationNum.text!, email: email.text!, password: password.text!, phoneNumber: phone.text!, url: URL) { (success) in
                if success {
                    self.loaderStop()
                    AlertView.showAlert(title: "Succcess!", message: "Wait for the admin to approve your request", buttonLabel: "OK", viewController: self)
                } else {
                    self.loaderStop()
                    AlertView.showAlert(title: "Failed!", message: "Registration Failed", buttonLabel: "OK", viewController: self)
                }
            }
        } else {
            loaderStop()
            AlertView.showAlert(title: "Failed!", message: "The phone number entered is not valid", buttonLabel: "OK", viewController: self)
        }
    }
    
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var registrationNum: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var loader: UIView!
    
    var constant:CGFloat = 180.0
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.27) {
            self.topConstraint.constant -= self.constant
            self.bottonConstraint.constant += self.constant
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if !(self.name.isEditing || self.email.isEditing || self.password.isEditing || self.registrationNum.isEditing || self.phone.isEditing) {
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.27, animations: {
                self.topConstraint.constant += self.constant
                self.bottonConstraint.constant -= self.constant
                self.view.layoutIfNeeded()
            })
        }
    }
    
    func isStringAnInt(string: String) -> Bool {
        return Int(string) != nil
    }
    
    func loaderStop() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.loader.isHidden = true
            self.loader.alpha = 0.0
            self.view.layoutIfNeeded()
        })
    }
    
    func loaderStart() {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.loader.isHidden = false
            self.loader.alpha = 1.0
            self.view.layoutIfNeeded()
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.delegate = self
        email.delegate = self
        registrationNum.delegate = self
        phone.delegate = self
        password.delegate = self
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(AuthenticationViewController.dismissKeyboard)))
        name.text = ""
        email.text = ""
        registrationNum.text = ""
        phone.text = ""
        password.text = ""
        loader.alpha = 0.0
        loader.isHidden = true
    }
    
    @objc func dismissKeyboard() {
        name.resignFirstResponder()
        email.resignFirstResponder()
        registrationNum.resignFirstResponder()
        phone.resignFirstResponder()
        password.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
