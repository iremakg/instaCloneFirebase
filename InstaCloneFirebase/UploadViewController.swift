//
//  UploadViewController.swift
//  InstaCloneFirebase
//
//  Created by irem on 5.08.2022.
//

import UIKit
import Firebase

class UploadViewController: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate{
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentText: UITextField!
   @IBOutlet weak var uploadButton: UIButton!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

// resim seçmek
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(choseImage))
        imageView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func choseImage(){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func makeAlert(titleinput: String , messageinput: String){
        let alert = UIAlertController(title: titleinput, message: messageinput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        self.present(alert, animated: true, completion: nil)
    }

  
//    seçilen resmi kaydetmek
    
    @IBAction func actionButtonClicked(_ sender: Any) {
        let storage = Storage.storage()
        let storageReference = storage.reference()
        let mediaFolder = storageReference.child("media")
        
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5){
            
            let uuıd = UUID().uuidString
            
            let imageReference = mediaFolder.child("\(uuıd).jpg")
            imageReference.putData(data, metadata: nil) { (metadata, error) in
                if error != nil {
                    self.makeAlert(titleinput: "Error", messageinput: error?.localizedDescription ?? "Error")
                }else{
                    imageReference.downloadURL { (url, error) in
                        if error == nil {
                            let imageurl = url?.absoluteString
                            
                            
                            //database
                            
                            let firestoreDatabase = Firestore.firestore()
                            var firestoreReference : DocumentReference? = nil
                            let firestorePost = ["imageurl" : imageurl!, "postedBy" : Auth.auth().currentUser!.email!, "postComment" : self.commentText.text!, "date" : FieldValue.serverTimestamp() , "likes" : 0 , ] as [String : Any]
                            firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { (error) in
                                if error != nil{
                                    self.makeAlert(titleinput: "Error", messageinput: error?.localizedDescription ?? "Error")
                                }else{
                                    
                                    self.imageView.image = UIImage(named: "32114")
                                    self.commentText.text = ""
                                    
                                    self.tabBarController?.selectedIndex = 0
                                }
                            })
                            
                            
                            
                        }
                    }
                    
                }
            }
        }
    }
    

}
