//
//  SignUpViewController.swift
//  MarketApp
//
//  Created by Furkan on 3.10.2022.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var txtPassword2: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtFullname: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func btnSignUp(_ sender: Any) {
        if let fullname = txtFullname.text, let email = txtEmail.text, let phone = txtPhone.text ,let pass = txtPassword.text ,let pass2 = txtPassword2.text{
            if pass == pass2{
               addUser2DB(Fullname: fullname, Email: email, Phone: phone, Password: pass)
                let alertController = UIAlertController(title: "Thank You :)", message: "Thank you for joining us", preferredStyle: .alert)
                let okBtn = UIAlertAction(title: "Go SignIn Page", style: .default, handler: { _ in
                    self.dismiss(animated: true)
                })
                alertController.addAction(okBtn)
                self.present(alertController, animated: true)
            }else{
                let alertController = UIAlertController(title: "Warning", message: "Passwords not match", preferredStyle: .alert)
                let okBtn = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertController.addAction(okBtn)
                self.present(alertController, animated: true)
            }
        }
    }

      

    
    func addUser2DB(Fullname:String,Email:String,Phone:String,Password:String){
        var request = URLRequest(url: URL(string: "http://localhost:8888/market/scripts/add_user.php")!)
        
        request.httpMethod = "POST"
        
        let params = "fullname=\(Fullname)&email=\(Email)&phone=\(Phone)&pass=\(Password)"
        
        request.httpBody = params.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request).resume()
    }

}
