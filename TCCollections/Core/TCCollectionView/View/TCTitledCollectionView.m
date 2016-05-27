	//
//  TCTitledCollectionView.m
//  Blueprint
//
//  Created by Tayphoon on 26.11.15.
//  Copyright © 2015 Tayphoon. All rights reserved.
//
#import <objc/message.h>

#import "TCTitledCollectionView.h"
#import "UICollectionView+Updates.h"

NSString * const TCCollectionViewCellReuseIdentifier = @"CollectionViewCellReuseIdentifier";

@interface TCCollectionViewCell : UICollectionViewCell

@property (nonatomic, readonly) UICollectionView * collectionView;

@end

@implementation TCCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.sectionInset = UIEdgeInsetsZero;
        
        _collectionView  = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                                collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.contentInset = UIEdgeInsetsZero;
        [self.contentView addSubview:_collectionView];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.collectionView.frame = self.bounds;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.collectionView.delegate = nil;
    self.collectionView.dataSource = nil;
    [self.collectionView reloadData];
    self.collectionView.contentOffset = CGPointZero;
}

@end

@interface TCTitledCollectionView()<UICollectionViewDataSource, UICollectionViewDelegate> {
    NSMutableDictionary * _registeredCellClasses;
    NSMutableDictionary * _registeredSupplementaryViewClasses;
}

@property (nonatomic, weak) TCCollectionViewCell * currentCell;

@end

@implementation TCTitledCollectionView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initialize];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initialize];
}

- (void)setContentInset:(UIEdgeInsets)contentInset {
    if (!UIEdgeInsetsEqualToEdgeInsets(_contentInset, contentInset)) {
        _contentInset = contentInset;
        [self setNeedsLayout];
    }
}

- (NSInteger)selectedPage {
    return [self titleSelectedIndex];
}

- (void)setCollectionViewLayout:(UICollectionViewLayout *)collectionViewLayout {
    _collectionViewLayout = collectionViewLayout;
    
    TCCollectionViewCell * cell = [self visibleCell];
    
    if (!cell) {
        cell = self.currentCell;
    }
    
    //we should copy layou because reuse UICollectionViewLayout make crash
    cell.collectionView.collectionViewLayout = [self tryCopyLayout:_collectionViewLayout];
}

- (void)setTitleBackgroundViewColor:(UIColor *)titleBackgroundViewColor {
    _titleBackgroundViewColor = titleBackgroundViewColor;
    self.titlesCollectionView.backgroundColor = _titleBackgroundViewColor;
}

- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier {
    _registeredCellClasses[identifier] = cellClass;
    
    TCCollectionViewCell * cell = [self visibleCell];
    if (cell) {
        for (NSString * identy in [_registeredCellClasses allKeys]) {
            [cell.collectionView registerClass:_registeredCellClasses[identy]
                    forCellWithReuseIdentifier:identy];
        }
    }
}

- (void)registerClass:(Class)cellClass forTitleCellWithReuseIdentifier:(NSString *)identifier {
    [self.titlesCollectionView registerClass:cellClass forCellWithReuseIdentifier:identifier];
}

- (void)beginUpdates {
    [self.collectionView beginUpdates];
    [self.titlesCollectionView beginUpdates];
}

- (void)insertPages:(NSIndexSet *)pages animated:(BOOL)animated {
    NSMutableArray * indexPaths = [NSMutableArray array];
    
    [pages enumerateIndexesUsingBlock:^(NSUInteger row, BOOL * stop) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:row inSection:0]];
    }];
    
    
    [self.collectionView insertItemsAtIndexPaths:indexPaths animated:animated];
    [self.titlesCollectionView insertItemsAtIndexPaths:indexPaths animated:animated];
}

- (void)deletePages:(NSIndexSet *)pages animated:(BOOL)animated {
    NSMutableArray * indexPaths = [NSMutableArray array];
    
    [pages enumerateIndexesUsingBlock:^(NSUInteger row, BOOL * stop) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:row inSection:0]];
    }];
    
    [self.collectionView deleteItemsAtIndexPaths:indexPaths animated:animated];
    [self.titlesCollectionView deleteItemsAtIndexPaths:indexPaths animated:animated];
}

