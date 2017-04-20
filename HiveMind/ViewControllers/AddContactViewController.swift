//
//  AddContactViewController.swift
//  HiveMind
//
//  Created by Brian Hans on 4/16/17.
//  Copyright © 2017 BrianHans. All rights reserved.
//

import UIKit
import Contacts

class AddContactViewController: UIViewController {

    var existingContacts: Set<String>
    var checked: [CNContact] = []
    var contacts: [CNContact] = []
    var contactStore: CNContactStore!
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    lazy var navigationBar: UINavigationBar = {
        let bar = UINavigationBar()
        return bar
    }()
    
    
    lazy var doneButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(close))
        return button
    }()
    
    var completion: (([HiveUser]) -> Void)?
    
    init(users: [HiveUser], completion: @escaping ([HiveUser]) -> Void) {
        existingContacts = Set()
        for user in users {
            existingContacts.insert(user.phoneNumber)
        }
        
        self.completion = completion
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        getContacts()
    }
    
    func setupViews() {
        tableView.register(ContactsTableViewCell.self, forCellReuseIdentifier: Constants.contactsTableViewCell)
        
        self.navigationItem.title = "Contacts"
        self.navigationItem.rightBarButtonItem = doneButton
        self.view.backgroundColor = UIColor.white
        
        navigationBar.pushItem(self.navigationItem, animated: false)
        
        self.view.addSubview(navigationBar)
        self.view.addSubview(tableView)
        
        navigationBar.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(64)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(navigationBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    func getContacts() {
        contactStore = CNContactStore()
        requestForAccess { (success) in
            if success {
                let keys: [CNKeyDescriptor] = [CNContactGivenNameKey as CNKeyDescriptor, CNContactImageDataKey as CNKeyDescriptor, CNContactPhoneNumbersKey as CNKeyDescriptor]
                
                let predicate = CNContact.predicateForContactsInContainer(withIdentifier: self.contactStore.defaultContainerIdentifier())
                if let contacts = try? self.contactStore.unifiedContacts(matching: predicate, keysToFetch: keys) {
                    self.contacts = contacts
                    for contact in contacts {
                        if self.existingContacts.contains(contact.phoneNumbers[0].value.stringValue) {
                            self.checked.append(contact)
                        }
                    }
                    self.tableView.reloadData()
                }
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }

    
    func requestForAccess(completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        
        switch authorizationStatus {
        case .authorized:
            completionHandler(true)
            
        case .denied, .notDetermined:
            self.contactStore.requestAccess(for: CNEntityType.contacts, completionHandler: { (access, accessError) -> Void in
                if access {
                    completionHandler(access)
                }
                else {
                    completionHandler(false)
                }
            })
            
        default:
            completionHandler(false)
        }
    }
    
    func close() {
        var hiveContacts: [HiveUser] = []
        for contact in checked {
            var image: UIImage? = nil
            if let imageData = contact.imageData {
                image = UIImage(data: imageData)
            }
            
            hiveContacts.append(HiveUser(name: contact.givenName, phoneNumber: contact.phoneNumbers[0].value.stringValue, picture: image, status: nil))
        }
        
        completion?(hiveContacts)
        self.dismiss(animated: true, completion: nil)
    }
}

extension AddContactViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.contactsTableViewCell) as! ContactsTableViewCell
        cell.setup(name: contacts[indexPath.row].givenName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = tableView.cellForRow(at: indexPath) as! ContactsTableViewCell
        
        row.setSelected(false, animated: true)
        
        if let index = checked.index(of: contacts[indexPath.row]) {
            checked.remove(at: index)
            row.setChecked(false)
        } else {
            checked.append(contacts[indexPath.row])
            row.setChecked(true)
        }
    }
}
