//
//  selectPictureViewController.swift
//  PicChat
//
//  Created by George James Manayath on 24/05/19.
//  Copyright © 2019 George James Manayath. All rights reserved.
//

import UIKit

class selectPictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var messageTextField: UITextField!
    
    var imagePicker : UIImagePickerController?
    var imageAdded = false
    override func viewDidLoad() {
        super.viewDidLoad()

       imagePicker = UIImagePickerController()
       imagePicker?.delegate = self
    }
    

    @IBAction func selectPhotoTapped(_ sender: Any) {
        if imagePicker != nil{
        imagePicker!.sourceType = .photoLibrary
        present(imagePicker!, animated: true, completion: nil)
        }
    }
    
    @IBAction func cameraTapped(_ sender: Any) {
        if imagePicker != nil{
            imagePicker!.sourceType = .camera
            present(imagePicker!, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imageView.image = image
            imageAdded = true
        }
        
        dismiss(animated: true, completion: nil)
    }
    @IBAction func nextTapped(_ sender: Any) {
        
        if let message = messageTextField.text{
            if imageAdded && message != ""{
                //next view controller
            }
            else{
                
                let alertVC = UIAlertController(title: "Error", message: "You Must Provide an image and a Message.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
                    alertVC.dismiss(animated: true, completion: nil)
                }
                alertVC.addAction(okAction)
                present(alertVC, animated: true, completion: nil)
                
            }
        }
    }
}
