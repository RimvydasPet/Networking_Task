//
//  ViewController.swift
//  Networking_Homework
//
//  Created by Rimvydas on 2023-09-26.
//

import UIKit

class ViewController: LoadableViewController {
    
    private var posts: [Posts] = []
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
//            self.loadData()
            self.refreshControl.endRefreshing()
            self.loadData()
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
            self.tryAgain()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(tryAgainAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    func loadData() {
        startLoading()
        let url = EndPoints.endpoint
        Networking<[Posts]>.loadData(urlString: url, completion: { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let allData):
                    self.posts = allData
                    DispatchQueue.main.async {
                        self.postTableView.reloadData()
                        self.stopLoading()
                    }
                case .failure(let apiError):
                    self.showAlert(errorMessage: apiError.localizedDescription)
                }
            }
        })
    }
    func tryAgain() {
        loadData()
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
                           title: "title: \(posts[indexPath.row].title)",
                           body: "\(posts[indexPath.row].body)")
            return cell
        } else {
            return cell
        }
        
    }
}
