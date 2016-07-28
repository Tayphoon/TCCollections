//
//  TCTitledCollectionController.m
//  Tayphoon
//
//  Created by Tayphoon on 04.02.16.
//  Copyright © 2016 Proarise. All rights reserved.
//

#import "TCTitledCollectionController.h"
#import "TCCollectionsConstants.h"

@interface TCTitledCollectionController() <TCTitledCollectionModelDelegate> {
    TCTitledCollectionView * _collectionView;
    UIActivityIndicatorView * _activityIndicator;
}

@end

@implementation TCTitledCollectionController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(!self.collectionView.superview) {
        [self.view addSubview:self.collectionView];
    }
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    if (_collectionView) {
        _collectionView.frame = self.view.bounds;
    }
}

- (TCTitledCollectionView*)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 0.0f;
        layout.minimumInteritemSpacing = 0.0f;
        layout.sectionInset = UIEdgeInsetsZero;
        
        _collectionView = [[TCTitledCollectionView alloc] init];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _collectionView.collectionViewLayout = layout;
        _collectionView.collectionView.backgroundColor = [UIColor clearColor];
        
        UICollectionViewFlowLayout * titleLayout = [[UICollectionViewFlowLayout alloc] init];
        titleLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        titleLayout.sectionInset = UIEdgeInsetsMake(0, 375 / 2, 0, 375 / 2);
        _collectionView.titlesCollectionView.collectionViewLayout = titleLayout;
    }
    return _collectionView;
}

- (UILabel*)noDataLabel {
    if(!_noDataLabel) {
        _noDataLabel = [[UILabel alloc] init];
        [_noDataLabel setFont:[UIFont systemFontOfSize:15]];
        [_noDataLabel setTextColor:[UIColor blackColor]];
        _noDataLabel.textAlignment = NSTextAlignmentCenter;
        _noDataLabel.backgroundColor = [UIColor clearColor];
        _noDataLabel.numberOfLines = 0;
        _noDataLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _noDataLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _noDataLabel.hidden = YES;
        
        if (self.collectionView) {
            [self.view insertSubview:_noDataLabel belowSubview:self.collectionView];
            _noDataLabel.frame = self.collectionView.frame;
        }
        else {
            [self.view addSubview:_noDataLabel];
            _noDataLabel.frame = self.view.frame;
        }
    }
    
    return _noDataLabel;
}

- (void)setModel:(id<TCTitledCollectionModel>)model {
    _model.delegate = nil;
    _model = model;
    _model.delegate = self;
}

- (void)collectionViewDidScrollToBottom:(UICollectionView*)collectionView {
    
}

#pragma mark - UICollectionView DataSource

- (NSInteger)numberOfSectionsInTitledCollectionView:(TCTitledCollectionView *)collectionView onPage:(NSInteger)pageIndex {
    return [self.model numberOfSectionsOnPage:pageIndex];
}

- (NSInteger)titledCollectionView:(TCTitledCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section onPage:(NSInteger)pageIndex {
    return [self.model numberOfItemsInSection:section onPage:pageIndex];
}

- (NSInteger)numberOfTitlesInTitledCollectionView:(TCTitledCollectionView *)collectionView {
    return [self.model numberOfTitles];
}

- (UICollectionViewCell *)titledCollectionView:(TCTitledCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath onPage:(NSInteger)pageIndex {
    UICollectionViewCell * cell = (UICollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:[self.model reuseIdentifierForCellAtIndexPath:indexPath]
                                                                                                   forIndexPath:indexPath
                                                                                                         onPage:pageIndex];
    
    if ([cell conformsToProtocol:@protocol(TCCollectionCell)]) {
        UICollectionViewCell<TCCollectionCell> * collectionCell = (UICollectionViewCell<TCCollectionCell>*)cell;
        collectionCell.item = [self.model itemAtIndexPath:indexPath onPage:pageIndex];
    }
    
    return cell;
}

- (UICollectionViewCell *)titledCollectionView:(TCTitledCollectionView *)collectionView cellForTitleAtIndex:(NSInteger)index {
    NSString * reuseIdentifier = [self.model reuseIdentifierForTitleCellAtIndex:index];
    UICollectionViewCell * cell = (UICollectionViewCell*)[collectionView dequeueTitleReusableCellWithReuseIdentifier:reuseIdentifier
                                                                                                            forIndex:index];
    
    if ([cell conformsToProtocol:@protocol(TCCollectionCell)]) {
        UICollectionViewCell<TCCollectionCell> * collectionCell = (UICollectionViewCell<TCCollectionCell>*)cell;
        collectionCell.item = [self.model titleItemAtIndex:index];
    }
    
    return cell;
}

- (UICollectionReusableView *)titledCollectionView:(TCTitledCollectionView *)collectionView
                 viewForSupplementaryElementOfKind:(NSString *)kind
                                       atIndexPath:(NSIndexPath *)indexPath
                                            onPage:(NSInteger)pageIndex {
    NSString * reuseIdentifier = [self.model reuseIdentifierForSupplementaryElementOfKind:kind atIndexPath:indexPath];
    UICollectionReusableView * supplementaryView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                                                                      withReuseIdentifier:reuseIdentifier
                                                                                             forIndexPath:indexPath
                                                                                                   onPage:pageIndex];
    
    if ([supplementaryView respondsToSelector:@selector(setTitle:)]) {
        NSString * title = [self.model titleForSupplementaryElementOfKind:kind atIndexPath:indexPath];
        [supplementaryView setValue:title forKey:@"title"];
    }
    
    return supplementaryView;
}

#pragma mark - UICollectionViewLayout Delegate

- (CGSize)titledCollectionView:(TCTitledCollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.model sizeForItemAtIndexPath:indexPath
                            constrainedToSize:collectionView.collectionView.frame.size];
}

