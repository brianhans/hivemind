//
//  ViewController.swift
//  HiveMind
//
//  Created by Brian Hans on 4/16/17.
//  Copyright © 2017 BrianHans. All rights reserved.
//

import UIKit
import SnapKit

class HiveListViewController: UIViewController {
    
    let viewModel = HiveListViewModel()
    
    lazy var collectionView: UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        let height: CGFloat = UIScreen.main.bounds.height
        let width: CGFloat = UIScreen.main.bounds.width
        let frame = CGRect(x: 0, y: 0, width: width, height: height)
        
        
        let cv = UICollectionView(frame: frame, collectionViewLayout: layout)
        cv.backgroundColor = .white
        
        cv.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        cv.alwaysBounceVertical = true
        cv.delegate = self
        cv.dataSource = self
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(cellLongPress(sender:)))
        longPressGesture.minimumPressDuration = 0.5
        longPressGesture.delaysTouchesBegan = true
        cv.addGestureRecognizer(longPressGesture)
        
        return cv
    }()
    
    lazy var addButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.showAddView))
        return button
    }()
    
    lazy var topLabel: UILabel = {
        
        let label = UILabel()
        
        label.text = "Hives"
        label.font = UIFont(name: ".SFUIText-Heavy", size: 72)
        label.backgroundColor = .white
        return label
        
    }()
    
    func setupViews() {
        collectionView.register(HiveListCollectionViewCell.self, forCellWithReuseIdentifier: Constants.hiveListTableViewCell)

//        self.navigationItem.title = "Hives"
//        self.navigationItem.rightBarButtonItem = addButton
        self.view.backgroundColor = UIColor.white
        self.view.addSubview(topLabel)
        self.view.addSubview(collectionView)
        
        topLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(40)
            make.right.equalToSuperview()
            make.width.equalTo(UIScreen.main.bounds.width)
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.top.equalTo(topLabel.snp.bottom)
        }
    }
    
    func showAddView() {
        let addHiveViewController = AddHiveViewController()
        addHiveViewController.delegate = self
        addHiveViewController.modalPresentationStyle = .overCurrentContext
        addHiveViewController.modalTransitionStyle = .crossDissolve
        self.present(addHiveViewController, animated: true, completion: nil)
    }
    
    func cellLongPress(sender: UILongPressGestureRecognizer) {
        let selectedPoint = sender.location(in: collectionView)
        if let selectedIndex = collectionView.indexPathForItem(at: selectedPoint) {
            let alertView = UIAlertController(title: "Deleted Hive", message: "Are you sure you want to delete this hive?", preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                if self.viewModel.deleteHive(at: selectedIndex.item) {
                    self.collectionView.reloadData()
                }
            })
            
            alertView.addAction(deleteAction)
            
            self.present(alertView, animated: true, completion: nil)
        }
        
        
    }
}

//MARK: Lifecycle methods

extension HiveListViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        self.viewModel.hives = Hive.getHives()
        collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

//MARK: TableView methods

extension HiveListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return  1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.hives.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.hiveListTableViewCell, for: indexPath) as! HiveListCollectionViewCell
        
        if indexPath.row == 0 {
            
            cell.setupFirst()
            
        }
        
        else {
            
            cell.setup(hive: viewModel.hives[indexPath.row - 1])
            
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            self.showAddView()
            return
        }
        
        let hiveController = HiveViewController(hive: viewModel.hives[indexPath.row - 1])
        self.navigationController?.pushViewController(hiveController, animated: true)
        collectionView.cellForItem(at: indexPath) //.setSelected(false, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let width: CGFloat = UIScreen.main.bounds.width - 20
        var height: CGFloat = 100
        
        if indexPath.row == 0 {
            height = 60
        }

        return CGSize(width: width, height: height)
        
        
    }

}

//MARK: Add Hive Delegate
extension HiveListViewController: AddHiveDelegate {
    func hiveCreated(hive: Hive) {
        DispatchQueue.main.async {
            HiveProvider.createHive(name: hive.name, completion: { (hive, error) in
                if let error = error {
                    print(error)
                }
                
                if let hive = hive {
                    hive.save()
                    self.viewModel.hives.append(hive)
                    self.collectionView.reloadData()
                    self.navigationController?.pushViewController(HiveViewController(hive: hive), animated: true)
                }
            })
        }
    }
}
