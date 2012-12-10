//
//  FbLocationPost.m
//  FacebookSametime
//
//  Created by Lion User on 09/12/2012.
//  Copyright (c) 2012 B&W. All rights reserved.
//

#import "FbLocationPost.h"

@implementation FbLocationPost

+ (void) getFriendLocations:(MainViewController *)_view {

    
    NSMutableArray * locList = [[NSMutableArray alloc] init];

    NSString * searchString = @"me/home?with=location";//@"search?type=checkin";
    
    [[[FBRequest alloc] initWithSession:[FBSession activeSession]
                              graphPath:searchString ]
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

             CLLocationCoordinate2D zoomCoord;
             zoomCoord.latitude = [[location objectForKey:@"latitude"] doubleValue];
             zoomCoord.longitude = [[location objectForKey:@"longitude"] doubleValue];
             NSString * userName = [user objectForKey:@"name"];
             NSString * city = [location objectForKey:@"city"];
             
             FriendLocation * friendLoc = [[FriendLocation alloc] initWithName:userName city:city coordinate:zoomCoord];
             [locList addObject:friendLoc];
         }
         
         [_view populateFriendsLocations:locList:locList];

    }];
}

@end
