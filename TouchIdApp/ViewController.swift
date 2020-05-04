//
//  ViewController.swift
//  TouchIdApp
//
//  Created by NISHANT RANJAN on 14/4/20.
//  Copyright © 2020 NISHANT RANJAN. All rights reserved.
//

import UIKit
import LocalAuthentication


class ViewController: UIViewController {

    @IBOutlet weak var infoLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func touchIdAction(_ sender: UIButton) {
        let  context = LAContext()
        var error : NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            self.evaluatePolicy(context: context)
        }
        else {
            switch error?.code {
            case LAError.Code.touchIDNotEnrolled.rawValue:
                self.infoLabel.text = error?.localizedDescription
            case LAError.Code.passcodeNotSet.rawValue:
                 self.infoLabel.text = error?.localizedDescription
            default:
                 self.infoLabel.text = error?.localizedDescription
            }
        }
    }
    
    func evaluatePolicy(context : LAContext) {
        
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Touch ID evaluate") { (sucess, error) in
            if error == nil {
                DispatchQueue.main.async {
                    self.infoLabel.text = "Success"
                    self.performSegue(withIdentifier: "secret", sender: self)
                }
            }
            else {
                
                DispatchQueue.main.async {
                  
                     if let err = error {
                        
                        switch err._code {
                                                       
                        case LAError.Code.systemCancel.rawValue:
                         self.infoLabel.text = "systemCancel"
                                                       
                        case LAError.Code.userCancel.rawValue:
                        self.infoLabel.text = "systemCancel"
                                                       
                        case LAError.Code.userFallback.rawValue:
                           self.infoLabel.text = "userFallback"
                           self.passwordCheck()
                                                       
                        default:
                         self.infoLabel.text = error?.localizedDescription
                     }
                    }
                }
                
               
                
                
                
//                switch error!._code {
//                case LAError.Code.systemCancel.rawValue:
//                    self.infoLabel.text = "systemCancel"
//                case LAError.Code.userCancel.rawValue:
//                    self.infoLabel.text = "userCancel"
//                case LAError.Code.userFallback.rawValue:
//                    self.infoLabel.text = "userFallback"
//                default:
//                    self.infoLabel.text = error?.localizedDescription
//                }
            }
        }
    }
    
    func passwordCheck() {
        let alert = UIAlertController(title: "Password", message: "Enter the password", preferredStyle: .alert)
        
        let authenticationAction = UIAlertAction(title: "Authenticate", style: .default) { (action) in
           
            guard let  textfield = alert.textFields?.first, let password = textfield.text else {
                return
            }
            
            if (password == "abc") {
                self.infoLabel.text = "Password Success"
                DispatchQueue.main.async {
                self.performSegue(withIdentifier: "secret", sender: self)
                }
            }
        }
        
        let  cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addTextField()
        alert.addAction(cancelAction)
        alert.addAction(authenticationAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func unwind(segue: UIStoryboardSegue) {
    }
    
}

