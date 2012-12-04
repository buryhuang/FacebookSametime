//
//  MainViewController.h
//  FacebookSametime
//
//  Created by Lion User on 03/12/2012.
//  Copyright (c) 2012 B&W. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface MainViewController : UIViewController

- (void) sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;
- (void) openSession;

- (void)viewWillAppear:(BOOL)animated;
- (void)populateUserDetails;

@property (nonatomic, retain) FBSession * fbSession;
@property (nonatomic, retain) NSString * fbSessionState;

@property (nonatomic, retain) IBOutlet UIBarButtonItem * barUserItem;

@end
