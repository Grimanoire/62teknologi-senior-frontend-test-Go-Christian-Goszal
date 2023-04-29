//
//  SearchResultViewController.swift
//  BusinessReviewProject
//
//  Created by Go Christian Goszal on 27/04/23.
//

import UIKit

protocol SearchResultsViewControllerDelegate: AnyObject {
    func searchResultsViewControllerDidTapRow(_ businessId: String)
}

class SearchResultsViewController: UIViewController {
    
    public var list: [BusinessList] = [BusinessList]()
    
    public weak var delegate: SearchResultsViewControllerDelegate?
    
    public let resultTableView: UITableView = {
        let table = UITableView()
        table.register(BusinessTableViewCell.self, forCellReuseIdentifier: BusinessTableViewCell.identifier)
        return table
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        view.addSubview(resultTableView)
        
        resultTableView.delegate = self
        resultTableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        resultTableView.frame = view.bounds
    }
    
}


extension SearchResultsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let businesses = list[indexPath.row]
        let businessId = businesses.id ?? ""
        self.delegate?.searchResultsViewControllerDidTapRow(businessId)
    }
    
}
