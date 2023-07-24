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
typealias RMLocationCompletion = (PBResult<RMLocation>) ->()
typealias RMLocationsCompletion = (PBResult<[RMLocation]>) ->()

protocol RickAndMortyApi {
    func getCharacters(by amount: Int, completion: @escaping RMCharactersCompletion)
    func getLocations(by ids: [Int], completion: @escaping RMLocationsCompletion)
    func getLocation(by ids: [Int], completion: @escaping RMLocationCompletion)
}

class RMService: RickAndMortyApi {
    private let baseUrl: String = "https://rickandmortyapi.com/api/"
    private let characterEndPoint = "character/"
    private let locationEndPoint = "location/"
    private let lowerBound = 1
    private let upperBound = 826
    
    private func buildFullUrl(endpoint: String, idsList: String) -> URL? {
        let fullUrl = baseUrl + endpoint + idsList
        return URL(string: fullUrl)
    }
    
    private func fetchData<T: Decodable>(from url: URL?, completion: @escaping (PBResult<T>) -> Void) {
        guard let url = url else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.dataNotFound))
                return
            }
            
            do {
                let decodedObject = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedObject))
            } catch {
                completion(.failure(.serializationError(error)))
            }
        }
        
        task.resume()
    }
    
    func getCharacters(by amount: Int, completion: @escaping RMCharactersCompletion) {
        guard amount >= lowerBound && amount <= upperBound else {
            completion(.failure(.invalidURL))
            return
        }
        
        let idsList = generateRandomNumbers(by: amount, from: lowerBound, to: upperBound).map { String($0) }.joined(separator: ",")
        let fullUrl = buildFullUrl(endpoint: characterEndPoint, idsList: idsList)
        
        fetchData(from: fullUrl) { (result: PBResult<[RMCharacter]>) in
            completion(result)
        }
    }
    
    func getLocation(by ids: [Int], completion: @escaping RMLocationCompletion) {
        let idsList = ids.map { String($0) }.joined(separator: ",")
        let fullUrl = buildFullUrl(endpoint: locationEndPoint, idsList: idsList)
        
        fetchData(from: fullUrl) { (result: PBResult<RMLocation>) in
            completion(result)
        }
    }
    
    func getLocations(by ids: [Int], completion: @escaping RMLocationsCompletion) {
        let idsList = ids.map { String($0) }.joined(separator: ",")
        let fullUrl = buildFullUrl(endpoint: locationEndPoint, idsList: idsList)
        
        fetchData(from: fullUrl) { (result: PBResult<[RMLocation]>) in
            completion(result)
        }
    }
}
