//
//  BCSquareImageEditorController.h
//  TripAway
//
//  Created by yangboshan on 16/3/15.
//  Copyright © 2016年 yangbs. All rights reserved.
//


typedef void(^ISImageEditorBlock)(NSMutableArray* result);

@interface ISImageEditorController : UIViewController

- (instancetype)initWithData:(NSMutableArray*)data block:(ISImageEditorBlock)block;

@end
