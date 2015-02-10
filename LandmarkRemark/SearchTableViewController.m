//
//  SearchTableViewController.m
//  LandmarkRemark
//
//  Created by Sasha Reid on 10/02/2015.
//  Copyright (c) 2015 raredynamics. All rights reserved.
//

#import "SearchTableViewController.h"
#import "NoteDetailViewController.h"


@interface SearchTableViewController () {
    NSMutableArray * searchResults; // Stores the PFObjects returned from Search
    PFObject * selectedNote; // Temporary storage of selected note to assist with prepareForSegue
}

@end


@implementation SearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Set the title
    self.title = @"Search";
    
    // Initialise the variables
    searchResults = [NSMutableArray array];
    
    //Quick hack to prevent empty rows from showing in the footer. Cleans this up a little
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Assign self to the delegates
    self.searchBar.delegate = self;
    
    // Show the keyboard so the user can start typing straight away
    [self.searchBar becomeFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Search Bar Delegate Methods


-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    
    // If the editing ends, reset the query and hide the keyboard
    [searchBar resignFirstResponder];
    searchBar.text = @"";
}


- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    
    // If the editing ends, reset the query and hide the keyboard
    [searchBar resignFirstResponder];
    searchBar.text = @"";
}



- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    // The search button was clicked. The code below performs the search on parse and returns the results
    // The query is an OR query as we're searching for both Username and Note Text
    
    // Create a query to search note text for the search string
    PFQuery * searchTextQuery = [PFQuery queryWithClassName:noteClassKey];
    [searchTextQuery whereKey:noteTextKey containsString:searchBar.text];
    
    // Create a query to search username for the search string
    PFQuery * searchUsernameQuery = [PFQuery queryWithClassName:noteClassKey];
    [searchUsernameQuery whereKey:noteOwnerUsernameKey containsString:searchBar.text];
    
    // Combine the two queries to perform an OR search on the Notes table
    PFQuery * combinedQuery = [PFQuery orQueryWithSubqueries:@[searchTextQuery,searchUsernameQuery]];
    [combinedQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (objects.count > 0) {
            
            // At least 1 search result exists. Show it to the user in the table
            // As we're updating the from a block, I need to grab the main queue
            dispatch_async(dispatch_get_main_queue(), ^{
                searchResults = (NSMutableArray *) objects;
                [self.tableView reloadData];
            });
        }
        else {
            
            // No results returned. Show an alert to the user and tell them to search again
            NSString * alertTitle = @"No Results";
            NSString * alertMessage = @"No items were found for the supplied search query.";
            
            // Create the alert
            UIAlertController *alertController = [UIAlertController
                                                  alertControllerWithTitle:alertTitle
                                                  message:alertMessage
                                                  preferredStyle:UIAlertControllerStyleAlert];
            
            // Create the OK button that hides the alert when clicked
            UIAlertAction *okAction = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                       }];
            
            // Add the button to the alert
            [alertController addAction:okAction];
            
            // Show the alert
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
}









#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    //There will only ever be 1 section. Setting this to one
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // This returns the number of results found during the search
    return searchResults.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    // Update the table cells with the result information
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        // If the cell doesn't exist, create it first
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"searchCell"];
    }
    
    // Grab the corresponding note (PFObject)
    PFObject * currentNote = [searchResults objectAtIndex:indexPath.row];
    
    // Update the cell with the associated info
    cell.textLabel.text = currentNote[noteTextKey];
    cell.detailTextLabel.text = currentNote[noteOwnerUsernameKey];
    
    return cell;
}



- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // With the cell selected,, grab the selected note and set the local variable for PrepareForSegue
    selectedNote = [searchResults objectAtIndex:indexPath.row];
    
    // Segue to the NoteDetailViewController
    [self performSegueWithIdentifier:@"noteDetailSegue" sender:self];
    
    return indexPath;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Deselect the cell after it's selected so that it doesn't stay highlighted
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}











#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // I need to pass the PFObject to the noteDetailViewController to display.
    // Use the local variable which was updated when the annotation callout was tapped
    
    if ([segue.identifier isEqualToString:@"noteDetailSegue"]) {
        
        // Make sure it's the correct Segue. Then grab the new ViewController and pass the object
        NoteDetailViewController * destination = (NoteDetailViewController *) segue.destinationViewController;
        destination.noteObject = selectedNote;
    }
}





@end
