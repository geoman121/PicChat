//
//  selectPictureViewController.swift
//  PicChat
//
//  Created by George James Manayath on 24/05/19.
//  Copyright © 2019 George James Manayath. All rights reserved.
//

import UIKit
import FirebaseStorage

class selectPictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var messageTextField: UITextField!
    
    var imagePicker : UIImagePickerController?
    var imageAdded = false
    var imageName = "\(NSUUID().uuidString).jpg"
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
                //upload images
                let imagesFolder = Storage.storage().reference().child("images")
                
                if let  image = imageView.image{
                    if let imageData =  image.jpegData(compressionQuality: 0.1){
                        
                        //setting unique name for image
                        let imageLabel = imagesFolder.child(imageName)
                        imageLabel.putData(imageData, metadata: nil)  { (metadata, error) in
                            if let error = error {
                                self.presentAlert(alert: error.localizedDescription)
                            }else{
                                //next view controller
                                
                                
                                imageLabel.downloadURL(completion: { (url, err) in
                                    if let err = err {
                                        print("Failed to get downloadurl", err)
                                        return
                                    }
                                    else{
                                        if let downloadURL = url?.absoluteString {
                                            print("Successfully uploaded profile image", downloadURL)
                                        self.performSegue(withIdentifier: "selectReciver ", sender: downloadURL)
                                            
                                        }
                                   
                                    }
                                })
                        }
                        
                        }
                }
            }
            
        }
            else{
                
                presentAlert(alert: "You Must Provide an image and a Message.")
                
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let downloadURL = sender as? String{
            if let selectVC = segue.destination as? selectRecipientTableViewController{
                selectVC.downloadURL = downloadURL
                selectVC.snapDecription = messageTextField.text!
                selectVC.imageName = imageName
            }
        }
    }
    
    func presentAlert(alert:String) {
        let alertVC = UIAlertController(title: "Error", message: alert, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            alertVC.dismiss(animated: true, completion: nil)
        }
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
}
