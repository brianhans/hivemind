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
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    lazy var navigationBar: UINavigationBar = {
        let bar = UINavigationBar()
        return bar
    }()
    
    lazy var doneButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.close))
        return button
    }()
    
    lazy var searchTextField: UITextField = {
        let textField = UIPaddedTextField()
        textField.placeholder = "Search"
        textField.backgroundColor = UIColor.paleGray
        textField.layer.cornerRadius = 10
        textField.delegate = self
        textField.textAlignment = .center
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
        
        self.navigationItem.title = "Contacts"
        self.navigationItem.rightBarButtonItem = doneButton
        
        navigationBar.backgroundColor = UIColor.clear
        navigationBar.isTranslucent = true
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.tintColor = UIColor.darkOrange
        
        navigationBar.pushItem(self.navigationItem, animated: false)
        
        self.view.addSubview(navigationBar)
        self.view.addSubview(tableView)
        self.view.addSubview(searchTextField)
        
        searchTextField.snp.makeConstraints{ (make) in
            make.top.equalTo(navigationBar.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(30)
            make.right.equalToSuperview().offset(-30)
            make.height.equalTo(35)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(searchTextField.snp.bottom).offset(20)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        navigationBar.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(64)
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
            
            hiveContacts.append(HiveUser(name: "\(contact.givenName) \(contact.familyName)", phoneNumber: contact.phoneNumbers[0].value.stringValue, picture: image))
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
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

extension AddContactViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textLength = self.searchTextField.text?.characters.count ?? 0
        
        let textRange = NSRange(Range(uncheckedBounds: (0, textLength)))
        
        if NSEqualRanges(textRange, range) && string.characters.count == 0 {
            textField.textAlignment = .center
        } else {
            textField.textAlignment = .left
        }
        
        return true
    }
}
