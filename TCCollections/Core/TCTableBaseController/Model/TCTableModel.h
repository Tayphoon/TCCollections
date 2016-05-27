//
//  TCTableModel.h
//  Tayphoon
//
//  Created by Tayphoon on 14.11.14.
//  Copyright (c) 2014 Tayphoon. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "TCTableViewCell.h"
#import "TCSectionHeaderView.h"

@protocol TCTableModel;

@protocol TCTableModelDelegate <NSObject>

@optional

- (void)modelDidChanged:(id<TCTableModel>)model;

- (void)modelWillChangeContent:(id<TCTableModel>)model;

- (void)model:(id<TCTableModel>)model didChangeSectionAtIndex:(NSUInteger)sectionIndex forChangeType:(NSUInteger)type;

- (void)model:(id<TCTableModel>)model didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSUInteger)type newIndexPath:(NSIndexPath *)newIndexPath;

- (void)modelDidChangeContent:(id<TCTableModel>)model;

- (void)modelCountersDidChanged:(id<TCTableModel>)model;

@end

@protocol TCTableModel <NSObject>

@property (nonatomic, weak) id<TCTableModelDelegate> delegate;

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

- (void)updateModelWithCompletion:(void (^)(NSError * error))completion;

- (void)clearModelData;

@end

@interface TCTableModel : NSObject<TCTableModel>

@property (nonatomic, assign) NSInteger section;
@property (nonatomic, strong) NSArray * items;
@property (nonatomic, strong) NSArray * sortDescriptors;

@property (nonatomic, weak) id<TCTableModelDelegate> delegate;

@end
