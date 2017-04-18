//
//  ViewController.swift
//  image-picker
//
//  Created by Aqib Shah on 4/16/17.
//  Copyright © 2017 Aqib Shah. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

  let memeTextAttributes: [String: Any] = [
    NSStrokeColorAttributeName: UIColor.black,
    NSForegroundColorAttributeName: UIColor.white,
    NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
    NSStrokeWidthAttributeName: 4
  ]
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var cameraButton: UIBarButtonItem!
  @IBOutlet weak var topTextField: UITextField!
  @IBOutlet weak var bottomTextField: UITextField!
  @IBOutlet weak var toolbar: UIToolbar!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    topTextField.delegate = self
    bottomTextField.delegate = self
    topTextField.defaultTextAttributes = memeTextAttributes
    bottomTextField.defaultTextAttributes = memeTextAttributes
    topTextField.text = "TOP"
    topTextField.textAlignment = .center
    bottomTextField.text = "BOTTOM"
    bottomTextField.textAlignment = .center;
  }
    
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    subscribeToKeyboardNotifications()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    unsubscribeFromKeyboardNotifications()
  }
  
  @IBAction func pickImage(_ sender: Any) {
    let imagePickerCtrl = UIImagePickerController()
    imagePickerCtrl.delegate = self
    imagePickerCtrl.sourceType = .photoLibrary
    present(imagePickerCtrl, animated: true, completion: nil)
  }
  
  @IBAction func pickImageFromCamera(_ sender: Any) {
    let imagePickerCtrl = UIImagePickerController()
    imagePickerCtrl.delegate = self
    imagePickerCtrl.sourceType = .camera
    present(imagePickerCtrl, animated: true, completion: nil)
  }

  func saveMeme() {
    let meme = Meme(topText: topTextField.text!,
                    bottomText: bottomTextField.text!,
                    image: imageView.image!,
                    memedImage: generateMemedImage())
  }
  
  func generateMemedImage() -> UIImage {
    toolbar.isHidden = true
    
    UIGraphicsBeginImageContext(self.view.frame.size)
    view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
    let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    
    toolbar.isHidden = false
    return memedImage
  }
  
  // MARK: UIImagePickerControllerDelegate Methods
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    dismiss(animated: true, completion: nil)
  }
  
  func imagePickerController(_ picker: UIImagePickerController,
                             didFinishPickingMediaWithInfo info: [String : Any]) {
    
    if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
      imageView.image = image
      imageView.contentMode = .scaleAspectFit
    }
    
    dismiss(animated: true, completion: nil)
  }
  
  // MARK: UITextFieldDelegate Methods
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  // MARK: Handle UIKeyboard
  
  func keyboardWillShow(_ notification:Notification) {
    view.frame.origin.y = 0 - getKeyboardHeight(notification)
  }
  
  func keyboardWillHide(_ notification:Notification) {
    view.frame.origin.y = 0
  }
  
  func getKeyboardHeight(_ notification:Notification) -> CGFloat {
    let userInfo = notification.userInfo
    let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
    return keyboardSize.cgRectValue.height
  }
  
  func subscribeToKeyboardNotifications() {
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
  }
  
  func unsubscribeFromKeyboardNotifications() {
    NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
    NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
  }

}   
