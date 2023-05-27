//
//  ApiManager.swift
//  MoviesInCollection
//
//  Created by George Weaver on 26.05.2023.
//

import Foundation
import UIKit

final class ApiManager {
    
    static var shared = ApiManager()
    
    func getMovies(completion: @escaping (MovieItem) -> Void) {
        let request = ApiType.getMovies.request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                return
            }
            
            if let data = data {
                do {
                    // Декодирование данных в экземпляр модели
                    let decoder = JSONDecoder()
                    let movieItem = try decoder.decode(MovieItem.self, from: data)
                    
                    switch httpResponse.statusCode {
                    case 200...299:
                        completion(movieItem)
                    case 401:
                        print("Invalid status code:", httpResponse.statusCode)
                        completion(.init(docs: []))
                    default:
                        print("Invalid status code:", httpResponse.statusCode)
                        completion(.init(docs: []))
                    }

                    // Обновление пользовательского интерфейса или выполнение других действий
                    // ...
                } catch {
                    print("Decoding error:", error)
                }
            }
        }
        task.resume()
    }
    
    func loadImage(from string: String?, completion: @escaping (UIImage) -> Void) {
        guard let posterString = string, let url = URL(string: posterString) else {
            return
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Ошибка загрузки изображения: \(error)")
                return
            }
            
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }
        task.resume()
    }
}
