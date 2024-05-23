//
//  Manager.swift
//  FileStructure
//
//  Created by Varsha Verma on 13/05/24.
//

import Foundation


class Manager {
    static let shared = Manager()
    private init() {}
    
    func uploadFile(fileURL: URL, to urlString: String, completion: @escaping (Result<URLResponse, Error>) -> Void) {
        guard let uploadURL = URL(string: urlString) else { return }
        
        var request = URLRequest(url: uploadURL)
        request.httpMethod = "POST"
        
        let task = URLSession.shared.uploadTask(with: request, fromFile: fileURL) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let response = response {
                completion(.success(response))
            }
        }
        task.resume()
    }
}
