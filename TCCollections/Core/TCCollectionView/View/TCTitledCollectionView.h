//
//  TCTitledCollectionView.h
//  TCCollections
//
//  Created by Tayphoon on 26.11.15.
//  Copyright © 2015 Tayphoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TCTitledCollectionView;

@protocol TCTitledCollectionViewDelegate <UICollectionViewDelegate>

@optional
- (CGFloat)heightForTitleViewInTitledCollectionView:(TCTitledCollectionView *)collectionView;

- (CGSize)titledCollectionView:(TCTitledCollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;

- (CGSize)titledCollectionView:(TCTitledCollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForTitleAtIndex:(NSInteger)index;

- (void)titledCollectionView:(TCTitledCollectionView *)collectionView didChangePageIndex:(NSInteger)pageIndex;

- (void)titledCollectionView:(TCTitledCollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath onPage:(NSInteger)pageIndex;

@end

@protocol TCTitledCollectionViewDataSource <NSObject>

- (NSInteger)numberOfTitlesInTitledCollectionView:(TCTitledCollectionView *)collectionView;
- (UICollectionViewCell *)titledCollectionView:(TCTitledCollectionView *)collectionView cellForTitleAtIndex:(NSInteger)index;

- (NSInteger)titledCollectionView:(TCTitledCollectionView *)collectionView numberOfItemsInSection:(NSInteger)section onPage:(NSInteger)pageIndex;
- (UICollectionViewCell *)titledCollectionView:(TCTitledCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath onPage:(NSInteger)pageIndex;

@optional

- (NSInteger)numberOfSectionsInTitledCollectionView:(TCTitledCollectionView *)collectionView onPage:(NSInteger)pageIndex;
- (UICollectionReusableView *)titledCollectionView:(TCTitledCollectionView *)collectionView
                 viewForSupplementaryElementOfKind:(NSString *)kind
                                       atIndexPath:(NSIndexPath *)indexPath
                                            onPage:(NSInteger)pageIndex;

@end

@interface TCTitledCollectionView : UIView

@property (nonatomic, readonly) UICollectionView * titlesCollectionView;
@property (nonatomic, readonly) UICollectionView * collectionView;
@property (nonatomic, readonly) UIView * separatorView;

@property (nonatomic, assign) UIEdgeInsets contentInset;
@property (nonatomic, weak) id <TCTitledCollectionViewDelegate> delegate;
@property (nonatomic, weak) id <TCTitledCollectionViewDataSource> dataSource;

@property (nonatomic, strong) UICollectionViewLayout * collectionViewLayout;
@property (nonatomic, strong) UIColor * titleBackgroundViewColor;
@property (nonatomic, readonly) NSInteger selectedPage;

- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;
- (void)registerClass:(Class)cellClass forTitleCellWithReuseIdentifier:(NSString *)identifier;

- (void)beginUpdates;

- (void)insertPages:(NSIndexSet *)pages animated:(BOOL)animated;
- (void)deletePages:(NSIndexSet *)pages animated:(BOOL)animated;
- (void)reloadPages:(NSIndexSet *)pages animated:(BOOL)animated;

- (void)endUpdates;

- (void)beginUpdatesOnPage:(NSInteger)pageIndex;

- (void)insertSections:(NSIndexSet *)sections onPage:(NSInteger)pageIndex animated:(BOOL)animated;
- (void)deleteSections:(NSIndexSet *)sections onPage:(NSInteger)pageIndex animated:(BOOL)animated;
- (void)reloadSections:(NSIndexSet *)sections onPage:(NSInteger)pageIndex animated:(BOOL)animated;

- (void)insertItemsAtIndexPaths:(NSArray *)indexPaths onPage:(NSInteger)pageIndex animated:(BOOL)animated;
- (void)deleteItemsAtIndexPaths:(NSArray *)indexPaths onPage:(NSInteger)pageIndex animated:(BOOL)animated;
- (void)reloadItemsAtIndexPaths:(NSArray *)indexPaths onPage:(NSInteger)pageIndex animated:(BOOL)animated;

- (void)endUpdatesOnPage:(NSInteger)pageIndex;

- (void)reloadData;
- (void)reloadDataOnPage:(NSInteger)pageIndex;

- (UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier
                                                    forIndexPath:(NSIndexPath *)indexPath
                                                          onPage:(NSInteger)pageIndex;

- (UICollectionReusableView *)dequeueReusableSupplementaryViewOfKind:(NSString *)elementKind
                                                 withReuseIdentifier:(NSString *)identifier
                                                        forIndexPath:(NSIndexPath *)indexPath
                                                              onPage:(NSInteger)pageIndex;

- (UICollectionViewCell *)dequeueTitleReusableCellWithReuseIdentifier:(NSString *)identifier forIndex:(NSInteger)index;

- (void)selectPageAtIndex:(NSInteger)pageIndex animated:(BOOL)animated;

- (void)scrollToPageAtIndex:(NSInteger)pageIndex animated:(BOOL)animated;

@end
