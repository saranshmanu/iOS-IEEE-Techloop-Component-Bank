//
//  RegisterViewController.swift
//  E+
//
//  Created by Saransh Mittal on 27/12/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit
import Alamofire

class RegisterViewController: UIViewController {

    func loginAction() {
        var url = authenticateUrl + "login"
        var username = email.text as! String
        print(username, password)
        Alamofire.request(url, method: .post, parameters: ["email" : username, "password" : password.text!]).responseJSON{
            response in print(response)
            if response.result.isSuccess == true{
                let x = response.result.value! as! NSDictionary
                if x["success"] as! Bool == true{
                    Name = x["name"] as! String
                    RegistrationNum = x["regno"] as! String
                    Email = x["email"] as! String
                    phoneNumber = x["phoneno"] as! String
                    print("Authentication successfull")
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

    func isStringAnInt(string: String) -> Bool {
        return Int(string) != nil
    }
    
    @IBAction func register(_ sender: Any) {
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.loader.alpha = 1.0
            self.loader.isHidden = false
            self.view.layoutIfNeeded()
        })
        if name.text! == "" || password.text! == "" || email.text! == "" || phone.text! == "" || registrationNum.text! == ""{
            let alertController = UIAlertController(title: "Failed!", message: "Fields Empty!", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            var url =  authenticateUrl + "register"
            if isStringAnInt(string: phone.text!){
                Alamofire.request(url, method: .post, parameters: ["name": name.text!, "regno": registrationNum.text!, "email": email.text!, "password": password.text!, "phoneno": phone.text!]).responseJSON{
                    response in
                    if response.result.isSuccess == true{
                        let x = response.result.value! as! NSDictionary
                        if x["success"] as! Bool == true{
                            print("Sign Up Success")
                            self.view.layoutIfNeeded()
                            self.loginAction()
                        }
                        else{
                            print("Sign Up Failed")
                            self.view.layoutIfNeeded()
                            UIView.animate(withDuration: 0.2, animations: {
                                self.loader.alpha = 0.0
                                self.loader.isHidden = true
                                self.view.layoutIfNeeded()
                            })
                            let alertController = UIAlertController(title: "Failed!", message: "Registration Failed!", preferredStyle: .alert)
                            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            alertController.addAction(defaultAction)
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                    else{
                        print("Sign Up Failed")
                        self.view.layoutIfNeeded()
                        UIView.animate(withDuration: 0.2, animations: {
                            self.loader.alpha = 0.0
                            self.loader.isHidden = true
                            self.view.layoutIfNeeded()
                        })
                        let alertController = UIAlertController(title: "Failed!", message: "Registration Failed!", preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
            else{
                print("Sign Up Failed")
                self.view.layoutIfNeeded()
                UIView.animate(withDuration: 0.2, animations: {
                    self.loader.alpha = 0.0
                    self.loader.isHidden = true
                    self.view.layoutIfNeeded()
                })
                let alertController = UIAlertController(title: "Failed!", message: "The phone number entered is not valid", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var registrationNum: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var loader: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard)))
        name.text = "Saransh Mittal"
        email.text = "saranshmanu@yahoo.co.in"
        registrationNum.text = "16BCE0642"
        phone.text = "9910749550"
        password.text = "qwerty"
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
