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
        return cv
    }()
    
    lazy var signalButton: UIButton = {
        let button = UIButton()
        button.setTitle("Signal", for: .normal)
        button.addTarget(self, action: #selector(self.showSignalView), for: .touchUpInside)
        button.backgroundColor = UIColor.blue
        return button
    }()
    
    lazy var addButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.showAddView))
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
    }
    
    func setupViews() {
        collectionView.register(HiveUserCollectionViewCell.self, forCellWithReuseIdentifier: Constants.hiveUserCollectionViewCell)
        
        self.navigationItem.title = viewModel.hive.name
        self.navigationItem.rightBarButtonItem = addButton
        
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(collectionView)
        self.view.addSubview(signalButton)
        
        signalButton.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(signalButton.snp.top)
        }
    }
    
    func showAddView() {
        let contactController = AddContactViewController(users: self.viewModel.hive.users) { contacts in
            self.viewModel.hive.users = contacts
            HiveProvider.addToHive(id: self.viewModel.hive.id, numbers: self.viewModel.hive.users.map{$0.phoneNumber})
        }
        
        present(contactController, animated: true, completion: nil)
    }
    
    func showSignalView() {
        let signalVC = SignalViewController() { title, options in
            HiveProvider.sendSignal(id: self.viewModel.hive.id, command: title, options: options)
        }
        
        present(signalVC, animated: true, completion: nil)
    }
}

//MARK: Collection View

extension HiveViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //Only show users if there is currently a signal
        if viewModel.signal != nil {
            return viewModel.hive.users.count
        } else {
            //TODO: Show empty state
            return 2
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.hiveUserCollectionViewCell, for: indexPath) as! HiveUserCollectionViewCell
//        let user = viewModel.hive.users[indexPath.item]
//        cell.setup(user: user, color: viewModel.signal!.statusColors[user.status])
        cell.layer.backgroundColor = UIColor.blue.cgColor
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = CGFloat((collectionView.frame.size.width / 3)) - 5
        return CGSize(width: height, height: height)
    }
}
