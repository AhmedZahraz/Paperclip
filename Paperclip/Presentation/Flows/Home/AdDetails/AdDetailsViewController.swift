//
//  AdDetailsViewController.swift
//  Paperclip
//
//  Created by Ahmed Zahraz on 18/02/2023.
//

import UIKit
import Combine

class AdDetailsViewController: UIViewController {
    
    // MARK: - Properties
    private var viewModel: AdDetailsViewModel?
    private var coordintor: AdDetailsCoordinator?
    private var adID: Int64?
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
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
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.numberOfLines = 0
        
        label.setContentCompressionResistancePriority(.init(rawValue: 759), for: .vertical)
        return label
    }()
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Life Cycle
    static func create(with viewModel: AdDetailsViewModel,
                       coordintor: AdDetailsCoordinator,
                       for adID: Int64) -> AdDetailsViewController {
        let view = AdDetailsViewController()
        view.viewModel = viewModel
        view.coordintor = coordintor
        view.adID = adID
        return view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = NSLocalizedString("addetails_screen_title", comment: "")
        
        setupUI()
        bind(to: self.viewModel)
        
        guard let id = adID else { fatalError("Ad ID should not be nil") }
        viewModel?.loadAd(id: id)
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(scrollView)

        scrollView.addSubview(contentView)

        contentView.addSubview(imageView)
        contentView.addSubview(isUrgentLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(descriptionLabel)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true

        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true

        
        let leading: CGFloat = 15
        let trailing: CGFloat = -15
        let constraints = [
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 250),
            
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
            
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: leading),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: trailing),
            descriptionLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 15),
            descriptionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 0),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -50)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func bind(to viewModel: AdDetailsViewModel?) {
        viewModel?.adStatePublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] state in
                switch state {
                case .none:
                    print("none")
                case .loading:
                    print("Show loading view")
                case .success(let ad):
                    print("success got Ad details")
                    self?.configure(with: ad)
                case .error:
                    print("Error in loading ads")
                }
            })
            .store(in: &cancellables)
    }
    
    private func configure(with ad: AdDetails) {
        imageView.load(from: ad.imageURL, with: ad.id) { [weak self] (_, image) in
            self?.imageView.image = image
        }
        
        let isUrgent = ad.isUrgent ?? false
        isUrgentLabel.isHidden = !isUrgent
        
        titleLabel.text = ad.title
        
        priceLabel.text = ad.price
        
        categoryLabel.text = ad.categoryName
        
        dateLabel.text = ad.creationDate
        
        descriptionLabel.text = ad.description
    }
}
