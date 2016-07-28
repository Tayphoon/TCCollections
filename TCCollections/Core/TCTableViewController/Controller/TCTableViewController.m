//
//  TCTableBaseController.m
//  Tayphoon
//
//  Created by Tayphoon on 20.11.14.
//  Copyright (c) 2014 Tayphoon. All rights reserved.
//

#import <OALayoutAnchor/OALayoutAnchor.h>

#import "TCTableViewController.h"
#import "TCCollectionsConstants.h"

@interface TCTableViewController() {
    UITableView * _tableView;
    BOOL _isDealocProcessing;
    UIEdgeInsets _tableInsets;
    NSLayoutConstraint * _activityIndicatorTopConstraint;
}

@property (nonatomic, strong) UIActivityIndicatorView * activityIndicator;

@end

@implementation TCTableViewController

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (UITableView*)tableView {
    if(!_tableView && !_isDealocProcessing && self.isViewLoaded) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.translatesAutoresizingMaskIntoConstraints = NO;
        
        if([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
        }
        
        [self.view addSubview:_tableView];
        [self configureTableLayoutConstraints];
    }
    return _tableView;
}

- (UILabel*)noDataLabel {
    if(!_noDataLabel && self.isViewLoaded) {
        _noDataLabel = [[UILabel alloc] init];
        [_noDataLabel setFont:[UIFont systemFontOfSize:18.0f]];
        [_noDataLabel setTextColor:[UIColor lightGrayColor]];
        _noDataLabel.textAlignment = NSTextAlignmentCenter;
        _noDataLabel.backgroundColor = [UIColor clearColor];
        _noDataLabel.numberOfLines = 0;
        _noDataLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _noDataLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _noDataLabel.hidden = YES;
        
        if (self.tableView) {
            [self.view insertSubview:_noDataLabel belowSubview:self.tableView];
            [self configureNoDataLayoutConstraintsForView:self.tableView];
        }
        else {
            [self.view addSubview:_noDataLabel];
            [self configureNoDataLayoutConstraintsForView:self.view];
        }
    }
    
    return _noDataLabel;
}

- (void)setModel:(id<TCTableViewModel>)model {
    _model.delegate = nil;
    _model = model;
    _model.delegate = self;
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.model numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.model numberOfItemsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[self.model reuseIdentifierForIndexPath:indexPath]];
    
    if (!cell) {
        cell = [self.model createCellForIndexPath:indexPath];
    }
    
    if ([cell conformsToProtocol:@protocol(TCTableViewCell)]) {
        UITableViewCell<TCTableViewCell> * tableCell = (UITableViewCell<TCTableViewCell>*)cell;
        tableCell.item = [self.model itemAtIndexPath:indexPath];
    }
    
    return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self.model respondsToSelector:@selector(heightForHeaderInSection:constrainedToSize:)]) {
        return [self.model heightForHeaderInSection:section constrainedToSize:tableView.bounds.size];
    }
    return 0;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([self.model respondsToSelector:@selector(createViewForHeaderInSection:)]) {
        
        UIView<TCSectionHeaderView> * sectionHeader = [self.model createViewForHeaderInSection:section];
        if ([self.model respondsToSelector:@selector(itemForSection:)]) {
            [sectionHeader setupWithItem:[self.model itemForSection:section]];
        }
        
        return sectionHeader;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.model heightForItemAtIndexPath:indexPath constrainedToSize:tableView.frame.size];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - TCTableModel Delegate

- (void)modelWillChangeContent:(id<TCTableViewModel>)model {
    [self.tableView beginUpdates];
}

- (void)model:(id<TCTableViewModel>)model didChangeSectionAtIndex:(NSUInteger)sectionIndex forChangeType:(NSUInteger)type {
    switch(type) {
        case TCCollectionsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case TCCollectionsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case TCCollectionsChangeUpdate:
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}

- (void)model:(id<TCTableViewModel>)model didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSUInteger)type newIndexPath:(NSIndexPath *)newIndexPath {
    switch(type) {
        case TCCollectionsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case TCCollectionsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                  withRowAnimation:UITableViewRowAnimationRight];
            break;
        case TCCollectionsChangeMove:
            if (![indexPath isEqual:newIndexPath]) {
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                      withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                      withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            break;
        case TCCollectionsChangeUpdate:
            if ([indexPath isEqual:newIndexPath] || newIndexPath == nil) {
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                      withRowAnimation:UITableViewRowAnimationNone];
            }
            else if(indexPath && newIndexPath) {
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                      withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                      withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            break;
    }
}

- (void)modelDidChangeContent:(id<TCTableViewModel>)model {
    [self updateNoDataLabelVisibility];
    [self.tableView endUpdates];
}

- (void)modelDidChanged:(id<TCTableViewModel>)model {
    [self updateNoDataLabelVisibility];
    [self.tableView reloadData];
}

#pragma mark - Scroll methods

- (void)scrollToBottomAnimated:(BOOL)animated delay:(CGFloat)delay {
    __block NSInteger section = [self.tableView numberOfSections] - 1;
    BOOL canScroll = ([self.tableView numberOfSections] > 0 && [self.tableView numberOfRowsInSection:section] > 0);
    
    if (canScroll) {
        __block  NSInteger row = [self.tableView numberOfRowsInSection:section] - 1;
        
        if(delay > 0.0f) {
            dispatch_time_t dispatchTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
            dispatch_after(dispatchTime, dispatch_get_main_queue(), ^{
                [self scrollToBottomAnimated:animated delay:0.0f];
            });
        }
        else {
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:animated];
        }
    }
}

