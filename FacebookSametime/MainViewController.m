//
//  MainViewController.m
//  FacebookSametime
//
//  Created by Lion User on 03/12/2012.
//  Copyright (c) 2012 B&W. All rights reserved.
//

#import "MainViewController.h"
#import "FriendLocation.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    if (self.fbSession == nil) {
        [self openSession];
        
        if(FBSession.activeSession.isOpen) {
            self.fbSession = FBSession.activeSession;
            [self populateUserDetails];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateCreated:
        case FBSessionStateCreatedTokenLoaded:{
            [session openWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                //handle the updating of views according to the sate of session
                self.fbSessionState = @"Opened";
            }];
            self.fbSessionState = @"Created";
        }
            break;
            
        case FBSessionStateOpen: {
            //            UIViewController *topViewController =
            //            [self.navController topViewController];
            //            if ([[topViewController modalViewController]
            //                 isKindOfClass:[SCLoginViewController class]]) {
            //                [topViewController dismissModalViewControllerAnimated:YES];
            //            }
            self.fbSessionState = @"Opened";
            
            if (FBSession.activeSession.isOpen) {
                NSLog(@"Session opened: Update User detail!");
                [self populateUserDetails];
            }
            
            [[[FBRequest alloc] initWithSession:[FBSession activeSession]
                                      graphPath:@"search?type=checkin" ]
             startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                 //NSLog(@"home result: %@", result);
                 NSArray *data = [result objectForKey:@"data"];
                 for(NSDictionary *message in data){
                     NSDictionary *user = [message objectForKey:@"from"];
                     NSDictionary *place = [message objectForKey:@"place"];
                     NSDictionary *location = [place objectForKey:@"location"];
                     NSLog(@"User %@ wrote: %@ @ %@,%@,%@", [user objectForKey:@"name"],
                           [message objectForKey:@"message"],
                           [location objectForKey:@"city"],
                           [location objectForKey:@"latitude"],
                           [location objectForKey:@"longitude"]);
                 }
             }];
        }
            break;
        case FBSessionStateClosed:
            self.fbSessionState = @"Closed";
            break;
        case FBSessionStateClosedLoginFailed:
            // Once the user has logged in, we want them to
            // be looking at the root view.
            //[self.navController popToRootViewControllerAnimated:NO];
            
            [FBSession.activeSession closeAndClearTokenInformation];
            
            //[self showLoginView];
            
            self.fbSessionState = @"ClosedLoginFailed";
            break;
        default:
            self.fbSessionState = @"Default state";
            break;
    }
    
    //    [self.tableView beginUpdates];
    //    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    //    [self.tableView endUpdates];
    self.fbSession = session;
    
    NSLog(@"Stat changed: %@",self.fbSessionState);
    
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
    
    
}

- (void)openSession
{
    //self.fbSessionState = @"not connected";
    
    NSArray *permissions = [[NSArray alloc] initWithObjects:
                            @"email",
                            @"user_likes",
                            @"read_stream",
                            @"friends_status",
                            @"user_status",
                            nil];
    
    [FBSession openActiveSessionWithReadPermissions:permissions
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session,
       FBSessionState state, NSError *error) {
         [self sessionStateChanged:session state:state error:error];
     }];
    
    [self populateUserDetails];
    
}

- (void)populateUserDetails
{
    if (FBSession.activeSession.isOpen) {
        FBRequest *me = [FBRequest requestForMe];
        [me startWithCompletionHandler:^(FBRequestConnection *connection,
                                         id result,
                                         NSError *error) {
            NSDictionary<FBGraphUser> *my = (NSDictionary<FBGraphUser> *) result;
            NSLog(@"My dictionary: %@", my.first_name);
            //self.barUserItem.title =  my.first_name;
            self.title = my.first_name;
        }];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"Will Appear!");
    
    if (self.fbSession == nil) {
        [self openSession];
        
        if(FBSession.activeSession.isOpen) {
            self.fbSession = FBSession.activeSession;
            [self populateUserDetails];
        }
    }

    // 1
    __block CLLocationCoordinate2D zoomLocation;

    [[[FBRequest alloc] initWithSession:[FBSession activeSession]
                              graphPath:@"search?type=checkin" ]
     startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
         //NSLog(@"home result: %@", result);
         NSArray *data = [result objectForKey:@"data"];
         for(NSDictionary *message in data){
             NSDictionary *user = [message objectForKey:@"from"];
             NSDictionary *place = [message objectForKey:@"place"];
             NSDictionary *location = [place objectForKey:@"location"];
             NSLog(@"User %@ wrote: %@ @ %@,%@,%@", [user objectForKey:@"name"],
                   [message objectForKey:@"message"],
                   [location objectForKey:@"city"],
                   [location objectForKey:@"latitude"],
                   [location objectForKey:@"longitude"]);
             
             zoomLocation.latitude = [[location objectForKey:@"latitude"] doubleValue];
             zoomLocation.longitude = [[location objectForKey:@"longitude"] doubleValue];
             NSString * userName = [user objectForKey:@"name"];

             FriendLocation *annotation = [[FriendLocation alloc] initWithName:userName city:[location objectForKey:@"city"] coordinate:zoomLocation] ;
             [_mapView addAnnotation:annotation];
         }
         //zoomLocation.latitude = 39.281516;
         //zoomLocation.longitude= -76.580806;
         // 2
         MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
         // 3
         MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
         // 4
         [_mapView setRegion:adjustedRegion animated:YES];
     }];


}


@end
