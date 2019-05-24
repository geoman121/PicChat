//
//  viewSnapViewController.swift
//  PicChat
//
//  Created by George James Manayath on 24/05/19.
//  Copyright © 2019 George James Manayath. All rights reserved.
//

import UIKit
import FirebaseDatabase
import SDWebImage

class viewSnapViewController: UIViewController {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var snap : DataSnapshot? 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let snapDictionary = snap?.value as? NSDictionary{
            if let description = snapDictionary["description"] as? String{
                if let imageURL = snapDictionary["imageURL"] as? String{
                    messageLabel.text = description
                    
                    if let url = URL(string: imageURL){
                         imageView.sd_setImage(with: url)
                    }
                    
                   
                }
            }
        }
    }
    

}
