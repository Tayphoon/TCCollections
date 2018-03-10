//
//  TCSelectionControllerModel.h
//  TCCollections
//
//  Created by Tayphoon on 26.06.15.
//  Copyright (c) 2015 Tayphoon. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TCSelectionControllerModel <NSObject>

@property (nonatomic, assign) BOOL allowsMultipleSelection;
@property (nonatomic, assign) BOOL allowsDeselection;

- (BOOL)isItemSelectedAtIndexPath:(NSIndexPath *)indexPath;
- (void)makeItemAtIndexPath:(NSIndexPath *)indexPath selected:(BOOL)selected;
- (NSIndexPath*)selectedIndexPathForSection:(NSInteger)section;
- (NSArray*)selectedItems;

@end
