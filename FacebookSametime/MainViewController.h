//
//  MainViewController.h
//  FacebookSametime
//
//  Created by Lion User on 03/12/2012.
//  Copyright (c) 2012 B&W. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <MapKit/MapKit.h>

#define METERS_PER_MILE 1609.344


@interface MainViewController : UIViewController<MKMapViewDelegate>

- (void) sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;
- (void) openSession;

- (void)viewWillAppear:(BOOL)animated;
- (void)populateUserDetails;

@property (nonatomic, retain) FBSession * fbSession;
@property (nonatomic, retain) NSString * fbSessionState;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
