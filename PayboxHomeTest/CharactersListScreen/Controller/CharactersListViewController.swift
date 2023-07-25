//
//  ViewController.swift
//  PayboxHomeTest
//
//  Created by Yadin Gamliel on 23/07/2023.
//

import UIKit
import RxSwift
import RxCocoa

class CharactersListViewController: UIViewController, Alertable, Storyborded {
    
    @IBOutlet weak var charactersTableView: UITableView!
    
    private var indicatorView = UIActivityIndicatorView()
    private var viewModel: CharactersViewModelProtocol?
    private var bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = CharactersViewModel()
        bindIndicatorView()
        setupTableView()
        viewModel?.fetchCharacters()
        bindErrorBehavior()
    }
    
    private func setupTableView() {
        charactersTableView.register(UINib(nibName: String(describing: CharacterTableViewCell.self), bundle: nil), forCellReuseIdentifier:  String(describing: CharacterTableViewCell.self))
        charactersTableView.rowHeight = UITableView.automaticDimension
        charactersTableView.estimatedRowHeight = 100
        charactersTableView.tableFooterView = UIView()
        
        self.bindTableViewData()
    }
    
    private func bindErrorBehavior() {
        viewModel?.errorBehavior.asObservable().skip(1).subscribe(onNext: { [weak self] error in
            DispatchQueue.main.async {
                self?.presentAlert(title: "Service failure", message: "Service failed with error: \(error?.localizedDescription ?? "no errorfound")", buttonTitle: "OK")
            }
        }).disposed(by: bag)
    }
    
    private func bindIndicatorView() {
        viewModel?.loadingBehavior.subscribe(onNext: { [weak self] isLoading in
            DispatchQueue.main.async {
                if (isLoading){
                    self?.addActivityIndicator()
                } else {
                    self?.removeIndicatorView()
                }
            }
        }).disposed(by: bag)
    }
    
    private func bindTableViewData() {
        viewModel?.charactersViewModels.bind(to: charactersTableView.rx.items(cellIdentifier: String(describing: CharacterTableViewCell.self), cellType: CharacterTableViewCell.self)) {
            row, item, cell in
            cell.configure(with: CharacterCellViewModel(character: item))
        }.disposed(by: bag)
        
        charactersTableView.rx.itemSelected
            .bind { [weak self] indexPath in
                guard let self = self else {
                    return
                }
                self.viewModel?.modelSelected(index: indexPath.row)
                self.charactersTableView.deselectRow(at: indexPath, animated: true)
            }
            .disposed(by: bag)
        
        self.viewModel?.selectedDetails
            .subscribe(onNext: { [weak self] details in
                DispatchQueue.main.async {
                    self?.moveToDetailsScreen(with: details)
                }
            })
            .disposed(by: bag)
    }
    
    private func moveToDetailsScreen(with character: RMCharacter) {
        let vc = CharacterDetailsViewController.instantiate()
        let viewModel = CharacterViewModel(with: character)
        vc.viewModel = viewModel
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension CharactersListViewController {
    
    func addActivityIndicator() {
        self.view.addSubview(indicatorView)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        let xConstraint = NSLayoutConstraint(item: self.indicatorView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
        
        let yConstraint = NSLayoutConstraint(item: self.indicatorView, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([xConstraint, yConstraint])
        
        indicatorView.startAnimating()
        self.view.isUserInteractionEnabled = false
    }
    
    func removeIndicatorView() {
        self.indicatorView.removeFromSuperview()
        self.view.isUserInteractionEnabled = true
    }
}