- (void)scrollToTopAnimated:(BOOL)animated delay:(CGFloat)delay {
    NSInteger section = [self.tableView numberOfSections];
    
    if (section > 0) {
        NSInteger itemsCount = [self.tableView numberOfRowsInSection:0];
        
        if (itemsCount > 0) {
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            if(delay > 0.0f) {
                dispatch_time_t dispatchTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
                dispatch_after(dispatchTime, dispatch_get_main_queue(), ^{
                    [self scrollToTopAnimated:animated delay:0.0f];
                });
            }
            else {
                [self.tableView scrollToRowAtIndexPath:indexPath
                                      atScrollPosition:UITableViewScrollPositionTop
                                              animated:animated];
            }
        }
    }
}

- (void)updateNoDataLabelVisibility {
    if (_noDataLabel) {
        _noDataLabel.hidden = ([self.model numberOfItemsInSection:0] > 0);
    }
}

- (BOOL)isActivityIndicatorShown {
    return _activityIndicator && !_activityIndicator.isHidden;
}

- (void)showActivityIndicatorAnimated:(BOOL)animated completion:(void (^)(void))completion {
    if (!self.isActivityIndicatorShown) {
        [self.activityIndicator startAnimating];
        
        CGFloat indicatorHeight = self.activityIndicator.frame.size.height;
        
        _tableInsets = self.tableView.contentInset;
        CGPoint contentOffset = self.tableView.contentOffset;
        UIEdgeInsets contentInsets = self.tableView.contentInset;
        contentInsets.top = indicatorHeight;
        contentOffset.y -= indicatorHeight;
        
        _activityIndicatorTopConstraint.constant = 0.0f;
        
        [UIView animateWithDuration:animated ? 0.3 : 0.0
                              delay:0.0
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             [self.activityIndicator layoutIfNeeded];
                             
                             self.tableView.contentInset = contentInsets;
                             [self.tableView setContentOffset:contentOffset animated:NO];
                         }
                         completion:^(BOOL finished) {
                             if (finished && completion) {
                                 completion();
                             }
                         }];
    }
}

- (void)hideActivityIndicatorAnimated:(BOOL)animated completion:(void (^)(void))completion {
    if (self.isActivityIndicatorShown) {
        void (^completionBlock)(BOOL finished) = ^(BOOL finished)
        {
            self.tableView.contentInset = _tableInsets;
            [self.activityIndicator stopAnimating];
            if (finished && completion) {
                completion();
            }
        };
        
        _activityIndicatorTopConstraint.constant = -30.0f;
        
        if (animated) {
            [UIView animateWithDuration:0.3
                                  delay:0.0
                                options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 [self.activityIndicator layoutIfNeeded];
                                 
                                 self.tableView.contentInset = _tableInsets;
                             }
                             completion:completionBlock];
        }
        else {
            completionBlock(YES);
            [self.tableView.layer removeAllAnimations];
            [self.tableView setContentOffset:self.tableView.contentOffset animated:NO];
        }
    }
}

#pragma mark - AutoLayout methods

- (void)configureTableLayoutConstraints {
    [_tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [_tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    [_tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [_tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
}

- (void)configureNoDataLayoutConstraintsForView:(UIView*)superView {
    [_noDataLabel.topAnchor constraintEqualToAnchor:superView.topAnchor].active = YES;
    [_noDataLabel.bottomAnchor constraintEqualToAnchor:superView.bottomAnchor].active = YES;
    [_noDataLabel.leadingAnchor constraintEqualToAnchor:superView.leadingAnchor].active = YES;
    [_noDataLabel.trailingAnchor constraintEqualToAnchor:superView.trailingAnchor].active = YES;
}

- (void)configureActivityIndicatorLayoutConstraints {
    _activityIndicatorTopConstraint = [_activityIndicator.topAnchor constraintEqualToAnchor:self.tableView.topAnchor constant:-30];
    _activityIndicatorTopConstraint.active = YES;
    [_activityIndicator.leadingAnchor constraintEqualToAnchor:self.tableView.leadingAnchor].active = YES;
    [_activityIndicator.trailingAnchor constraintEqualToAnchor:self.tableView.trailingAnchor].active = YES;
    [_activityIndicator.heightAnchor constraintEqualToConstant:30.0f].active = YES;
}

#pragma mark - Private methods

- (UIActivityIndicatorView*)activityIndicator {
    if (!_activityIndicator && self.isViewLoaded) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicator.hidesWhenStopped = YES;
        _activityIndicator.hidden = YES;
        _activityIndicator.backgroundColor = [UIColor whiteColor];
        _activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
        [self.tableView.superview insertSubview:_activityIndicator aboveSubview:self.tableView];
        [self configureActivityIndicatorLayoutConstraints];
    }
    
    return _activityIndicator;
}

- (void)dealloc {
    _isDealocProcessing = YES;
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}

@end