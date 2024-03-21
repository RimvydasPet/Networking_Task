//
//  ViewController.swift
//  Networking_Homework
//
//  Created by Rimvydas on 2023-09-26.
//

import UIKit
import CoreData

class ViewController: LoadableViewController {
    
    var posts: [PostsCoreData] = []
    let postTableViewCell = PostTableViewCell()
    var refreshControl = UIRefreshControl()
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var postTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        context = appDelegate.persistentContainer.viewContext
        setupTableView()
        refreshControl.addTarget(self, action: #selector(handleRefreshControl), for: UIControl.Event.valueChanged)
        postTableView.addSubview(refreshControl)
//        self.loadData()
        self.fetchPosts()
        self.stopLoading()
        //data base place
        // print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }
    
    @objc func handleRefreshControl(_ send: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.loadData()
//            self.fetchPosts()
            self.stopLoading()
            
            self.postTableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    private func setupTableView() {
        postTableView?.dataSource = self
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        postTableView.register(nib, forCellReuseIdentifier: "PostTableViewCell")
    }
    
    //MARK: - Alert
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
    
    //MARK: - Save to CoreData
    private func savePosts(posts: [Posts]) {
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
    //MARK: - Load From CoreData
    func fetchPosts() {
        let request: NSFetchRequest<PostsCoreData> = PostsCoreData.fetchRequest()
        
        do {
            posts = try context.fetch(request)
            guard  let userId = posts.last?.userId,
                   let id = posts.last?.id,
                   let title = posts.last?.title,
                   let body = posts.last?.body
            else { return }
            postTableViewCell.loadTableViewCellLabel?.text = "\(userId)"
            postTableViewCell.nameTableViewCellLabel?.text = "\(id)"
            postTableViewCell.statusTableViewCellLabel?.text = title
            postTableViewCell.bodyTableViewCellLabel?.text = body
        } catch {
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
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath)
        if let cell = cell as? PostTableViewCell {
            cell.setupText(userId: "userId: \(posts[indexPath.row].userId)",
                           id: "id: \(posts[indexPath.row].id)",
                           title: "title: \(String(describing: posts[indexPath.row].title) )",
                           body: "\(String(describing: posts[indexPath.row].body))")
            return cell
        } else {
            return cell
        }
        
    }
}
