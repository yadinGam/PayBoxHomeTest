//
//  CharactersViewModel.swift
//  PayboxHomeTest
//
//  Created by Yadin Gamliel on 24/07/2023.
//

import Foundation
import RxSwift
import RxCocoa

protocol CharactersViewModelProtocol {
    var charactersViewModels: BehaviorRelay<[RMCharacter]> { get }
    var loadingBehavior: BehaviorRelay<Bool> { get }
    func fetchCharacters()
    func bindIndicatorView(completion: @escaping (Bool)->())
}

class CharactersViewModel: CharactersViewModelProtocol {
    
    var charactersViewModels = BehaviorRelay<[RMCharacter]>(value: [])
    var loadingBehavior = BehaviorRelay<Bool>(value: false)
    
    private var characters = [RMCharacter]()
    private var bag = DisposeBag()
    
    func bindIndicatorView(completion: @escaping (Bool)->()) {
        self.loadingBehavior.subscribe(onNext: completion).disposed(by: bag)
    }
    
    func fetchCharacters() {
        let service = RMService()
        
        loadingBehavior.accept(true)
        service.getCharacters(by: 25) { [weak self] result in
            
            DispatchQueue.main.async {
                self?.loadingBehavior.accept(false)
                switch result {
                    
                case .success(let items):
                    self?.charactersViewModels.accept(items)
                    
                case .failure(let error):
                    //                    self?.presentAlert(title: "Service failure", message: "Service failed with error: \(error.localizedDescription)", buttonTitle: "OK")
                    print("Service failed with error: \(error.localizedDescription)")
                }
            }
        }
    }
    
}
