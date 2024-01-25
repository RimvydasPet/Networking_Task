//
//  ViewController.swift
//  Networking_Homework
//
//  Created by Rimvydas on 2023-09-26.
//

import UIKit

class ViewController: LoadableViewController {
    
    //    class PostsViewController
    
    private var posts: [Posts] = []
    
    @IBOutlet weak var postTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        loadData()
    }
    
    private func setupTableView() {
        postTableView?.dataSource = self
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        postTableView?.register(nib, forCellReuseIdentifier: "PostTableViewCell")
    }
    
    private func loadData() {
        startLoading()
        let url = EndPoints.endpoint
        Networking<[Posts]>.loadData(urlString: url, completion: { result in
            switch result {
            case .success(let allData):
                self.posts = allData
                DispatchQueue.main.async {
                    self.postTableView.reloadData()
                    self.stopLoading()
                }
            case .failure(let apiError):
                print(apiError.localizedDescription)
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
                           title: "title: \(posts[indexPath.row].title)",
                           body: "\(posts[indexPath.row].body)")
            return cell
        } else {
            return cell
        }
        
    }
}
