//
//  ShoppingViewController.swift
//  MarketApp
//
//  Created by Furkan on 4.10.2022.
//

import UIKit

class ShoppingViewController: UIViewController {

    var id : String?
    @IBOutlet weak var searchBar: UISearchBar!
    var productList = [Product]()
    @IBOutlet weak var shoppingView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setCVLayout()
        get_alldata(Id: id!)
        searchBar.delegate = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.topViewController?.title = "Happy Shopping!"
    }
    func setCVLayout(){
        let design = UICollectionViewFlowLayout()
        let width = self.shoppingView.frame.width
        design.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        design.itemSize = CGSize(width: (width - 30) / 2, height:  (width - 30) / 1.25)
        design.minimumInteritemSpacing = 5
        design.minimumLineSpacing = 5
        shoppingView.collectionViewLayout = design
        shoppingView.dataSource = self
        shoppingView.delegate = self
    }
    func get_selected_data(q:String){
        var request = URLRequest(url: URL(string: "http://localhost:8888/Market/scripts/get_selected_products.php")!)
        
        request.httpMethod = "POST"
           
        let postData = "query=\(q)"
           
        request.httpBody = postData.data(using: .utf8)
           
        URLSession.shared.dataTask(with: request, completionHandler: { data,response,error in
            if error != nil && data == nil{
                print(error.debugDescription)
            }else{
                self.productList.removeAll()
                do {
                    let json = try JSONDecoder().decode(Products.self, from: data!)
                    if let list = json.products{
                        self.productList  = list
                    }
                    
                } catch {
                    print(error.localizedDescription)
                }
                
                DispatchQueue.main.async {
                    self.shoppingView.reloadData()
                }
                
            }
        }).resume()
    }
    func get_alldata(Id:String){

        var request = URLRequest(url: URL(string: "http://localhost:8888/Market/scripts/get_products.php")!)
        
        
        request.httpMethod = "POST"
           
        let postData = "id=\(Id)"
           
        request.httpBody = postData.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request, completionHandler: { data,response,error in
            if error != nil && data == nil{
                print(error.debugDescription)
            }else{
                self.productList.removeAll()
                do {
                    let json = try JSONDecoder().decode(Products.self, from: data!)
                    if let list = json.products{
                        self.productList  = list
                    }
                    
                } catch {
                    print(error.localizedDescription)
                }
                
                DispatchQueue.main.async {
                    self.shoppingView.reloadData()
                }
                
            }
        }).resume()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let data = sender as? Product{
            if segue.identifier == "goDetail"{
                let dest = segue.destination as! ProductDetailViewController
                dest.product = data
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
}
extension ShoppingViewController:UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewClickProtocol{
    func clickFunc(indexPath: IndexPath) {
        showToast(message: "Added To Basket", font: .systemFont(ofSize: 12))
        addToBasket(UserId: User.userId!, ProductId: productList[indexPath.row].id!, Piece: "1")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ProductListCollectionViewCell
        
            DispatchQueue.global().async {
            let data = try? Data(contentsOf: URL(string:self.productList[indexPath.row].img!)!)
                DispatchQueue.main.async {
                    cell.imgView.image = UIImage(data: data!)
                }
            }
        cell.lblTitle.text = self.productList[indexPath.row].name
        cell.lblPrice.text = self.productList[indexPath.row].price!+"$"
        cell.CollectionViewClickProtocol = self
        cell.iPath = indexPath
        return cell
    
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goDetail", sender: productList[indexPath.row])
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
extension ShoppingViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let query = searchBar.text{
            get_selected_data(q: query)
        }else{
            get_alldata(Id: id!)
        }
        
    }
}
protocol UICollectionViewClickProtocol{
    func clickFunc(indexPath:IndexPath)
}

class ProductListCollectionViewCell: UICollectionViewCell {
    @IBAction func btnAddBasket(_ sender: Any) {
        CollectionViewClickProtocol?.clickFunc(indexPath: iPath!)
    }
    var CollectionViewClickProtocol : UICollectionViewClickProtocol?
    var iPath : IndexPath?
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
}
