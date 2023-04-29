//
//  SearchViewController.swift
//  BusinessReviewProject
//
//  Created by Go Christian Goszal on 27/04/23.
//

import UIKit

class SearchViewController: UIViewController {
    
    private var pageNumber: Int = 0
    private var list: [BusinessList] = [BusinessList]()

    private let discoverTable: UITableView = {
        let table = UITableView()
        table.register(BusinessTableViewCell.self, forCellReuseIdentifier: BusinessTableViewCell.identifier)
        return table
    }()
    
    private let searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsViewController())
        controller.searchBar.placeholder = "Search for a Business"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Yelp"
        view.backgroundColor = .systemBackground
        
        let navBarAppearance: UINavigationBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithDefaultBackground()
        navBarAppearance.backgroundColor = UIColor.systemGroupedBackground
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        
        view.addSubview(discoverTable)
        discoverTable.delegate = self
        discoverTable.dataSource = self
        navigationItem.searchController = searchController
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        navigationController?.navigationBar.tintColor = .systemBlue
        fetchBusinessList()
        
        
        searchController.searchResultsUpdater = self
    }
    
    
    private func fetchBusinessList() {
        APICaller.shared.getBusinessList { [weak self] result in
            switch result {
            case .success(let list):
                self?.list = list
                DispatchQueue.main.async {
                    self?.discoverTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchMoreBusinessList() {
        pageNumber += 1
        APICaller.shared.getBusinessList (page: pageNumber) { [weak self] result in
            switch result {
            case .success(let list):
                self?.list.append(contentsOf: list)
                DispatchQueue.main.async {
                    self?.discoverTable.tableFooterView = nil
                    self?.discoverTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTable.frame = view.bounds
    }
}


extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BusinessTableViewCell.identifier, for: indexPath) as? BusinessTableViewCell else {
            return UITableViewCell()
        }
        
        
        let businesses = list[indexPath.row]
        let model = BusinessViewModel(businessName: businesses.name ?? "Unknown name", imageURL: businesses.image_url ?? "", rating: businesses.rating, reviewCount: businesses.review_count)
        cell.configure(with: model)
        
        return cell;
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.discoverTable.tableFooterView = spinnerFooter()
        if indexPath.row == list.count - 1 {fetchMoreBusinessList()}
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let businesses = list[indexPath.row]
        let businessId = businesses.id ?? ""
        
        DispatchQueue.main.async {
            let vc = BusinessDetailViewController()
            vc.businessId = businessId
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    private func spinnerFooter() -> UIView {
        let footer = UIView(frame: CGRect(x:0 , y:0, width: view.frame.size.width, height: 100))
        let spinner = UIActivityIndicatorView()
        spinner.center = footer.center
        footer.addSubview(spinner)
        spinner.startAnimating()
        
        return footer
    }
}

extension SearchViewController: UISearchResultsUpdating, SearchResultsViewControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let term = searchBar.text,
              !term.trimmingCharacters(in: .whitespaces).isEmpty,
              term.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultsController = searchController.searchResultsController as? SearchResultsViewController else {
                  return
              }
        resultsController.delegate = self
        
        APICaller.shared.getBusinessList(with: term) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let list):
                    resultsController.list = list
                    resultsController.resultTableView.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }

    
    func searchResultsViewControllerDidTapRow(_ businessId: String) {

        DispatchQueue.main.async { [weak self] in
            let vc = BusinessDetailViewController()
            vc.businessId = businessId
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }

}

