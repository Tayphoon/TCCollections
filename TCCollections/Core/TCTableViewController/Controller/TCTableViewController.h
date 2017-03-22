//
//  TCTableViewController.h
//  TCCollections
//
//  Created by Tayphoon on 20.11.14.
//  Copyright (c) 2014 Tayphoon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCTableViewModel.h"

@interface TCTableViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, TCTableViewModelDelegate>

@property (nonatomic, readonly) UITableView * tableView;
@property (nonatomic, strong) UILabel * noDataLabel;
@property (nonatomic, strong) id<TCTableViewModel> tableViewModel;
@property (nonatomic, readonly) BOOL isActivityIndicatorShown;
@property (nonatomic, readonly) UIActivityIndicatorView * activityIndicator;

- (void)scrollToBottomAnimated:(BOOL)animated delay:(CGFloat)delay;
- (void)scrollToTopAnimated:(BOOL)animated delay:(CGFloat)delay;

- (void)updateNoDataLabelVisibility;

- (void)showActivityIndicatorAnimated:(BOOL)animated completion:(void (^)(void))completion;

- (void)hideActivityIndicatorAnimated:(BOOL)animated completion:(void (^)(void))completion;

@end
