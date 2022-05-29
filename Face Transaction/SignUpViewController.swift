//
//  SignUpViewController.swift
//  Face Transaction
//
//  Created by Ayush Singh on 29/05/22.
//

import UIKit
import FirebaseStorage

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var verification: UIButton!
    
    var myimage = UIImage()
    override func viewDidLoad() {
        verification.setTitle("Verifying", for: .normal)
        verification.backgroundColor = .lightGray
        verification.isEnabled = false
        
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.pickPhoto()
        }
        // Do any additional setup after loading the view.
        
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
        imageView.image = image
        
        uploadCaptureImage()
        
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func uploadCaptureImage() {
        let id = number
        let uploadRef = Storage.storage ().reference (withPath: "main/\(id).jpg")
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
                    
                    self.verification.setTitle("You're Verified, Please login again", for: .normal)
                    self.verification.isEnabled = true
                    self.verification.backgroundColor = .link
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
