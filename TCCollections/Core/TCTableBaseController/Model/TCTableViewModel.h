//
//  TCTableViewModel.h
//  TCCollections
//
//  Created by Tayphoon on 28.07.16.
//  Copyright © 2016 Tayphoon. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TCTableViewCell.h"
#import "TCSectionHeaderView.h"

@protocol TCTableViewModel;

@protocol TCTableViewModelDelegate <NSObject>

@optional

- (void)modelDidChanged:(id<TCTableViewModel>)model;

- (void)modelWillChangeContent:(id<TCTableViewModel>)model;

- (void)model:(id<TCTableViewModel>)model didChangeSectionAtIndex:(NSUInteger)sectionIndex forChangeType:(NSUInteger)type;

- (void)model:(id<TCTableViewModel>)model didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSUInteger)type newIndexPath:(NSIndexPath *)newIndexPath;

- (void)modelDidChangeContent:(id<TCTableViewModel>)model;

- (void)modelCountersDidChanged:(id<TCTableViewModel>)model;

@end

@protocol TCTableViewModel <NSObject>

@property (nonatomic, weak) id<TCTableViewModelDelegate> delegate;

@optional

- (NSString*)titleForSection:(NSInteger)section;

- (CGFloat)heightForHeaderInSection:(NSUInteger)section constrainedToSize:(CGSize)size;

- (Class)classForHeaderInSection:(NSUInteger)section;

- (UIView<TCSectionHeaderView>*)createViewForHeaderInSection:(NSUInteger)section;

- (id)itemForSection:(NSUInteger)section;

@required

- (NSUInteger)numberOfSections;

- (Class)cellClassForIndexPath:(NSIndexPath*)indexPath;

- (NSUInteger)numberOfItemsInSection:(NSInteger)section;

- (NSString*)reuseIdentifierForIndexPath:(NSIndexPath*)indexPath;

- (UITableViewCell<TCTableViewCell>*)createCellForIndexPath:(NSIndexPath*)indexPath;

- (CGFloat)heightForItemAtIndexPath:(NSIndexPath*)indexPath constrainedToSize:(CGSize)size;

- (id)itemAtIndexPath:(NSIndexPath*)indexPath;

- (NSIndexPath *)indexPathOfObject:(id)object;

@end
