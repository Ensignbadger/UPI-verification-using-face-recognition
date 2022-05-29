//
//  CheckTransationViewController.swift
//  Face Transaction
//
//  Created by Ayush Singh on 29/05/22.
//

import UIKit

class CheckTransationViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if result == "The two faces belong to the same person. " {
            print("Transation Completed")
            label.text = "Transation Completed"
        }else{
            label.text = "Transation Failed"
        }
        // Do any additional setup after loading the view.
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
