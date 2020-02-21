//
//  TweetCell.swift
//  Twitter
//
//  Created by Christian Lapinig on 2/13/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var tweetContent: UILabel!
    @IBOutlet weak var favButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    
    // Set properties
    var favorited: Bool = false
    var tweetId: Int = -1
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func setFavorite(_ sender: Any) {
        let toBeFavorited = !favorited
        
        if (toBeFavorited) {
            TwitterAPICaller.client?.favoriteTweet(tweetId: tweetId, success: {
                self.isFavorited(true)
            }, failure: { (Error) in
                print("Could not favorite tweet.")
                print("Error: \(Error)")
            })
        } else {
            TwitterAPICaller.client?.unfavoriteTweet(tweetId: tweetId, success: {
                self.isFavorited(false)
            }, failure: { (Error) in
                print("Could not unfavorite tweet.")
                print("Error: \(Error)")
            })
        }
    }
    
    func isFavorited(_ isFavorited: Bool) {
        favorited = isFavorited
        
        if (favorited) {
            favButton.setImage(UIImage(named: "favorite-tweet"), for: UIControl.State.normal)
        } else {
            favButton.setImage(UIImage(named: "favorite-tweet-empty"), for: UIControl.State.normal)
        }
    }
    
    @IBAction func setRetweet(_ sender: Any) {
        TwitterAPICaller.client?.retweet(tweetId: tweetId, success: {
            self.isRetweeted(true)
        }, failure: { (Error) in
            print("Cannot retweet.")
            print("Error: \(Error)")
        })
    }
    
    func isRetweeted(_ isRetweeted: Bool) {
        if (isRetweeted) {
            retweetButton.setImage(UIImage(named: "Retweet-Green"), for: UIControl.State.normal)
            retweetButton.isEnabled = false
        } else {
            retweetButton.setImage(UIImage(named: "retweet"), for: UIControl.State.normal)
            retweetButton.isEnabled = true
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
