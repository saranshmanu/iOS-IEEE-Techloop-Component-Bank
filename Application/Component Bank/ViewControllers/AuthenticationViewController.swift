//
//  ViewController.swift
//  E+
//
//  Created by Saransh Mittal on 21/10/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit
import Alamofire

class AuthenticationViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottonConstraint: NSLayoutConstraint!
    @IBOutlet weak var loader: UIView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBAction func loginAction(_ sender: Any) {
        dismissKeyboard()
        loaderStart()
        let username:String = usernameTextField.text! as String
        let password:String = passwordTextField.text! as String
        print(username, password)
        NetworkEngine.Authentication.login(username: username, password: password) { (success) in
            self.loaderStop()
            if success {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController")
                self.present(vc!, animated: true, completion: nil)
            } else {
                AlertView.showAlert(title: "Failed!", message: "Authentication Failed!", buttonLabel: "OK", viewController: self)
            }
        }
    }
    
    var constant:CGFloat = 180.0
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        loader.alpha = 0.0
        loader.isHidden = true
        usernameTextField.text = "saranshmanu@yahoo.co.in"
        passwordTextField.text = "qwerty"
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(AuthenticationViewController.dismissKeyboard)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
