//
//  TCCollectionViewModel.h
//  TCCollections
//
//  Created by Tayphoon on 28.07.16.
//  Copyright © 2016 Tayphoon. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TCCollectionViewModel;

@protocol TCCollectionViewModelDelegate <NSObject>

@optional

- (void)modelDidChanged:(id<TCCollectionViewModel>)model;

- (void)modelWillChangeContent:(id<TCCollectionViewModel>)model;

- (void)model:(id<TCCollectionViewModel>)model didChangeSectionAtIndex:(NSUInteger)sectionIndex forChangeType:(NSUInteger)type;

- (void)model:(id<TCCollectionViewModel>)model
              didChangeObject:(id)anObject
                  atIndexPath:(NSIndexPath *)indexPath
                forChangeType:(NSUInteger)type
                 newIndexPath:(NSIndexPath *)newIndexPath;

- (void)modelDidChangeContent:(id<TCCollectionViewModel>)model;

@end


@protocol TCCollectionViewModel <NSObject>

@property (nonatomic, weak) id<TCCollectionViewModelDelegate> delegate;

- (NSUInteger)numberOfSections;

- (NSString*)titleForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath*)indexPath;

- (NSUInteger)numberOfItemsInSection:(NSInteger)section;

- (NSString*)reuseIdentifierForCellAtIndexPath:(NSIndexPath*)indexPath;

- (NSString*)reuseIdentifierForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath*)indexPath;

- (CGSize)sizeForItemAtIndexPath:(NSIndexPath*)indexPath constrainedToSize:(CGSize)size;

- (id)itemAtIndexPath:(NSIndexPath*)indexPath;

- (NSIndexPath*)indexPathOfObject:(id)object;

@end
