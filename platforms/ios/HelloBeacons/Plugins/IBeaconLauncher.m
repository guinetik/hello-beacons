#import "Cordova/CDV.h"
#import "IBeaconLauncher.h"

@implementation IBeaconLauncher
@synthesize beaconManager;

- (void)launch:(CDVInvokedUrlCommand *)command {
    self.callbackId = command.callbackId;
    if(beaconManager == nil) {
        beaconManager = [[IBeaconManager alloc]
                                         init];
        beaconManager.delegate = self;
        [beaconManager startRanging];
    }
}

- (void)stop:(CDVInvokedUrlCommand *)command {
    self.callbackId = command.callbackId;
    if(beaconManager != nil) {
        [beaconManager stopRanging];
        beaconManager = nil;
    }
}


- (void)display:(NSString *)message {
    NSLog(@"sending message: %@", message);
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK
                                                     messageAsString:message];
    [self.commandDelegate sendPluginResult:pluginResult
                          callbackId:self.callbackId];

}
@end