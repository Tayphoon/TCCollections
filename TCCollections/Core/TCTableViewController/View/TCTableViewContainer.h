//
//  TCTableViewContainer.h
//  TCCollections
//
//  Created by Tayphoon on 09/08/16.
//  Copyright © 2016 Tayphoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TCTableViewContainer <NSObject>

@property (nonatomic, readonly) UITableView * tableView;
@property (nonatomic, assign) CGFloat tableViewViewBottomMargin;

@end