- (void)reloadPages:(NSIndexSet *)pages animated:(BOOL)animated {
    NSMutableArray * indexPaths = [NSMutableArray array];
    
    [pages enumerateIndexesUsingBlock:^(NSUInteger row, BOOL * stop) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:row inSection:0]];
    }];
    
    [self.collectionView reloadItemsAtIndexPaths:indexPaths animated:animated];
    [self.titlesCollectionView reloadItemsAtIndexPaths:indexPaths animated:animated];
}

- (void)endUpdates {
    [self.collectionView endUpdates];
    [self.titlesCollectionView endUpdates];
    
    NSUInteger currentPage = [self currentPageIndex];
    if (currentPage != NSNotFound) {
        [self.titlesCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:currentPage inSection:0]
                                                animated:NO
                                          scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    }
}


- (void)beginUpdatesOnPage:(NSInteger)pageIndex {
    if (pageIndex == [self currentPageIndex]) {
        TCCollectionViewCell * cell = [self visibleCell];
        [cell.collectionView beginUpdates];
    }
}

- (void)insertSections:(NSIndexSet *)sections onPage:(NSInteger)pageIndex animated:(BOOL)animated {
    if (pageIndex == [self currentPageIndex]) {
        TCCollectionViewCell * cell = [self visibleCell];
        [cell.collectionView insertSections:sections animated:animated];
    }
}

- (void)deleteSections:(NSIndexSet *)sections onPage:(NSInteger)pageIndex animated:(BOOL)animated {
    if (pageIndex == [self currentPageIndex]) {
        TCCollectionViewCell * cell = [self visibleCell];
        [cell.collectionView deleteSections:sections animated:animated];
    }
}

- (void)reloadSections:(NSIndexSet *)sections onPage:(NSInteger)pageIndex animated:(BOOL)animated {
    if (pageIndex == [self currentPageIndex]) {
        TCCollectionViewCell * cell = [self visibleCell];
        [cell.collectionView reloadSections:sections animated:animated];
    }
}

- (void)insertItemsAtIndexPaths:(NSArray *)indexPaths onPage:(NSInteger)pageIndex animated:(BOOL)animated {
    if (pageIndex == [self currentPageIndex]) {
        TCCollectionViewCell * cell = [self visibleCell];
        [cell.collectionView insertItemsAtIndexPaths:indexPaths animated:animated];
    }
}

- (void)deleteItemsAtIndexPaths:(NSArray *)indexPaths onPage:(NSInteger)pageIndex animated:(BOOL)animated {
    if (pageIndex == [self currentPageIndex]) {
        TCCollectionViewCell * cell = [self visibleCell];
        [cell.collectionView deleteItemsAtIndexPaths:indexPaths animated:animated];
    }
}

- (void)reloadItemsAtIndexPaths:(NSArray *)indexPaths onPage:(NSInteger)pageIndex animated:(BOOL)animated{
    if (pageIndex == [self currentPageIndex]) {
        TCCollectionViewCell * cell = [self visibleCell];
        [cell.collectionView reloadItemsAtIndexPaths:indexPaths animated:animated];
    }
}

- (void)endUpdatesOnPage:(NSInteger)pageIndex {
    if (pageIndex == [self currentPageIndex]) {
        TCCollectionViewCell * cell = [self visibleCell];
        [cell.collectionView endUpdates];
    }
}

- (void)reloadData {
    [self.titlesCollectionView reloadData];
    [self.collectionView reloadData];
}

- (void)reloadDataOnPage:(NSInteger)pageIndex {
    TCCollectionViewCell * cell = (TCCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:pageIndex inSection:0]];
    if (cell) {
        [cell.collectionView reloadData];
    }
    
    if ([self.collectionView.visibleCells count] == 0) {
        [self.collectionView reloadData];
    }
}

- (UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier
                                                    forIndexPath:(NSIndexPath *)indexPath
                                                          onPage:(NSInteger)pageIndex {
    TCCollectionViewCell * cell = (TCCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:pageIndex inSection:0]];
    
    if (!cell) {
        cell = self.currentCell;
    }
    
    return [cell.collectionView dequeueReusableCellWithReuseIdentifier:identifier
                                                          forIndexPath:indexPath];
}

