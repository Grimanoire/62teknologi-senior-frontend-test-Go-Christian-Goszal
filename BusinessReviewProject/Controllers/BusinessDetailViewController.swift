//
//  BusinessDetailViewController.swift
//  BusinessReviewProject
//
//  Created by Go Christian Goszal on 28/04/23.
//

import UIKit

class BusinessDetailViewController: UIViewController {

    public var businessId: String = String()
    public var latitude: Double = 0
    public var longitude: Double = 0
    private var detailView: BusinessDetailView?
    private var reviews: [BusinessDetailReview] = [BusinessDetailReview]()
    
    private let tableView: UITableView = {
        let table = UITableView(frame: CGRect.zero, style: UITableView.Style.grouped)
        table.backgroundColor = .systemBackground
        table.register(BusinessDetailReviewTableViewCell.self, forCellReuseIdentifier: BusinessDetailReviewTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        detailView = BusinessDetailView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 300))
        tableView.tableHeaderView = detailView
        configureDetailView()
        fetchBusinessDetailReview()
    }

    private func configureDetailView() {

        APICaller.shared.getBusinessDetail(with: businessId) { [weak self] result in
            switch result {
            case .success(let details):
                self?.latitude = details.coordinates.latitude
                self?.longitude = details.coordinates.longitude
                self?.detailView?.configure(with: BusinessDetailViewModel(businessName: details.name ?? "Empty", imageURL: details.image_url ?? "", rating: details.rating, reviewCount: details.review_count, location: details.location.display_address ?? [""]))
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchBusinessDetailReview() {
        APICaller.shared.getBusinessDetailReview(with: businessId) { [weak self] result in
            switch result {
            case .success(let reviews):
                self?.reviews = reviews
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}

extension BusinessDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviews.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BusinessDetailReviewTableViewCell.identifier, for: indexPath) as? BusinessDetailReviewTableViewCell else {
            return UITableViewCell()
        }
        
        
        let reviews = reviews[indexPath.row]
        let model = BusinessDetailReviewViewModel(name: reviews.user.name ?? "Empty", rating: reviews.rating, reviewText: reviews.text ?? "Empty")
        cell.configure(with: model)
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header")
        header?.isUserInteractionEnabled = true
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 230
    }
    
}
