#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <Cordova/CDVPlugin.h>
#import "IBeaconManager.h"

@protocol IBeaconManagerProtocol
- (void)display:(NSString *)message;
@end

@interface IBeaconManager : NSObject <IBeaconManagerProtocol, CLLocationManagerDelegate> {
    CLLocationManager   *_locationManager;
    NSUUID              *_uuid;
    CLBeaconRegion      *region;
}

@property(nonatomic) id <IBeaconManagerProtocol> delegate;

- (void)startRanging;
- (void)stopRanging;
@end

