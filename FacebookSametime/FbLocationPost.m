//
//  FbLocationPost.m
//  FacebookSametime
//
//  Created by Lion User on 09/12/2012.
//  Copyright (c) 2012 B&W. All rights reserved.
//

#import "FbLocationPost.h"

@implementation FbLocationPost

+ (void) getFriendLocations:(id <FbLocationPostDelegate>)_delegate {

    
    NSMutableArray * locList = [[NSMutableArray alloc] init];
    NSMutableDictionary * friendList = [[NSMutableDictionary alloc] init];

    //NSString * searchString = @"me/home?with=location";//@"search?type=checkin";
    NSString * fqlQueryString = @"select id, name from profile where id in (select author_uid from location_post where author_uid in (select uid2 from friend where uid1=me()) limit 100)"; //  and timestamp < 1301043200
    NSDictionary *queryParam =
    [NSDictionary dictionaryWithObjectsAndKeys:fqlQueryString, @"q", nil];
    
    [[[FBRequest alloc] initWithSession:[FBSession activeSession]
                            graphPath:@"/fql"
                            parameters:queryParam
                            HTTPMethod:@"GET"]
     startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
         //NSLog(@"home result: %@", result);
         NSArray *data = [result objectForKey:@"data"];
         //NSLog(@"Query data: %@", data);
         for(NSDictionary *message in data){
             //NSLog(@"Query message: %@", message);;
             NSString *userId = [[message objectForKey:@"id"] stringValue];
             NSString *userName = [message objectForKey:@"name"];
             [friendList setObject:userName forKey:userId];
         }
    }];
    
    fqlQueryString = @"select author_uid, message, latitude, longitude, type, timestamp from location_post where author_uid in (select uid2 from friend where uid1=me()) limit 100";
    queryParam =
    [NSDictionary dictionaryWithObjectsAndKeys:fqlQueryString, @"q", nil];
    
    [[[FBRequest alloc] initWithSession:[FBSession activeSession]
                              graphPath:@"/fql"
                             parameters:queryParam
                             HTTPMethod:@"GET"]
     startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
         //NSLog(@"home result: %@", result);
         NSArray *data = [result objectForKey:@"data"];
         //NSLog(@"Query data: %@", data);
         for(NSDictionary *entry in data){
             //NSLog(@"Query message: %@", entry);;
             NSString *userId = [[entry objectForKey:@"author_uid"] stringValue];
             NSString *userName = [friendList objectForKey:userId];
             NSString *message = [entry objectForKey:@"message"];
             CLLocationCoordinate2D zoomCoord;
             zoomCoord.latitude = [[entry objectForKey:@"latitude"] doubleValue];
             zoomCoord.longitude = [[entry objectForKey:@"longitude"] doubleValue];
             NSString * city = [entry objectForKey:@"type"];
             
             NSLog(@"User %@ wrote: %@ @ %@,%f,%f", userName,
                   message, city, zoomCoord.latitude, zoomCoord.longitude);
             
             FriendLocation * friendLoc = [[FriendLocation alloc] initWithName:userName city:message coordinate:zoomCoord];
             [locList addObject:friendLoc];
         }
         
         [_delegate locationListReady:locList];
         
     }];

    fqlQueryString = @"select author_uid, message, latitude, longitude, type, timestamp from location_post where author_uid=me() limit 10";
    queryParam =
    [NSDictionary dictionaryWithObjectsAndKeys:fqlQueryString, @"q", nil];
    
    [[[FBRequest alloc] initWithSession:[FBSession activeSession]
                              graphPath:@"/fql"
                             parameters:queryParam
                             HTTPMethod:@"GET"]
     startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
         //NSLog(@"home result: %@", result);
         NSArray *data = [result objectForKey:@"data"];
         NSLog(@"Myself Query data: %@", data);
         for(NSDictionary *entry in data){
             //NSLog(@"Query message: %@", entry);;
             //NSString *userId = [[entry objectForKey:@"author_uid"] stringValue];
             //NSString *userName = [friendList objectForKey:userId];
             NSString *message = [entry objectForKey:@"message"];
             CLLocationCoordinate2D zoomCoord;
             zoomCoord.latitude = [[entry objectForKey:@"latitude"] doubleValue];
             zoomCoord.longitude = [[entry objectForKey:@"longitude"] doubleValue];
             NSString * city = [entry objectForKey:@"type"];
             
             NSLog(@"User myself wrote: %@ @ %@,%f,%f",
                   message, city, zoomCoord.latitude, zoomCoord.longitude);
             
             FriendLocation * friendLoc = [[FriendLocation alloc] initWithName:@"Me" city:message coordinate:zoomCoord];
             [locList addObject:friendLoc];
         }
         
         [_delegate locationListReady:locList];
         
     }];

}

@end
