//
//  APIGeneros.swift
//  MovieApp
//
//  Created by Paulina Mellado Mateos on 09/09/22.
//

import Foundation



func generos(completion: @escaping (Welcome) -> Void) {
    let url = URL(string: "https://api.themoviedb.org/3/genre/movie/list?api_key=146780240fcf6b0a89bf2bdaa9cfd8c1&language=en-US")!
    URLSession.shared.dataTask(with: url) { data, response, error in
        if let data = data {
            if let generosData = try? JSONDecoder().decode(Welcome.self, from: data) {
                DispatchQueue.main.async {
                    completion(generosData)
                    print(data)
                    return
                }
            }
        }
    }.resume()
}
