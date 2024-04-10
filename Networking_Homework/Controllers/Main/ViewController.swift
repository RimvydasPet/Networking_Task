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
    
    var posts: [Posts] = []
    var users: [Users] = []
    var refreshControl = UIRefreshControl()
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @IBOutlet weak var postTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        context = appDelegate.persistentContainer.viewContext
        refreshControl.addTarget(self, action: #selector(handleRefreshControl), for: UIControl.Event.valueChanged)
        postTableView.addSubview(refreshControl)
        self.coreDataExtension.fetchPosts()
        self.coreDataExtension.fetchUserDetails()
        self.setupTableView()
        DispatchQueue.main.async {
          
            self.postTableView.reloadData()
            self.refreshControl.endRefreshing()
        }
        //data base place:
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    @objc func handleRefreshControl() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.loadPostsData()
            self.stopLoading()
            self.loadUsersData()
            self.stopLoading()
            self.setupTableView()
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
            self.loadPostsData()
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
    func loadPostsData() {
        startLoading()
        let url = EndPoints.postsEndpoint
        Networking<[Posts]>.loadData(urlString: url, completion: { result in
            DispatchQueue.main.async {
                do {
                    switch result {
                    case .success(let allData):
                        self.posts = allData
                        self.coreDataExtension.savePosts(posts: allData)
                    case .failure(let apiError):
                        self.showAlert(errorMessage: apiError.localizedDescription)
                    }
                }
            }
        })
    }
    
    func loadUsersData() {
        startLoading()
        let url = EndPoints.usersEndpoint
        Networking<[Users]>.loadData(urlString: url, completion: { result in
            DispatchQueue.main.async {
                do {
                    switch result {
                    case .success(let allData):
                        self.users = allData
                        self.coreDataExtension.saveUserDetails(userDetails: allData)
                    case .failure(let apiError):
                        self.showAlert(errorMessage: apiError.localizedDescription)
                    }
                }
            }
        })
    }
    //MARK: - End of the class
}

//MARK: - Extensions
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if coreDataExtension.userDetails.count == 0 {
            return users.count
        } else {
            return coreDataExtension.userDetails.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath)
        if let cell = cell as? PostTableViewCell {
            if coreDataExtension.userDetails.count == 0 {
                cell.setupTextUsers(name: "Name: \(users[indexPath.row].name )")
                cell.setupTextPosts(title: "Title: \(posts[indexPath.row].title )")
            } else {
                cell.setupTextUsers(name: "Name: \(coreDataExtension.userDetails[indexPath.row].name ?? "Default name")")
                cell.setupTextPosts(title: "Title: \(coreDataExtension.posts[indexPath.row].title ?? "Default title")")
            }
            return cell
        } else {
            return cell
        }
    }
}
