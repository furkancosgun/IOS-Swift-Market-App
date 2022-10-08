//
//  FavoritesViewController.swift
//  MarketApp
//
//  Created by Furkan on 3.10.2022.
//

import UIKit

class FavoritesViewController: UIViewController {
    @IBOutlet weak var collectionViewFavs: UICollectionView!
    var favList = [Product]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setCVLayout()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.topViewController?.title = "My Favorites"
        getFavorites(userId: User.userId!)
    }
    func getFavorites(userId:String){
        var request = URLRequest(url: URL(string: "http://localhost:8888/market/scripts/getFavorites.php")!)
        
        request.httpMethod = "POST"
        
        let param = "userId=\(userId)"
        
        request.httpBody = param.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request, completionHandler: {data,response,error in
            if data == nil && error != nil{
                print(error?.localizedDescription ?? "error")
            }else{
                self.favList.removeAll()
                do {
                    let json = try JSONDecoder().decode(Favorites.self, from: data!)
                    if let favs = json.favorites{
                        self.favList = favs
                    }
                } catch  {
                    print(error.localizedDescription)
                }
                DispatchQueue.main.async {
                    self.collectionViewFavs.reloadData()
                }
            }
        }).resume()
    }
    func setCVLayout(){
        let design = UICollectionViewFlowLayout()
        let width = self.collectionViewFavs.frame.width
        design.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        design.itemSize = CGSize(width: (width - 30) / 3, height:  (width - 30) / 1.5)
        design.minimumInteritemSpacing = 5
        design.minimumLineSpacing = 5
        collectionViewFavs.collectionViewLayout = design
        collectionViewFavs.dataSource = self
        collectionViewFavs.delegate = self
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let data = sender as? Product{
            if segue.identifier == "goDetail"{
                let dest = segue.destination as! ProductDetailViewController
                dest.product = data
            }
        }
    }
}
extension FavoritesViewController : UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FavoritesCellCollectionView
        
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: URL(string:self.favList[indexPath.row].img!)!)
                DispatchQueue.main.async {
                    cell.imgView.image = UIImage(data: data!)
                }
            }
        cell.lblTitle.text = self.favList[indexPath.row].name
        cell.lblPrice.text = (self.favList[indexPath.row].price ?? "") + "tl"
    
        return cell
    
    }
    
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            performSegue(withIdentifier: "goDetail", sender: favList[indexPath.row])
        }
    
}

class FavoritesCellCollectionView:UICollectionViewCell{
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgView: UIImageView!
}
