//
//  ContactPicker.swift
//  Altienco
//
//  Created by mac on 16/12/22.
//  Copyright © 2022 Letstrack. All rights reserved.
//


import ContactsUI

class ContactPicker : NSObject,CNContactPickerDelegate{
    static let shared  = ContactPicker()
    var pickContactCallback : ((String) -> Void)?
    weak var controller : UIViewController?
    
    func openConatactPiker(cotroller : UIViewController,
                           callback: @escaping (String) -> Void) {
        self.controller = cotroller
        let authorizationStatus = CNContactStore.authorizationStatus(for: .contacts)
        if authorizationStatus == .notDetermined {
            CNContactStore().requestAccess(for: .contacts) { [weak self] didAuthorize,
                                                                         error in
                if didAuthorize  {
                    self?.pickContactCallback = callback;
                    DispatchQueue.main.async {
                        self?.retrieveContacts()
                    }
                }
                else{
                    self?.showSettingsAlert { (check) in
                        if (check){
                            // perint
                        }
                    }
                }
            }
            
        } else if authorizationStatus == .authorized {
            pickContactCallback = callback;
            retrieveContacts()
        }
        else{
            self.showSettingsAlert { (check) in
                if (check){
                    // perint
                }
            }
        }
        
    }
    
    private func showSettingsAlert(_ completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        let alert = UIAlertController(title: nil, message: "This app requires access to Contacts to proceed. Go to Settings to grant access.", preferredStyle: .alert)
        if
            let settings = URL(string: UIApplication.openSettingsURLString),
            UIApplication.shared.canOpenURL(settings) {
            alert.addAction(UIAlertAction(title: "Open Settings", style: .default) { action in
                completionHandler(false)
                UIApplication.shared.open(settings)
            })
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { action in
            completionHandler(false)
        })
        self.controller?.present(alert, animated: true)
    }
    
    func retrieveContacts(){
        let cpvc: CNContactPickerViewController = CNContactPickerViewController()
        let displayedItems = [CNContactPhoneNumbersKey,CNContactEmailAddressesKey]
        cpvc.displayedPropertyKeys = displayedItems
        cpvc.modalPresentationStyle = .fullScreen
        cpvc.delegate = self
        self.controller?.present(cpvc, animated: true, completion: nil)
    }
    
    
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty) {
        if let phone = contactProperty.value as? CNPhoneNumber {
            let numberphn = phone.stringValue.stripped
            pickContactCallback?(numberphn)
        } else {
            print("number.value not of type CNPhoneNumber")
        }
    }
    
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension String {

    var stripped: String {
        let okayChars = Set("1234567890")
        return self.filter {okayChars.contains($0) }
    }
}
