//
//  ISWebViewController.m
//  InventorySystemForiPhone
//
//  Created by yangboshan on 16/5/6.
//  Copyright © 2016年 yangboshan. All rights reserved.
//

#import "ISWebViewController.h"

@interface ISWebViewController ()<UIWebViewDelegate>
@property (nonatomic,strong) UIWebView* webView;
@end

@implementation ISWebViewController

#pragma mark - life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webView];
    self.title = self.resTitle;
    NSURL *url = [[NSURL alloc] initWithString:self.url];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    [[ISProcessViewHelper sharedInstance] showProcessViewInView:self.view];
}

#pragma mark webView delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[ISProcessViewHelper sharedInstance] hideProcessViewInView:self.view];
}

#pragma mark - property
-(UIWebView*)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        [_webView setDelegate:self];
    }
    return _webView;
}
@end
