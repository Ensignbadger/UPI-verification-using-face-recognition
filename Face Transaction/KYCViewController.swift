//
//  KYCViewController.swift
//  Face Transaction
//
//  Created by Ayush Singh on 29/05/22.
//

import UIKit
import FirebaseStorage

class KYCViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var pay: UIButton!
    var myimage = UIImage()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pay.setTitle("Verifying", for: .normal)
        pay.backgroundColor = .lightGray
        pay.isEnabled = false
        downloadURL()
        DispatchQueue.main.async {
            
            self.pickPhoto()
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func verify(_ sender: Any) {
//        api()
        self.performSegue (withIdentifier: "check", sender: self)
        
    }
    func pickPhoto() {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = self
        picker.allowsEditing = true
        present (picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        
        myimage = image
        imageView.image = myimage
        
        uploadCaptureImage()
        
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func api() {
        
        link1 = "\(link1)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        link2 = "\(link2)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        
        let headers = [
            "content-type": "application/x-www-form-urlencoded",
            "X-RapidAPI-Host": "face-verification2.p.rapidapi.com",
            "X-RapidAPI-Key": "52f79a3db8mshfb9661e9ebfd7f4p17a052jsnfc565919706d"
        ]
        
        print(link1,link2)
        let postData = NSMutableData(data: "linkFile1=\(link1)".data(using: String.Encoding.utf8)!)
        postData.append("&linkFile2=\(link2)".data(using: String.Encoding.utf8)!)


        

        let request = NSMutableURLRequest(url: NSURL(string: "https://face-verification2.p.rapidapi.com/faceverification")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        print(request)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error!)
            } else {

                if let data = data {
                    do {

                        
                        if let json = try JSONSerialization.jsonObject(with: data) as? [String:Any]  {
                            print(json)
                            let data = json["data"] as? [String: Any]
                            if let message = data?["resultMessage"] {
                                result = "\(message)"
                                DispatchQueue.main.async {
                                    self.pay.setTitle("PAY", for: .normal)
                                    self.pay.isEnabled = true
                                    self.pay.backgroundColor = .link
                                    
                                }
                                
                            }
                            
                        }
                        
                    } catch let error {
                        print(error)
                    }
                }
            }
        
        })
        
        dataTask.resume()
    }
    
    func downloadURL(){
        let id = number
        let uploadRef = Storage.storage ().reference (withPath: "main/\(id).jpg")
        uploadRef.downloadURL(completion:{ (url, error) in
            if let error = error {
                print ("Got an error generating the URL: \(error.localizedDescription)")
                return
            }
            if let url = url {
                print ("Here is your download URL: \(url.absoluteString)")
                link2 = url.absoluteString
            }
            })
        
    }

    
    func uploadCaptureImage() {
        let id = number
        let uploadRef = Storage.storage ().reference (withPath: "temp/\(id).jpg")
        guard let imageData = imageView.image?.jpegData(compressionQuality: 0.75) else { return }
        let uploadMetadata = StorageMetadata.init()
        uploadMetadata.contentType = "image/jpeg"
        let taskReference = uploadRef.putData (imageData, metadata: uploadMetadata) { (downloadMetadata, error) in
            if let error = error {
                print ("Oh no! Got an error! \(error.localizedDescription)")
                return
            }
            print ("Put is complete and I got this back: \(String (describing: downloadMetadata))")

            uploadRef.downloadURL(completion:{ (url, error) in
                if let error = error {
                    print ("Got an error generating the URL: \(error.localizedDescription)")
                    return
                }
                if let url = url {
                    print ("Here is your download URL: \(url.absoluteString)")
                    link1 = url.absoluteString
                    
                    self.api()
                }
                })
        }
        taskReference.observe(.progress) { [weak self] (snapshot) in
            guard let pctThere = snapshot.progress?.fractionCompleted else { return }
            print ("You are \(pctThere) complete")
        }
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
