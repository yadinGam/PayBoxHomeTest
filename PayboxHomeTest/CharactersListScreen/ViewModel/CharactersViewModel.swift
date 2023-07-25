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
    func modelSelected(index: Int)
    var selectedDetails: PublishSubject<RMCharacter> { get }
    var errorBehavior: BehaviorRelay<Error?> { get }
}

class CharactersViewModel: CharactersViewModelProtocol {
    var errorBehavior: BehaviorRelay<Error?> = BehaviorRelay<Error?>(value: nil)
    
    var selectedDetails = PublishSubject<RMCharacter>()
    var charactersViewModels = BehaviorRelay<[RMCharacter]>(value: [])
    var loadingBehavior = BehaviorRelay<Bool>(value: false)
    
    private var characters = [RMCharacter]()
    private var bag = DisposeBag()
    
    func modelSelected(index: Int) {
        self.fetchLocations(by: index)
    }
    
    func bindIndicatorView(completion: @escaping (Bool)->()) {
        self.loadingBehavior.subscribe(onNext: completion).disposed(by: bag)
    }
    
    func fetchCharacters() {
        let service = RMService()
        
        loadingBehavior.accept(true)
        service.getCharacters(by: 25) { [weak self] result in
            
            self?.loadingBehavior.accept(false)
            
            switch result {
                
            case .success(let items):
                DispatchQueue.main.async {
                    self?.charactersViewModels.accept(items)
                }
            case .failure(let error):
                self?.errorBehavior.accept(error)
            }
        }
    }
    
    func fetchLocations(by index: Int) {
        loadingBehavior.accept(true)
        let locationsIds = self.charactersViewModels.value[index].locationsIds
        let locationsIdsNumbers = self.charactersViewModels.value[index].locationsIdsNumbers
        
        guard locationsIdsNumbers.count >= 1 else {
            self.selectedDetails.onNext(self.charactersViewModels.value[index])
            loadingBehavior.accept(false)
            return
        }
        
        RMService().getLocations(by: locationsIdsNumbers) { [weak self] result in
            
            guard let self = self else {
                return
            }
            
            self.loadingBehavior.accept(false)
            
            switch result {
                
            case .success(let items):
                
                var currentSelectedCharacter = self.charactersViewModels.value[index]
                
                let originId = currentSelectedCharacter.origin?.IdFromLocation
                let locationId = currentSelectedCharacter.location?.IdFromLocation
                
                items.forEach {
                    if ($0.IdFromLocation == originId) {
                        currentSelectedCharacter.origin?.name = $0.name
                        currentSelectedCharacter.origin?.type = $0.type
                        currentSelectedCharacter.origin?.dimension = $0.dimension
                    }
                    
                    if ($0.IdFromLocation == locationId) {
                        currentSelectedCharacter.location?.name = $0.name
                        currentSelectedCharacter.location?.type = $0.type
                        currentSelectedCharacter.location?.dimension = $0.dimension
                    }
                }
                
                self.selectedDetails.onNext(currentSelectedCharacter)
            case .failure(let error):
                self.errorBehavior.accept(error)
                break
            }
        }
    }
}
