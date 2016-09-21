//
//  HJShareMenu.m
//  Pods
//
//  Created by hujie on 15/7/26.
//
//

#import "HJShareMenu.h"

//cell
#import "HJShareMenuPageCell.h"



typedef enum : NSUInteger {
    SingleLineMode,
    SinglePageMode,
    MultiPageMode,
} HJShareMenuMode;

static NSString * const kShareMenuPageCellIdentifier = @"kHJShareMenuPageCellIdentifier";
static const NSInteger kBackgroundViewColor       = 0x000000;
static const CGFloat kAnimationDuration           = 0.4;
static const CGFloat kBackgroundViewAlpha         = 0.6;
static const  NSInteger kShareMenuBackgroundColor = 0xe1e3e4;
static const CGFloat   kCancelButtonFontSize      = 15.0;
static const NSInteger kCancelButtonTextColor     = 0x323232;
static const CGFloat kCancelButtonHeight          = 45.0;
static const CGFloat kSpacing                     = 5.0;


@interface HJShareMenu ()<  UICollectionViewDataSource,
                            UICollectionViewDelegate,
                            UICollectionViewDelegateFlowLayout,
                            HJShareMenuPageCellDelegate>

@property (nonatomic, strong) UICollectionView *menuCollectionView;

@property (nonatomic, strong) NSArray  *menuItems;

@property (nonatomic, strong) UIButton *cancelButton;

@property (nonatomic, weak) UIControl   *backgroundView;

@property (nonatomic, assign) HJShareMenuMode menuMode;

@property (nonatomic,assign) CGFloat pageViewHeight;

@property (nonatomic, strong) UIPageControl *pageControl;

@end


@implementation HJShareMenu


#pragma mark - init 
- (id)initWithMenuItems:(NSArray *)items
{
    self = [super init];
    if (self) {
        //设置数据
        self.menuItems  = items;
        if (self.menuItems.count  < 4) {
            self.menuMode  = SingleLineMode;
        }
        else if (self.menuItems.count < 7) {
            self.menuMode = SinglePageMode;
        }
        else {
            self.menuMode = MultiPageMode;
        }
        //布局
        [self buildLayout];
        
        //设置样式
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark - public
- (void)showMenu
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    UIView *backgroundView = [[UIControl alloc] initWithFrame:keyWindow.frame];
    self.backgroundView  = backgroundView;
    [self.backgroundView addSubview:self];
    self.backgroundView.backgroundColor = [UIColor colorWithRed:((float)((kBackgroundViewColor & 0xFF0000) >> 16)) / 255.0
                                                          green:((float)((kBackgroundViewColor & 0xFF00) >> 8)) / 255.0
                                                           blue:((float)(kBackgroundViewColor & 0xFF)) / 255.0 alpha:0];
    [keyWindow addSubview:self.backgroundView];
    
    [self.backgroundView addTarget:self action:@selector(backgroundViewDidTap:) forControlEvents:UIControlEventTouchUpInside];
    
    //begin frame
    self.frame  = CGRectMake(0,
                             keyWindow.frame.size.height,
                             keyWindow.frame.size.width,
                             self.pageViewHeight + kCancelButtonHeight + kSpacing * 2);
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0,
                                keyWindow.frame.size.height - self.frame.size.height - kSpacing,
                                keyWindow.frame.size.width,
                                self.frame.size.height);
        self.backgroundView.backgroundColor = [UIColor colorWithRed:((float)((kBackgroundViewColor & 0xFF0000) >> 16)) / 255.0
                                                              green:((float)((kBackgroundViewColor & 0xFF00) >> 8)) / 255.0
                                                               blue:((float)(kBackgroundViewColor & 0xFF)) / 255.0 alpha:kBackgroundViewAlpha];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            //end frame
            self.frame = CGRectMake(0,
                                    keyWindow.frame.size.height - self.frame.size.height,
                                    keyWindow.frame.size.width,
                                    self.frame.size.height);
        }];
    }];
}

- (void)hideMenu
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    CGRect toFrame =  CGRectMake(0,
                                 keyWindow.frame.size.height,
                                 keyWindow.frame.size.width,
                                 self.frame.size.height);
    
    [UIView animateWithDuration:kAnimationDuration
                     animations:^{
                         self.frame = toFrame;
                         self.backgroundView.backgroundColor = [UIColor colorWithRed:((float)((kBackgroundViewColor & 0xFF0000) >> 16)) / 255.0
                                                                               green:((float)((kBackgroundViewColor & 0xFF00) >> 8)) / 255.0
                                                                                blue:((float)(kBackgroundViewColor & 0xFF)) / 255.0 alpha:0];
                     }
                     completion:^(BOOL finished) {
                         [self.backgroundView removeFromSuperview];
                     }];
}


#pragma mark  - Pirvate
- (void)buildLayout
{
    NSDictionary *viewsDic = @{@"_menuCollectionView":self.menuCollectionView,
                               @"self":self,
                               @"_cancelButton":self.cancelButton,
                               @"_pageControl":self.pageControl};
    
    NSDictionary *metrics  = @{@"menuCollectionViewHeight":[NSNumber numberWithDouble:self.pageViewHeight],
                               @"cancelButtonHeight":[NSNumber numberWithDouble:kCancelButtonHeight]};
    
    NSString *vflH = @"H:|-5-[_menuCollectionView(==_cancelButton)]-5-|";
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vflH
                                                                 options:0
                                                                 metrics:nil
                                                                   views:viewsDic]];
    
    NSString *vflV = @"V:|-0-[_menuCollectionView(menuCollectionViewHeight)]-5-[_cancelButton(cancelButtonHeight)]-5-|";
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vflV
                                                                 options:0
                                                                 metrics:metrics
                                                                   views:viewsDic]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.cancelButton
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.menuCollectionView
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1
                                                      constant:0]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControl
                                                     attribute:NSLayoutAttributeBottom
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.menuCollectionView
                                                     attribute:NSLayoutAttributeBottom
                                                    multiplier:1
                                                      constant:0]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControl
                                                     attribute:NSLayoutAttributeCenterX
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self.menuCollectionView
                                                     attribute:NSLayoutAttributeCenterX
                                                    multiplier:1
                                                      constant:0]];
    
     [self bringSubviewToFront:self.pageControl];
    
}

