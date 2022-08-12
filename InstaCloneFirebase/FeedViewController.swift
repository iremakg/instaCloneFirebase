//
//  FeedViewController.swift
//  InstaCloneFirebase
//
//  Created by irem on 5.08.2022.
//

import UIKit

class FeedViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.userEmailLabel.text = "test"
        cell.commentLabel.text = "comment"
        cell.userImageView.image = UIImage(named: "32114")
        cell.likeLabel.text = "0"
        
        return cell
    }

}
