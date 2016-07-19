//
//  MoviesViewController.swift
//  Flikster
//
//  Created by Karan Khurana on 7/16/16.
//  Copyright © 2016 Karan Khurana. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD


class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var movies = [NSDictionary]()
    var endpoint: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.hidden = true

        self.errorView.hidden = true
        
//        searchBar.delegate = self
        
        // Initialize a UIRefreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)

        tableView.dataSource = self
        tableView.delegate = self
        collectionView!.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        getNowPlaying()
        // Do any additional setup after loading the view.
    }
    
    func getNowPlaying(){
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        
        // Display HUD right before the request is made
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,
             completionHandler: { (dataOrNil, response, error) in
                if error != nil {
                    self.errorLabel.text = "There was a network error. Please try again."
                    self.errorView.hidden = false
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                } else {
                    self.errorView.hidden = true
                    if let data = dataOrNil {
                        if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                            data, options:[]) as? NSDictionary {
                            //                            print("response: \(responseDictionary)")
                            // Hide HUD once the network request comes back (must be done on main UI thread)
                            MBProgressHUD.hideHUDForView(self.view, animated: true)
                            
                            self.movies = responseDictionary["results"] as! [NSDictionary]
                            self.tableView.reloadData()
                            self.collectionView.reloadData()
                        }
                    }
                }
        })
        task.resume()
    }
    
    func refreshControlAction(refreshControl: UIRefreshControl) {
        
        // ... Create the NSURLRequest (myRequest) ...
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        // Configure session so that completion handler is executed on main UI thread
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,
         completionHandler: { (dataOrNil, response, error) in
            if error != nil {
                self.errorLabel.text = "There was a network error. Please try again."
                self.errorView.hidden = false
                refreshControl.endRefreshing()
            } else {
                self.errorView.hidden = true
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                        self.movies = responseDictionary["results"] as! [NSDictionary]
                        self.tableView.reloadData()
                        self.collectionView.reloadData()
                        // Tell the refreshControl to stop spinning
                        refreshControl.endRefreshing()
                    }
                }
            }
        })
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return movies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        
        // No color when the user selects cell
        cell.selectionStyle = .None
        cell.layoutMargins = UIEdgeInsetsZero
        
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let posterbaseURL = "https://image.tmdb.org/t/p/w342"
        
        if let posterPath = movie["poster_path"] as? String {
            let posterURL = NSURL(string: posterbaseURL + posterPath)
            UIView.animateWithDuration(1, animations: {
                cell.posterView.setImageWithURL(posterURL!)

            })
        }
        
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MovieCollectionViewCell", forIndexPath: indexPath) as! MovieCollectionViewCell
        // No color when the user selects cell
        cell.layoutMargins = UIEdgeInsetsZero
        
        let movie = movies[indexPath.item]
//        print("\(movies)")
//        let title = movie["title"] as! String
//        let overview = movie["overview"] as! String
        let posterbaseURL = "https://image.tmdb.org/t/p/w342"
        
        if let posterPath = movie["poster_path"] as? String {
            let posterURL = NSURL(string: posterbaseURL + posterPath)
            UIView.animateWithDuration(1, animations: {
                cell.collectionImageView.setImageWithURL(posterURL!)
                
            })
        }
        
        
        return cell
    }
    

    @IBAction func onTapGrid(sender: AnyObject) {
        if tableView.hidden && !collectionView.hidden{
            tableView.hidden = false
            collectionView.hidden = true
        } else {
            tableView.hidden = true
            collectionView.hidden = false
        }
        
    }
    
//    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
//        self.searchBar.endEditing(true)
//    }
//    
//    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
//        let foundMovies = movies.filter ({ (aMovie) -> Bool in
//            return aMovie.title!.lowercasestring.rangeOfString(searchText.lowercaseString) != nil
//        })
//        print("\(foundMovies)")
//        movies = foundMovies
//        self.tableView.reloadData()
//    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var movie: NSDictionary!
        if ((sender?.isKindOfClass(UITableViewCell)) == true) {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            movie = movies[indexPath!.row]
        } else if ((sender?.isKindOfClass(UICollectionViewCell)) == true) {
            let cell = sender as! UICollectionViewCell
            let indexPath = self.collectionView.indexPathForCell(cell)
            movie = self.movies[indexPath!.row]
        }
        
        
        let detailViewController = segue.destinationViewController as! DetailsViewController
        
        detailViewController.movie = movie
        
        
    }
    

}
