//
//  TCTableBaseView.m
//  TCCollections
//
//  Created by Tayphoon on 06.10.15.
//  Copyright © 2015 Tayphoon. All rights reserved.
//

#import <OALayoutAnchor/OALayoutAnchor.h>

#import "TCTableBaseView.h"

@interface TCTableBaseView()

@property (nonatomic, strong) NSLayoutConstraint * tableBottomConstraint;

@end

@implementation TCTableBaseView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {        
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_tableView];
        [self configureTableLayoutConstraints];
    }
    
    return self;
}

- (void)setTableViewViewBottomMargin:(CGFloat)tableViewViewBottomMargin {
    if (self.tableBottomConstraint.constant != tableViewViewBottomMargin) {
        self.tableBottomConstraint.constant = tableViewViewBottomMargin;
        [self layoutIfNeeded];
    }
}

- (CGFloat)tableViewViewBottomMargin {
    return self.tableBottomConstraint.constant;
}

- (void)configureTableLayoutConstraints {
    [_tableView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [_tableView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [_tableView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
    
    self.tableBottomConstraint = [_tableView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor];
    self.tableBottomConstraint.active = YES;
}

@end
