//
//  ViewController.swift
//  MovieApp
//
//  Created by Paulina Mellado Mateos on 09/09/22.
//

import UIKit

let notificationNamePau = "com.paumellado.LocalNotification"

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, NotificationAlert {

    

    @IBOutlet weak var comingSoon: UIImageView!
    

    @IBOutlet weak var myGenreCollection: UICollectionView!
    @IBOutlet weak var myMovieCollection: UICollectionView!
    
    @IBOutlet weak var soon: UIImageView!
    
    let aux = [1,2,3,4,5,6,7,8]
    
    
    var arrayG : Welcome?
    var arrayM : Movie?
    var movieDeployment : Result?
    var genreDeployment : Genre?
    private let cache = NSCache<NSString, UIImage>()
    private let utilityQueue = DispatchQueue.global(qos: .utility)
    
    var generosAux: Int = 1
   
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.comingSoon.layer.cornerRadius = 15
        self.myGenreCollection.register(UINib(nibName: "GenerosCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        self.myGenreCollection.delegate = self
        self.myGenreCollection.dataSource = self
        
        self.myMovieCollection.register(UINib(nibName: "MoviesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Row")
        self.myMovieCollection.delegate = self
        self.myMovieCollection.dataSource = self
//----------------------------------------------------------------------------------------------------------
        generos { respuesta in
                self.arrayG = respuesta
                self.myGenreCollection.reloadData()
        }
        
//----------------------------------------------------------------------------------------------------------
        movies(genero: "28") { respuestaMovie in
            self.arrayM = respuestaMovie
            self.myMovieCollection.reloadData()
        }
        
}
//----------------------------------------------------------------------------------------------------------
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        if collectionView == myMovieCollection {
            if  let retorno = arrayM?.results.count {
                return retorno
            }
        }
 
        if  let retorno = arrayG?.genres.count {
            if generosAux == 0 {
                return 0
            }else {
                return retorno
            }
            
        }
        
        return 0
    }
    

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell2 = self.myMovieCollection.dequeueReusableCell(withReuseIdentifier: "Row", for: indexPath) as? MoviesCollectionViewCell
        
        let movie = arrayM?.results[indexPath.row]
        cell2?.nameLb.text = movie?.title
        cell2?.etiqueta1.text = movie?.releaseDate
        
        if let avarage = movie?.voteAverage {
            cell2?.etiqueta2.text = String(avarage)
        }
        if let popular = movie?.popularity {
            cell2?.etiqueta3.text = String(popular)
        }
        
        
        if let name = movie?.posterPath {
            let imageName = "https://image.tmdb.org/t/p/original" + name
            let cacheString = NSString(string: imageName)
            
            if let cacheImage = self.cache.object(forKey: cacheString) {
                cell2?.movieImg.image = cacheImage
            } else {
                self.loadImage(from: URL(string: imageName)) { [weak self] (image) in
                    guard let self = self, let image = image else { return }
                    cell2?.movieImg.image = image
              
                    self.cache.setObject(image, forKey: cacheString)
                }
            }
    
        
        }
        
        if collectionView == myGenreCollection {
            let cell = self.myGenreCollection.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? GenerosCollectionViewCell
            let genero = arrayG?.genres[indexPath.row]
            cell?.lbGeneros.text = genero?.name
            cell?.selectGenero = genero?.id
            
            
            return cell!
        }
        
        return cell2!
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == myGenreCollection{
            genreDeployment = arrayG?.genres[indexPath.row]
           
             if let generoAux = genreDeployment?.id {
                movies(genero: String(generoAux)) { respuestaMovie in
                    self.arrayM = respuestaMovie
                    self.myMovieCollection.reloadData()
                }
            }
                        
        }else {
            movieDeployment = arrayM?.results[indexPath.row]
            performSegue(withIdentifier: "deployment", sender: self)
        }
        
        
        
    }

    
    @IBAction func forKids(_ sender: Any) {
        generosAux = 0
        self.myGenreCollection.reloadData()
        movies(genero: "16") { respuestaMovie in
            self.arrayM = respuestaMovie
            self.myMovieCollection.reloadData()
            
            if let name = self.arrayM?.results[0].posterPath {
                let imageName = "https://image.tmdb.org/t/p/original" + name
                let cacheString = NSString(string: imageName)
                
                if let cacheImage = self.cache.object(forKey: cacheString) {
                    self.soon.image = cacheImage
                } else {
                    self.loadImage(from: URL(string: imageName)) { [weak self] (image) in
                        guard let self = self, let image = image else { return }
                        self.soon.image = image
                  
                        self.cache.setObject(image, forKey: cacheString)
                    }
                }
            }
        }
        
    }
    
    @IBAction func allMovies(_ sender: Any) {
        generosAux = 1
        self.myGenreCollection.reloadData()
        movies(genero: "12") { respuestaMovie in
            self.arrayM = respuestaMovie
            self.myMovieCollection.reloadData()
            
            if let name = self.arrayM?.results[0].posterPath {
                let imageName = "https://image.tmdb.org/t/p/original" + name
                let cacheString = NSString(string: imageName)
                
                if let cacheImage = self.cache.object(forKey: cacheString) {
                    self.soon.image = cacheImage
                } else {
                    self.loadImage(from: URL(string: imageName)) { [weak self] (image) in
                        guard let self = self, let image = image else { return }
                        self.soon.image = image
                  
                        self.cache.setObject(image, forKey: cacheString)
                    }
                }
            
            }
            
        }
        
    }
    
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DeploymentViewController {
            vc.des = movieDeployment?.overview
            vc.name = movieDeployment?.title
            vc.delegateImp = self
            vc.voteCount = movieDeployment?.voteCount
            vc.popularaty = movieDeployment?.popularity
            vc.originalTitle = movieDeployment?.originalTitle
            vc.originalLangua = movieDeployment?.originalLanguage
            vc.releaseData = movieDeployment?.releaseDate
            if let name = movieDeployment?.posterPath {
                vc.img = "https://image.tmdb.org/t/p/original" + name
            }
        }
    }
    

    // MARK: - Image Loading
    private func loadImage(from url: URL?, completion: @escaping (UIImage?) -> ()) {
        utilityQueue.async {
            guard let data = try? Data(contentsOf: url!) else { return }
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
    
    
    
    
    func didSelectString(_ string: String) {
        // create the alert
        let alert = UIAlertController(title: "Compra Lista", message: "Tu compra se ha efectuado, tus boletos para la pelicula " + string + "están listos", preferredStyle: UIAlertController.Style.alert)

        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

        // show the alert
        self.present(alert, animated: true, completion: nil)
    }



}
    
    