- (UICollectionReusableView *)dequeueReusableSupplementaryViewOfKind:(NSString *)elementKind
                                                 withReuseIdentifier:(NSString *)identifier
                                                        forIndexPath:(NSIndexPath *)indexPath
                                                              onPage:(NSInteger)pageIndex {
    TCCollectionViewCell * cell = (TCCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:pageIndex inSection:0]];
    
    if (!cell) {
        cell = self.currentCell;
    }
    
    return [cell.collectionView dequeueReusableSupplementaryViewOfKind:elementKind
                                                   withReuseIdentifier:identifier
                                                          forIndexPath:indexPath];
}

- (UICollectionViewCell *)dequeueTitleReusableCellWithReuseIdentifier:(NSString *)identifier forIndex:(NSInteger)index {
    return [self.titlesCollectionView dequeueReusableCellWithReuseIdentifier:identifier
                                                                forIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
}

- (void)selectPageAtIndex:(NSInteger)pageIndex animated:(BOOL)animated {
    [self.titlesCollectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:pageIndex inSection:0]
                                            animated:animated
                                      scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForRow:pageIndex inSection:0]
                                      animated:animated
                                scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
}

- (void)scrollToPageAtIndex:(NSInteger)pageIndex animated:(BOOL)animated {
    [self.titlesCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:pageIndex inSection:0]
                                      atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                              animated:animated];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:pageIndex inSection:0]
                                atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                        animated:animated];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect actualBounds = UIEdgeInsetsInsetRect(self.bounds, self.contentInset);
    
    CGFloat titleViewHeight = [self heightForTitleView];
    self.titlesCollectionView.frame = CGRectMake(actualBounds.origin.x,
                                                 actualBounds.origin.y,
                                                 actualBounds.size.width,
                                                 titleViewHeight);
    
    CGFloat separatorViewHeight = 0.5f;
    _separatorView.frame = CGRectMake(actualBounds.origin.x,
                                      CGRectGetMaxY(self.titlesCollectionView.frame),
                                      actualBounds.size.width,
                                      separatorViewHeight);
    
    CGFloat collectionViewY = CGRectGetMaxY(self.titlesCollectionView.frame) + separatorViewHeight;
    self.collectionView.frame = CGRectMake(actualBounds.origin.x,
                                           collectionViewY,
                                           actualBounds.size.width,
                                           actualBounds.size.height - collectionViewY);
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGPoint centerPoint = CGPointMake(self.collectionView.frame.size.width / 2 + scrollView.contentOffset.x,
                                      self.collectionView.frame.size.height /2 + scrollView.contentOffset.y);
    NSIndexPath * indexPath = [self.collectionView indexPathForItemAtPoint:centerPoint];
    
    if (scrollView == self.collectionView && indexPath.row != [self titleSelectedIndex]) {
        [self.titlesCollectionView selectItemAtIndexPath:indexPath
                                                animated:YES
                                          scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
        [self performPageIndexDidChangedToIndex:indexPath.row];
    }
}

