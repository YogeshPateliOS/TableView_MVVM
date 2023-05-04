//
//  CoreDataManager.swift
//  TableView_MVVM
//
//  Created by Mittal Shah on 5/4/23.
//

import UIKit
import CoreData

class CoreDataManager {
    
    var context: NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
   
    // MARK: - Core Data Saving support

    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

extension CoreDataManager {
    
    func addUser(user: UserModel) {
        let userEntity = UserEntity(context: context)
        self.addUpdateUser(user: user, userEntity: userEntity)
    
    }
    
    func updateUser(user: UserModel, userEntity: UserEntity) {
        self.addUpdateUser(user: user, userEntity: userEntity)
    }
    
    private func addUpdateUser(user: UserModel, userEntity: UserEntity) {
        userEntity.firstName = user.firstName
        self.saveContext()
    }
    
    func fetchUsers() -> [UserEntity] {
        var users: [UserEntity] = []
        do {
            users = try! context.fetch(UserEntity.fetchRequest())
        }catch {
            print("Fetch user Error,", error)
        }
        return users
    }
    
    func deleteUser(userEntity: UserEntity) {
        context.delete(userEntity)
        self.saveContext()
    }
    
}
