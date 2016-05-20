//
//  ISLocationManager.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/20.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISLocationManager.h"
#import <CoreLocation/CoreLocation.h>

@interface ISLocationManager()<CLLocationManagerDelegate>
@property(nonatomic, strong) CLLocationManager * locationManager;
@property(nonatomic, strong) CLGeocoder * geocoder;

@end

@implementation ISLocationManager


#pragma mark - lifeCycle

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    static ISLocationManager *sharedInstance = nil;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ISLocationManager alloc] init];
    });
    return sharedInstance;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init{
    self = [super init];
    if (self) {
#warning TEST
        self.fetchedLocation = @"南京市建邺区奥体大街1118号";
    }
    return self;
}


#pragma mark - 

- (void)startUpdatingLocation{
    
    if (![CLLocationManager locationServicesEnabled]) {
    //定位没打开
        [[[UIAlertView alloc] initWithTitle:@"提示"
                                    message:@"定位没打开,请到设置->隐私->定位服务进行设置。"
                                   delegate:nil
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil, nil] show];
        return;
    }
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
        [self.locationManager requestWhenInUseAuthorization];
    }else if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse){
        //设置代理
        self.locationManager.delegate = self;
        //设置定位精度
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //定位频率,每隔多少米定位一次
        CLLocationDistance distance = 10.0;//十米定位一次
        self.locationManager.distanceFilter = distance;
        //启动跟踪定位
        [self.locationManager startUpdatingLocation];
    }
}


#pragma mark - CoreLocation 代理
#pragma mark 跟踪定位代理方法，每次位置发生变化即会执行（只要定位到相应位置）
//可以通过模拟器设置一个虚拟位置，否则在模拟器中无法调用此方法
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *location = [locations firstObject];//取出第一个位置
    CLLocationCoordinate2D coordinate = location.coordinate;//位置坐标
    NSLog(@"经度：%f,纬度：%f,海拔：%f,航向：%f,行走速度：%f",coordinate.longitude,coordinate.latitude,location.altitude,location.course,location.speed);
    [self getAddressByLatitude:coordinate.latitude longitude:coordinate.longitude];
    
    //如果不需要实时定位，使用完即使关闭定位服务
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    [self.locationManager stopUpdatingLocation];
}


-(void)getAddressByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude{
    //反地理编码
    CLLocation *location=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        if (placemarks.count) {
            CLPlacemark *placemark = [placemarks firstObject];
            
//            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:placemark.addressDictionary
//                                                               options:NSJSONWritingPrettyPrinted
//                                                                 error:nil];
//            NSString *jsonString = [[NSString alloc] initWithData:jsonData
//                                                         encoding:NSUTF8StringEncoding];
//            NSLog(@"%@",jsonString);
            
            self.fetchedLocation = [NSString stringWithFormat:@"%@%@%@%@",
                                    placemark.addressDictionary[@"State"],
                                    placemark.addressDictionary[@"City"],
                                    placemark.addressDictionary[@"SubLocality"],
                                    placemark.addressDictionary[@"Street"]];
            NSLog(@"%@",self.fetchedLocation);
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:kISLocationDidUpdateNotification object:nil userInfo:nil];
            });
        }
    }];
}


#pragma mark - property

- (CLLocationManager*)locationManager{
    if (_locationManager == nil) {
        _locationManager = [CLLocationManager new];
    }
    return _locationManager;
}

- (CLGeocoder*)geocoder{
    if (_geocoder == nil) {
        _geocoder = [CLGeocoder new];
    }
    return _geocoder;
}

@end
