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
    private var dataArray =  [Result]()
    private var savedArray = [Int]()
    private let searchController = UISearchController()
    private var offSet = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        setDelegates()
        addSearchbar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       tableView.reloadData()
   }
}

extension ListVC: UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Cell
        itemsInCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserSingleton.chosenMovie = self.dataArray[indexPath.row]
        performSegue(withIdentifier: "movieDetails", sender: nil)
    }
    
    fileprivate func setDelegates(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    fileprivate func fetchData(){
        let url = UrlClass().baseUrl+UrlClass().moviesUrl+UrlClass().key+"\(offSet)"
        Webservice.fetchData(urlString: url, tableView: tableView, model: Model.self) { datas in
            for data in datas.results{
                self.dataArray.append(data)
            }
        }
        offSet = offSet+1
    }
    
    @objc func tapped(sender: UIButton){
        let indexPath = IndexPath(row: sender.tag, section: 0)
        let cell = self.tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) as! Cell
        tappedSettings(indexPath: indexPath, cell: cell)
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else{return}
        let url = UrlClass().baseUrl+UrlClass().searchUrl+"\(text)"
        Webservice.fetchData(urlString: url, tableView: tableView, model: Model.self) { data in
            self.dataArray = data.results
        }
        if text == ""{
            fetchData()
        }
    }
    
    fileprivate func addSearchbar(){
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
    }
    
    fileprivate func itemsInCell(cell: Cell, indexPath: IndexPath){
        
        cell.nameLabelField.text = self.dataArray[indexPath.row].originalTitle
        cell.likeButton.tag = indexPath.row
        cell.likeButton.addTarget(self, action: #selector(tapped), for: .touchUpInside)
    
        CoreDataManagement.retrieveValues() { saved in
            self.savedArray.removeAll(keepingCapacity: false)
            self.savedArray = saved
        }
        cell.heartImageView.image = UIImage(named: "heart")
        self.savedArray.forEach { saved in
            if saved == self.dataArray[indexPath.row].id{
                cell.heartImageView.image = UIImage(named: "redHeart")
            }
        }
        
        let indexObserver = indexPath.row
        if indexObserver == self.dataArray.count - 2{
            fetchData()
            }
    }
    
    fileprivate func tappedSettings(indexPath : IndexPath, cell: Cell){
        let id = self.dataArray[indexPath.row].id
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
    }
}

