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
        
        if (locationsIdsNumbers.count == 0) {
            self.selectedDetails.onNext(self.charactersViewModels.value[index])
            loadingBehavior.accept(false)
        } else if(locationsIdsNumbers.count == 1) {
            
            RMService().getLocation(by: locationsIdsNumbers) { [weak self] result in
                
                guard let self = self else {
                    return
                }
                
                self.loadingBehavior.accept(false)
                
                switch result {
                    
                case .success(let item):
                    var currentSelectedCharacter = self.charactersViewModels.value[index]
                    switch locationsIds[0] {
                        
                    case .origin:
                        currentSelectedCharacter.origin?.name = item.name
                        currentSelectedCharacter.origin?.type = item.type
                        currentSelectedCharacter.origin?.dimension = item.dimension
                    case .location:
                        currentSelectedCharacter.location?.name = item.name
                        currentSelectedCharacter.location?.type = item.type
                        currentSelectedCharacter.location?.dimension = item.dimension
                    }
                
                    self.selectedDetails.onNext(currentSelectedCharacter)
                case .failure(let error):
                    self.loadingBehavior.accept(false)
                    self.errorBehavior.accept(error)
                    break
                }
                
            }
        } else if(locationsIdsNumbers.count > 1) {
            RMService().getLocations(by: locationsIdsNumbers) { [weak self] result in
                
                guard let self = self else {
                    return
                }
                
                self.loadingBehavior.accept(false)
                
                switch result {
                    
                case .success(let items):
                    var currentSelectedCharacter = self.charactersViewModels.value[index]
                    currentSelectedCharacter.origin?.name = items.first?.name
                    currentSelectedCharacter.origin?.type = items.first?.type
                    currentSelectedCharacter.origin?.dimension = items.first?.dimension
                    
                    currentSelectedCharacter.location?.name = items.count == 1 ? items.first?.name : items[1].name
                    currentSelectedCharacter.location?.type = items.count == 1 ? items.first?.type : items[1].type
                    currentSelectedCharacter.location?.dimension = items.count == 1 ? items.first?.dimension : items[1].dimension
                    
                    self.selectedDetails.onNext(currentSelectedCharacter)
                case .failure(let error):
                    self.loadingBehavior.accept(false)
                    DispatchQueue.main.async {
                        self.errorBehavior.accept(error)
                    }
                    break
                }
            }
        }
    }
}
