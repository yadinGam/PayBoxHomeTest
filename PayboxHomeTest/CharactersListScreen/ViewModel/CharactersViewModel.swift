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
}

class CharactersViewModel: CharactersViewModelProtocol {
    
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
    
    

    func fetchLocations(by index: Int) {
        print("character: \(self.charactersViewModels.value[index])")
        let locationsIds = self.charactersViewModels.value[index].locationsIds
        let locationsIdsNumbers = self.charactersViewModels.value[index].locationsIdsNumbers
        print("locationsIds: \(locationsIds)")
        print("locationsIdsNumbers: \(locationsIdsNumbers)")
        
        loadingBehavior.accept(true)
        
        if (locationsIds.count == 0) {
            self.selectedDetails.onNext(self.charactersViewModels.value[index])
        } else if(locationsIds.count > 1) {
            RMService().getLocations(by: locationsIdsNumbers) { [weak self] result in
                
                guard let self = self else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.loadingBehavior.accept(false)
                }
                
                switch result {
                    
                case .success(let items):
                    var currentSelectedCharacter = self.charactersViewModels.value[index]
                    
                    if items.count >= 1 {
                        print("updating origin")
                        currentSelectedCharacter.origin?.name = items.first?.name
                        currentSelectedCharacter.origin?.type = items.first?.type
                        currentSelectedCharacter.origin?.dimension = items.first?.dimension
                    }
                    
                    if items.count == 2 {
                        currentSelectedCharacter.location?.name = items[1].name
                        currentSelectedCharacter.location?.type = items[1].type
                        currentSelectedCharacter.location?.dimension = items[1].dimension
                    }
                    
                    print("currentSelectedCharacter: \(currentSelectedCharacter)")
                    self.selectedDetails.onNext(currentSelectedCharacter)
                case .failure(let error):
                    print("failed with error: \(error)")
                    break
                }
            }
        } else if (locationsIds.count == 1) {
            
            RMService().getLocation(by: locationsIdsNumbers) { result in
                
                switch result {
                    
                case .success(let item):
                    var currentSelectedCharacter = self.charactersViewModels.value[index]
                    switch locationsIds[0] {
                        
                    case .origin(let index):
                        print("updating origin only")
                        currentSelectedCharacter.origin?.name = item.name
                        currentSelectedCharacter.origin?.type = item.type
                        currentSelectedCharacter.origin?.dimension = item.dimension
                    case .location(let index):
                        print("updating location only")
                        currentSelectedCharacter.location?.name = item.name
                        currentSelectedCharacter.location?.type = item.type
                        currentSelectedCharacter.location?.dimension = item.dimension
                    }
                    
                    print("currentSelectedCharacter: \(currentSelectedCharacter)")
                    self.selectedDetails.onNext(currentSelectedCharacter)
                case .failure(let error):
                    print("failed with error: \(error)")
                    break
                }
                
            }
        }
    }
}
