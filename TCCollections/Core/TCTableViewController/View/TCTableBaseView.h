//
//  TCTableBaseView.h
//  TCCollections
//
//  Created by Tayphoon on 06.10.15.
//  Copyright © 2015 Tayphoon. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TCTableViewContainer.h"

@interface TCTableBaseView : UIView<TCTableViewContainer>

@property (nonatomic, readonly) UITableView * tableView;
@property (nonatomic, assign) CGFloat tableViewViewBottomMargin;

@end
