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
        refreshControl.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
        postTableView.addSubview(refreshControl)
        self.coreDataExtension.fetchPosts()
        self.coreDataExtension.fetchUserDetails()
        self.stopLoading()
        //data base place:
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    private func setupTableView() {
        postTableView?.dataSource = self
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        postTableView.register(nib, forCellReuseIdentifier: "PostTableViewCell")
    }
    
    @objc func handleRefreshControl() {
            self.loadPostsData()
            self.postTableView.reloadData()
            self.stopLoading()
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.refreshControl.endRefreshing()
            self.refreshControl.endRefreshing()
        }
    }
    
    //MARK: - Alert
    func showAlert(errorMessage: String) {
        let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        let tryAgainAction = UIAlertAction(title: "Try Again", style: .default) { (_) in
            self.loadPostsData()
            self.stopLoading()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            self.coreDataExtension.fetchPosts()
            self.coreDataExtension.fetchUserDetails()
            DispatchQueue.main.async() {
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
        return coreDataExtension.userDetails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell", for: indexPath)
        if let cell = cell as? PostTableViewCell {
            cell.setupTextPosts(title: "Title: \(coreDataExtension.posts[indexPath.row].title ?? "No Tittle")")
            cell.setupTextUsers(name: "Name: \(coreDataExtension.userDetails[indexPath.row].name ?? "No Name")")
            return cell
        } else {
            return cell
        }
    }
}
