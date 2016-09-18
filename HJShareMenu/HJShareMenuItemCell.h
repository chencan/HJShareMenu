//
//  HJShareMenuItemCell.h
//  Pods
//
//  Created by hujie on 15/7/26.
//
//

#import <UIKit/UIKit.h>


@class HJShareMenuItemCell;
@class HJShareMenuItem;

@protocol HJShareMenuItemCellDelegate <NSObject>

-(void)menuItemCellDidTap:(HJShareMenuItemCell *)shareMenuItemCell;

@end



@interface HJShareMenuItemCell : UICollectionViewCell

@property (nonatomic, assign)id<HJShareMenuItemCellDelegate> delegate;

@property (nonatomic, strong) UIButton *menuItemButton;
@property (nonatomic, strong) UILabel     *menuLabel;
@property (nonatomic, strong) HJShareMenuItem *menuItem;


@end
