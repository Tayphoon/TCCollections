//
//  TCTableViewController.m
//  TCCollections
//
//  Created by Tayphoon on 20.11.14.
//  Copyright (c) 2014 Tayphoon. All rights reserved.
//

#import "TCTableViewController.h"
#import "TCCollectionsConstants.h"
#import "TCTableViewCell.h"
#import "TCSectionHeaderView.h"

@interface TCTableViewController() {
    UITableView * _tableView;
    BOOL _isDealocProcessing;
    UIActivityIndicatorView * _activityIndicator;
}

@property (nonatomic, assign) UIEdgeInsets tableInsets;
@property (nonatomic, strong) NSLayoutConstraint * activityIndicatorTopConstraint;

@end

@implementation TCTableViewController

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
        
        //Disable estimated heights by default to fix layout issues for iOS 11
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        
        if([_tableView respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) {
            _tableView.cellLayoutMarginsFollowReadableWidth = NO;
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

- (void)setTableViewModel:(id<TCTableViewModel>)tableViewModel {
    _tableViewModel.delegate = nil;
    _tableViewModel = tableViewModel;
    _tableViewModel.delegate = self;
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView {
    return [self.tableViewModel numberOfSections];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.tableViewModel numberOfItemsInSection:section];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[self.tableViewModel reuseIdentifierForIndexPath:indexPath]];
    
    if ([cell conformsToProtocol:@protocol(TCTableViewCell)]) {
        UITableViewCell<TCTableViewCell> * tableCell = (UITableViewCell<TCTableViewCell>*)cell;
        tableCell.item = [self.tableViewModel itemAtIndexPath:indexPath];
    }
    
    return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self.tableViewModel respondsToSelector:@selector(heightForHeaderInSection:constrainedToSize:)]) {
        return [self.tableViewModel heightForHeaderInSection:section constrainedToSize:tableView.bounds.size];
    }
    
    return 0;
}

- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section {
    UIView * sectionHeader;
    if ([self.tableViewModel respondsToSelector:@selector(reuseIdentifierForHeaderInSection:)]) {
        NSString * reuseIdentifier = [self.tableViewModel reuseIdentifierForHeaderInSection:section];
        sectionHeader = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseIdentifier];
    }
    return sectionHeader;
}

- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section {
    UIView * sectionFooter;
    if ([self.tableViewModel respondsToSelector:@selector(reuseIdentifierForFooterInSection:)]) {
        NSString * reuseIdentifier = [self.tableViewModel reuseIdentifierForFooterInSection:section];
        sectionFooter = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuseIdentifier];
    }
    return sectionFooter;
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.tableViewModel titleForHeaderInSection:section];
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    return [self.tableViewModel heightForItemAtIndexPath:indexPath constrainedToSize:tableView.frame.size];
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
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case TCCollectionsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationRight];
            break;
        case TCCollectionsChangeMove:
            if (![indexPath isEqual:newIndexPath]) {
                [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                                      withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.tableView insertRowsAtIndexPaths:@[newIndexPath]
                                      withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            break;
        case TCCollectionsChangeUpdate:
            if(indexPath && newIndexPath && ![indexPath isEqual:newIndexPath]) {
                [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                                      withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.tableView insertRowsAtIndexPaths:@[newIndexPath]
                                      withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            else if(indexPath) {
                [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                                      withRowAnimation:UITableViewRowAnimationNone];
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
        _noDataLabel.hidden = ([self.tableViewModel numberOfItemsInSection:0] > 0);
    }
}

- (BOOL)isActivityIndicatorShown {
    return _activityIndicator && !_activityIndicator.isHidden;
}

- (void)showActivityIndicatorAnimated:(BOOL)animated completion:(void (^)(void))completion {
    if (!self.isActivityIndicatorShown) {
        [self.activityIndicator startAnimating];
        
        CGFloat indicatorHeight = self.activityIndicator.frame.size.height;
        
        self.tableInsets = self.tableView.contentInset;
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

        __weak typeof(self) weakSelf = self;
        void (^completionBlock)(BOOL finished) = ^(BOOL finished)
        {
            self.tableView.contentInset = weakSelf.tableInsets;
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
                                 
                                 self.tableView.contentInset = weakSelf.tableInsets;
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
    [self.tableView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.tableView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    [self.tableView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.tableView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
}

- (void)configureNoDataLayoutConstraintsForView:(UIView*)superView {
    [self.noDataLabel.topAnchor constraintEqualToAnchor:superView.topAnchor].active = YES;
    [self.noDataLabel.bottomAnchor constraintEqualToAnchor:superView.bottomAnchor].active = YES;
    [self.noDataLabel.leadingAnchor constraintEqualToAnchor:superView.leadingAnchor].active = YES;
    [self.noDataLabel.trailingAnchor constraintEqualToAnchor:superView.trailingAnchor].active = YES;
}

- (void)configureActivityIndicatorLayoutConstraints {
    self.activityIndicatorTopConstraint = [self.activityIndicator.topAnchor constraintEqualToAnchor:self.tableView.topAnchor constant:-30];
    self.activityIndicatorTopConstraint.active = YES;
    [self.activityIndicator.leadingAnchor constraintEqualToAnchor:self.tableView.leadingAnchor].active = YES;
    [self.activityIndicator.trailingAnchor constraintEqualToAnchor:self.tableView.trailingAnchor].active = YES;
    [self.activityIndicator.heightAnchor constraintEqualToConstant:30.0f].active = YES;
}

#pragma mark - Private methods

- (UIActivityIndicatorView*)activityIndicator {
    if (!_activityIndicator && self.isViewLoaded) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicator.hidesWhenStopped = YES;
        _activityIndicator.hidden = YES;
        _activityIndicator.backgroundColor = [UIColor clearColor];
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
