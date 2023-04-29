//
//  BusinessDetailReviewTableViewCell.swift
//  BusinessReviewProject
//
//  Created by Go Christian Goszal on 28/04/23.
//

import UIKit

class BusinessDetailReviewTableViewCell: UITableViewCell {

    static let identifier = "BusinessDetailReviewTableViewCell"
    
    private let userLabel: UILabel = {
       
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ratingLabel: UILabel = {
       
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let reviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.contentMode = .scaleToFill
        label.numberOfLines = 0
        label.textAlignment = .justified
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(userLabel)
        contentView.addSubview(ratingLabel)
        contentView.addSubview(reviewLabel)
        
        applyConstraints()
    }
    
    private func applyConstraints() {
        
        let userLabelConstraints = [
            userLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            userLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            userLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ]
        
        let ratingLabelConstraints = [
            ratingLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            ratingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ]
        
        let reviewLabelConstraints = [
            reviewLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            reviewLabel.topAnchor.constraint(equalTo: userLabel.bottomAnchor, constant: 15),
            reviewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ]
        
        NSLayoutConstraint.activate(userLabelConstraints)
        NSLayoutConstraint.activate(ratingLabelConstraints)
        NSLayoutConstraint.activate(reviewLabelConstraints)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        reviewLabel.frame = contentView.bounds
    }
    
    public func configure(with model: BusinessDetailReviewViewModel) {
        userLabel.text = model.name
        
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "star.fill")?.withTintColor(.systemYellow)
        let string = NSMutableAttributedString(string: "\(model.rating) ")
        string.append(NSAttributedString(attachment: imageAttachment))
        
        ratingLabel.attributedText = string
        
        reviewLabel.text = model.reviewText
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
