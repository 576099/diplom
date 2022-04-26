//
//  ProfileViewController.swift
//  UIBaseComponents
//
//  Created by Александр Смирнов on 16.03.2022.
//

import UIKit

class ProfileViewController: UIViewController {
        
    private lazy var profileHeaderView: ProfileHeaderView = {
//        let view = ProfileHeaderView(frame: .zero)
        let view = ProfileHeaderView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(UIScreen.main.bounds.width), height: CGFloat(220 )))
        view.delegate = self
//        view.isUserInteractionEnabled = true
        return view
    }()
    
//    self.profileHeaderView.delegate = self.view
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.autoresizingMask = [.flexibleHeight]
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostCell")
        tableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: "PhotoCell")
        tableView.register(ProfileHeaderView.self, forHeaderFooterViewReuseIdentifier: "ProfileHeaderView")
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var jsonDecoder: JSONDecoder = {
        return JSONDecoder()
    }()
    
    private var dataSource: [Posts.Article] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.setupView()
        self.fetchPosts { [weak self] posts in
            self?.dataSource = posts
            self?.tableView.reloadData()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    private func setupNavigationBar() {
        self.navigationController?.navigationBar.prefersLargeTitles = false
        //скрываем заголовок navigationBar именно у этого navigationController
        self.navigationController?.navigationBar.isHidden = true
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.clear]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.clear]
        navBarAppearance.backgroundColor = UIColor.clear

        navBarAppearance.shadowImage = nil
        navBarAppearance.shadowColor = nil
        self.navigationController?.navigationBar.standardAppearance = navBarAppearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        self.navigationController?.navigationBar.layoutIfNeeded()
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(self.tableView)
        
        let topConstraint = self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor)
        let leadingConstraint = self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)
        let trailingConstraint = self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        let bottomConstraint = self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        
        NSLayoutConstraint.activate([
            topConstraint, leadingConstraint, trailingConstraint, bottomConstraint
        ])
    }
    private func fetchPosts(completion: @escaping ([Posts.Article]) -> Void) {
        if let path = Bundle.main.path(forResource: "Post", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
//                let jsonObj = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                let posts = try self.jsonDecoder.decode(Posts.self, from: data)
//                print("json data: \(posts)")
                completion(posts.articles)
            } catch let error {
                print("parse error: \(error.localizedDescription)")
            }
        } else {
            fatalError("Invalid filename/path.")
        }
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        } else if section == 1 {
            return 1
        } else {
            return self.dataSource.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath == [1, 0] {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as? PhotosTableViewCell else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
                return cell
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostTableViewCell else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
                return cell
            }
            cell.delegate = self
            let post = self.dataSource[indexPath.row]
            let viewModel = PostTableViewCell.ViewModel(author: post.author,
                                                        description: post.description,
                                                        image: post.image,
                                                        likes: post.publishedLikesAtString,
                                                        views: post.publishedViewsAtString)
            cell.setup(with: viewModel)
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
            return 3
    }
    //Устанавливаем прозрачность для HeaderInSection начиная с 1-ой
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let profHV = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ProfileHeaderView") as! ProfileHeaderView
            profHV.delegate = self
            return profHV
    }
    
    //обрабатываем касание на ячейку
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == [1,0] {
            let photoVC = PhotosViewController()
            photoVC.title = "Photo Gallery"
            self.navigationController?.pushViewController(photoVC, animated: true)
        } else {
            
            let pushDetailVC = DetailPostViewController()
            //        guard let indexPathRow = self.tableView.indexPath(for: cell)?.row else { return }
            let author = dataSource[indexPath.row].author
            dataSource[indexPath.row].views += 1
            //        let viewsPost = dataSource[indexPath.row].views
            
            pushDetailVC.authorLabel.text = author
            pushDetailVC.descriptionLabel.text = dataSource[indexPath.row].description
            pushDetailVC.imageView1.image = UIImage(named: dataSource[indexPath.row].image)
            pushDetailVC.likesLabel.text = "Likes: \(dataSource[indexPath.row].likes)"
            pushDetailVC.viewsLabel.text = "Views: \(dataSource[indexPath.row].views)"
            
            self.navigationController?.pushViewController(pushDetailVC, animated: true)
            
            print(author)
            self.tableView.reloadRows(at: [indexPath], with: .fade)
        }
    }

    //Устанавливаем значение высоты Заголовок Секции
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 220
        }else {
            return 0
        }
    }
    
    //методы для реализации удаления ячеек
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            dataSource.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
}

extension ProfileViewController: ProfileViewProtocol {
    func buttonTappedFromController() {
        print(#function)
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
}

extension ProfileViewController: PostTableViewCellProtocol {
    func upperLikeTap(cell: PostTableViewCell) {
        guard let indexPathRow = self.tableView.indexPath(for: cell)?.row else { return }
        let indexPath = IndexPath(row: indexPathRow, section: 2)
        dataSource[indexPathRow].likes += 1
        self.tableView.reloadRows(at: [indexPath], with: .fade)
        print("\(indexPath)")
    }
    
}
