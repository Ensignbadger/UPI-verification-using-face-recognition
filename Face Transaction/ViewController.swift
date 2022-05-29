//
//  ViewController.swift
//  Face Transaction
//
//  Created by Ayush Singh on 28/05/22.
//

import UIKit
import FirebaseStorage

var number = ""
var link1 = String()
var link2 = String()
var result = String()

class ViewController: UIViewController {
    @IBOutlet weak var phone: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func login(_ sender: Any) {
        number = phone.text!
        print(number)
        
        checkUser()
    }
    
    func checkUser(){
        let id = number
        let uploadRef = Storage.storage ().reference (withPath: "main/\(id).jpg")
        uploadRef.downloadURL(completion:{ (url, error) in
            if let error = error {
                print ("Sign Up")
                DispatchQueue.main.async {
//                    self.present(ProceedViewController(), animated: true, completion: nil)
                    self.performSegue (withIdentifier: "proceed", sender: self)

                }
     
            
            }
            if let url = url {
                link1 = url.absoluteString
                self.performSegue (withIdentifier: "login", sender: self)
                print ("Log In")
                
            }
            })
        
    }
    

}

