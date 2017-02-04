//
//  SearchUsersViewController.swift
//  NotifyMe
//
//  Created by Pierre on 1/31/17.
//  Copyright © 2017 Pierre. All rights reserved.
//

import UIKit

class SearchUsersViewController: UIViewController {

    //MARK: Properties
    var allUsers: [User]?
    var selectedUsersForNote: [User] = []

    var filteredUsernames: [String]?
    var searchResults: [String] = []
    
    
    //MARK: Further UI
    var searchController: UISearchController!
    
    let menuButton = UIButton(type: .custom)
    
    
    //MARK: IBOutlets
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var searchPlaceholder: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var addUsersButton: UIButton!
    
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        guard let allusers = allUsers else { return }
//        
//        for username in allusers {
//            filteredUsernames?.append(username.username)
//        }
        
        searchBar.showsCancelButton = false
    	
        menuButton.setImage(#imageLiteral(resourceName: "more_button"), for: .normal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: menuButton)
        
        menuButton.layer.transform = CATransform3DTranslate(CATransform3DIdentity, +self.view.frame.width, 0, 0)

        addUsersButton.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, +self.view.frame.height, 0)

        
        collectionView.allowsMultipleSelection = true
        
        setupSearchController()
        
        
        getAllUsers { (users) in
            if let users = users {
                self.allUsers = users.filter{ $0.identifier != UserController.sharedController.currentUser.identifier }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            } else {
                self.allUsers = []
            }
        }
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

    }
    
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let createNoteViewController = segue.destination as? CreateNoteViewController
        
        if segue.identifier == "toCreateNoteView" {
            createNoteViewController?.selectedUsersForNote = self.selectedUsersForNote
        }
    }
    
    
    //MARK: Builder Functions
    func getAllUsers(completion: @escaping (_ users: [User]?) -> Void) {
        UserController.fetchAllUsers { (users) in
            completion(users)
        }
    }

}

extension SearchUsersViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    //MARK: Search Result Updating
    func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchResultsUpdater = self
        
    	automaticallyAdjustsScrollViewInsets = false
        definesPresentationContext = true
        
		searchController.searchBar.delegate = self
        searchController.searchBar.keyboardAppearance = .dark
        searchController.searchBar.barTintColor = .purpleThemeColor()
        
    	providesPresentationContextTransitionStyle = true
        
        //searchController.searchBar.sizeToFit()
        //searchPlaceholder.addSubview(searchController.searchBar)
        //searchController.obscuresBackgroundDuringPresentation = true
        //searchController.dimsBackgroundDuringPresentation = true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
    	//blurEffectView.removeFromSuperview()
        //let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchTerm)
        
        //       guard let searchTerm = searchController.searchBar.text?.lowercased() else { return }
        //
        //       filteredUsernames = allUsers?.filter({ (users) -> Bool in
        //            let userString: NSString = users as NSString
        //
        //            return (userString.range(of: searchTerm, options: .caseInsensitive).location) != NSNotFound
        //       })
        
        //    func updateSearchResults(for searchController: UISearchController) {
        //        guard let searchString = searchController.searchBar.text else {
        //            return
        //        }
        //
        //        filteredArray = dataArray.filter({ (country) -> Bool in
        //            let countryText:NSString = country as NSString
        //
        //            return (countryText.range(of: searchString, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
        //        })
        //
        //        tblSearchResults.reloadData()
        //    }
    }
    

    
    
    //MARK: Search Bar Delegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
    	searchBar.showsCancelButton = true
    }
    
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        searchBar.showsCancelButton = true
//        
//        if !searchText.isEmpty {
//            filterContentForSearchText()
//            
//            collectionView.reloadData()
//        }
//    }
    
    func filterContentForSearchText() {
        filteredUsernames?.removeAll(keepingCapacity: false)
        
        guard let allusers = allUsers else { return }
        
        for username in allusers {
            let searchTerm = username.username
            
            guard let input = searchBar.text else { return }
            
            if searchTerm.localizedCaseInsensitiveContains(input) {
                searchResults.append(username.username)
            }
        }
    }
    
}