- (void)titledCollectionView:(TCTitledCollectionView *)collectionView didChangePageIndex:(NSInteger)pageIndex {
    [self reloadDataOnPage:pageIndex];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGFloat scrollOffset = scrollView.contentOffset.y + scrollView.frame.size.height -
    scrollView.contentInset.bottom - scrollView.contentInset.top;
    
    if (scrollOffset >= roundf(scrollView.contentSize.height)) {
        [self collectionViewDidScrollToBottom:self.collectionView];
    }
}

#pragma mark - TCTitledCollectionModel Delegate

- (void)modelWillChangeContent:(id<TCTitledCollectionModel>)model {
    [self.collectionView beginUpdates];
    [self.collectionView beginUpdatesOnPage:self.collectionView.selectedPage];
}

- (void)modelDidChangeContent:(id<TCTitledCollectionModel>)model {
    [self updateNoDataLabelVisibility];
    [self.collectionView endUpdatesOnPage:self.collectionView.selectedPage];
    [self.collectionView endUpdates];
}

- (void)model:(id<TCTitledCollectionModel>)model didChangePageAtIndex:(NSUInteger)pageIndex forChangeType:(NSUInteger)type {
    [self.collectionView insertPages:[NSIndexSet indexSetWithIndex:pageIndex] animated:YES];
}

- (void)model:(id<TCTitledCollectionModel>)model didChangeSectionAtIndex:(NSUInteger)sectionIndex onPage:(NSInteger)pageIndex forChangeType:(NSUInteger)type  {
    switch(type) {
        case TCCollectionsChangeInsert:
            [self.collectionView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                                         onPage:pageIndex
                                       animated:YES];
            break;
        case TCCollectionsChangeDelete:
            [self.collectionView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                                         onPage:pageIndex
                                       animated:YES];
            break;
            
        case TCCollectionsChangeUpdate:
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                                         onPage:pageIndex
                                       animated:YES];
            break;
    }
}

- (void)model:(id<TCTitledCollectionModel>)model didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSUInteger)type newIndexPath:(NSIndexPath *)newIndexPath onPage:(NSInteger)pageIndex {
    switch(type) {
        case TCCollectionsChangeInsert:
            [self.collectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                                  onPage:pageIndex
                                                animated:YES];
            break;
        case TCCollectionsChangeDelete:
            [self.collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                                  onPage:pageIndex
                                                animated:YES];
            break;
        case TCCollectionsChangeMove:
            [self.collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                                  onPage:pageIndex
                                                animated:YES];
            [self.collectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                                  onPage:pageIndex
                                                animated:YES];
            break;
        case TCCollectionsChangeUpdate:
            if ([indexPath isEqual:newIndexPath] || newIndexPath == nil) {
                [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                                      onPage:pageIndex
                                                    animated:YES];
            }
            else if(indexPath && newIndexPath) {
                [self.collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                                                      onPage:pageIndex
                                                    animated:YES];
                [self.collectionView insertItemsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                                                      onPage:pageIndex
                                                    animated:YES];
            }
            break;
    }
}

- (void)modelDidChanged:(id<TCTitledCollectionModel>)model {
    [self updateNoDataLabelVisibility];
    [self.collectionView reloadData];
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
        
        [self.collectionView.superview insertSubview:self.activityIndicator aboveSubview:self.collectionView];
        
        self.activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.activityIndicator.frame = CGRectMake(self.collectionView.frame.origin.x,
                                                  self.collectionView.frame.origin.y,
                                                  self.collectionView.frame.size.width,
                                                  self.collectionView.frame.size.height);
        
        if (completion) {
            completion();
        }
    }
}

- (void)hideActivityIndicatorAnimated:(BOOL)animated completion:(void (^)(void))completion {
    if (self.isActivityIndicatorShown) {
        [self.activityIndicator stopAnimating];
        [self.activityIndicator removeFromSuperview];
        if (completion) {
            completion();
        }
    }
}

#pragma mark - Private methods

- (void)reloadDataOnPage:(NSInteger)pageIndex {
    if (![self.model isDataLoadedForPage:pageIndex]) {
        [self showActivityIndicatorAnimated:YES
                                 completion:nil];
        
        [self.model loadItemsForPageAtIndex:pageIndex
                                 completion:^(NSError *error) {
                                     if (!error) {
                                         [self.collectionView reloadDataOnPage:pageIndex];
                                     }
                                     
                                     [self hideActivityIndicatorAnimated:NO
                                                              completion:nil];
                                 }];
    }
}

- (UIActivityIndicatorView*)activityIndicator {
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicator.frame = CGRectMake(0.0f, -30, self.view.frame.size.width, 30);
        _activityIndicator.hidesWhenStopped = YES;
        _activityIndicator.hidden = YES;
        _activityIndicator.backgroundColor = [UIColor clearColor];
    }
    
    return _activityIndicator;
}

@end
