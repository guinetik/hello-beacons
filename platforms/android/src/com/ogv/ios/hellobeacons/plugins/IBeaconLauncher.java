package com.ogv.ios.hellobeacons.plugins;

import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.RemoteException;
import android.util.Log;

import com.radiusnetworks.ibeacon.IBeacon;
import com.radiusnetworks.ibeacon.IBeaconConsumer;
import com.radiusnetworks.ibeacon.IBeaconManager;
import com.radiusnetworks.ibeacon.RangeNotifier;
import com.radiusnetworks.ibeacon.Region;

import org.apache.cordova.*;
import org.json.JSONArray;
import org.json.JSONException;

import java.util.Collection;

public class IBeaconLauncher extends CordovaPlugin implements IBeaconConsumer {
    private static String DEBUG_TAG = "iBeacon :: DEBUG => ";
    public static final String ACTION_VERIFY_BT = "verifyBluetooth";
    public static final String START_BROWSING = "launch";
    public static final String STOP_BROWSING = "stop";
    private IBeaconManager iBeaconManager;
    private Context context;
    private CallbackContext callbackContext;
    private boolean isBrowsing;
    private Region region;

    @Override
    public boolean execute(String action, JSONArray args, final CallbackContext callbackContext)
            throws JSONException {
        context = this.cordova.getActivity();
        iBeaconManager = IBeaconManager.getInstanceForApplication(this.context);
        this.callbackContext = callbackContext;
        try {
            if (action.equalsIgnoreCase(ACTION_VERIFY_BT)) {
                cordova.getThreadPool().execute(new Runnable() {
                    @Override
                    public void run() {
                        if (verifyBluetooth()) {
                            callbackContext.success();
                        } else {
                            callbackContext.error("Bluetooth LE not detected");
                        }
                    }
                });
                return true;
            } else if (action.equalsIgnoreCase(START_BROWSING)) {
                cordova.getThreadPool().execute(new Runnable() {
                    @Override
                    public void run() {
                        if (verifyBluetooth()) {
                            startBrowsing();
                        } else {
                            callbackContext.error("Bluetooth LE not detected");
                        }
                    }
                });
                return true;
            } else if (action.equalsIgnoreCase(STOP_BROWSING)) {
                cordova.getThreadPool().execute(new Runnable() {
                    @Override
                    public void run() {
                        if (verifyBluetooth()) {
                            if(isBrowsing) {
                                stopBrowsing();
                            }
                        } else {
                            callbackContext.error("Bluetooth LE not detected");
                        }
                    }
                });
                return true;
            }
        } catch (Exception e) {
            System.out.println(DEBUG_TAG + e.getMessage());
            callbackContext.error(e.getMessage());
            return false;
        }
        return false;
    }

    private void stopBrowsing() {
        try {
            iBeaconManager.stopMonitoringBeaconsInRegion(region);
        } catch (RemoteException e) {
            Log.e(DEBUG_TAG, "ERROR", e);
        }
    }

    private boolean verifyBluetooth() {
        try {
            return iBeaconManager.checkAvailability();
        } catch (Exception e) {
            Log.e(DEBUG_TAG, "ERROR", e);
            return false;
        }
    }

    private void startBrowsing() {
        try {
            region = new Region("E2C56DB5-DFFB-48D2-B060-D0F5A71096E0", null, null, null);
            iBeaconManager.startRangingBeaconsInRegion(region);
            this.isBrowsing = true;
        } catch (RemoteException e) {
            Log.e(DEBUG_TAG, "ERROR", e);
        }
    }

    @Override
    public boolean bindService(Intent arg0, ServiceConnection arg1, int arg2) {
        return context.bindService(arg0, arg1, arg2);
    }

    @Override
    public void unbindService(ServiceConnection arg0) {
        context.unbindService(arg0);
    }

    @Override
    public void onIBeaconServiceConnect() {
        iBeaconManager.setRangeNotifier(new RangeNotifier() {
            @Override
            public void didRangeBeaconsInRegion(Collection iBeacons, Region region) {
                IBeacon beacon = (IBeacon) iBeacons.iterator().next();
                Log.i(DEBUG_TAG, "The first iBeacon I see is about " + beacon.getAccuracy() + " meters away.");
                if (callbackContext != null) {
                    callbackContext.success("The first iBeacon I see is about " + beacon.getAccuracy() + " meters away.");
                }
            }
        });
    }

    @Override
    public Context getApplicationContext() {
        return cordova.getActivity().getApplicationContext();
    }
}
