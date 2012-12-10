//
//  FbLocationPostDelegate.h
//  FacebookSametime
//
//  Created by Lion User on 09/12/2012.
//  Copyright (c) 2012 B&W. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FbLocationPostDelegate <NSObject>

@required
- (void) locationListReady:(NSMutableArray *)_locList;

@end
