//
//  BasketViewController.swift
//  MarketApp
//
//  Created by Furkan on 3.10.2022.
//

import UIKit

class BasketViewController: UIViewController {

    
    @IBOutlet weak var lblPrice: UILabel!
    var basketList = [BasketElement]()
    @IBOutlet weak var tblView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
       
        tblView.delegate = self
        tblView.dataSource = self
    }
    func getBasketData(UserId:String){
        var request = URLRequest(url: URL(string: "http://localhost:8888/market/scripts/getBasket.php")!)
        request.httpMethod = "POST"
        request.httpBody = "userId=\(UserId)".data(using: .utf8)
        URLSession.shared.dataTask(with: request, completionHandler: { data,response,error in
            if data == nil && error != nil{
                print(error?.localizedDescription as Any)
            }else{
                self.basketList.removeAll()
                do {
                    let json = try JSONDecoder().decode(Basket.self, from: data!)
                    
                    if let list = json.basket{
                        self.basketList = list
                    }
                } catch  {
                    print(error.localizedDescription)
                }
                DispatchQueue.main.async {
                    self.tblView.reloadData()
                    self.setAllData()
                }
            }
        }).resume()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.topViewController?.title = "Basket"
        getBasketData(UserId: User.userId!)
    }
    override func viewDidDisappear(_ animated: Bool) {
        for i in basketList{
            setBasket(Id: i.id!, piece: i.piece!)
        }
    }
    func setBasket(Id:String,piece:String){
        var request = URLRequest(url: URL(string: "http://localhost:8888/market/scripts/setBasket.php")!)
        request.httpMethod = "POST"
        request.httpBody = "id=\(Id)&piece=\(piece)".data(using: .utf8)
        URLSession.shared.dataTask(with: request).resume()
    }
    func setAllData(){
        var total = 0
        for i in basketList{
            let value1 : Int = Int(i.piece!)!
            let value2 : Int = Int(i.price!)!
            total += value1 * value2
        }
        lblPrice.text = String(total) + "$"
    }
    
    @IBAction func createOrder(_ sender: Any) {
    }
}
extension BasketViewController:UITableViewDelegate,UITableViewDataSource, UITableViewClickProtocol{
    func clickFunc(indexPath: IndexPath, btn: UIStepper,label:UILabel) {
        basketList[indexPath.row].piece = String(Int(btn.value))
        label.text = "Piece:" + String(Int(btn.value))
        setAllData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return basketList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BasketViewTableViewCell
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: URL(string:self.basketList[indexPath.row].img!)!)
            DispatchQueue.main.async {
                cell.imgView.image = UIImage(data: data!)
            }
        }
        cell.lblTitle.text = basketList[indexPath.row].name
        cell.lblPrice.text = "Price: \(basketList[indexPath.row].price!) $"
        cell.lblPiece.text = "Piece: \(basketList[indexPath.row].piece!) "
        cell.TableViewClickProtocol = self
        cell.iPath = indexPath
        cell.btnPieceCalc.value = Double(Int(basketList[indexPath.row].piece!)!)
        return cell

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        //Delete Action
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete"){
            (contexttualAction,view,boolValue) in
            self.basketList[indexPath.row].piece = "0"
            self.setBasket(Id:  self.basketList[indexPath.row].id!, piece: "0")
            self.basketList.remove(at: indexPath.row)
            self.setAllData()
            self.tblView.reloadData()
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
protocol UITableViewClickProtocol{
    func clickFunc(indexPath:IndexPath,btn:UIStepper,label:UILabel)
}
class BasketViewTableViewCell:UITableViewCell{
    @IBOutlet weak var imgView: UIImageView!
    var TableViewClickProtocol : UITableViewClickProtocol?
    var iPath : IndexPath?
    @IBAction func btnPiece(_ sender: UIStepper) {
        TableViewClickProtocol?.clickFunc(indexPath: iPath!,btn: sender,label:lblPiece)
    }
    @IBOutlet weak var btnPieceCalc: UIStepper!
    @IBOutlet weak var lblPiece: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
}