extension SearchUsersViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let allUsers = allUsers {
            return allUsers.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userCell", for: indexPath) as! SearchUserCollectionViewCell
        
        if let users = allUsers {
            let user = users[indexPath.item]
            
            cell.updateUser(user: user)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        menuButton.layer.transform = CATransform3DIdentity
        
        let cell = collectionView.cellForItem(at: indexPath) as! SearchUserCollectionViewCell
        cell.backgroundHighlightView.backgroundColor = .purpleThemeColor()
        
        
        if let users = allUsers {
        	let user = users[indexPath.item]
            selectedUsersForNote.append(user)
        }
        
        if selectedUsersForNote.count > 0 {
            UIView.animate(withDuration: 0.2, animations: {
                self.addUsersButton.layer.transform = CATransform3DIdentity
            })
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! SearchUserCollectionViewCell
        cell.backgroundHighlightView?.backgroundColor = nil
        
        selectedUsersForNote.removeLast()
        
        if selectedUsersForNote.count == 0 {
            UIView.animate(withDuration: 0.4, animations: {
                self.addUsersButton.layer.transform = CATransform3DTranslate(CATransform3DIdentity, 0, +self.view.frame.height, 0)
            })
        }
    }

}

extension SearchUsersViewController {
    
    //MARK: Report User Alert Controller
    func reportUserAlertController() {
        let reportActionSheet = UIAlertController(title: "Report", message: "", preferredStyle: .actionSheet)
        
        let reportAction = UIAlertAction(title: "Report Users", style: .default) { (alert) in
            for user in self.selectedUsersForNote {
                ReportController.reportUser(user)
            }
        }
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        
        reportActionSheet.addAction(reportAction)
        reportActionSheet.addAction(cancelAction)
        
        present(reportActionSheet, animated: true, completion: nil)
    }

}




//lazy var blurEffectView = UIVisualEffectView()

//    func backgroundBlurCollectionView() {
//    	let blurEffect = UIBlurEffect(style: .dark)
//
//        blurEffectView.effect = blurEffect
//        blurEffectView.frame = self.view.bounds
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//
//        collectionView.addSubview(blurEffectView)
//    }

//////////////////////////////////////////////////////////////////////////////

//func searchBarCancelButtonClicked(searchBar: UISearchBar!) {
//    searchBar.text = nil
//    searchBar.showsCancelButton = false
//    searchBar.resignFirstResponder()
//    isSearchOn = false
//    self.collectionView.reloadData()
//}

//func searchBar(searchBar: UISearchBar!, textDidChange searchText: String!) {
//    searchBar.showsCancelButton = true
//    if !searchText.isEmpty {
//        isSearchOn = true
//        self.filterContentForSearchText()
//        self.collectionView.reloadData()
//    }
//}

//func filterContentForSearchText() {
//    // Remove all elements from the searchResults array
//    searchResults.removeAll(keepCapacity: false)
//    
//    // Loop throught the collection view's dataSource object
//    for imageFileName in imageFileNames {
//        let stringToLookFor = imageFileName as NSString
//        let sourceString = searchBar.text as NSString
//        
//        if stringToLookFor.localizedCaseInsensitiveContainsString(sourceString) {
//            searchResults.append(imageFileName)
//        }
//    }
//}

//func collectionViewBackgroundTapped() {
//    // Dismiss the keyboard that's shown on the device's screen
//    searchBar.resignFirstResponder()
//}

// This function allow the default tap gesture added to the collection view cell,
// an the collection view's background to to work simultaneously

//func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOfGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//    // Perform default tap gesture
//    return true
//}


//import UIKit
//
//let reuseIdentifier = "Cell"
//
//class MasterViewController: UIViewController, UISearchBarDelegate, UIGestureRecognizerDelegate {
//    
//    @IBOutlet weak var editButton: UIBarButtonItem!
//    @IBOutlet weak var searchBar: UISearchBar!
//    @IBOutlet weak var collectionView: UICollectionView!

//    var icon: PhotoCell!
//    var imageFileNames = [String]()
//    var selectedPhotoName = String()
//    var isSearchOn = false
//    var searchResults = [String]()

//    override func viewDidLoad() {
//        super.viewDidLoad()

//        // Set the collection view's backgroundcolor to display an image
//        self.collectionView!.backgroundColor = UIColor(patternImage: UIImage(named: "purty_wood")!)
//        
//        // Register the  class with the collection view
//        self.collectionView!.registerClass(PhotoCell.self, forCellWithReuseIdentifier: reuseIdentifier)
//        
//        // Add objects in the collection view dataSource, imageFileNames Array
//        loadImages()
//        
//        //1. Create a tap gesture recognizer object
//        let tapRecognizer = UITapGestureRecognizer()
//        tapRecognizer.numberOfTapsRequired = 2
//        
//        //2. Set the target function for the tap gesture recognizer object
//        tapRecognizer.addTarget(self, action: "collectionViewBackgroundTapped")
//        
//        //3. Add the tap gesture recognizer to the collection view
//        self.collectionView.addGestureRecognizer(tapRecognizer)
//    }
//    
//    
//    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        // Return the number of items in the section
//        // Return the number of items in a section (number of photos in an album)
//        if isSearchOn == true && !searchResults.isEmpty {
//            return searchResults.count
//        } else {
//            return imageFileNames.count
//        }
//    }
//    
//    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//        // Initialize the reusable Collection View Cell with our custom class
//        icon = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as PhotoCell
//        var photoName = String()
//        
//        // Initialize the photoName variable with an item in the searchResults array or an item in the imageFileNames array
//        if isSearchOn == true && !searchResults.isEmpty {
//            photoName = searchResults[indexPath.item]
//        } else {
//            photoName = imageFileNames[indexPath.item]
//        }
//        
//        // Configure the collection view cell
//        icon.imageView.image = UIImage(named: photoName)
//        var stringArray: Array = photoName.componentsSeparatedByString(".")
//        icon.caption.text = stringArray[0]
//        
//        // Return the cell
//        return icon
//    }
//    
//    
//    // MARK: UICollectionViewDelegate
//    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        // Put the selected collection view cell's photo file name in a variable
//        if isSearchOn == true && !searchResults.isEmpty {
//            selectedPhotoName = searchResults[indexPath.row] as String
//        } else {
//            selectedPhotoName = imageFileNames[indexPath.row] as String
//        }
//        
//        // Pass control to the PhotoDetailViewController
//        self.performSegueWithIdentifier("photoDetail", sender:self)
//    }
//    
//    import UIKit
//    
//    class PhotoCell: UICollectionViewCell {
//        // The collection view cell's objects
//        var imageView: UIImageView!
//        var caption: UILabel!
//        
//        required init(coder aDecoder: NSCoder) {
//            super.init(coder: aDecoder)
//        }
//        
//        override init(frame: CGRect) {
//            super.init(frame: frame)
//            
//            // Create an ImageView and add it to the collection view
//            imageView = UIImageView(frame: CGRect(x:30, y:12, width:55, height:55))
//            imageView.contentMode = UIViewContentMode.ScaleAspectFill
//            contentView.addSubview(imageView)
//            
//            // Create a Label view and add it to the collection view
//            let textFrame = CGRect(x:5, y:67, width:100, height:35)
//            caption = UILabel(frame: textFrame)
//            caption.font = UIFont.systemFontOfSize(14.0)
//            caption.textAlignment = .Center
//            caption.numberOfLines = 2
//            caption.lineBreakMode = NSLineBreakMode.ByWordWrapping
//            caption.textColor = UIColor.whiteColor()
//            caption.backgroundColor = UIColor.blackColor()
//            contentView.addSubview(caption)
//        }
//}
