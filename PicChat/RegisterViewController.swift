//
//  RegisterViewController.swift
//  PicChat
//
//  Created by George James Manayath on 23/05/19.
//  Copyright © 2019 George James Manayath. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class RegisterViewController: UIViewController {

    @IBOutlet weak var nameTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func registerPressed(_ sender: Any) {
        Auth.auth().createUser(withEmail: emailTextfield.text!, password: passwordTextfield.text!, completion: { (user, error) in
            if error != nil {
                self.presentAlert(alert: (error?.localizedDescription)! )
            } else {
                print("Registeraion successful :)")
                if let user = user {
                    Database.database().reference().child("users").child(user.user.uid).child("email").setValue(user.user.email)
                
                self.performSegue(withIdentifier: "moveToSnaps", sender: nil)
                }
            }
        })
    }
    func presentAlert(alert:String){
        let alertVC = UIAlertController(title: "Error", message: alert, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            alertVC.dismiss(animated: true, completion: nil)
        }
        alertVC.addAction(okAction)
        present(alertVC,animated: true,completion: nil)
        
    }

}
