//
//  BusinessDetailView.swift
//  BusinessReviewProject
//
//  Created by Go Christian Goszal on 28/04/23.
//

import UIKit

class BusinessDetailView: UIView {
    static let identifier = "header"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
       
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 24, weight: .bold)
        return label
    }()
    
    private let ratingLabel: UILabel = {
       
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private let locationLabel: UILabel = {
       
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private let reviewLabel: UILabel = {
       
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let locationButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(askToOpenMap), for: .touchUpInside)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
        button.backgroundColor = .systemBlue
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Open location", for: .normal)
        button.layer.cornerRadius = 8
        return button
        }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(ratingLabel)
        addSubview(locationLabel)
        addSubview(locationButton)
        addSubview(reviewLabel)
        configureConstraints()
        isUserInteractionEnabled = true
    }
    
    func configureConstraints() {

        let nameLabelConstraints = [
            nameLabel.topAnchor.constraint(equalTo: bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
        ]
        
        let ratingLabelConstraints = [
            ratingLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            ratingLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
        ]

        let locationLabelConstraints = [
            locationLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 20),
            locationLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            locationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ]
        
        let locationButtonConstraints = [
            locationButton.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 20),
            locationButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            locationButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ]
        
        let reviewLabelConstraints = [
            reviewLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 75),
            reviewLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            reviewLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(nameLabelConstraints)
        NSLayoutConstraint.activate(ratingLabelConstraints)
        NSLayoutConstraint.activate(locationLabelConstraints)
        NSLayoutConstraint.activate(locationButtonConstraints)
        NSLayoutConstraint.activate(reviewLabelConstraints)
    }
    
    public func configure(with model: BusinessDetailViewModel) {
        guard let url = URL(string: model.imageURL) else {
            return
        }
        DispatchQueue.main.async { [weak self] in
            self?.imageView.sd_setImage(with: url, completed: nil)
            self?.nameLabel.text = model.businessName
            
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = UIImage(systemName: "star.fill")?.withTintColor(.systemYellow)
            let string = NSMutableAttributedString(string: "\(model.rating) ")
            string.append(NSAttributedString(attachment: imageAttachment))
            string.append(NSAttributedString(string: " (\(model.reviewCount))"))
            
            self?.ratingLabel.attributedText = string
            
            self?.locationLabel.text = model.location.joined(separator: " ")
            
            self?.reviewLabel.text = "Reviews"
        }
    }
    
    @objc func askToOpenMap() {
        OpenMapDirections.present(in: BusinessDetailViewController(), sourceView: locationButton, latitude: 1.0, longitude: 1.0)
        }

    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
