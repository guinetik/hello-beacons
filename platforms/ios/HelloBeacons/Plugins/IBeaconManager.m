#import "IBeaconManager.h"
#import "BeaconMessage.h"

@implementation IBeaconManager
@synthesize delegate;

- (void)startRanging {

    //Check if monitoring is available or not
    if (![CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]) {
        UIAlertView *alert = [[UIAlertView alloc]
                                           initWithTitle:@"Monitoring not available"
                                           message:nil
                                           delegate:nil
                                           cancelButtonTitle:@"Ok"
                                           otherButtonTitles:nil];
        [alert show];
        return;
    }

    if (_locationManager != nil) {
        if (region) {
            region.notifyOnEntry             = YES;
            region.notifyOnExit              = YES;
            region.notifyEntryStateOnDisplay = YES;
            [_locationManager startMonitoringForRegion:region];
            [_locationManager startRangingBeaconsInRegion:region];

        }
        else {
            _uuid            = [[NSUUID alloc]
                                        initWithUUIDString:@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"];
            _locationManager = [[CLLocationManager alloc]
                                                   init];
            _locationManager.delegate = self;
            region = [[CLBeaconRegion alloc]
                                      initWithProximityUUID:_uuid
                                      identifier:@"com.ogv.ios.hellobeacons"];
            if (region) {
                region.notifyOnEntry             = YES;
                region.notifyOnExit              = YES;
                region.notifyEntryStateOnDisplay = YES;
                [_locationManager startMonitoringForRegion:region];
                [_locationManager startRangingBeaconsInRegion:region];

            }
        }
    }
    else {
        _uuid            = [[NSUUID alloc]
                                    initWithUUIDString:@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"];
        _locationManager = [[CLLocationManager alloc]
                                               init];
        _locationManager.delegate = self;
        region = [[CLBeaconRegion alloc]
                                  initWithProximityUUID:_uuid
                                  identifier:@"com.ogv.ios.hellobeacons"];
        if (region) {
            region.notifyOnEntry             = YES;
            region.notifyOnExit              = YES;
            region.notifyEntryStateOnDisplay = YES;
            [_locationManager startMonitoringForRegion:region];
            [_locationManager startRangingBeaconsInRegion:region];

        }
    }
}


- (void)stopRanging {
    [_locationManager stopRangingBeaconsInRegion:region];
    [_locationManager stopMonitoringForRegion:region];

    BeaconMessage *msg = [[BeaconMessage alloc]
                                         init];
    msg.message = MESSAGE_STOP_RANGING;
    [delegate display:msg.toJSONString];
}

- (void)locationManager:(CLLocationManager *)manager
        didEnterRegion:(CLRegion *)region {
    NSLog(@"Enter Region  @", region);
    [_locationManager startRangingBeaconsInRegion:region];
    BeaconMessage *msg = [[BeaconMessage alloc]
                                         init];
    msg.message = MESSAGE_ENTER_REGION;
    [delegate display:msg.toJSONString];
}

- (void)locationManager:(CLLocationManager *)manager
        didExitRegion:(CLRegion *)region {
    NSLog(@"Exit Region  %@", region);
    [_locationManager stopRangingBeaconsInRegion:region];
    BeaconMessage *msg = [[BeaconMessage alloc]
                                         init];
    msg.message = MESSAGE_EXIT_REGION;
    [delegate display:msg.toJSONString];
}

- (void)locationManager:(CLLocationManager *)manager
        didStartMonitoringForRegion:(CLRegion *)region {
    NSLog(@"Monitoring for %@", region);
    BeaconMessage *msg = [[BeaconMessage alloc]
                                         init];
    msg.message = MESSAGE_START_MONITORING;
    [delegate display:msg.toJSONString];

}

- (void)locationManager:(CLLocationManager *)manager
        didDetermineState:(CLRegionState)state
        forRegion:(CLRegion *)region {
    if (state == CLRegionStateInside) {
        [_locationManager startRangingBeaconsInRegion:region];
        BeaconMessage *msg = [[BeaconMessage alloc]
                                             init];
        msg.message = MESSAGE_REGION_INSIDE;
        [delegate display:msg.toJSONString];
    }
    else {
        //[[BluetoothManager shared] scan];
        [_locationManager stopRangingBeaconsInRegion:region];
        BeaconMessage *msg = [[BeaconMessage alloc]
                                             init];
        msg.message = MESSAGE_REGION_OUTSIDE;
        [delegate display:msg.toJSONString];
    }
    //[_locationManager startRangingBeaconsInRegion:region];

}

- (void)locationManager:(CLLocationManager *)manager
        didRangeBeacons:(NSArray *)beacons
        inRegion:(CLBeaconRegion *)region {

    NSArray *unknownBeacons = [beacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity = %d",
                                                                                                    CLProximityUnknown]];
    if ([unknownBeacons count]) {
        NSLog(@"unknown beacons %@", unknownBeacons);
        BeaconMessage *msg = [[BeaconMessage alloc]
                                             init];
        msg.message = MESSAGE_BEACONS_UNKNOWN;
        msg.beacons = [self getBeacons:unknownBeacons withDistance:@"Desconhecidos"];
        [delegate display:msg.toJSONString];
    }

    NSArray *immediateBeacons = [beacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity = %d",
                                                                                                      CLProximityImmediate]];
    if ([immediateBeacons count]) {
        NSLog(@"immediate beacons %@", immediateBeacons);
        BeaconMessage *msg = [[BeaconMessage alloc]
                                             init];
        msg.message = MESSAGE_BEACONS_IMMEDIATE;
        msg.beacons = [self getBeacons:immediateBeacons withDistance:@"Imediato"];
        [delegate display:msg.toJSONString];
    }


    NSArray *nearBeacons = [beacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity = %d",
                                                                                                 CLProximityNear]];
    if ([nearBeacons count]) {
        NSLog(@"near beacons %@", nearBeacons);
        BeaconMessage *msg = [[BeaconMessage alloc]
                                             init];
        msg.message = MESSAGE_BEACONS_NEAR;
        msg.beacons = [self getBeacons:nearBeacons withDistance:@"Próximo"];
        [delegate display:msg.toJSONString];
    }


    NSArray *farBeacons = [beacons filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"proximity = %d",
                                                                                                CLProximityFar]];
    if ([farBeacons count]) {
        NSLog(@"far beacons %@", farBeacons);
        BeaconMessage *msg = [[BeaconMessage alloc]
                                             init];
        msg.message = MESSAGE_BEACONS_FAR;
        msg.beacons = [self getBeacons:farBeacons withDistance:@"Longe"];
        [delegate display:msg.toJSONString];
    }

}

- (NSMutableArray <BeaconItem> *)getBeacons:(NSArray *)beaconsArr withDistance:(NSString *)distance {
    NSMutableArray <BeaconItem> *beacons = (NSMutableArray <BeaconItem> *) [[NSMutableArray alloc]
                                                                                            init];
    for (int                    j        = 0; j < beaconsArr.count; j++) {
        CLBeacon   *beacon = [beaconsArr objectAtIndex:j];
        BeaconItem *dict   = [[BeaconItem alloc]
                                          init];
        dict.major    = [beacon.major intValue];
        dict.minor    = [beacon.minor intValue];
        dict.uuid     = beacon.proximityUUID.UUIDString;
        dict.accuracy = beacon.accuracy;
        dict.distance = distance;
        [beacons addObject:dict];
    }
    return beacons;
}
@end

