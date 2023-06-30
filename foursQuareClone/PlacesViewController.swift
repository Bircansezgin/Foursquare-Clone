//
//  PlacesViewController.swift
//  Pods
//
//  Created by Bircan Sezgin on 26.06.2023.
//

import UIKit
import Parse

class PlacesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var PlaaceNameArray = [String]()
    var placeIdArray = [String]()
    var selectedID = ""
    
    override func viewDidLoad() {
        
        userAccountInfoFetch()
        
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonClick))
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Exit" ,style: .plain , target: self, action: #selector(exitButton))
        
        tableView.dataSource = self
        tableView.delegate = self
        
        getDataFormParse()
    }
    
    @objc func addButtonClick(){
        self.performSegue(withIdentifier: "placeAddVc", sender: nil)
    }
    
    @objc func exitButton(){
        makeAlertExitButton(title: "Exit", message: "Are you sure to close your account?", okButton: "Yes, Sure", noButton: "No, Thanks")
        
    }

    
    func makeAlertExitButton(title:String, message:String, okButton:String , noButton:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: okButton, style: .default) { alertAction in
            PFUser.logOutInBackground { error in
                if error != nil{
                    //Cikis islemi basarili olmadi!
                    print("Error" + (error?.localizedDescription ?? ""))
                }else{
                    // Cikis islemi basarili oldu!
                    UIControl().sendAction(#selector(NSXPCConnection.suspend),
                                                to: UIApplication.shared, for: nil)
                       DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                           exit(0)
                  }
                }
            }
        }
        let no = UIAlertAction(title: noButton, style:.destructive )
        alert.addAction(ok)
        alert.addAction(no)
        self.present(alert, animated: true)
        
    }
    
    func userAccountInfoFetch(){
        let placeModel = PlaceModel.sharedInstance
        if let currentUser = PFUser.current() {
            let accountName = currentUser.username ?? ""
            placeModel.accountName = accountName
            print(placeModel.accountName)
        }
    }
    
    
    
    func getDataFormParse(){
        let query = PFQuery(className: "places")
        query.findObjectsInBackground { objects, error in
            if error != nil{
                self.makeAlertExitButton(title: "Error", message: "Data no", okButton: "OK", noButton: "Try, Later!")
            }else{
                if objects != nil{
                    self.PlaaceNameArray.removeAll(keepingCapacity: false)
                    self.placeIdArray.removeAll(keepingCapacity: false)
                    for object in objects!{
                        if let placeName = object.object(forKey: "name") as? String{
                            if let placeId = object.objectId{
                                self.PlaaceNameArray.append(placeName)
                                self.placeIdArray.append(placeId)
                            }
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //detailsVc
        if segue.identifier == "detailsVc"{
            let destinationVC = segue.destination as! detailsViewController
            destinationVC.chosenPalceId = selectedID
        }
    }
    
    
}


extension PlacesViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PlaaceNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = PlaaceNameArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedID = placeIdArray[indexPath.row]
        self.performSegue(withIdentifier: "detailsVc", sender: nil)
    }
}
