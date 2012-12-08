//
//  FriendLocation.h
//  FacebookSametime
//
//  Created by Lion User on 08/12/2012.
//  Copyright (c) 2012 B&W. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface FriendLocation : NSObject <MKAnnotation> {
    NSString *_name;
    NSString *_city;
    CLLocationCoordinate2D _coordinate;
}

@property (copy) NSString *name;
@property (copy) NSString *city;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id)initWithName:(NSString*)name city:(NSString*)city coordinate:(CLLocationCoordinate2D)coordinate;

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

@end
