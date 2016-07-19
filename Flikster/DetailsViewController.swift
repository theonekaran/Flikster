//
//  DetailsViewController.swift
//  Flikster
//
//  Created by Karan Khurana on 7/16/16.
//  Copyright © 2016 Karan Khurana. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, UIScrollViewDelegate {

    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backgroundView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var releasedLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    var movie: NSDictionary!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        
        let title = movie["title"] as? String
        let overview = movie["overview"] as? String
        let defaultReleaseDate = movie["release_date"] as? String
        let rating = movie["vote_average"] as! Double
        
//        navigationItem.title = title
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        //        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        let dateObj = dateFormatter.dateFromString(defaultReleaseDate!)
        
        
        dateFormatter.dateStyle = NSDateFormatterStyle.LongStyle
        
        titleLabel.text = title
        overviewLabel.text = overview
        releasedLabel.text = dateFormatter.stringFromDate(dateObj!)
        ratingLabel.text = String(rating) + "/10"
        
        overviewLabel.sizeToFit()
        
        let posterbaseURL = "https://image.tmdb.org/t/p/w342"
        
        if let posterPath = movie["poster_path"] as? String {
            let posterURL = NSURL(string: posterbaseURL + posterPath)
            backgroundView.setImageWithURL(posterURL!)
        }

        // Do any additional setup after loading the view.
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
