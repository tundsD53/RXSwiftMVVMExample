//
//  ViewController.swift
//  RxSwiftAndMVVM
//
//  Created by Tunde on 20/05/2019.
//  Copyright © 2019 Degree 53 Limited. All rights reserved.
//

import UIKit
import Moya
import RxSwift
import RxOptional

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let disposeBag = DisposeBag()
    let searchController = UISearchController(searchResultsController: nil)
    let charactersViewModel = CharactersViewModel(networkConfig: NetworkConfig(baseUrl: Constants.baseUrl), provider: MoyaProvider<RickAndMortyEndpoint>(plugins: [NetworkLoggerPlugin(verbose: true, cURL: true)]))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        tableView.register(UINib(nibName: String(describing: CharacterTableViewCell.self), bundle: nil), forCellReuseIdentifier: CharacterTableViewCell.cellId)
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        tableView.tableHeaderView = searchController.searchBar
        setupCharacterBinding()
        setupSearchBinding()
    }
    
    func setupCharacterBinding() {
        
        charactersViewModel
            .getCharactersObservable()
            .map { try? $0.get().data }
            .filterNil()
            .bind(to: tableView.rx.items(cellIdentifier: CharacterTableViewCell.cellId, cellType: CharacterTableViewCell.self)) {
                row, element, cell in
                cell.configure(with: element)
            }.disposed(by: disposeBag)
        
        charactersViewModel
            .getCharactersObservable()
            .subscribe(onNext: { result in
                switch result {

                case .failure(let error):
                    UIAlertController(networkError: error).show()
                default: break
                }
            }).disposed(by: disposeBag)
    }
    
    func setupSearchBinding(){
        searchController.searchBar.rx
            .text
            .filterNil()
            .debounce(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] query in
                self.charactersViewModel.findCharacters(with: query)
            }).disposed(by: disposeBag)
    }
}

extension Thread {
    
    var threadName: String {
        if let currentOperationQueue = OperationQueue.current?.name {
            return "OperationQueue: \(currentOperationQueue)"
        } else if let underlyingDispatchQueue = OperationQueue.current?.underlyingQueue?.label {
            return "DispatchQueue: \(underlyingDispatchQueue)"
        } else {
            let name = __dispatch_queue_get_label(nil)
            return String(cString: name, encoding: .utf8) ?? Thread.current.description
        }
    }
}
