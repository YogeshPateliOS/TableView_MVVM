//
//  UserListViewController.swift
//  TableView_MVVM
//
//  Created by Mittal Shah on 5/4/23.
//

import UIKit

enum CRUDType {
    case insert, update, delete, fetch
}

class UserListViewController: UIViewController {
    
    @IBOutlet weak var userTableView: UITableView!
    private var viewModel = UserViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configuration()
    }
 
    
}

extension UserListViewController {
   
    func configuration() {
        self.viewModel.delegate = self
    }
    
    func manageCRUD(type: CRUDType, index: Int = 0) {
        var alertController = UIAlertController()
        
        switch type {
        case .insert :
            alertController = UIAlertController(
                title: "Add User",
                message: "Please enter your user details.",
                preferredStyle: .alert)
            
            let save = UIAlertAction(
                title: "Save",
                style: .default) { _ in
                    if let firstName = alertController.textFields?.first?.text, !firstName.isEmpty {
                        let fistName = UserModel(firstName: firstName)
                        self.viewModel.addName(user:fistName)
                    }
                }
            alertController.addAction(save)
            alertController.addTextField { firstNameField in
                firstNameField.placeholder = "Enter your first name"
            }
            self.present(alertController, animated: true)
        case.update :
            alertController = UIAlertController(
                title: "Update User",
                message: "Please enter your user details.",
                preferredStyle: .alert)
            
            alertController.addTextField { firstName in
                firstName.placeholder = self.viewModel.users[index].firstName
            }
            
            let update = UIAlertAction(
                title: "Update",
                style: .default) { _ in
                    let user = UserModel(firstName: (alertController.textFields?.first?.text)!)
                    self.viewModel.updateName(user: user, userEntity: self.viewModel.users[index])
                }
            alertController.addAction(update)
            self.present(alertController, animated: true)
        case .delete :
            self.viewModel.deleteName(userEntity: self.viewModel.users[index])
        case .fetch :
            print("update")
        }
        
           
    }
    
}

extension UserListViewController {
    
    @IBAction func addUserButtonTapped(_ sender: UIBarButtonItem) {
        self.manageCRUD(type: .insert)
    }
}

extension UserListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.viewModel.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else { return UITableViewCell() }
        let user = viewModel.users[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = user.firstName
        cell.contentConfiguration = content
        return cell
    }  
}


extension UserListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = self.viewModel.users[indexPath.row]
        self.viewModel.selectedUserEntity =  user
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let update = UIContextualAction(
            style: .normal, title: "Update") { _, _, _ in
                // Update
                self.manageCRUD(type: .update, index: indexPath.row)
               
            }
        update.backgroundColor = UIColor.systemIndigo
        
        let delete = UIContextualAction(
            style: .destructive,
            title: "Delete") { _, _, _ in
                self.manageCRUD(type: .delete, index: indexPath.row)
            }
        return UISwipeActionsConfiguration(actions: [delete, update])
    }
}

extension UserListViewController: UserControllerToViewModel {
    func reloadData() {
        self.userTableView.reloadData()
    }
    
}
