//
//  EditProfileVC.swift
//  Ribbit
//
//  Created by Ahsan Ali on 31/05/2021.

// MARK: - change and update user's info

import Alamofire
import ImageLoader
import IQKeyboardManagerSwift
import SwiftyJSON
import TweeTextField
import UIKit

class EditProfileVC: BaseVC, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    // MARK: - Outlets

    @IBOutlet var txtFacebook: TweeAttributedTextField! {
        didSet { txtFacebook.delegate = self
        }
    }
    @IBOutlet var txtUserName: TweeAttributedTextField!

    @IBOutlet var txtInsta: TweeAttributedTextField! {
        didSet { txtInsta.delegate = self
        }
    }
    @IBOutlet var txtTwitter: TweeAttributedTextField! {
        didSet { txtTwitter.delegate = self
        }
    }
    @IBOutlet var txtBio: TweeAttributedTextField! {
        didSet {
            txtBio.delegate = self
        }
    }
    @IBOutlet var prSwitch: UISwitch!
    // @IBOutlet weak var lblName: UILabel!
    private  let loader: Loader = .fromNib()

    @IBOutlet var profilePhoto: UIImageView!

    // MARK: - Vars
    private var vm: EditProfileViewModel!

    // MARK: - Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        IQKeyboardManager.shared.enableAutoToolbar = true
        vm = EditProfileViewModel()
        setView()
        setNav()
    }

    // MARK: - Actions
    @IBAction func Update(_ sender: Any) {
        txtBio.showInfo("")
        txtInsta.showInfo("")
        txtTwitter.showInfo("")
        txtFacebook.showInfo("")

        let validator = Validator()

        if txtBio.text! != "" {
            if let errorMsg = validator.validate(text: txtBio.text!, with: [.validateBio]) {
                txtBio.showInfo(errorMsg)
                return
            }
        }
        if txtFacebook.text! != "" {
            if let errorMsg = validator.validate(text: txtFacebook.text!, with: [.validateURL ]) {
                txtFacebook.showInfo(errorMsg)
                return
            }
        }

        if txtTwitter.text! != "" {
            if let errorMsg = validator.validate(text: txtTwitter.text!, with: [.validateURL ]) {
                txtTwitter.showInfo(errorMsg)
                return
            }
        }

        if txtInsta.text! != "" {
            if let errorMsg = validator.validate(text: txtInsta.text!, with: [.validateURL ]) {
                txtInsta.showInfo(errorMsg)
                return
            }
        }

        let loader: Loader = .fromNib()
        loader.setView(hasLoader: true)

        vm.updateProfile(username: txtUserName.text!, bio: txtBio.text!, fab: txtFacebook.text!, insta: txtInsta.text!, twiter: txtTwitter.text!, publicPortfolio: prSwitch.isOn.description)
        vm.bindViewModelToController = {
            loader.removeFromSuperview()
            self.view.makeToast("Profile Updated")
        }
        vm.bindErrorViewModelToController = { _ in
            loader.removeFromSuperview()
        }
    }

    // MARK: - IBActions

    @IBAction func Logout(_ sender: Any) {
        USER.shared.logout()
    }

    // MARK: - Helpers
    private func setView() {
        // lblName.text = USER.shared.details?.user?.nameChars.uppercased()
        txtUserName.text = USER.shared.details?.user?.fullName
        txtUserName.isUserInteractionEnabled = false
        txtBio.text = USER.shared.details?.user?.bio
        txtInsta.text = USER.shared.details?.user?.instagramUrl
        txtFacebook.text = USER.shared.details?.user?.facebookUrl
        txtTwitter.text = USER.shared.details?.user?.twitterUrl
        self.profilePhoto.layer.masksToBounds = false
        self.profilePhoto.layer.cornerRadius = self.profilePhoto.frame.size.width / 2
        self.profilePhoto.clipsToBounds = true
        let avatar = USER.shared.details?.user?.avatar ?? ""
        self.profilePhoto.getImage(url: EndPoint.kServerBase + "file/users/"+avatar, placeholderImage: nil) { _ in
            self.profilePhoto.contentMode = .scaleAspectFill
        } failer: { _ in
            self.profilePhoto.setImageForName(USER.shared.details?.user!.firstName?.capitalized ?? "GGOG", backgroundColor: nil, circular: true, textAttributes: nil)
        }
        if let isOn = USER.shared.details?.user?.publicPortfolio, isOn != ""{
            prSwitch.isOn = isOn == "true"
        }
    }

    private func setNav() {
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }

    @IBAction func UploadImage(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "Please Select an Option", preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }))

        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
        }))

        alert.popoverPresentationController?.sourceView = self.view

        self.present(alert, animated: true, completion: {
            print("completion block")
        })
    }
    @IBAction func RemoveImage(_ sender: Any) {
        self.removeImage()
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            print("Image not found!")
            return
        }
        self.uploadImageApiCall(img: selectedImage)
        self.dismiss(animated: true, completion: nil)
    }

    func uploadImageApiCall(img: UIImage) {
        self.loader.setView(hasLoader: true)
        let url = EndPoint.kServerBase + EndPoint.updateAvatar
        NetworkUtil.mulitiparts(apiMethod: url, serverImage: img, parameters: ["": ""], showProgress: true, onSuccess: { resp -> Void in
            self.loader.removeFromSuperview()
            print(resp!)
            do {
                let json = try JSON(data: resp as! Data)
                print(json)
                USER.shared.details?.user?.avatar = json["avatar"].string
                self.profilePhoto.image = img
                self.Update(self)
            } catch let myJSONError {
                print(myJSONError)
            }
        }) { error in
            self.loader.removeFromSuperview()
            print(error)
        }
    }
    func removeImage() {
        self.loader.setView(hasLoader: true)
        let url = EndPoint.kServerBase + EndPoint.updateAvatar
        print(url)
        NetworkUtil.request(apiMethod: url, parameters: ["": ""], requestType: .delete, showProgress: true, view: self.view, onSuccess: { resp -> Void in
            self.loader.removeFromSuperview()
            print(resp!)
            USER.shared.details?.user?.avatar = ""
            self.profilePhoto.setImageForName(USER.shared.details?.user!.firstName?.capitalized ?? "GGOG", backgroundColor: nil, circular: true, textAttributes: nil)
            self.Update(self)
        }) { error in
            print(error)
            self.loader.removeFromSuperview()
            self.view.makeToast(error)
        }
    }
}
// MARK: - Textfield delegate
extension EditProfileVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        if textField == txtBio {
            txtFacebook.becomeFirstResponder()
        } else  if textField == txtFacebook {
            txtTwitter.becomeFirstResponder()
        } else if textField == txtTwitter {
            txtInsta.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtUserName {
            txtUserName.showInfo("")
        } else if textField == txtBio {
            txtBio.showInfo("")
        } else if textField == txtFacebook {
            txtFacebook.showInfo("")
        } else if textField == txtInsta {
            txtInsta.showInfo("")
        } else if textField == txtTwitter {
            txtTwitter.showInfo("")
        }
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        let validator = Validator()

        if updatedText != "" {
            if textField == txtBio {
                if let errorMsg = validator.validate(text: updatedText, with: [.validateBio]) {
                    txtBio.showInfo(errorMsg)
                }
            } else   if textField == txtFacebook {
                if let errorMsg = validator.validate(text: updatedText, with: [.validateURL ]) {
                    txtFacebook.showInfo(errorMsg)
                }
            } else  if textField == txtTwitter {
                if let errorMsg = validator.validate(text: updatedText, with: [.validateURL ]) {
                    txtTwitter.showInfo(errorMsg)
                }
            } else  if textField == txtInsta {
                if let errorMsg = validator.validate(text: updatedText, with: [.validateURL ]) {
                    txtInsta.showInfo(errorMsg)
                }
            }
        }

        return true
    }
}
