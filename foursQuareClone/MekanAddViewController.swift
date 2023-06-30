//
//  MekanAddViewController.swift
//  foursQuareClone
//
//  Created by Bircan Sezgin on 27.06.2023.
//

import UIKit

class MekanAddViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    
    @IBOutlet weak var placeNameTextField: UITextField!
    @IBOutlet weak var placeTypeTextfield: UITextField!
    @IBOutlet weak var placeCommentTextField: UITextField!
    @IBOutlet weak var photoSelectImage: UIImageView!
    @IBOutlet weak var nextButtonHide: UIButton!
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButtonHide.isHidden = true
        photoSelectImage.isUserInteractionEnabled = true // Tiklanabilirlige Erisim vermek!
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(choseImage))
        photoSelectImage.addGestureRecognizer(gestureRecognizer)
        
        let gestureRecognizerHide = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(gestureRecognizerHide)
        
        
        
    }
    
    @objc func choseImage(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        
        pickerController.sourceType = .photoLibrary
        self.present(pickerController, animated: true)
    }
    
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
    // Resim secildekten sonra ne olmasini istiyorisek!
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        photoSelectImage.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
        nextButtonHide.isHidden = false
    }

    @IBAction func nextPageButton(_ sender: Any) {
        
        if placeNameTextField.text != "" && placeTypeTextfield.text != "" && placeCommentTextField.text != ""{
            if let chosenImage = photoSelectImage.image{
                let placeModel = PlaceModel.sharedInstance
                placeModel.placeName = placeNameTextField.text!
                placeModel.placeType = placeTypeTextfield.text!
                placeModel.placeComment = placeCommentTextField.text!
                placeModel.placeImage = chosenImage
                
                self.performSegue(withIdentifier: "mapVc", sender: nil)
            }
            
        }else{
            makeAlerts(title: "Error", message: "Place Name/Type/Comment??")
        }
        
        
    }
    
    
    
    func makeAlerts(title:String, message:String){
        let alerts = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Okay", style: .default)
        alerts.addAction(okButton)
        self.present(alerts, animated: true)
    }
}
