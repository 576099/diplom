//
//  PhotosViewController.swift
//  HomeWork_2_5
//
//  Created by Александр Смирнов on 07.04.2022.
//

import UIKit

class PhotosViewController: UIViewController {

    private var isExpanded = false
    private lazy var screenWidth = UIScreen.main.bounds.size.width
    private var myViewCenterXConstraint: NSLayoutConstraint?
    private var myViewCenterYConstraint: NSLayoutConstraint?
    private var myViewWidth: NSLayoutConstraint?
    private var myViewHeight: NSLayoutConstraint?
    
    private lazy var jsonDecoder: JSONDecoder = {
        return JSONDecoder()
    }()
    
    private var dataSource: [Photos.Images] = []
    
    private func fetchPhotos(completion: @escaping ([Photos.Images]) -> Void) {
        if let path = Bundle.main.path(forResource: "Photos", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
//                let jsonObj = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                let photos = try self.jsonDecoder.decode(Photos.self, from: data)
//                print("json data: \(photos)")
                completion(photos.images)
            } catch let error {
                print("parse error: \(error.localizedDescription)")
            }
        } else {
            fatalError("Invalid filename/path.")
        }
    }
    
    private enum Constants {
        static let itemCount: CGFloat = 3
    }
    
    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
//        collectionView.backgroundColor = .systemBlue
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: "CustomCell")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "DefaultCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
//        logoImageView.image = UIImage(named: "logo")
        logoImageView.clipsToBounds = true
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        return logoImageView
    }()
    
    private lazy var myView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 50
        view.isHidden = true
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var backView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        view.isHidden = true
        view.backgroundColor = .systemGray
        return view
    }()

    private lazy var closeBackViewButton: UIButton = {
        let button = UIButton()
        button.setTitle("X", for: .normal)
        button.isHidden = true
        button.alpha = 0
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(self.collectionView)
        let topConstraint = self.collectionView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 8)
        let leftConstraint = self.collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 8)
        let rightConstraint = self.collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -8)
        let bottomConstraint = self.collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        
        NSLayoutConstraint.activate([
            topConstraint, leftConstraint, rightConstraint, bottomConstraint
        ])
        
        self.setupNavigationBar()
        self.fetchPhotos{ [weak self] ph in
            self?.dataSource = ph
        }
        
        self.view.addSubview(self.myView)
        self.myView.addSubview(self.logoImageView)
        self.view.addSubview(self.backView)
        self.view.bringSubviewToFront(self.myView)
        self.backView.addSubview(closeBackViewButton)
        
        self.myViewCenterXConstraint = self.myView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        self.myViewCenterYConstraint = self.myView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        self.myViewWidth = self.myView.widthAnchor.constraint(equalToConstant: 100)
        self.myViewHeight = self.myView.heightAnchor.constraint(equalToConstant: 100)
        
        let backViewCenterXConstraint = self.backView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        let backViewCenterYConstraint = self.backView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        let backViewWidth = self.backView.widthAnchor.constraint(equalTo: self.view.widthAnchor)
        let backViewHeight = self.backView.heightAnchor.constraint(equalTo: self.view.heightAnchor)
        
        let buttonTopConstraint = self.closeBackViewButton.topAnchor.constraint(equalTo: self.backView.topAnchor, constant: 170)
        let buttonRightConstraint = self.closeBackViewButton.trailingAnchor.constraint(equalTo: self.backView.trailingAnchor, constant: -20)
        let buttonWidthConstraint = self.closeBackViewButton.widthAnchor.constraint(equalToConstant: 50)
        let buttonHeightConstraint = self.closeBackViewButton.heightAnchor.constraint(equalToConstant: 50)
        NSLayoutConstraint.activate([
            self.myViewCenterXConstraint, self.myViewCenterYConstraint, self.myViewWidth, self.myViewHeight, backViewCenterXConstraint, backViewCenterYConstraint, backViewWidth, backViewHeight, buttonTopConstraint, buttonRightConstraint, buttonWidthConstraint, buttonHeightConstraint
        ].compactMap({ $0 }))
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
    
    private func itemSize(for width: CGFloat, with spacing: CGFloat) -> CGSize {
        // 3 элемента в ряду
        let neededWidth = width - 2 * spacing
        let itemWidth = floor(neededWidth / Constants.itemCount)
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    @objc private func didTapCloseButton() {
        self.isExpanded.toggle()
        self.myViewWidth?.constant = self.isExpanded ? self.screenWidth : 100
        self.myViewHeight?.constant = self.isExpanded ? self.screenWidth : 100
        self.myView.isHidden = true
        
        if !self.isExpanded {
            self.backView.isHidden = true
            self.closeBackViewButton.isHidden = true
        }
        
        UIImageView.animate(withDuration: 0.5) {
            self.backView.alpha = self.isExpanded ? 1 : 0
            self.closeBackViewButton.alpha = self.isExpanded ? 1 : 0
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.logoImageView.layer.cornerRadius = 50
        }
    }
}

extension PhotosViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        print(self.dataSource[indexPath.row].imageName)
        
        self.logoImageView.image = UIImage(named: self.dataSource[indexPath.row].imageName)
        
        if !isExpanded {
            self.isExpanded.toggle()
        self.myViewWidth?.constant = self.screenWidth
        self.myViewHeight?.constant = self.screenWidth
        self.myView.isHidden = self.isExpanded ? false : true
        self.backView.isHidden = false
        self.closeBackViewButton.isHidden = false
        
        UIImageView.animate(withDuration: 0.5) {
            self.backView.alpha = self.isExpanded ? 1 : 0
            self.logoImageView.layer.cornerRadius = self.isExpanded ? 0 : 50
            self.logoImageView.clipsToBounds = false
            self.view.layoutIfNeeded()
            
        } completion: { _ in
            UIImageView.animate(withDuration: 0.3) {
                self.closeBackViewButton.alpha = self.isExpanded ? 1 : 0
                self.view.layoutIfNeeded()
            } completion: { _ in
                
            }
        }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as? PhotosCollectionViewCell else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DefaultCell", for: indexPath)
//            cell.backgroundColor = .systemRed
            return cell
        }
        let image = self.dataSource[indexPath.row]
        let viewModel = PhotosCollectionViewCell.ViewModel(image: image.imageName)
        cell.setupImage(with: viewModel)
//        cell.backgroundColor = .yellow
//        cell.setup(with: "AAA")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing
        return self.itemSize(for: collectionView.frame.width, with: spacing ?? 0)
    }
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let cell = collectionView.cellForItem(at: indexPath) as? PhotosCollectionViewCell
//        print(indexPath)
//        cell?.updateText("BBB")
//    }
}

