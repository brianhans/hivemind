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
    var filteredContacts: [CNContact] = []
    
    var contactStore: CNContactStore!
    
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.white
        button.setTitle("X", for: .normal)
        button.backgroundColor = UIColor.blue
        button.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        return button
    }()
    
    
    lazy var topLabel: UILabel = {
        
        let label = UILabel()
        
        label.text = "Contacts"
        label.textAlignment = .center
        label.font = UIFont(name: "Avenir", size: 40)
        label.backgroundColor = .white
        return label
        
    }()
    
    
    lazy var navigationBar: UINavigationBar = {
        let bar = UINavigationBar()
        return bar
    }()
    
    
    lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.addTarget(self, action: #selector(self.close), for: .touchUpInside)
        button.backgroundColor = UIColor.darkOrange
        button.layer.cornerRadius = 10
        return button
    }()
    
    lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Search"
        textField.delegate = self
        textField.backgroundColor = UIColor.lightGray
        textField.layer.cornerRadius = 10
        return textField
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
        
        searchTextField.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
    }
    
    func setupViews() {
        tableView.register(ContactsTableViewCell.self, forCellReuseIdentifier: Constants.contactsTableViewCell)
        
        self.view.backgroundColor = UIColor.white
        
        navigationBar.pushItem(self.navigationItem, animated: false)
        
//        self.view.addSubview(navigationBar)
        self.view.addSubview(tableView)
        self.view.addSubview(searchTextField)
        self.view.addSubview(topLabel)
        self.view.addSubview(cancelButton)
        self.view.addSubview(doneButton)
        
        
        
        
        doneButton.snp.makeConstraints { (make) in
            
            make.bottom.equalToSuperview().offset(-8)
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
            make.height.equalTo(50)
        }
        
        topLabel.snp.makeConstraints{ (make) in
            
            make.top.left.right.equalToSuperview()
            make.height.equalTo(60)
            
        }
        
        
        searchTextField.snp.makeConstraints{ (make) in
            make.top.equalTo(topLabel.snp.bottom)
            make.left.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
            make.left.right.equalToSuperview().offset(10)
            make.height.equalTo(50)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(searchTextField.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(doneButton.snp.bottom)
        }
        
        cancelButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(8)
            make.right.equalToSuperview().offset(-8)
            make.height.equalTo(30)
            make.width.equalTo(30)
            
        }
        
    
    }
    
    func searchTextChanged() {
        var contactsFound: [CNContact] = []
        
        if let text = searchTextField.text {
            contactsFound = contacts.filter({("\($0.givenName.lowercased()) \($0.familyName.lowercased())").contains(text.lowercased())})
        }
        
        self.filteredContacts = contactsFound
        self.tableView.reloadData()
    }
    
    func getContacts() {
        contactStore = CNContactStore()
        requestForAccess { (success) in
            if success {
                let keys: [CNKeyDescriptor] = [CNContactGivenNameKey as CNKeyDescriptor, CNContactFamilyNameKey as CNKeyDescriptor, CNContactImageDataKey as CNKeyDescriptor, CNContactPhoneNumbersKey as CNKeyDescriptor]
                
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
    
    func cancel(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func close() {
    
        var hiveContacts: [HiveUser] = []
        for contact in checked {
            var image: UIImage? = nil
            if let imageData = contact.imageData {
                image = UIImage(data: imageData)
            }
            
            hiveContacts.append(HiveUser(name: "\(contact.givenName) \(contact.familyName)", phoneNumber: contact.phoneNumbers[0].value.stringValue, picture: image, status: nil))
        }
        
        completion?(hiveContacts)
        self.dismiss(animated: true, completion: nil)
    }
}

extension AddContactViewController: UITableViewDelegate, UITableViewDataSource {
    
    func getDataSource() -> [CNContact]{
        if let text = self.searchTextField.text{
            if text.characters.count > 0{
                return filteredContacts
            }
        }
        
        return contacts
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.getDataSource().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.contactsTableViewCell) as! ContactsTableViewCell
        let dataSource = getDataSource()
        cell.setup(name: "\(dataSource[indexPath.row].givenName) \(dataSource[indexPath.row].familyName)")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = tableView.cellForRow(at: indexPath) as! ContactsTableViewCell
        
        row.setSelected(false, animated: true)
        let dataSource = getDataSource()
        
        
        
        if let index = checked.index(of: dataSource[indexPath.row]) {
            checked.remove(at: index)
            row.setChecked(false)
        } else {
            checked.append(dataSource[indexPath.row])
            row.setChecked(true)
        }
    }
}


extension AddContactViewController: UITextFieldDelegate{
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
 
        
        return true
        
    }
    
    
    
}
