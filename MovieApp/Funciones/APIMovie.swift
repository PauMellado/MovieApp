//
//  APIMovie.swift
//  MovieApp
//
//  Created by Paulina Mellado Mateos on 09/09/22.
//

import Foundation
import UIKit

let selectG = GenerosCollectionViewCell()
let idGenero = selectG.selectGenero ?? 28
let idSelect = String(idGenero)


func movies(genero: String, completion: @escaping (Movie) -> Void) {
    let url = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=146780240fcf6b0a89bf2bdaa9cfd8c1&language=en-US&with_genres=" + genero)!

    URLSession.shared.dataTask(with: url) { data, response, error in
        if let data = data {
            if let generosData = try? JSONDecoder().decode(Movie.self, from: data) {
                DispatchQueue.main.sync {
                    completion(generosData)
                    return
                }
            }
        }
    }.resume()
}
