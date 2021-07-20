//
//  NetworkService.swift
//  MovieNews
//
//  Created by Olexandr Dranchuk on 15.07.2021.
//

import Foundation

class NetworkService {
    
    ///Singleton instance
    static let shared = NetworkService()
    
    private var id: Int?
    
    let topRatedStringRequest = "https://api.themoviedb.org/3/movie/top_rated?api_key=f910e2224b142497cc05444043cc8aa4&language=en-US&page="
    
    let mostPopularStringRequest = "https://api.themoviedb.org/3/movie/popular?api_key=f910e2224b142497cc05444043cc8aa4&language=en-US&page="
    
    let searchStringRequest = "https://api.themoviedb.org/3/search/company?api_key=f910e2224b142497cc05444043cc8aa4&query="
    
    let imageStringRequest = "https://image.tmdb.org/t/p/original"
    
// MARK: - Public methods
    
    func loadData<T: Codable>(from url: URL, dataModel: T.Type, onSucces: @escaping ( (T) -> Void )) {
        
        load(with: url) { data in
            do {
                let result = try JSONDecoder().decode(dataModel.self, from: data)
                onSucces(result)
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }
    
    func loadImage<T: Codable>(imageUrl: String, onSucces: @escaping ( (T) -> Void )) {
        
        guard let url = URL(string: "\(imageStringRequest)\(imageUrl)") else { return }
        
        load(with: url) { data in
            guard let data = data as? T else { return }
            onSucces(data)
        }
    }
    
// MARK: - Private methods
    
    private func load (with url: URL, onSuccess: @escaping  ((Data) -> Void)) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                
                if let error = error {
                    print("Failed to load data form url with error - \(error.localizedDescription)")
                }
                
                guard let data = data,
                      let response = response as? HTTPURLResponse
                else { return }
                
                if response.statusCode == 200 {
                    onSuccess(data)
                } else {
                    print("Invalid data from responce")
                }
                
            }
        }.resume()
        
    }
    
    
}
