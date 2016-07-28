//
//  TCTableBaseView.h
//  Tayphoon
//
//  Created by Tayphoon on 06.10.15.
//  Copyright © 2015 Tayphoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCTableBaseView : UIView

@property (nonatomic, readonly) UITableView * tableView;
@property (nonatomic, assign) UIEdgeInsets contentInsets;
@property (nonatomic, assign) CGFloat tableViewViewBottomMargin;

- (void)layoutTableView;

@end
