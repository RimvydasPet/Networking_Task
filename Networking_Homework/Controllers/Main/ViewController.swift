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
    
    //For Core Data
    var savedPosts: [PostsCoreData]?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var refreshControl = UIRefreshControl()
    
    @IBOutlet weak var postTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadData()
        refreshControl.addTarget(self, action: #selector(handleRefreshControl), for: UIControl.Event.valueChanged)
        postTableView.addSubview(refreshControl)
        
    }
    
    @objc func handleRefreshControl(_ send: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.loadData()
            //self.postTableView.reloadData()
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
    
    func fetchPosts() {
        let request: NSFetchRequest<PostsCoreData> = PostsCoreData.fetchRequest()
        do {
            self.savedPosts = try context.fetch(PostsCoreData.fetchRequest())
            guard let body = savedPosts?.last?.body,
                  let id = savedPosts?.last?.id,
                  let title = savedPosts?.last?.title,
                  let userId = savedPosts?.last?.userId
            else { return }
//            idLabel.text = shirtId.uuidString
//            nameLabel.text = shirtName
//            ratingValueLabel.text = " \(shirtRating)"
//            imageView.image = UIImage(data: shirtImage)
            DispatchQueue.main.async {
                self.postTableView.reloadData()
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func loadData() {
        startLoading()
        let url = EndPoints.endpoint
        Networking<[Posts]>.loadData(urlString: url, completion: { result in
            DispatchQueue.main.async {
                do {
                    switch result {
                    case .success(let allData):
                        
//                            self.savedPosts = try self.context.fetch(PostsCoreData.fetchRequest())
                            self.posts = allData
                            self.postTableView.reloadData()
                            self.stopLoading()
                        
                        
                       
                        
                    case .failure(let apiError):
                        self.showAlert(errorMessage: apiError.localizedDescription)
                    }
                } catch {
                    // Handle the error here, if needed
                    print("Error: \(error)")
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
                           title: "title: \(posts[indexPath.row].title )",
                           body: "\(posts[indexPath.row].body)")
            return cell
        } else {
            return cell
        }
        
    }
}
