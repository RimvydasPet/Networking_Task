//
//  CoreDataPosts.swift
//  Networking_Homework
//
//  Created by Rimvydas on 2024-03-28.
//

import UIKit
import CoreData

class CoreDataExtension: UIViewController {
    
    var userDetails : [UserDetails] = []
    var posts: [PostsCoreData] = []
    let postTableViewCell = PostTableViewCell()
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    //MARK: - Save Users Details to CoreData
    func saveUserDetails(userDetails: [Users]) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "UserDetails", in: managedContext) else { return  }
        
        for users in userDetails {
            let item = UserDetails(entity: entity, insertInto: managedContext)
            item.id = Int64(users.id)
            item.name = users.name
            item.username = users.username
            item.email = users.email
        }
        
        do {
            try managedContext.save()
            dismiss(animated: true)
        } catch {
            print(error.localizedDescription)
        }
    }
    //MARK: - Load Users Details From CoreData
    func fetchUserDetails() {
        let request: NSFetchRequest<UserDetails> = UserDetails.fetchRequest()
        
        do {
            userDetails = try context.fetch(request)
            guard  let id = userDetails.last?.id,
                   let name = userDetails.last?.name,
                   let username = userDetails.last?.username,
                   let email = userDetails.last?.email
            else { return }
            postTableViewCell.nameTableViewCellLabel?.text = "\(name)"
            postTableViewCell.bodyTableViewCellLabel?.text = email
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //MARK: - Save Posts to CoreData
    func savePosts(posts: [Posts]) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "PostsCoreData", in: managedContext) else { return  }
        
        for post in posts {
            let item = PostsCoreData(entity: entity, insertInto: managedContext)
            item.id = Int64(post.id)
            item.userId = Int64(post.userId)
            item.title = post.title
            item.body = post.body
        }
        
        do {
            try managedContext.save()
            dismiss(animated: true)
        } catch {
            print(error.localizedDescription)
        }
    }
    //MARK: - Load Posts From CoreData
    func fetchPosts() {
        let request: NSFetchRequest<PostsCoreData> = PostsCoreData.fetchRequest()
        
        do {
            posts = try context.fetch(request)
            guard  let userId = posts.last?.userId,
                   let id = posts.last?.id,
                   let title = posts.last?.title,
                   let body = posts.last?.body
            else { return }
            postTableViewCell.nameTableViewCellLabel?.text = "\(id)"
            postTableViewCell.bodyTableViewCellLabel?.text = body
        } catch {
            print(error.localizedDescription)
        }
    }

    
}

