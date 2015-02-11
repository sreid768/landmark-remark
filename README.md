# Sasha Reid Developer Test
Implement the Landmark Remark specification 

## Approach

I read the entire document and then copied the original set of requirements to a Google Doc. From there I tried to clarify each of the user cases by drawing out the extended impacts of each. You can see this document here: http://bit.ly/16P4fFJ

I then used my notepad to quickly sketch how the interfaces will look. You can see these here http://bit.ly/1DCW24H and here http://bit.ly/1DCW64v. Once I'm happy with those I'd normally create a set of Axure wireframes and a clickable prototype in POP but skipped these due to the time constraints. 

I then drew a quick diagram of the data model showing what tables and values I'd need to send and receive from Parse. Originally I was going to create a "Note" model object to pass data around the app but realised the PFObject would be sufficient. 

Once all that made sense I opened up xcode and created the new project. I started with a single view controller for the map and used local test objects to get the annotations and callouts working. I then added the note detail view controller, Parse connectivity and the ability to add notes via an Alert Controller. All notes were saved against anonymous logins to keep testing the interface fast. 

With enough data in the system I added search using a table view controller. I was going to add a search bar to the map but later decided to move it to separate controller. I wasn't happy with how it felt / looked and decided to keep the UI very clean and functional instead. 

I then did a full test and clean up of the copy, views (adding constraints) and code given that this will take longer once I introduce the login wall. 

After reviewing best practice for how other apps are handing Login / Registration (http://beta.pttrns.com/?scid=17) I confirmed that I was having a single view controller that could tab between both access methods. I wired up the Registration process followed by Login with Parse and made sure it all worked. I then added all of the error handling and the 'switching' animation to instill a good first impression. 

I did another clean up and full test using my iPhone while driving to a friend's for dinner. Once I was happy with it all I uploaded the code to GitHub and wrote the readme. 

## Time

> Recommended Hours: 5 - 12 

> Total Hours: 14 

Once I started the project I knew I was going to go slightly over. Given the app is almost entirely focused on exceptional handling of MKMapView and CLLocationManager and I haven't yet worked on a map based project of this scale, I spent 2 hours reading and practicing these libraries in an iOS8 environment to ensure I had a solid understanding of how it all works. However, with that taken into account I was fairly smack bang on the estimated time to finish the project. 

- [0.5] Reading brief and expanding requirements.
- [0.5] Reviewing best practice interfaces, sketching the app and outlining the data model.
- [2.0] MKMapView and CLLocationManager research and practice.
- [0.5] xcode and environment setup. Adding Parse libraries and dependencies. Adding global constraints files.
- [5.0] Creating the map view, adding pins and connecting with Parse.
- [0.5] Creating the note detail view.
- [2.0] Creating the search view and the associated Parse queries.
- [2.0] Creating the login / registration view, Parse submission and error handing. 
- [1.0] Full testing, clean up and polish.


## Known Issues and Limitations

With more time and less constraints I could have done a bit more with this app but I think it works well as a developer competency test. My current issues are:

- No app icon, loading image or design throughout.
- No loading indicator when logging in or registering. I would normally add something like MBProgressHUD here
- No logout feature. I just need to add [PFUser logOut] and the segue back to the login page
- Doesn't remember you after closing the app. Given the above issue it's the quickest way to go back to the login screen. I would normally just test for [PFUser currentUser].
- Search is case sensitive. By default the parse search is case sensitive and I've just used that. I'd normally save a lower case version of the note in the same Parse object and do the same for the user's search query. 
- No loading indicator when searching. I wouldn't use MBProgressHUD here but some line of text in the view background perhaps. 
- No loading indicator when saving. I wouldn't use MBProgressHUD here but possibly a non-intrusive view that slides in from the bottom of the screen to show success or errors. It would disappear after a few seconds without user action. 