#pragma mark - UICollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (collectionView == self.titlesCollectionView || collectionView == self.collectionView) {
        return 1;
    }

    NSInteger pageIndex = [self pageIndexForCollectionView:collectionView];
    return [self.dataSource numberOfSectionsInTitledCollectionView:self onPage:pageIndex];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.titlesCollectionView && [self.dataSource respondsToSelector:@selector(numberOfTitlesInTitledCollectionView:)]) {
        return [self.dataSource numberOfTitlesInTitledCollectionView:self];
    }
    
    if (collectionView == self.collectionView && [self.dataSource respondsToSelector:@selector(numberOfTitlesInTitledCollectionView:)]) {
        return [self.dataSource numberOfTitlesInTitledCollectionView:self];
    }

    NSInteger pageIndex = [self pageIndexForCollectionView:collectionView];
    return [self.dataSource titledCollectionView:self
                          numberOfItemsInSection:section
                                          onPage:pageIndex];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.titlesCollectionView && [self.dataSource respondsToSelector:@selector(titledCollectionView:cellForTitleAtIndex:)]) {
        UICollectionViewCell * cell = [self.dataSource titledCollectionView:self cellForTitleAtIndex:indexPath.row];
        return cell;
    }
    
    if (collectionView == self.collectionView) {
        TCCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:TCCollectionViewCellReuseIdentifier
                                                                                forIndexPath:indexPath];
        
        self.currentCell = cell;
        
        for (NSString * identy in [_registeredCellClasses allKeys]) {
            [cell.collectionView registerClass:_registeredCellClasses[identy]
                    forCellWithReuseIdentifier:identy];
        }
        
        //we should copy layou because reuse UICollectionViewLayout make crash
        UICollectionViewLayout * layoutCopy = [self tryCopyLayout:_collectionViewLayout];
        
        cell.collectionView.collectionViewLayout = layoutCopy;
        cell.collectionView.delegate = self;
        cell.collectionView.dataSource = self;
        [cell.collectionView reloadData];

        return cell;
    }
    
    if ([self.dataSource respondsToSelector:@selector(titledCollectionView:cellForItemAtIndexPath:onPage:)]) {
        NSInteger pageIndex = [self pageIndexForCollectionView:collectionView];
        return [self.dataSource titledCollectionView:self cellForItemAtIndexPath:indexPath onPage:pageIndex];
    }
    
    return nil;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ((collectionView != self.titlesCollectionView && collectionView != self.collectionView) &&
        [self.dataSource respondsToSelector:@selector(titledCollectionView:viewForSupplementaryElementOfKind:atIndexPath:onPage:)]) {
        NSInteger pageIndex = [self pageIndexForCollectionView:collectionView];
        return [self.dataSource titledCollectionView:self
                   viewForSupplementaryElementOfKind:kind
                                         atIndexPath:indexPath
                                              onPage:pageIndex];
    }

    return nil;
}

#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.titlesCollectionView) {
        [self.titlesCollectionView scrollToItemAtIndexPath:indexPath
                                          atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                                  animated:YES];
        [self.collectionView scrollToItemAtIndexPath:indexPath
                                    atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                            animated:YES];
        
        [self performPageIndexDidChangedToIndex:indexPath.row];
    }
    else if (collectionView != self.collectionView &&
             [self.delegate respondsToSelector:@selector(titledCollectionView:didSelectItemAtIndexPath:onPage:)]) {
        NSInteger pageIndex = [self pageIndexForCollectionView:collectionView];
        [self.delegate titledCollectionView:self didSelectItemAtIndexPath:indexPath onPage:pageIndex];
    }
}

#pragma mark - UICollectionView Delegate Proxy

- (BOOL)respondsToSelector:(SEL)selector {
    if ([super respondsToSelector:selector]) {
        return YES;
    }
    return [_delegate respondsToSelector:selector];
}

- (id)forwardingTargetForSelector:(SEL)selector {
    id delegate = self.delegate;
    return [super respondsToSelector:selector] ? self : delegate;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    NSMethodSignature* signature = [super methodSignatureForSelector:selector];
    if (!signature && [self.delegate respondsToSelector:selector]) {
        id delegate = self.delegate;
        signature = [delegate methodSignatureForSelector:selector];
    }
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    if ([super respondsToSelector:invocation.selector]) {
        [super forwardInvocation:invocation];
    }
    else if ([self.delegate respondsToSelector:invocation.selector]) {
        [invocation invokeWithTarget:self.delegate];
    }
}

#pragma mark - UICollectionViewLayout Delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.titlesCollectionView && [self.delegate respondsToSelector:@selector(titledCollectionView:layout:sizeForTitleAtIndex:)]) {
        return [self.delegate titledCollectionView:self layout:collectionViewLayout sizeForTitleAtIndex:indexPath.row];
    }
    
    if (collectionView == self.collectionView) {
        return collectionView.frame.size;
    }
    
    if ([self.delegate respondsToSelector:@selector(titledCollectionView:layout:sizeForItemAtIndexPath:)]) {
        return [self.delegate titledCollectionView:self layout:collectionViewLayout sizeForItemAtIndexPath:indexPath];
    }
    
    return CGSizeZero;
}

