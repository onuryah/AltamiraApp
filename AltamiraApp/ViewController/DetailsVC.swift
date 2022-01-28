//
//  DetailsVC.swift
//  AltamiraApp
//
//  Created by Ceren Çapar on 25.01.2022.
//

import UIKit

class DetailsVC: UIViewController {
    @IBOutlet weak var orginalTitleLabelField: UILabel!
    @IBOutlet weak var adultLabelField: UILabel!
    @IBOutlet weak var realiseLabelField: UILabel!
    @IBOutlet weak var popularityLabelField: UILabel!
    @IBOutlet weak var voteAvarageLabelField: UILabel!
    @IBOutlet weak var voteCountLabelField: UILabel!
    @IBOutlet weak var overViewLabelField: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!
    private var savedArray = [Int]()
    private var selectedMovie : Result?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        backAndSaveButtonAdded()
        synchronizeChosenMovie()
        fixSaveButton()
    }
    
    fileprivate func backAndSaveButtonAdded() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "< Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(goBack))
    }
    
    @objc func goBack(){
        self.dismiss(animated: true, completion: nil)
    }
    
    fileprivate func synchronizeChosenMovie(){
        self.selectedMovie = UserSingleton.chosenMovie
        objectSettings()
    }
    @objc func saveButtonClicked(){
        if let selectedMovie = selectedMovie {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Liked", style: UIBarButtonItem.Style.plain, target: self, action: #selector(unLikeClicked))
            CoreDataManagement.save(value: selectedMovie.id)
        }
    }
    
    @objc func unLikeClicked(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Like", style: UIBarButtonItem.Style.plain, target: self, action: #selector(saveButtonClicked))
        for i in self.savedArray{
            if let id = self.selectedMovie?.id{
                if id == i{
                    if let index = self.savedArray.firstIndex(of: id) {
                        CoreDataManagement.deleteData(id: id)
                        self.savedArray.remove(at: index)
                    }
                }
            }
        }
    }
    
    private func fixSaveButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Like", style: UIBarButtonItem.Style.plain, target: self, action: #selector(saveButtonClicked))
        CoreDataManagement.retrieveValues() { saved in
            self.savedArray.removeAll(keepingCapacity: false)
            self.savedArray = saved
        }
        savedArray.forEach { saved in
            
            if saved == selectedMovie?.id{
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Liked", style: UIBarButtonItem.Style.plain, target: self, action: #selector(unLikeClicked))
            }
        }

    }
    
    func objectSettings(){
        navigationItem.title = self.selectedMovie?.title
        overViewLabelField.lineBreakMode = .byWordWrapping
        overViewLabelField.sizeToFit()
        if let selectedMovie = selectedMovie {
            if let posterUrl = self.selectedMovie?.posterPath{
                let url = "https://image.tmdb.org/t/p/w342"+posterUrl
                movieImageView.load(url: url)
            }
            orginalTitleLabelField.text = "Orjinal İsim: "+selectedMovie.originalTitle
            overViewLabelField.text = selectedMovie.overview
            if let realise = selectedMovie.releaseDate{
                realiseLabelField.text = "Yapım Tarihi: "+realise
            }
            popularityLabelField.text = "Popülerlik: "+String(selectedMovie.popularity)
            if String(selectedMovie.adult) == "true"{
                adultLabelField.text = "Kitle: Yetişkinler içindir."
            }else{
                adultLabelField.text = "Kitle: Genel İzleyici Kitlesi içindir"
            }
            voteAvarageLabelField.text = "Puan Ortalaması: "+String(selectedMovie.voteAverage)
            voteCountLabelField.text = "Puanlama Sayısı: "+String(selectedMovie.voteCount)
            
        }
    }
}


