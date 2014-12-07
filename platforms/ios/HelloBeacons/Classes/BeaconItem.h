//
// Created by João Guilherme on 3/31/14.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@protocol BeaconItem
@end

@interface BeaconItem : JSONModel
@property(strong, nonatomic) NSString *uuid;
@property(strong,nonatomic) NSString *distance;
@property(nonatomic) double accuracy;
@property(nonatomic) int major;
@property(nonatomic) int minor;
@end