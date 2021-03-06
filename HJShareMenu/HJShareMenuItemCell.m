//
//  HJShareMenuItemCell.m
//  Pods
//
//  Created by hujie on 15/7/26.
//
//

#import "HJShareMenuItemCell.h"
#import "HJShareMenuItem.h"

static const  CGFloat kMenuLabelMarginTop  = 8.0;
static const CGFloat kMenuLabelFontSize    = 12.0;
static const NSInteger kMenuLabelTextColor = 0x646464;

static const CGFloat kMenuItemButtonHeight = 60.0;

const CGFloat kMenuItemWidth = 100.0;
const CGFloat kMenuItemHeight = 100.0;

@implementation HJShareMenuItemCell

#pragma mark - init
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self buildLayout];
    }
    return self;
}

- (void)buildLayout
{
    
    NSDictionary *viewsDic = @{@"_menuItemButton":self.menuItemButton,
                               @"_menuLabel":self.menuLabel};
    
    NSDictionary *metrics  = @{@"kMenuLabelMarginTop":[NSNumber numberWithDouble:kMenuLabelMarginTop],
                               @"kMenuItemButtonWidth":[NSNumber numberWithFloat:kMenuItemButtonHeight]};
    
    NSString *vflV = @"V:|-0-[_menuItemButton(kMenuItemButtonWidth)]-kMenuLabelMarginTop-[_menuLabel]";
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vflV
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:viewsDic]];
    
    NSString *vflH = @"H:|-2-[_menuLabel]-2-|";
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vflH
                                                                             options:0
                                                                             metrics:metrics
                                                                               views:viewsDic]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView
                                                                 attribute:NSLayoutAttributeCenterX
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.menuItemButton
                                                                 attribute:NSLayoutAttributeCenterX
                                                                multiplier:1
                                                                  constant:0]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.menuItemButton
                                                                 attribute:NSLayoutAttributeCenterX
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.menuLabel
                                                                 attribute:NSLayoutAttributeCenterX
                                                                multiplier:1
                                                                  constant:0]];
    
    [self.menuItemButton addConstraint:[NSLayoutConstraint constraintWithItem:self.menuItemButton
                                                                 attribute:NSLayoutAttributeWidth
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.menuItemButton
                                                                 attribute:NSLayoutAttributeHeight
                                                                multiplier:1
                                                                  constant:0]];
    
    
    
}


#pragma mark - Action
- (void)menuItemButtonDidCick:(id)sender
{
    if(self.delegate && [self.delegate respondsToSelector:@selector(menuItemCellDidTap:)])
    {
        [self.delegate menuItemCellDidTap:self];
    }
    if (self.menuItem.action) {
        self.menuItem.action();
    }
}

#pragma mark - Property
- (UIButton *)menuItemButton
{
    if (!_menuItemButton) {
        _menuItemButton = [[UIButton alloc] init];
        [_menuItemButton addTarget:self action:@selector(menuItemButtonDidCick:)  forControlEvents:UIControlEventTouchUpInside];
        _menuItemButton.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_menuItemButton];
    }
    return _menuItemButton;
}


- (UILabel *)menuLabel
{
    if (!_menuLabel) {
        
        _menuLabel = [[UILabel alloc] init];
        _menuLabel.numberOfLines = 2;
        _menuLabel.textAlignment = NSTextAlignmentCenter;
        _menuLabel.font  = [UIFont systemFontOfSize:kMenuLabelFontSize];
        _menuLabel.textColor = [UIColor colorWithRed:((float)((kMenuLabelTextColor & 0xFF0000) >> 16)) / 255.0
                                                                        green:((float)((kMenuLabelTextColor & 0xFF00) >> 8)) / 255.0
                                                                         blue:((float)(kMenuLabelTextColor & 0xFF)) / 255.0 alpha:1];
        _menuLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_menuLabel];
    }
    return _menuLabel;
}

- (void)setMenuItem:(HJShareMenuItem *)menuItem {
    _menuItem = menuItem;
    
    [self.menuItemButton setImage:menuItem.menuItemImage forState:UIControlStateNormal];
    self.menuLabel.text  = menuItem.menuItemTitle;
}
@end
