//
//  RMServiceAPI.swift
//  PayboxHomeTest
//
//  Created by Yadin Gamliel on 23/07/2023.
//

import Foundation

enum PBResult<T> {
    case success(T)
    case failure(PBError)
}

enum PBError: Error {
    case networkError(Error)
    case dataNotFound
    case serializationError(Error)
    case statusCodeError(Int)
    case invalidURL
}

typealias RMCharactersCompletion = (PBResult<[RMCharacter]>) ->()
typealias RMLocationCompletion = (PBResult<[RMLocation]>) ->()

protocol RickAndMortyApi {
    func getCharacters(by amount: Int, completion: @escaping RMCharactersCompletion)
    func getLocation(by id: Int, completion: @escaping RMLocationCompletion)
    func getLocations(by ids: [Int], completion: @escaping RMLocationCompletion)
}

class RMService: RickAndMortyApi {
    
    private let baseUrl: String = "https://rickandmortyapi.com/api/"
    private let characterEndPoint = "character/"
    private let locationEndPoint = "location/"
    private let lowerBound = 1
    private let upperBound = 826
    
    func getCharacters(by amount: Int, completion: @escaping RMCharactersCompletion) {
        let idsList = generateRandomNumbers(by: amount, from: lowerBound, to: upperBound).map { String($0) }.joined(separator: ",")
        
        let fullUrl = baseUrl+characterEndPoint+idsList
        
        guard let url = URL(string: fullUrl) else {
            return completion(.failure(.invalidURL))
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.dataNotFound))
                return
            }
            
            do {
                let decodedObject = try JSONDecoder().decode([RMCharacter].self, from: data)
                completion(.success(decodedObject))
            } catch {
                completion(.failure(.serializationError(error)))
            }
        }
        
        task.resume()
    }
    
    func getLocation(by id: Int, completion: @escaping RMLocationCompletion) {
        self.getLocations(by: [id], completion: completion)
    }
    
    func getLocations(by ids: [Int], completion: @escaping RMLocationCompletion) {
        let idsList = ids.map { String($0) }.joined(separator: ",")
        let fullUrl = baseUrl+locationEndPoint+idsList
        
        guard let url = URL(string: fullUrl) else {
            return completion(.failure(.invalidURL))
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.dataNotFound))
                return
            }
            
            do {
                let decodedObject = try JSONDecoder().decode([RMLocation].self, from: data)
                completion(.success(decodedObject))
            } catch {
                completion(.failure(.serializationError(error)))
            }
        }
        
        task.resume()
    }
    
}