- (void)cancelled {
    [self hideMenu];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(hj_shareMenuCancelled:)])
    {
        [self.delegate hj_shareMenuCancelled:self];
    }
    
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return (self.menuItems.count / 6)+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HJShareMenuPageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kShareMenuPageCellIdentifier forIndexPath:indexPath];
    
    
    NSInteger loc = indexPath.row*6;
    NSInteger len = (loc + 6)>self.menuItems.count?self.menuItems.count - loc:6;
    cell.menuPageItems = [self.menuItems subarrayWithRange: NSMakeRange(loc , len)];
    cell.delegate  = self;
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (CGFloat) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.height);
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.menuCollectionView.frame.size.width;
    
    self.pageControl.currentPage = (self.menuCollectionView.contentOffset.x + pageWidth / 2) / pageWidth;
}





#pragma mark - HJShareMenuPageCellDelegate
- (void)shareMenuPageCell:(HJShareMenuPageCell *)pageCell selectedAtIndex:(NSInteger)index
{
    [self hideMenu];
    
    NSIndexPath *pageIndex  = [self.menuCollectionView indexPathForCell:pageCell];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(hj_shareMenu:selectedAtIndex:)])
    {
        [self.delegate hj_shareMenu:self selectedAtIndex:6*pageIndex.row +index];
    }
}


#pragma makr - Action
- (void)backgroundViewDidTap:(id)sender
{
    [self cancelled];
}


- (void)cancelButtonDidCick:(id)sender
{
    [self cancelled];
}


#pragma mark - Property
- (void)setMenuMode:(HJShareMenuMode)menuMode
{
    _menuMode = menuMode;
    if (menuMode == SingleLineMode) {
        self.pageViewHeight = 130.0;
    }
    else {
        self.pageViewHeight = 258.0;
        if (menuMode == SinglePageMode) {
            self.pageControl.hidden = YES;
        }
        else if (menuMode == MultiPageMode) {
            self.pageControl.numberOfPages =  self.menuItems.count/6 +1;
        }
    }
}


- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl  = [[UIPageControl alloc] init];
        _pageControl.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_pageControl];
    }
    return _pageControl;
}

- (UICollectionView *)menuCollectionView
{
    if (!_menuCollectionView) {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.sectionInset = UIEdgeInsetsMake(0,
                                                   0,
                                                   0,
                                                   0);
        flowLayout.minimumLineSpacing = 0;
        _menuCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                 collectionViewLayout:flowLayout];
        _menuCollectionView.translatesAutoresizingMaskIntoConstraints = NO;
        _menuCollectionView.backgroundColor  = [UIColor colorWithRed:((float)((kShareMenuBackgroundColor & 0xFF0000) >> 16)) / 255.0
                                                               green:((float)((kShareMenuBackgroundColor & 0xFF00) >> 8)) / 255.0
                                                                blue:((float)(kShareMenuBackgroundColor & 0xFF)) / 255.0 alpha:1];
        
        _menuCollectionView.layer.cornerRadius = 5;
        _menuCollectionView.bounces = NO;
        _menuCollectionView.pagingEnabled = YES;
        _menuCollectionView.showsHorizontalScrollIndicator = NO;
        _menuCollectionView.dataSource = self;
        _menuCollectionView.delegate = self;
        [_menuCollectionView registerClass:[HJShareMenuPageCell class] forCellWithReuseIdentifier:kShareMenuPageCellIdentifier];
        [self addSubview:_menuCollectionView];
    }
    return _menuCollectionView;
}

- (UIButton *)cancelButton
{
    if (!_cancelButton) {
        
        _cancelButton  = [[UIButton alloc] init];
        [_cancelButton setTitle:kHJShareMenuLocalizedStrings(@"cancel") forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor colorWithRed:((float)((kCancelButtonTextColor & 0xFF0000) >> 16)) / 255.0
                                                     green:((float)((kCancelButtonTextColor & 0xFF00) >> 8)) / 255.0
                                                      blue:((float)(kCancelButtonTextColor & 0xFF)) / 255.0 alpha:1] forState:UIControlStateNormal];
        _cancelButton.backgroundColor  = [UIColor colorWithRed:((float)((kShareMenuBackgroundColor & 0xFF0000) >> 16)) / 255.0
                                                         green:((float)((kShareMenuBackgroundColor & 0xFF00) >> 8)) / 255.0
                                                          blue:((float)(kShareMenuBackgroundColor & 0xFF)) / 255.0 alpha:1];
        _cancelButton.layer.cornerRadius = 5;
        _cancelButton.titleLabel.font  = [UIFont systemFontOfSize:kCancelButtonFontSize];
        _cancelButton.translatesAutoresizingMaskIntoConstraints  = NO;
        [_cancelButton addTarget:self action:@selector(cancelButtonDidCick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancelButton];
    }
    return _cancelButton;
}


@end