#pragma mark - Private methods

- (NSUInteger)currentPageIndex {
    NSUInteger pageIndex = self.collectionView.contentOffset.x / CGRectGetWidth(self.collectionView.frame);
    return pageIndex;
}

- (NSInteger)titleSelectedIndex {
    NSArray * selectedItems = [self.titlesCollectionView indexPathsForSelectedItems];
    if ([selectedItems count] > 0) {
        return ((NSIndexPath*)[selectedItems firstObject]).row;
    }
    return NSNotFound;
}

- (TCCollectionViewCell*)visibleCell {
    NSArray * visibleCells = self.collectionView.visibleCells;
    TCCollectionViewCell * visibleCell = ([visibleCells count] > 0) ? [visibleCells objectAtIndex:0] : nil;
    return visibleCell;
}

- (void)initialize {
    _registeredCellClasses = [NSMutableDictionary dictionary];
    _registeredSupplementaryViewClasses = [NSMutableDictionary dictionary];

    _titlesCollectionView = [self makeCollectionView];
    _titlesCollectionView.backgroundColor = [UIColor whiteColor];
    _titlesCollectionView.showsHorizontalScrollIndicator = NO;
    _titlesCollectionView.contentInset = UIEdgeInsetsZero;
    [self addSubview:_titlesCollectionView];
    
    _separatorView = [[UIView alloc] init];
    _separatorView.backgroundColor = [UIColor lightGrayColor];
    _separatorView.clipsToBounds = YES;
    [self addSubview:_separatorView];

    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;

    _collectionView = [self makeCollectionView];
    [_collectionView registerClass:[TCCollectionViewCell class] forCellWithReuseIdentifier:TCCollectionViewCellReuseIdentifier];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.pagingEnabled = YES;
    _collectionView.collectionViewLayout = layout;
    [self addSubview:_collectionView];
    
    self.titleBackgroundViewColor = [UIColor whiteColor];
}

- (CGFloat)heightForTitleView {
    if ([self.delegate respondsToSelector:@selector(heightForTitleViewInTitledCollectionView:)]) {
        return [self.delegate heightForTitleViewInTitledCollectionView:self];
    }
    return 40.0f;
}

- (void)performPageIndexDidChangedToIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(titledCollectionView:didChangePageIndex:)]) {
        [self.delegate titledCollectionView:self didChangePageIndex:index];
    }
}

- (UICollectionView *)makeCollectionView {
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView * collectionView  = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                            collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.bounces = NO;
    
    return collectionView;
}

- (NSInteger)pageIndexForCollectionView:(UICollectionView*)collectionView {
    TCCollectionViewCell * cell = [self cellForView:collectionView];
    if (cell) {
        NSIndexPath * indexPath = [self.collectionView indexPathForCell:cell];
        return (indexPath) ? indexPath.row : NSNotFound;
    }
    
    return NSNotFound;
}

- (UICollectionViewLayout*)tryCopyLayout:(UICollectionViewLayout*)layout {
    UICollectionViewLayout * layoutCopy = layout;
    if ([layout isKindOfClass:[UICollectionViewFlowLayout class]]) {
        UICollectionViewFlowLayout * flowLayout = (UICollectionViewFlowLayout*)layout;
        UICollectionViewFlowLayout * flowLayoutCopy = [[[layout class] alloc] init];
        flowLayoutCopy.scrollDirection = flowLayout.scrollDirection;
        flowLayoutCopy.minimumLineSpacing = flowLayout.minimumLineSpacing;
        flowLayoutCopy.minimumInteritemSpacing = flowLayout.minimumInteritemSpacing;
        flowLayoutCopy.sectionInset = flowLayout.sectionInset;
        layoutCopy = flowLayoutCopy;
    }
    return layoutCopy;
}

- (TCCollectionViewCell*)cellForView:(UIView*)view {
    if ([view.superview isKindOfClass:[TCCollectionViewCell class]] || !view.superview) {
        return (TCCollectionViewCell*)view.superview;
    }
    
    return [self cellForView:view.superview];
}

@end
