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
    var savedArray = [Int]()
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
                adultLabelField.text = "Yetişkinler İçindir."
            }else{
                adultLabelField.text = "Genel İzleyici Kitlesi"
            }
            voteAvarageLabelField.text = "Puan Ortalaması: "+String(selectedMovie.voteAverage)
            voteCountLabelField.text = "Puanlama Sayısı: "+String(selectedMovie.voteCount)
            
        }
    }
    @objc func saveButtonClicked(){
        if let selectedMovie = selectedMovie {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Unlike", style: UIBarButtonItem.Style.plain, target: self, action: #selector(unLikeClicked))
            CoreDataManagement.save(value: selectedMovie.id)
        }
    }
    
    @objc func unLikeClicked(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Like", style: UIBarButtonItem.Style.plain, target: self, action: #selector(saveButtonClicked))
        if let selectedMovie = selectedMovie {
            CoreDataManagement.deleteData(id: selectedMovie.id)
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
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Unlike", style: UIBarButtonItem.Style.plain, target: self, action: #selector(unLikeClicked))
            }else{
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Like", style: UIBarButtonItem.Style.plain, target: self, action: #selector(saveButtonClicked))
            }
        }

    }
}
