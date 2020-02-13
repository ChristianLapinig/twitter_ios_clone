//
//  HomeTableViewController.swift
//  Twitter
//
//  Created by Christian Lapinig on 2/12/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    var tweets = [NSDictionary]()
    var numberOfTweets: Int!
    
    let tweetsRefreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getTweets()
        
        tweetsRefreshControl.addTarget(self, action: #selector(getTweets), for: .valueChanged)
        tableView.refreshControl = tweetsRefreshControl
    }
    
    // Get tweets
    @objc func getTweets() {
        let url = "https://api.twitter.com/1.1/statuses/home_timeline.json"
        let params = ["count": 10]
        
        TwitterAPICaller.client?.getDictionariesRequest(url: url, parameters: params, success: { (tweets: [NSDictionary]) in
            // Clean tweets to prevent duplicates being appended
            self.tweets.removeAll()
            
            for tweet in tweets {
                self.tweets.append(tweet)
            }
            
            self.tableView.reloadData()
            self.tweetsRefreshControl.endRefreshing()
        }, failure: { (Error) in
            print("Could not retreive tweets! Sorry for the inconvenience.")
        })
    }
    
    @IBAction func onLogout(_ sender: Any) {
        TwitterAPICaller.client?.logout()
        
        // Bring user back to login page
        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as! TweetCell
        let tweet = tweets[indexPath.row]
        let user = tweet["user"] as! NSDictionary
        let handle = user["screen_name"] as! String
        let imageUrl = URL(string: (user["profile_image_url_https"] as? String)!)
        let data = try? Data(contentsOf: imageUrl!)
        
        if let imageData = data {
            cell.profileImageView.image = UIImage(data: imageData)
        }
        
        cell.handleLabel.text = handle
        cell.tweetContent.text = tweet["text"] as! String
        
        return cell
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
}
