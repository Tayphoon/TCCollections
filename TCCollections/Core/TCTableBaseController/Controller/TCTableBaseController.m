//
//  TCTableBaseController.m
//  Tayphoon
//
//  Created by Tayphoon on 20.11.14.
//  Copyright (c) 2014 Tayphoon. All rights reserved.
//

#import "TCTableBaseController.h"
#import "TCCollectionsConstants.h"

@interface TCTableBaseController() {
    UITableView * _tableView;
    BOOL _isDealocProcessing;
    UIEdgeInsets _tableInsets;
}

@property (nonatomic, strong) UIActivityIndicatorView * activityIndicator;

@end

@implementation TCTableBaseController

- (id)init {
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(!self.tableView.superview) {
        [self.view addSubview:self.tableView];
    }
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (UITableView*)tableView {
    if(!_tableView && !_isDealocProcessing && self.isViewLoaded) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        if([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [_tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        if([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
    return _tableView;
}

- (UILabel*)noDataLabel {
    if(!_noDataLabel) {
        _noDataLabel = [[UILabel alloc] init];
        [_noDataLabel setFont:[UIFont systemFontOfSize:18.0f]];
        [_noDataLabel setTextColor:[UIColor lightGrayColor]];
        _noDataLabel.textAlignment = NSTextAlignmentCenter;
        _noDataLabel.backgroundColor = [UIColor clearColor];
        _noDataLabel.numberOfLines = 0;
        _noDataLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _noDataLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _noDataLabel.hidden = YES;
        
        if (self.tableView) {
            [self.view insertSubview:_noDataLabel belowSubview:self.tableView];
            _noDataLabel.frame = self.tableView.frame;
        }
        else {
            [self.view addSubview:_noDataLabel];
            _noDataLabel.frame = self.view.frame;
        }
    }
    
    return _noDataLabel;
}

- (void)setModel:(id<TCTableModel>)model {
    _model.delegate = nil;
    _model = model;
    _model.delegate = self;
}

- (void)reloadDataWithCompletion:(void (^)(NSError *error))completion {
    void (^completionBlock)(NSError *error) = ^(NSError *error) {
        if(!error) {
            [self.tableView reloadData];
        }
        
        [self updateNoDataLabelVisibility];

        if (completion) {
            completion(error);
        }
    };
    
    if(self.model) {
        [self.model updateModelWithCompletion:completionBlock];
    }
    else {
        completionBlock(nil);
    }
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

- (void)modelWillChangeContent:(id<TCTableModel>)model {
    [self.tableView beginUpdates];
}

- (void)model:(id<TCTableModel>)model didChangeSectionAtIndex:(NSUInteger)sectionIndex forChangeType:(NSUInteger)type {
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

- (void)model:(id<TCTableModel>)model didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSUInteger)type newIndexPath:(NSIndexPath *)newIndexPath {
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

- (void)modelDidChangeContent:(id<TCTableModel>)model {
    [self updateNoDataLabelVisibility];
    [self.tableView endUpdates];
}

- (void)modelDidChanged:(id<TCTableModel>)model {
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
    return _activityIndicator && _activityIndicator.superview;
}

- (void)showActivityIndicatorAnimated:(BOOL)animated completion:(void (^)(void))completion {
    if (self.activityIndicator.isHidden) {
        [self.activityIndicator startAnimating];
        
        CGFloat indicatorHeight = self.activityIndicator.frame.size.height;
        self.activityIndicator.frame = CGRectMake(self.tableView.frame.origin.x,
                                                  self.tableView.frame.origin.y - indicatorHeight,
                                                  self.tableView.frame.size.width,
                                                  self.activityIndicator.frame.size.height);
        [self.tableView.superview insertSubview:self.activityIndicator aboveSubview:self.tableView];
        
        self.activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _tableInsets = self.tableView.contentInset;
        CGPoint contentOffset = self.tableView.contentOffset;
        UIEdgeInsets contentInsets = self.tableView.contentInset;
        contentInsets.top = indicatorHeight;
        contentOffset.y -= indicatorHeight;
        
        [UIView animateWithDuration:animated ? 0.3 : 0.0
                              delay:0.0
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.activityIndicator.frame = CGRectMake(self.tableView.frame.origin.x,
                                                                       self.tableView.frame.origin.y,
                                                                       self.tableView.frame.size.width,
                                                                       self.activityIndicator.frame.size.height);

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
        CGFloat indicatorHeight = self.activityIndicator.frame.size.height;

        void (^completionBlock)(BOOL finished) = ^(BOOL finished)
        {
            self.tableView.contentInset = _tableInsets;
            [self.activityIndicator stopAnimating];
            [self.activityIndicator removeFromSuperview];
            if (finished && completion) {
                completion();
            }
        };
        
       if (animated) {
            [UIView animateWithDuration:0.3
                                  delay:0.0
                                options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 self.activityIndicator.frame = CGRectMake(self.tableView.frame.origin.x,
                                                                           self.tableView.frame.origin.y - indicatorHeight,
                                                                           self.tableView.frame.size.width,
                                                                           self.activityIndicator.frame.size.height);
                                 
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

#pragma mark - Private methods

- (UIActivityIndicatorView*)activityIndicator {
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicator.frame = CGRectMake(0.0f, -30, self.view.frame.size.width, 30);
        _activityIndicator.hidesWhenStopped = YES;
        _activityIndicator.hidden = YES;
        _activityIndicator.backgroundColor = [UIColor whiteColor];
    }
    
    return _activityIndicator;
}

- (void)dealloc {
    _isDealocProcessing = YES;
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
}

@end