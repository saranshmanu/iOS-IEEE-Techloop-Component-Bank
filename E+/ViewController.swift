//
//  ViewController.swift
//  E+
//
//  Created by Saransh Mittal on 21/10/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

var customToken = String()

class ViewController: UIViewController {

    @IBOutlet weak var forgetPasswordButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBAction func loginAction(_ sender: Any) {
        var url = "https://fathomless-refuge-57649.herokuapp.com/authenticate/"
        var username = usernameTextField.text as! String
        var password = passwordTextField.text as! String
        Alamofire.request(url, method: .post, parameters: ["username" : username, "password" : password], headers: ["Content-Type" : "application/x-www-form-urlencoded"]).responseJSON{
            response in print(response.result.value!)
            if response.result.isSuccess == true{
                let x = response.result.value! as! NSDictionary
                if x["code"] as! Int == 0{
                    customToken = x["token"] as! String
                    FIRAuth.auth()?.signIn(withCustomToken: customToken ?? "") { (user, error) in
                        if error == nil{
                            print("Authentication successfull")
                            print(FIRAuth.auth()?.currentUser?.uid as! String)
                            //Go to the HomeViewController if the login is sucessful
                            let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController")
                            self.present(vc!, animated: true, completion: nil)
                        }
                        else{
                            print("Authentication failed")
                            //to initiate alert if login is unsuccesfull
                            let alertController = UIAlertController(title: "Failed!", message: "Authentication Failed!", preferredStyle: .alert)
                            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            alertController.addAction(defaultAction)
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                }
                else{
                    print("Authentication Failed")
                    //to initiate alert if login is unsuccesfull
                    let alertController = UIAlertController(title: "Failed!", message: "Authentication Failed!", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            else{
                print("Authentication Failed")
                //to initiate alert if login is unsuccesfull
                let alertController = UIAlertController(title: "Failed!", message: "Authentication Failed!", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    @IBAction func registerAction(_ sender: Any) {
        var url = "https://fathomless-refuge-57649.herokuapp.com/register/"
        var username = usernameTextField.text as! String
        var password = passwordTextField.text as! String
        Alamofire.request(url, method: .post, parameters: ["username" : username, "password" : password], headers: ["Content-Type" : "application/x-www-form-urlencoded"]).responseJSON{
            response in print(response.result.value!)
            if response.result.isSuccess == true{
                let x = response.result.value! as! NSDictionary
                if x["code"] as! Int == 0{
                    print("Sign Up Success")
                }
                else if x["code"] as! Int == 1{
                    print("User Already Signed Up or Invalid VIT credentials!")
                }
                else{
                    print("Sign Up Failed")
                }
            }
            else{
                print("Sign Up Failed")
            }
        }
        
    }
    @IBAction func forgetPasswordAction(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

