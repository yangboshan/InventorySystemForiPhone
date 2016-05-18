//
//  ISCommonMacro.h
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/4.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#ifndef ISCommonMacro_h
#define ISCommonMacro_h

#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define NavBarHeightAlone 44
#define NavBarHeight 64
#define TabBarHeight 49

#define IOSVersion   [[[UIDevice currentDevice] systemVersion] floatValue]
#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define HEXCOLOR(c) [UIColor colorWithRed:((c>>16)&0xFF)/255.0 green:((c>>8)&0xFF)/255.0 blue:(c&0xFF)/255.0 alpha:1.0]

#define TheameColor RGB(128,176,33)
#define TheameColorAlpha(a) RGBA(128,176,33,a)

#define BorderColor RGB(223, 223, 223).CGColor
#define MaskColor RGBA(0, 0, 0, 0.5)

#define Lantinghei(s) [UIFont fontWithName:@"Lantinghei SC" size:s]
#define LantingheiBold(s) [UIFont fontWithName:@"FZLTHJW--GB1-0" size:s]
#define LantingheiBoldS(s) [UIFont fontWithName:@"FZLanTingHeiS-B-GB" size:s]

#define Font(s) [ISUtilities getDynamicFontSize:s]
#define LantingheiD(s) [UIFont fontWithName:@"Lantinghei SC" size:Font(s)]
#define LantingheiBoldD(s) [UIFont fontWithName:@"FZLTHJW--GB1-0" size:Font(s)]
#define LantingheiBoldSD(s) [UIFont fontWithName:@"FZLanTingHeiS-B-GB" size:Font(s)]

#define ImageSize 500000

#endif /* ISCommonMacro_h */
