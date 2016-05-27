//
//  MALocationServices.m
//  MoodAlarm
//
//  Created by Angelica Bato on 5/26/16.
//  Copyright © 2016 Angelica Bato. All rights reserved.
//

#import "MALocationStore.h"
#import "MAWeatherAPI.h"

@implementation MALocationStore

+ (instancetype)sharedStore {
    static MALocationStore *_sharedLocationStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedLocationStore = [[MALocationStore alloc] init];
    });
    
    return _sharedLocationStore;
}

-(instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (void)getLocation {
    
    NSLog(@"1");
    
    if ([CLLocationManager locationServicesEnabled]) {
        NSLog(@"2");
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        self.locationManager.delegate = self;
        [self.locationManager requestWhenInUseAuthorization];
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        [self.locationManager startUpdatingLocation];
    }
}

-(NSArray *)getCurrentLocationInformation {
    return @[self.latitude, self.longitude];
}

-(void)getWeatherWithCompletionBlock:(void(^)(BOOL))completionBlock {
    
    [MAWeatherAPI getWeatherInfoForCurrentLocationForLatitude:self.latitude longitude:self.longitude withCompletion:^(NSDictionary *dict) {
        NSLog(@"%@",dict[@"currently"][@"apparentTemperature"]);
        completionBlock(YES);
    }];
    
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    [self.locationManager stopUpdatingLocation];
//    UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Failed to Get Your Location" message:@"Try again!" preferredStyle:UIAlertControllerStyleAlert];
//    
//    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        [self dismissViewControllerAnimated:YES completion:nil];
//    }];
//    
//    [errorAlert addAction:ok];
//    
//    [self presentViewController:errorAlert animated:YES completion:nil];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    self.currentLocation = [locations lastObject];

    self.latitude = [NSString stringWithFormat:@"%f",self.currentLocation.coordinate.latitude];
    self.longitude = [NSString stringWithFormat:@"%f",self.currentLocation.coordinate.longitude];
    
    [self.locationManager stopUpdatingLocation];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:self.currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        NSUInteger count = placemarks.count;
        
        for (CLPlacemark *placemark in placemarks) {
            self.city = [placemark locality];
            self.state = [placemark administrativeArea];
            NSLog(@"%@,%@",self.latitude, self.longitude);
            count--;
        }
        if (count == 0) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"locationInfoComplete" object:nil];
        }
    }];
    
}

- (void)locationManager:(CLLocationManager*)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined: {
            NSLog(@"User still thinking..");
        } break;
        case kCLAuthorizationStatusDenied: {
            NSLog(@"User hates you");
        } break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways: {
            [self.locationManager startUpdatingLocation];
        } break;
        default:
            break;
    }
}







@end
