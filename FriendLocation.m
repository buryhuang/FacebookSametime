//
//  FriendLocation.m
//  FacebookSametime
//
//  Created by Lion User on 08/12/2012.
//  Copyright (c) 2012 B&W. All rights reserved.
//

#import "FriendLocation.h"

@implementation FriendLocation

@synthesize name = _name;
@synthesize city = _address;
@synthesize coordinate = _coordinate;

- (id)initWithName:(NSString*)name city:(NSString*)city coordinate:(CLLocationCoordinate2D)coordinate {
    if ((self = [super init])) {
        _name = [name copy];
        _city = [city copy];
        _coordinate = coordinate;
    }
    return self;
}

- (NSString *)title {
    if ([_name isKindOfClass:[NSNull class]])
        return @"Unknown charge";
    else
        return _name;
}

- (NSString *)subtitle {
    return _city;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    
}

@end
