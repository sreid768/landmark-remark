//
//  SearchTableViewController.h
//  LandmarkRemark
//
//  Created by Sasha Reid on 10/02/2015.
//  Copyright (c) 2015 raredynamics. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTableViewController : UITableViewController <UISearchBarDelegate>

// Outlet to the search bar that's referred to in the implementation
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


@end
