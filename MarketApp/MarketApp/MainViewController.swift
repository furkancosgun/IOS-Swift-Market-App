//
//  ViewController.swift
//  MarketApp
//
//  Created by Furkan on 3.10.2022.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var txtPass: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func btnSignIn(_ sender: Any) {
        LoginToMarket(Email: txtEmail.text!, Password: txtPass.text!)
    }
    
    func LoginToMarket(Email:String,Password:String){
        var request = URLRequest(url: URL(string: "http://localhost:8888/market/scripts/signIn.php")!)
        request.httpMethod = "POST"
        let params = "email=\(Email)&pass=\(Password)"
        request.httpBody = params.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request, completionHandler: {data,response,error in
            if data == nil && error != nil{
                print(error as Any)
            }else{
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!,options: []) as? [String:Any]{
                        if let userid = json["userId"] as? String{
                            User.userId = userid
                            User.fullName = json["full_name"] as? String
                            User.email = json["email"] as? String
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: "goHome", sender: nil)
                            }
                        }else{
                            DispatchQueue.main.async {
                                let alertController = UIAlertController(title: "Warning", message: "Email or Password is Wrong", preferredStyle: .alert)
                                let okButton = UIAlertAction(title: "Ok", style:.default)
                                        alertController.addAction(okButton)
                                        self.present(alertController, animated: true)
                            }
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }).resume()
    }
    

}

