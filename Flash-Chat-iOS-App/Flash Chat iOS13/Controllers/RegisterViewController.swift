//
//  RegisterViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//
//if let email n psswd is used so that both can be used with normal string and auth will only happen if both doesnt fail

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func registerPressed(_ sender: UIButton) {
        if let email=emailTextfield.text, let password=passwordTextfield.text{
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e=error{
                    print(e.localizedDescription)
                }else{ //navigation to chatviewcontroller
                    self.performSegue(withIdentifier: K.registerSegue, sender: self)
                }
            }
        }

    }
    
}
