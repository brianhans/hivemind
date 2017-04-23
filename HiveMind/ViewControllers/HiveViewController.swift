//
//  HiveViewController.swift
//  HiveMind
//
//  Created by Brian Hans on 4/16/17.
//  Copyright © 2017 BrianHans. All rights reserved.
//

import UIKit
import PBJHexagon

class HiveViewController: UIViewController {

    let viewModel: HiveViewModel
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = PBJHexagonFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = .zero
        flowLayout.headerReferenceSize = .zero
        flowLayout.footerReferenceSize = .zero
        let width = UIScreen.main.bounds.width / 3 - 25
        let height = width * 2 / sqrt(3)
        flowLayout.itemSize = CGSize(width: width, height: height)
        flowLayout.itemsPerRow = 3
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = UIColor.clear
        cv.bounces = true
        cv.alwaysBounceVertical = true
        return cv
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(updateHive), for: .valueChanged)
        return refresh
    }()
    
    lazy var addButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.showSignalView))
        return button
    }()
    
    

    init(hive: Hive) {
        viewModel = HiveViewModel(hive: hive)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Don't use storyboards. Please.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        updateHive()
    }
    
    func setupViews() {
        collectionView.register(HiveUserCollectionViewCell.self, forCellWithReuseIdentifier: Constants.hiveUserCollectionViewCell)
        collectionView.addSubview(refreshControl)
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.clear
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.tintColor = UIColor.darkOrange
        
        self.navigationItem.title = viewModel.hive.name
        self.navigationItem.rightBarButtonItem = addButton
        
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(collectionView)

        collectionView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func showAddView() {
        let contactController = AddContactViewController(users: self.viewModel.hive.users) { contacts in
            self.viewModel.hive.users = contacts
            self.viewModel.hive.save()
            HiveProvider.addToHive(id: self.viewModel.hive.id, numbers: self.viewModel.hive.users.map{$0.phoneNumber})
            self.collectionView.reloadData()
        }
        
        present(contactController, animated: true, completion: nil)
    }
    
    func showSignalView() {
        let signalVC = SignalViewController() { signal in
            self.viewModel.hive.signal = signal
            self.viewModel.hive.save()
            HiveProvider.sendSignal(id: self.viewModel.hive.id, command: signal.title, options: signal.options)
        }
        
        present(signalVC, animated: true, completion: nil)
    }
    
    func showContactDetails(user: HiveUser) {
        let contactDetailsViewController = ContactDetailsViewController()
        contactDetailsViewController.user = user
        contactDetailsViewController.modalPresentationStyle = .overCurrentContext
        contactDetailsViewController.modalTransitionStyle = .crossDissolve
        self.present(contactDetailsViewController, animated: true, completion: nil)
    }
    
    func updateHive() {
        viewModel.updateHive { _ in
            self.collectionView.reloadData()
            self.refreshControl.endRefreshing()
        }
    } 
}

//MARK: Collection View

extension HiveViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.hive.users.count + 1

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.hiveUserCollectionViewCell, for: indexPath) as! HiveUserCollectionViewCell
        
        if indexPath.row == 0{
            cell.setupFirst()
            return cell
        }
        
        let user = viewModel.hive.users[indexPath.item - 1]
        cell.setup(user: user, color: viewModel.signal?.statusColors[user.status ?? "unknown"] ?? .goldenTainoi)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = CGFloat((collectionView.frame.size.width / 3)) - 5
        return CGSize(width: height, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == 0{
            self.showAddView()
        }
        
        else{
            showContactDetails(user: viewModel.hive.users[indexPath.row - 1])
        }
        
    }
}
