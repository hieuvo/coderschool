import UIKit
import Foundation
import SwiftyJSON
import KFSwiftImageLoader

var UITableLoadingViewKey = "UITableLoadingViewKey"

public class MovieTableViewDelegateConfiguration {
    public var scrollViewDidScroll: ((scrollView: UIScrollView) -> ())?
}

public class MovieTableView: UITableView {
    
    public var delegateConfiguration = MovieTableViewDelegateConfiguration()
    public var onDidSelectItem: ((item: Any) -> ())?
    
    var movies = [Movie]()
    var filteredMovies = [Movie]()
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.initialize()
    }
    
    public override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        self.initialize()
    }
    
    public func initialize() {
        self.dataSource = self
        self.delegate = self
        self.scrollsToTop = false
    }
    
    public func addData(data: SwiftyJSON.JSON) {
        movies = []

        for (_,subJson):(String, JSON) in data {
            movies.append(Movie(json: subJson))
        }
        
        filteredMovies = movies
    }

    public override func reloadData() {
        super.reloadData()
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    func prepareDataForDetailView(viewControl: MovieDetailViewController, indexPath: NSIndexPath) {
        let movie = filteredMovies[indexPath.row]
        viewControl.movie = movie
    }
    
    func showResultForSearchText(searchText: String) {
        if searchText.isEmpty {
            filteredMovies = movies
        } else {
            filteredMovies = []
            
            for movie in movies {
                if movie.title.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil {
                    filteredMovies.append(movie)
                }
            }
        }

        reloadData()
    }
}

extension MovieTableView: UITableViewDataSource {   
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredMovies.count
    }

    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("movieCell", forIndexPath: indexPath) as! MovieTableViewCell

        cell.movie = filteredMovies[indexPath.row]
        
        return cell
    }
}

extension MovieTableView: UITableViewDelegate {
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // ScrollViewDelegate
    public func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
//        let currentOffset = scrollView.contentOffset.y
//        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
        
//        let threhold = maximumOffset - currentOffset
//        if threhold <= 10 && (shouldLoadMore && !isLoadingMore) {
//            isLoadingMore = true
//            self.onLoadMore?()
//        }
    }
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        self.delegateConfiguration.scrollViewDidScroll?(scrollView: scrollView)
    }
}