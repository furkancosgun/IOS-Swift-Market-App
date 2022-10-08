//
//  CategoriesViewController.swift
//  MarketApp
//
//  Created by Furkan on 5.10.2022.
//

import UIKit

class CategoriesViewController: UIViewController {

    @IBOutlet weak var categoryView: UICollectionView!
    var categoryList = [Category]()
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllCategories()
        setCVLayout()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.topViewController?.title = "Categories"
    }
    func getAllCategories()
    {
        let request = URLRequest(url: URL(string: "http://localhost:8888/Market/scripts/get_categories.php")!)
        URLSession.shared.dataTask(with: request, completionHandler: { data,response,error in
            if data == nil && error != nil{
                print(error.debugDescription)
            }else{
                self.categoryList.removeAll()
                do {
                    let json = try JSONDecoder().decode(Categories.self, from: data!)
                    if let categories = json.categories{
                        self.categoryList = categories
                    }
                    DispatchQueue.main.async {
                        self.categoryView.reloadData()
                    }
                } catch  {
                    print(error.localizedDescription)
                }
            }
        }).resume()
        
    }
    func setCVLayout(){
        let design = UICollectionViewFlowLayout()
        let width = self.categoryView.frame.width
        design.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        design.itemSize = CGSize(width: (width - 30) / 3, height:  (width - 30) / 1.5)
        design.minimumInteritemSpacing = 5
        design.minimumLineSpacing = 5
        categoryView.collectionViewLayout = design
        categoryView.dataSource = self
        categoryView.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let data = sender as? String{
            if segue.identifier == "goShop"{
                let dest = segue.destination as! ShoppingViewController
                dest.id = data
            }
        }
    }

}


extension CategoriesViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CategoriesCollectionViewCell
        
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: URL(string:self.categoryList[indexPath.row].img!)!)
            DispatchQueue.main.async {
                    cell.imgView.image = UIImage(data: data!)
            }
        }
        cell.lblTitle.text = self.categoryList[indexPath.row].name
    
        return cell
    
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goShop", sender: categoryList[indexPath.row].id)
    }
}



class CategoriesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgView: UIImageView!
}
