//
//  ViewController.swift
//  AltamiraApp
//
//  Created by Ceren Çapar on 25.01.2022.
//

import UIKit
import CoreData

class ListVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var dataArray =  [Result]()
    var offSet = 1
    var indexObserver = 0
    var savedArray = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        setDelegates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       tableView.reloadData()
   }


}

extension ListVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Cell
        cell.nameLabelField.text = self.dataArray[indexPath.row].originalTitle
        cell.likeButton.tag = indexPath.row
        cell.likeButton.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        
        
        CoreDataManagement.retrieveValues(tableView: tableView) { saved in
            self.savedArray.removeAll(keepingCapacity: false)
            self.savedArray = saved
        }
        cell.heartImageView.image = UIImage(named: "heart")
        self.savedArray.forEach { saved in
            if saved == self.dataArray[indexPath.row].id{
                cell.heartImageView.image = UIImage(named: "redHeart")
            }
        }
        
        
        self.indexObserver = indexPath.row
        if indexObserver == self.dataArray.count - 2{
                offSet = offSet + 1
                let url = "https://api.themoviedb.org/3/movie/popular?language=tr-TR&api_key=3a70be5987b4f1919dafae3d8c738cf5&page="+"\(offSet)"
            Webservice.fetchData(urlString: url, tableView: self.tableView, model: Model.self) { datas in
                        datas.results.forEach { extraData in
                            self.dataArray.append(extraData)
                        }
                }
            }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserSingleton.chosenMovie = self.dataArray[indexPath.row]
        performSegue(withIdentifier: "movieDetails", sender: nil)
    }
    
    fileprivate func setDelegates(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    func fetchData(){
        let url = "https://api.themoviedb.org/3/movie/popular?language=tr-TR&api_key=3a70be5987b4f1919dafae3d8c738cf5&page=1"
        Webservice.fetchData(urlString: url, tableView: tableView, model: Model.self) { datas in
            self.dataArray = datas.results
        }
    }
    
    @objc func tapped(sender: UIButton){
        let indexpath = IndexPath(row: sender.tag, section: 0)
        let cell = self.tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! Cell
        let id = self.dataArray[indexpath.row].id
        if cell.heartImageView.image == UIImage(named: "heart"){
            CoreDataManagement.save(value: id)
        }else if cell.heartImageView.image == UIImage(named: "redHeart"){
            for i in self.savedArray{
                if id == i{
                    if let index = self.savedArray.firstIndex(of: i) {
                        CoreDataManagement.deleteData(id: id)
                        self.savedArray.remove(at: index)
                    }
                }
            }
        }
        tableView.reloadData()
    }
}

