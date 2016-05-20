//
//  BCScanViewController.h
//  TripAway4Server
//
//  Created by yangboshan on 15/12/22.
//  Copyright (c) 2015年 yangbs. All rights reserved.
//

#import "ZBarSDK.h"

typedef void(^ISScanResultBlock)(NSString* result);

@interface ISScanViewController : UIViewController<ZBarReaderViewDelegate>
@property (nonatomic,copy) ISScanResultBlock block;


@end
