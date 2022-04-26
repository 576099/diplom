//
//  DetailPostViewController.swift
//  Diplom
//
//  Created by Александр Смирнов on 26.04.2022.
//

import UIKit

class DetailPostViewController: UIViewController {

    lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 18.0, weight: UIFont.Weight.bold)
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var imageView1: UIImageView = {
        let imageView1 = UIImageView()
        imageView1.contentMode = .scaleAspectFit
        imageView1.backgroundColor = .black
//        imageView1.setContentCompressionResistancePriority(UILayoutPriority(250), for: .vertical)
        imageView1.clipsToBounds = true
        return imageView1
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray
//        label.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .vertical)
        label.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
//        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var likesLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
//        label.setContentCompressionResistancePriority(UILayoutPriority(500), for: .vertical)
//        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var viewsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .black
//        label.setContentCompressionResistancePriority(UILayoutPriority(500), for: .vertical)
//        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    private lazy var stackViewHorizontal: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 200
//        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.setupView()
        // Do any additional setup after loading the view.
    }
    
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        //показываем заголовок navigationBar именно у этого navigationController
        self.navigationController?.navigationBar.isHidden = false
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.shadowImage = nil
        navBarAppearance.shadowColor = nil
        self.navigationController?.navigationBar.standardAppearance = navBarAppearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        self.navigationController?.navigationBar.layoutIfNeeded()
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        self.view.addSubview(authorLabel)
//        self.contentView.backgroundColor = .white

//        self.contentView.addSubview(self.backView)
        self.view.addSubview(stackView)
        
        self.stackView.addArrangedSubview(self.authorLabel)
        self.stackView.addArrangedSubview(self.imageView1)
        self.stackView.addArrangedSubview(self.descriptionLabel)
        self.stackView.addArrangedSubview(self.stackViewHorizontal)
        self.stackViewHorizontal.addArrangedSubview(likesLabel)
        self.stackViewHorizontal.addArrangedSubview(viewsLabel)
        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100),
            self.stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            self.stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            
        ])
    }
}
