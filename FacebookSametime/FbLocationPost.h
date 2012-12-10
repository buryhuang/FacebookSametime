//
//  FbLocationPost.h
//  FacebookSametime
//
//  Created by Lion User on 09/12/2012.
//  Copyright (c) 2012 B&W. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import <MapKit/MapKit.h>
#import "FriendLocation.h"
#import "FbLocationPostDelegate.h"

@interface FbLocationPost : NSObject

+ (void) getFriendLocations:(id <FbLocationPostDelegate>)_delegate;

@end
