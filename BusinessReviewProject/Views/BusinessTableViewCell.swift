//
//  BusinessTableViewCell.swift
//  BusinessReviewProject
//
//  Created by Go Christian Goszal on 27/04/23.
//

import UIKit
import SDWebImage

class BusinessTableViewCell: UITableViewCell {

    static let identifier = "BusinessTableViewCell"
    
    private let businessLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let businessImageUIImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(businessImageUIImageView)
        contentView.addSubview(businessLabel)
        contentView.addSubview(ratingLabel)
        
        applyConstraints()
        
    }
    
    private func applyConstraints() {
        let businessPosterUIImageViewConstraints = [
            businessImageUIImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            businessImageUIImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            businessImageUIImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            businessImageUIImageView.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        let businessLabelConstraints = [
            businessLabel.leadingAnchor.constraint(equalTo: businessImageUIImageView.trailingAnchor, constant: 20),
            businessLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -15),
        ]
        
        let ratingLabelConstraints = [
            ratingLabel.leadingAnchor.constraint(equalTo: businessImageUIImageView.trailingAnchor, constant: 20),
            ratingLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 15),
        ]
        
        NSLayoutConstraint.activate(businessPosterUIImageViewConstraints)
        NSLayoutConstraint.activate(businessLabelConstraints)
        NSLayoutConstraint.activate(ratingLabelConstraints)
    }
    
    
    public func configure(with model: BusinessViewModel) {

        guard let url = URL(string: model.imageURL) else {
            return
        }
        businessImageUIImageView.sd_setImage(with: url, completed: nil)
        businessLabel.text = model.businessName
        
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "star.fill")?.withTintColor(.systemYellow)
        let string = NSMutableAttributedString(string: "\(model.rating) ")
        string.append(NSAttributedString(attachment: imageAttachment))
        string.append(NSAttributedString(string: " (\(model.reviewCount))"))
        
        ratingLabel.attributedText = string
    }
    
    
    required init?(coder: NSCoder) {
        fatalError()
    }

}
