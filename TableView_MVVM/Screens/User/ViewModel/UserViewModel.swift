//
//  UserViewModel.swift
//  TableView_MVVM
//
//  Created by Mittal Shah on 5/4/23.
//

import Foundation


protocol UserControllerToViewModel: AnyObject {
    func reloadData()
}

class UserViewModel {

    weak var delegate: UserControllerToViewModel?

    private var manager = CoreDataManager()
    
    lazy var users: [UserEntity] = manager.fetchUsers() {
        didSet {
            delegate?.reloadData()
        }
    }

    var selectedUserEntity: UserEntity?

    
    func addName(user: UserModel) {
        manager.addUser(user: user)
    }
    
    func updateName(user: UserModel, userEntity: UserEntity) {
        manager.updateUser(user: user, userEntity: userEntity)
    }
    
    func deleteName(userEntity: UserEntity) {
        manager.deleteUser(userEntity: userEntity)
    }
    
}
