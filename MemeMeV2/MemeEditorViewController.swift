//
//  MemeEditorViewController.swift
//  MemeMeV1
//
//  Created by Yu-Jen Chang on 6/26/17.
//  Copyright © 2017 Yu-Jen Chang. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var ImagePickView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var toolBar: UIToolbar!
    
    @IBOutlet weak var shareButton: UIButton!
    
    
    let imagePickerView = UIImagePickerController()
    let textFieldDelegate = TextFieldDelegate()
    var memeToBeEdited: Meme? 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
        self.imagePickerView.delegate = self
        
        if (self.memeToBeEdited == nil) {
            self.initViewSetup("TOP", bottomString: "BOTTOM", enableShare: false, image: nil)
        } else {
            self.initViewSetup(self.memeToBeEdited!.topText!, bottomString: self.memeToBeEdited!.bottomText!, enableShare: true, image: self.memeToBeEdited!.originImage!)
            self.toolBar.isHidden = true
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // diabled camera button if no camera available
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        self.subscribeToKeyboardNotification()
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        // unsubscribe the notification
        self.unSubscribeToKeyboardNotification()
    }
    
    
    // hide status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // Pick button
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        presentImagePicker(.photoLibrary)
    }
    
    
    // Camera button
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        presentImagePicker(.camera)
    }
    
    
    // init view
    func initViewSetup(_ topString: String, bottomString: String, enableShare: Bool, image: UIImage?) {
        setDefaultTextField(self.topTextField, initText: topString)
        setDefaultTextField(self.bottomTextField, initText: bottomString)
        self.shareButton.isEnabled = enableShare
        self.ImagePickView.image = image
    }
    
    
    // present image picker for different sourceType
    func presentImagePicker(_ source: UIImagePickerControllerSourceType) {
        imagePickerView.sourceType = source
        self.present(imagePickerView, animated: true, completion: nil)
    }
    
    
    // present image when user selects an image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.ImagePickView.image = image
            self.ImagePickView.contentMode = .scaleAspectFit
            self.shareButton.isEnabled = true
            setDefaultTextField(self.topTextField, initText: "TOP")
            setDefaultTextField(self.bottomTextField, initText: "BOTTOM")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // dismiss imagePickerView when user hits cancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    // initialize textField
    func setDefaultTextField(_ textField: UITextField!, initText: String) {
        textField.delegate = textFieldDelegate
        
        // textField attributes
        let memeTextAttributes: [String:Any] = [
            NSStrokeColorAttributeName: UIColor.black,
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            // a zero value for stroke width indicates fill with no stroke
            // a positive value makes a stroke with no fill
            // a negative value for stroke width creates both a fill and stroke
            NSStrokeWidthAttributeName: NSNumber(value: -5.0)
        ]
        
        textField.defaultTextAttributes = memeTextAttributes
        textField.text = initText
        textField.borderStyle = .none
        textField.textAlignment = .center
        textField.backgroundColor = UIColor.clear
    }
    
    
    // get keyboard height
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        // notification carries info in userInfo dictionary
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    
    // move the view up when UIKeyboardWillShow occurs
    func keyboardWillShow(_ notification: Notification) {
        if self.bottomTextField.isFirstResponder {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    
    // move back the view when UIKeyboardWillHide occurs
    func keyboardWillHide(_ notification: Notification) {
        self.view.frame.origin.y = 0
    }
    
    
    // when even UIKeyboardWillShow occurs, the method keyboardWillShow is called
    // when even UIKeyboardWillHide occurs, the method keyboardWillHide is called
    // subscribe to be notified when keyboard appears/hide
    func subscribeToKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    
    // remove keyboard notification
    func unSubscribeToKeyboardNotification() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
    }
    
    
    // share button
    @IBAction func shareMeme(_ sender: Any) {
        let image = generateMemedImage()
        let activityVC = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
        // save memedImage
        activityVC.completionWithItemsHandler = {
            (activitType, completed: Bool, returnedItems: [Any]?, activityError: Error?) in
            // Return if cancelled
            if (!completed) {
                return
            } else {
                self.save(memedImage: image)
            }
            
            //self.dismiss(animated: true, completion: nil)
            if let navigationVC = self.navigationController {
                navigationVC.popToRootViewController(animated: true)
            }
        }
    }
    
    // save memedImage
    func save(memedImage: UIImage) {
        let meme = Meme(topText: self.topTextField.text!, bottomText: self.bottomTextField.text!, originImage: self.ImagePickView.image!, memedImage: memedImage)
        
        // Add to memes array in the AppDelegate for sharing between table view & collection view
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(meme)
        
    }
    
    
    func generateMemedImage() -> UIImage {
        // Hide tool & nav bar
        navigationController?.isNavigationBarHidden = true
        self.toolBar.isHidden = true
        
        
        // render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // put back tool & nav bar
        navigationController?.isNavigationBarHidden = false
        self.toolBar.isHidden = false
        
        
        return memedImage
    }
    
    
    // return to original view
    @IBAction func cancel(_ sender: Any) {
        if self.memeToBeEdited == nil {
            if let navigationVC = self.navigationController {
                navigationVC.popToRootViewController(animated: true)
            }
        } else {
            self.navigationController!.popViewController(animated: true)
        }
        
    }
}



