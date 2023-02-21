//
//  AdItemCollectionViewCell.swift
//  Paperclip
//
//  Created by Ahmed Zahraz on 20/02/2023.
//

import UIKit

class AdItemCollectionViewCell: UICollectionViewCell {
    
    var ad: AdItem?
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 5
        imageView.backgroundColor = .lightGray
        imageView.setContentCompressionResistancePriority(.init(rawValue: 755), for: .vertical)
        return imageView
    }()
    
    private let isUrgentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .white
        label.backgroundColor = .red.withAlphaComponent(0.8)
        label.numberOfLines = 1
        label.text = NSLocalizedString("urgent_text", comment: "")
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 2
        
        label.setContentCompressionResistancePriority(.init(rawValue: 754), for: .vertical)
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.numberOfLines = 1
        
        label.setContentCompressionResistancePriority(.init(rawValue: 753), for: .vertical)
        return label
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12, weight: .thin)
        label.numberOfLines = 1
        
        label.setContentCompressionResistancePriority(.init(rawValue: 752), for: .vertical)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 12, weight: .thin)
        label.numberOfLines = 1
        
        label.setContentCompressionResistancePriority(.init(rawValue: 751), for: .vertical)
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 5
//        layer.shadowOpacity = 0.3
//        layer.shadowOffset = .zero
//        layer.shadowColor = UIColor.black.cgColor
//        layer.shadowRadius = 3
        
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.lightGray.cgColor
        
        
        contentView.addSubview(imageView)
        contentView.addSubview(isUrgentLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(dateLabel)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        let leading: CGFloat = 8
        let trailing: CGFloat = -8
        let constraints = [
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 150),
            
            isUrgentLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: trailing),
            isUrgentLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -trailing),
            isUrgentLabel.widthAnchor.constraint(equalToConstant: 70),
            isUrgentLabel.heightAnchor.constraint(equalToConstant: 26),
            
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leading),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: trailing),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            titleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 0),
            
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leading),
            priceLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: trailing),
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 3),
            priceLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 0),
            
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leading),
            categoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: trailing),
            categoryLabel.topAnchor.constraint(greaterThanOrEqualTo: priceLabel.bottomAnchor, constant: 10),
            categoryLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 0),
            
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leading),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: trailing),
            dateLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 3),
            dateLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 0),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: trailing)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func configure(with ad: AdItem) {
        self.ad = ad
        
        imageView.image = nil
        imageView.load(from: ad.smallImageURL, with: ad.id) { [weak self] (identifier, image) in
            if identifier == self?.ad?.id {
                self?.imageView.image = image
            }
        }
        
        let isUrgent = ad.isUrgent ?? false
        isUrgentLabel.isHidden = !isUrgent
        
        titleLabel.text = ad.title
        
        priceLabel.text = ad.price
        
        categoryLabel.text = ad.categoryName
        
        dateLabel.text = ad.creationDate
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
}
