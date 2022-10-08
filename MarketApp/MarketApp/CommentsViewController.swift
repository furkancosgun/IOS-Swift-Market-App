//
//  CommentsViewController.swift
//  MarketApp
//
//  Created by Furkan on 5.10.2022.
//

import UIKit

class CommentsViewController: UIViewController {
    var product:Product?
    var commentList = [Comment]()
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = product?.name!
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: URL(string:self.product!.img!)!)
            DispatchQueue.main.async {
                self.imgView.image = UIImage(data: data!)
            }
        }
        tblView.delegate = self
        tblView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        getComments(Id: (product?.id)!)
    }
   
    
    func getComments(Id:String){
        var request = URLRequest(url: URL(string: "http://localhost:8888/Market/scripts/get_comments.php")!)
        request.httpMethod = "POST"
        
        let param = "id=\(Id)"
        
        request.httpBody = param.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request, completionHandler: { data,response,error in
            if data == nil && error != nil{
                print(error?.localizedDescription as Any)
            }else{
                self.commentList.removeAll()
                do {
                    let json = try JSONDecoder().decode(comments.self, from: data!)
                    if let comments = json.comments{
                        self.commentList = comments
                    }
                } catch  {
                    print(error.localizedDescription)
                }
                DispatchQueue.main.async {
                    self.tblView.reloadData()
                }
            }
        }).resume()

    }

    @IBAction func addComment(_ sender: Any) {
        let alertController = UIAlertController(title: "Add Comment", message: "Please Write Comment", preferredStyle: .alert)

        let addButton = UIAlertAction(title: "ADD", style: .default, handler: {_ in
                  let txtComment = alertController.textFields![0] as UITextField
         
            self.addComment2DB(ProductID: ( self.product?.id)!, UserID: User.userId!, Text:   txtComment.text!)
            self.showToast(message: "Added Your Comment", font: .systemFont(ofSize: 12))
              })
        
        let cancelButton = UIAlertAction(title: "CANCEL", style: .destructive, handler: {_ in
                
              })
              
              alertController.addAction(addButton)
              alertController.addAction(cancelButton)
            
              alertController.addTextField{ txtField in
                  txtField.placeholder = "Comment.."
                  txtField.keyboardType = .default
              }
              self.present(alertController, animated: true)
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
    
    func addComment2DB(ProductID:String,UserID:String,Text:String){
        var requset = URLRequest(url: URL(string: "http://localhost:8888/Market/scripts/add_comment.php")!)
        
        requset.httpMethod = "POST"
        
        let params = "product_id=\(ProductID)&user_id=\(UserID)&text=\(Text)"
        
        requset.httpBody = params.data(using: .utf8)
        
        URLSession.shared.dataTask(with: requset).resume()
        
    }
}
extension CommentsViewController : UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CommentsTableViewCell
        cell.lblComment.text = commentList[indexPath.row].text
        cell.lblUname.text = commentList[indexPath.row].full_name
     
        return cell
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
 
}

class CommentsTableViewCell : UITableViewCell{
    @IBOutlet weak var lblComment: UILabel!
    @IBOutlet weak var lblUname: UILabel!
}
