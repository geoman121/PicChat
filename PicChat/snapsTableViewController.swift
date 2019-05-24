//
//  snapsTableViewController.swift
//  PicChat
//
//  Created by George James Manayath on 24/05/19.
//  Copyright © 2019 George James Manayath. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class snapsTableViewController: UITableViewController {

    var snaps : [DataSnapshot] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let currentUserUid = Auth.auth().currentUser?.uid{
            Database.database().reference().child("users").child(currentUserUid).child("snaps").observe(.childAdded) { (snapshot) in
            self.snaps.append(snapshot)
            self.tableView.reloadData()
                
                Database.database().reference().child("users").child(currentUserUid).child("snaps").observe(.childRemoved, with: { (snapshot) in
                    
                    var index = 0
                    for snap in self.snaps{
                        if snapshot.key == snap.key{
                            self.snaps.remove(at: index)
                        }
                        index += 1
                    }
                    self.tableView.reloadData()
                })
            }
        }
     
    }

    // MARK: - Table view data source

    @IBAction func logOutTapped(_ sender: Any) {
        try? Auth.auth().signOut()
        
        dismiss(animated: true, completion: nil)
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if snaps.count == 0{
            return 1
        }else{
        return snaps.count
    }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snap = snaps[indexPath.row]
        performSegue(withIdentifier: "viewSnap", sender: snap)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewSnap"{
            if let viewVC = segue.destination as? viewSnapViewController{
                if let snap = sender as? DataSnapshot{
                   viewVC.snap = snap 
                }
                
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()

        if snaps.count == 0{
            cell.textLabel?.text = "You have no pics..!"
        }else{
        let snap = snaps[indexPath.row]

        if let snapDictionary = snap.value as? NSDictionary{
            if let fromEmail = snapDictionary["from"] as? String{
                cell.textLabel?.text = fromEmail
            }
        }
        }
        return cell
    }
    

   

}
