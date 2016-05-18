//
//  BCSquareImagePublishAddImageCell.m
//  TripAway
//
//  Created by yangboshan on 16/3/2.
//  Copyright © 2016年 yangbs. All rights reserved.
//

#import "ISOrderAddImageCell.h"
#import "BCPhotoPickerViewController.h"
#import "ISImageEditorController.h"
#import "DownSheet.h"


@interface ISOrderAddImageCell()
@property (nonatomic, strong) NSMutableArray * imageList;
@property (nonatomic, weak) UITableView * tableView;
@end

@implementation ISOrderAddImageCell

static float const margin  = 5;
static float const item_margin = 5;
static int const items_per_row = 6;
static int const max_number = 10;



- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)configureWithData:(id)data indexPath:(NSIndexPath *)indexPath superView:(UITableView *)superView{
    
    self.imageList = data;
    self.tableView = superView;
    
    for(UIView* subview in self.container.subviews){
        [subview removeFromSuperview];
    }
    
    float item_width = (ScreenWidth - margin * 2 - (items_per_row - 1) * item_margin) / items_per_row;
    float item_height = item_width;
    self.containerHeight.constant = item_height + margin * 2;
    
    float xOffset = margin;
    float yOffset = margin;
    
    for(int i = 0; i <= self.imageList.count; i++){
        NSMutableDictionary* d =  (self.imageList.count >= 1 && (i < self.imageList.count)) ? self.imageList[i] : nil;
        if (i) {
            xOffset = margin +  (i % items_per_row) * (item_width + item_margin);
            yOffset = margin + (i / items_per_row) * (item_height + item_margin);
            self.containerHeight.constant = yOffset + item_height + margin;
        }
        
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(xOffset, yOffset, item_width, item_height)];
        imageView.userInteractionEnabled = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.tag = i;
        imageView.image = d[@"image"];
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped:)];
        [imageView addGestureRecognizer:tap];
        [self.container addSubview:imageView];
        
        if (i == self.imageList.count) {
            imageView.image = [UIImage imageNamed:@"order_list_add"];
        }
    }
}

- (void)imageViewTapped:(UIGestureRecognizer*)gesture{
    __weak typeof(self) weakSelf = self;
    [[self.tableView superview] endEditing:YES];
    if (gesture.view.tag == self.imageList.count) {
        if (self.imageList.count >= max_number) {
            return;
        }else{
            NSArray * list = @[@"门头",@"堆头",@"陈列",@"其他"];
            DownSheet * sheet = [[DownSheet alloc] initWithlist:list block:^(NSInteger index) {
                BCPhotoPickerViewController* photoPickerController = [[BCPhotoPickerViewController alloc] init];
                photoPickerController.maxOfSelection = max_number - weakSelf.imageList.count;
                photoPickerController.block = ^(NSArray * imageList){
                    for(UIImage *image in imageList){
                        UIImage * waterMark = [image waterMarkImageWithLocation:list[index]];
                        [weakSelf.imageList addObject:[@{@"image":waterMark,@"remark":list[index]} mutableCopy]];
                    }
                    [weakSelf.tableView reloadData];
                };
                [[weakSelf viewController] presentViewController:photoPickerController animated:YES completion:nil];
            }];
            [sheet showInView:nil];
        }
    }else{
        ISImageEditorController * editorController = [[ISImageEditorController alloc] initWithData:self.imageList block:^(NSArray *result) {
            [weakSelf.tableView reloadData];
        }];
        [[self viewController].navigationController pushViewController:editorController animated:YES];
    }
}


@end
