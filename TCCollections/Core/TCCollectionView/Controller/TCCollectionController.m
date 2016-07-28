//
//  TCCollectionController.m
//  Tayphoon
//
//  Created by Tayphoon on 27.08.15.
//  Copyright (c) 2015 Tayphoon. All rights reserved.
//

#import <OALayoutAnchor/OALayoutAnchor.h>

#import "TCCollectionController.h"
#import "UICollectionView+Updates.h"
#import "TCCollectionsConstants.h"

@interface TCCollectionController() {
    UICollectionView * _collectionView;
    UIActivityIndicatorView * _activityIndicator;
}

@end

@implementation TCCollectionController

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (UICollectionView*)collectionView {
    if (!_collectionView && self.isViewLoaded) {
        UICollectionViewFlowLayout * collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                             collectionViewLayout:collectionViewFlowLayout];
        [self.view addSubview:_collectionView];
        [self configureCollectionViewLayoutConstraints];
    }
    
    return _collectionView;
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
        
        if (self.collectionView) {
            [self.view insertSubview:_noDataLabel belowSubview:self.collectionView];
            [self configureNoDataLayoutConstraintsForView:self.collectionView];
        }
        else {
            [self.view addSubview:_noDataLabel];
            [self configureNoDataLayoutConstraintsForView:self.view];
        }
    }
    
    return _noDataLabel;
}

- (void)setModel:(id<TCCollectionViewModel>)model {
    _model.delegate = nil;
    _model = model;
    _model.delegate = self;
}

- (void)collectionViewDidScrollToBottom:(UICollectionView*)collectionView {
    
}

#pragma mark - UICollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.model numberOfSections];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.model numberOfItemsInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:[self.model reuseIdentifierForCellAtIndexPath:indexPath]
                                                                            forIndexPath:indexPath];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    NSString * reuseIdentifier = [self.model reuseIdentifierForSupplementaryElementOfKind:kind atIndexPath:indexPath];
    UICollectionReusableView * supplementaryView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                      withReuseIdentifier:reuseIdentifier
                                                                                             forIndexPath:indexPath];
    
    if ([supplementaryView respondsToSelector:@selector(setTitle:)]) {
        NSString * title = [self.model titleForSupplementaryElementOfKind:kind atIndexPath:indexPath];
        [supplementaryView setValue:title forKey:@"title"];
    }
    
    return supplementaryView;
}

#pragma mark - UICollectionViewLayout Delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.model sizeForItemAtIndexPath:indexPath constrainedToSize:CGSizeMake(collectionView.frame.size.width, 0)];
}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGFloat scrollOffset = scrollView.contentOffset.y + scrollView.frame.size.height -
    scrollView.contentInset.bottom - scrollView.contentInset.top;
    
    if (scrollOffset >= roundf(scrollView.contentSize.height)) {
        [self collectionViewDidScrollToBottom:self.collectionView];
    }
}

#pragma mark - TCCollectionViewModel Delegate

- (void)modelWillChangeContent:(id<TCCollectionViewModel>)model {
    [self.collectionView beginUpdates];
}

- (void)model:(id<TCCollectionViewModel>)model didChangeSectionAtIndex:(NSUInteger)sectionIndex forChangeType:(NSUInteger)type {
    switch(type) {
        case TCCollectionsChangeInsert:
            [self.collectionView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                                       animated:YES];
            break;
        case TCCollectionsChangeDelete:
            [self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                                       animated:YES];
            break;
    }
}

- (void)model:(id<TCCollectionViewModel>)model didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSUInteger)type newIndexPath:(NSIndexPath *)newIndexPath {
    switch(type) {
        case TCCollectionsChangeInsert:
            [self.collectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                                animated:YES];
            break;
        case TCCollectionsChangeDelete:
            [self.collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                                animated:YES];
            break;
        case TCCollectionsChangeMove:
            [self.collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                                animated:YES];
            [self.collectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                                animated:YES];
            break;
        case TCCollectionsChangeUpdate:
            if ([indexPath isEqual:newIndexPath] || newIndexPath == nil) {
                [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                                    animated:YES];
            }
            else if(indexPath && newIndexPath) {
                [self.collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                                    animated:YES];
                [self.collectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                                    animated:YES];
            }
            break;
    }
}

- (void)modelDidChangeContent:(id<TCCollectionViewModel>)model {
    [self updateNoDataLabelVisibility];
    [self.collectionView endUpdates];
}

- (void)modelDidChanged:(id<TCCollectionViewModel>)model {
    [self updateNoDataLabelVisibility];
    [self.collectionView reloadData];
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
        
        if (completion) {
            completion();
        }
    }
}

- (void)hideActivityIndicatorAnimated:(BOOL)animated completion:(void (^)(void))completion {
    if (self.isActivityIndicatorShown) {
        [self.activityIndicator stopAnimating];
        
        if (completion) {
            completion();
        }
    }
}

#pragma mark - AutoLayout methods

- (void)configureCollectionViewLayoutConstraints {
    [_collectionView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [_collectionView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    [_collectionView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [_collectionView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
}

- (void)configureNoDataLayoutConstraintsForView:(UIView*)superView {
    [_noDataLabel.topAnchor constraintEqualToAnchor:superView.topAnchor].active = YES;
    [_noDataLabel.bottomAnchor constraintEqualToAnchor:superView.bottomAnchor].active = YES;
    [_noDataLabel.leadingAnchor constraintEqualToAnchor:superView.leadingAnchor].active = YES;
    [_noDataLabel.trailingAnchor constraintEqualToAnchor:superView.trailingAnchor].active = YES;
}

- (void)configureActivityIndicatorLayoutConstraints {
    [_activityIndicator.topAnchor constraintEqualToAnchor:self.collectionView.topAnchor].active = YES;
    [_activityIndicator.leadingAnchor constraintEqualToAnchor:self.collectionView.leadingAnchor].active = YES;
    [_activityIndicator.trailingAnchor constraintEqualToAnchor:self.collectionView.trailingAnchor].active = YES;
    [_activityIndicator.heightAnchor constraintEqualToConstant:30.0f].active = YES;
}

#pragma mark - Private methods

- (UIActivityIndicatorView*)activityIndicator {
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicator.hidesWhenStopped = YES;
        _activityIndicator.hidden = YES;
        _activityIndicator.backgroundColor = [UIColor whiteColor];
        _activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
        [self.collectionView.superview insertSubview:_activityIndicator aboveSubview:self.collectionView];
        [self configureActivityIndicatorLayoutConstraints];
    }
    
    return _activityIndicator;
}

@end
