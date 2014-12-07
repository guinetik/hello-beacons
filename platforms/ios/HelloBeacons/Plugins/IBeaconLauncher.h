#import <Cordova/CDVPlugin.h>
#import "Foundation/Foundation.h"
#import "IBeaconManager.h"

@interface IBeaconLauncher : CDVPlugin<IBeaconManagerProtocol> {
}

@property (retain) IBeaconManager *beaconManager;
@property(nonatomic, copy) NSString *callbackId;

- (void) launch:(CDVInvokedUrlCommand*)command;
- (void) stop:(CDVInvokedUrlCommand*)command;

@end