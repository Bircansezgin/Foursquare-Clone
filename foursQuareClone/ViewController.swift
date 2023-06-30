//
//  ViewController.swift
//  foursQuareClone
//
//  Created by Bircan Sezgin on 1.06.2023.
//

import UIKit
import Parse

class ViewController: UIViewController {
    let user = PFUser()
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
      
        
  
    }
    
    
    @IBAction func signInButton(_ sender: Any) {
        if usernameTextField.text != "" && passwordTextField.text != ""{
            PFUser.logInWithUsername(inBackground: usernameTextField.text!, password: passwordTextField.text!) { user, error in
                if error != nil{
                    self.makeAlert(title: "Error", message: "Kullanici Adi / Sifre Hatali", okButton: "Tekrar deneyin")

                }else{
                    self.performSegue(withIdentifier: "homePage", sender: nil)
                }
            }
        }else{
            makeAlert(title: "Error", message: "Giris Yaparken Hata Olustu!", okButton: "Yeniden Deneyiniz")
        }
    }
    
    @IBAction func signUPbutton(_ sender: Any) {
        if usernameTextField.text != "" && passwordTextField.text != ""{
            user.username = usernameTextField.text!
            user.password = passwordTextField.text!
            user.signUpInBackground { success, error in
                if error != nil{
                    self.makeAlert(title: "Error", message: "Kullanici Adi / Sifre Hatali", okButton: "Tekrar deneyin")
                }else{
                     //Segue
                    self.performSegue(withIdentifier: "homePage", sender: nil)
                }
            }
            
        }else{
            makeAlert(title: "Error", message: "Giris Yaparken Hata Olustu!", okButton: "Yeniden Deneyiniz")
        }
        
    }
    
    
    func makeAlert(title:String, message:String, okButton:String ){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: okButton, style:.default )
        alert.addAction(ok)
        self.present(alert, animated: true)
        
    }

}

