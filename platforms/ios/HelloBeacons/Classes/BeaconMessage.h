//
// Created by João Guilherme on 3/31/14.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "BeaconItem.h"

#define MESSAGE_STOP_RANGING            @"RANGE_STOP"

#define MESSAGE_ENTER_REGION            @"REGION_ENTER"
#define MESSAGE_EXIT_REGION             @"REGION_EXIT"
#define MESSAGE_REGION_INSIDE           @"REGION_INSIDE"
#define MESSAGE_REGION_OUTSIDE          @"REGION_OUTSIDE"

#define MESSAGE_START_MONITORING        @"START_MONITORING"

#define MESSAGE_BEACONS_UNKNOWN         @"BEACONS_UNKNOWN"
#define MESSAGE_BEACONS_IMMEDIATE       @"BEACONS_IMMEDIATE"
#define MESSAGE_BEACONS_NEAR            @"BEACONS_NEAR"
#define MESSAGE_BEACONS_FAR             @"BEACONS_FAR"

@interface BeaconMessage : JSONModel
@property(strong, nonatomic) NSString *message;
@property(strong, nonatomic) NSArray<BeaconItem>  *beacons;
@end