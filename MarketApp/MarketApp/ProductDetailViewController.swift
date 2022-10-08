//
//  ProductDetailViewController.swift
//  MarketApp
//
//  Created by Furkan on 4.10.2022.
//

import UIKit

class ProductDetailViewController: UIViewController {

    @IBOutlet weak var btnFavorite: UIBarButtonItem!
    @IBOutlet weak var lblPiece: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    var product : Product?
    override func viewDidLoad() {
        super.viewDidLoad()
        lblPrice.text = (product?.price!)!+"$"
        lblTitle.text = product?.name!
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: URL(string:self.product!.img!)!)
            DispatchQueue.main.async {
                self.imgView.image = UIImage(data: data!)
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        isFav(userId: User.userId!, productId: (product?.id)!)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goComments"{
            if let data = sender as? Product{
                let dest = segue.destination as! CommentsViewController
                dest.product = data
            }
        }
    }

    @IBAction func addFavorite(_ sender: Any) {
        if btnFavorite.image == UIImage(systemName: "star"){
            addFavs(userId: User.userId!, productId: (product?.id)!)
            btnFavorite.image = UIImage(systemName: "star.fill")
        }else{
            delToFavs(userId: User.userId!, productId: (product?.id)!)
            btnFavorite.image = UIImage(systemName: "star")
        }
    }
    
    func addFavs(userId:String,productId:String){
        var request = URLRequest(url: URL(string: "http://localhost:8888/market/scripts/addFavorite.php")!)
        
        request.httpMethod = "POST"
        
        let params = "productId=\(productId)&userId=\(userId)"
        
        request.httpBody = params.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request).resume()
        
    }
    func isFav(userId:String,productId:String) {
        var request = URLRequest(url: URL(string: "http://localhost:8888/market/scripts/isFav.php")!)

        request.httpMethod = "POST"
        
        let params = "productId=\(productId)&userId=\(userId)"
        
        request.httpBody = params.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request,completionHandler: {data,response,error in
            if data == nil && error != nil{
                print(error?.localizedDescription as Any)
            }else{
                do{
                    if let json = try JSONSerialization.jsonObject(with: data!,options: []) as? [String:Any]{
                        if json["success"] as! Int == 1{
                            self.btnFavorite.image = UIImage(systemName: "star.fill")
                        }else{
                            self.btnFavorite.image = UIImage(systemName: "star")
                        }
                    }
                    }catch{
                    print(error.localizedDescription)
                }
            }
           
        }).resume()
    }
    
    func delToFavs(userId:String,productId:String){
        var request = URLRequest(url: URL(string: "http://localhost:8888/market/scripts/deleteFavorite.php")!)
        
        request.httpMethod = "POST"
        
        let params = "productId=\(productId)&userId=\(userId)"
        
        request.httpBody = params.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request).resume()
    }
    @IBAction func btnAddBasket(_ sender: Any) {
        if let piece = lblPiece.text{
            if Int(piece)! > 0{
                addToBasket(UserId: User.userId!, ProductId: (product?.id)!, Piece: piece)
                self.showToast(message: "Added To Basker", font: .systemFont(ofSize: 12))
            }
        }
    }
    
    func addToBasket(UserId:String,ProductId:String,Piece:String){
        var request = URLRequest(url: URL(string: "http://localhost:8888/market/scripts/addToBasket.php")!)
        request.httpMethod = "POST"
        let params = "productId=\(ProductId)&userId=\(UserId)&piece=\(Piece)"
        request.httpBody = params.data(using: .utf8)
        URLSession.shared.dataTask(with: request).resume()
    }
    @IBAction func sizeChanger(_ sender: UIStepper) {
        lblPiece.text = String(Int(sender.value))
    }
    
    @IBAction func btnGoComments(_ sender: Any) {
        performSegue(withIdentifier: "goComments", sender: product)
    }
    
    func showToast(message : String, font: UIFont) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.systemIndigo
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
    
}
