//
//  ViewController.swift
//  Networking_Homework
//
//  Created by Rimvydas on 2023-09-26.
//

import UIKit
import CoreData

class ViewController: LoadableViewController {
    
    let postTableViewCell = PostTableViewCell()
    var coreDataExtension = CoreDataExtension()
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
        self.coreDataExtension.fetchPosts()
        self.stopLoading()
        //        data base place:
        //        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    @objc func handleRefreshControl(_ send: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.loadData()
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
            self.coreDataExtension.fetchUserDetails()
            self.coreDataExtension.fetchPosts()
            self.stopLoading()
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
            }
        }
        
        alertController.addAction(tryAgainAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - Load from API
    func loadData() {
        startLoading()
        let url = EndPoints.postsEndpoint
        Networking<[Posts]>.loadData(urlString: url, completion: { result in
            DispatchQueue.main.async {
                do {
                    switch result {
                    case .success(let allData):
                        self.coreDataExtension.savePosts(posts: allData)
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
        return coreDataExtension.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath)
        if let cell = cell as? PostTableViewCell {
            cell.setupTextPosts(userId: "userId: \(coreDataExtension.posts[indexPath.row].userId)",
                                id: "id: \(coreDataExtension.posts[indexPath.row].id)",
                                title: "title: \(coreDataExtension.posts[indexPath.row].title ?? "No tittle"))",
                                body: "\(coreDataExtension.posts[indexPath.row].body ?? "No body"))")
            return cell
        } else {
            return cell
        }
    }
}
