//
//  selectRecipientTableViewController.swift
//  PicChat
//
//  Created by George James Manayath on 24/05/19.
//  Copyright © 2019 George James Manayath. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class selectRecipientTableViewController: UITableViewController {

    var snapDecription = ""
    var downloadURL = ""
    var users : [User] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        Database.database().reference().child("users").observe(.childAdded)
        {(snapshot) in
            let user = User()
            if let userDictionary = snapshot.value as? NSDictionary{
                if let email = userDictionary["email"] as? String{
                    user.email = email
                    user.uid = snapshot.key
                    self.users.append(user)
                    self.tableView.reloadData()
                }
            }
        }
    }

    // MARK: - Table view data source
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()

        let user = users[indexPath.row]
        cell.textLabel?.text = user.email

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let user = users[indexPath.row]
        if let fromEmail = Auth.auth().currentUser?.email{
            let snap = ["from":fromEmail, "description": snapDecription, "imageURL": downloadURL ]
            Database.database().reference().child("users").child(user.uid).child("snaps").childByAutoId().setValue(snap)
            navigationController?.popToRootViewController(animated: true)
        }
    }
    

}
class User{
    var email = ""
    var uid = ""
}
