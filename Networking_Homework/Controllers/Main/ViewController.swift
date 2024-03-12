//
//  ViewController.swift
//  Networking_Homework
//
//  Created by Rimvydas on 2023-09-26.
//

import UIKit
import CoreData

class ViewController: LoadableViewController {
    //from API
    private var posts: [Posts] = []
    let postTableViewCell = PostTableViewCell()
    var refreshControl = UIRefreshControl()
    //For Core Data
    //    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var managedContext: NSManagedObjectContext?
    
    @IBOutlet weak var postTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        savePosts(posts: posts)
        setupTableView()
        self.fetchPosts()
        //loadData()
        refreshControl.addTarget(self, action: #selector(handleRefreshControl), for: UIControl.Event.valueChanged)
        postTableView.addSubview(refreshControl)
        
    }
    
    @objc func handleRefreshControl(_ send: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
//            self.loadData()
            //self.postTableView.reloadData()
            self.fetchPosts()
            self.stopLoading()
            self.postTableView.reloadData()
            self.refreshControl.endRefreshing()
            
        }
    }
    
    private func setupTableView() {
        postTableView?.dataSource = self
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        postTableView?.register(nib, forCellReuseIdentifier: "PostTableViewCell")
    }
    //MARK: - allert
    func showAlert(errorMessage: String) {
        let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        let tryAgainAction = UIAlertAction(title: "Try Again", style: .default) { (_) in
            self.loadData()
            self.postTableView.reloadData()
            self.stopLoading()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            // need to implement how to show initial values after cancel. Idea to load from SwiftData
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
        }
        
        alertController.addAction(tryAgainAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - CoreData
    private func savePosts(posts: [Posts]) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "PostsCoreData", in: managedContext) else { return  }
        
        for post in posts {
//            let item = PostsCoreData(context: managedContext)
            let item = PostsCoreData(entity: entity, insertInto: managedContext)
            item.id = Int64(post.id)
            item.userId = Int64(post.userId)
            item.title = post.title
            item.body = post.body
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
        do {
            try managedContext.save()
            dismiss(animated: true)
        } catch {
            print(error.localizedDescription)
        }
    }
    //MARK: - Load From CoreData
        func fetchPosts() {
            let request: NSFetchRequest<PostsCoreData> = PostsCoreData.fetchRequest()
            
            do {
                let savedPosts = try managedContext?.fetch(request)
                guard let body = savedPosts?.last?.body,
                      let id = savedPosts?.last?.id,
                      let title = savedPosts?.last?.title,
                      let userId = savedPosts?.last?.userId
                else { return }
                postTableViewCell.bodyTableViewCellLabel.text = body
                postTableViewCell.nameTableViewCellLabel.text = ("\(id)")
                postTableViewCell.statusTableViewCellLabel.text = title
                postTableViewCell.loadTableViewCellLabel.text = ("\(userId)")
            }
            catch {
                print(error.localizedDescription)
            }
        }
    
    //MARK: - Load from API
    func loadData() {
        startLoading()
        let url = EndPoints.endpoint
        Networking<[Posts]>.loadData(urlString: url, completion: { result in
            DispatchQueue.main.async {
                do {
                    switch result {
                    case .success(let allData):
                        self.savePosts(posts: allData)
                        self.postTableView.reloadData()
                        self.stopLoading()
                    case .failure(let apiError):
                        self.showAlert(errorMessage: apiError.localizedDescription)
                    }
                }
            }
        })
    }
}
//MARK: - Extensions
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(posts.count)
        return posts.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath)
        if let cell = cell as? PostTableViewCell {
            cell.setupText(userId: "userId: \(posts[indexPath.row].userId)",
                           id: "id: \(posts[indexPath.row].id)",
                           title: "title: \(posts[indexPath.row].title )",
                           body: "\(posts[indexPath.row].body)")
            return cell
        } else {
            return cell
        }
        
    }
}
