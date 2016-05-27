//
//  TCTableBaseView.m
//  Tayphoon
//
//  Created by Tayphoon on 06.10.15.
//  Copyright © 2015 Tayphoon. All rights reserved.
//

#import "TCTableBaseView.h"

@implementation TCTableBaseView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _contentInsets = UIEdgeInsetsZero;
        
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        if([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
        }
        [self addSubview:_tableView];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self layoutTableView];
}

- (void)layoutTableView {
    CGRect actualBounds = UIEdgeInsetsInsetRect(self.bounds, _contentInsets);
    _tableView.frame = CGRectMake(actualBounds.origin.x,
                                  actualBounds.origin.y,
                                  actualBounds.size.width,
                                  actualBounds.size.height - _tableViewViewBottomMargin);
}

- (void)setContentInsets:(UIEdgeInsets)contentInsets {
    if (!UIEdgeInsetsEqualToEdgeInsets(_contentInsets, contentInsets)) {
        _contentInsets = contentInsets;
        [self setNeedsLayout];
    }
}

- (void)setTableViewViewBottomMargin:(CGFloat)tableViewViewBottomMargin {
    if (_tableViewViewBottomMargin != tableViewViewBottomMargin) {
        _tableViewViewBottomMargin = tableViewViewBottomMargin;
        [self layoutTableView];
    }
}

@end
