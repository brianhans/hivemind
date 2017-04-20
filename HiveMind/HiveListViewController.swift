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
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    lazy var addButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.showAddView))
        return button
    }()
    
    func setupViews() {
        tableView.register(HiveListTableViewCell.self, forCellReuseIdentifier: Constants.hiveListTableViewCell)

        self.navigationItem.title = "Hives"
        self.navigationItem.rightBarButtonItem = addButton
        
        self.view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.top.bottom.left.right.equalToSuperview()
        }
    }
    
    func showAddView() {
        let addHiveViewController = AddHiveViewController()
        addHiveViewController.delegate = self
        addHiveViewController.modalPresentationStyle = .overCurrentContext
        addHiveViewController.modalTransitionStyle = .crossDissolve
        self.present(addHiveViewController, animated: true, completion: nil)
    }
}

//MARK: Lifecycle methods

extension HiveListViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
}

//MARK: TableView methods

extension HiveListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.hives.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.hiveListTableViewCell) as! HiveListTableViewCell
        cell.setup(hive: viewModel.hives[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let hiveController = HiveViewController(hive: viewModel.hives[indexPath.row])
        self.navigationController?.pushViewController(hiveController, animated: true)
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
                    self.navigationController?.pushViewController(HiveViewController(hive: hive), animated: true)
                }
            })
        }
    }
}
