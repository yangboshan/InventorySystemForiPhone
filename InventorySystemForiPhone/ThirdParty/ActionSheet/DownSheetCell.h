//
//  DownSheetCell.h
//  audioWriting
//
//  Created by wolf on 14-7-19.
//  Copyright (c) 2014年 wangruiyy. All rights reserved.
//

#import <UIKit/UIKit.h>
#define RGBCOLOR(r, g, b)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r, g, b, a)   [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]


@interface DownSheetCell : UITableViewCell{
    UIImageView *leftView;
    UILabel *InfoLabel;
    UILabel *subLabel;
    UIView *backgroundView;
}
-(void)setData:(NSString *)data;
@end

