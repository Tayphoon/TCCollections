//
//  TCTitledCollectionModel.h
//  Tayphoon
//
//  Created by Tayphoon on 04.02.16.
//  Copyright © 2016 Proarise. All rights reserved.
//

#import "TCCollectionModel.h"

@protocol TCTitledCollectionModel;

@protocol TCTitledCollectionModelDelegate <TCCollectionViewModelDelegate>

@optional

- (void)modelWillChangeContent:(id<TCTitledCollectionModel>)model onPage:(NSInteger)pageIndex;

- (void)model:(id<TCTitledCollectionModel>)model didChangePageAtIndex:(NSUInteger)pageIndex forChangeType:(NSUInteger)type;

- (void)model:(id<TCTitledCollectionModel>)model didChangeSectionAtIndex:(NSUInteger)sectionIndex onPage:(NSInteger)pageIndex forChangeType:(NSUInteger)type;

- (void)model:(id<TCTitledCollectionModel>)model didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSUInteger)type newIndexPath:(NSIndexPath *)newIndexPath onPage:(NSInteger)pageIndex;

- (void)modelDidChangeContent:(id<TCTitledCollectionModel>)model onPage:(NSInteger)pageIndex;

- (void)modelDidChanged:(id<TCTitledCollectionModel>)model onPage:(NSInteger)pageIndex;

@end

@protocol TCTitledCollectionModel <TCCollectionViewModel>

@property (nonatomic, weak) id<TCTitledCollectionModelDelegate> delegate;

- (NSUInteger)numberOfTitles;

- (NSUInteger)numberOfSectionsOnPage:(NSInteger)pageIndex;

- (NSUInteger)numberOfItemsInSection:(NSInteger)section onPage:(NSInteger)pageIndex;

- (NSString*)reuseIdentifierForTitleCellAtIndex:(NSInteger)index;

- (CGSize)sizeForTitleAtIndex:(NSInteger)index constrainedToSize:(CGSize)size;

- (id)titleItemAtIndex:(NSInteger)index;

- (id)itemAtIndexPath:(NSIndexPath*)indexPath onPage:(NSInteger)pageIndex;

- (void)loadItemsForPageAtIndex:(NSInteger)index completion:(void (^)(NSError * error))completion;

- (BOOL)isDataLoadedForPage:(NSInteger)pageIndex;

@end