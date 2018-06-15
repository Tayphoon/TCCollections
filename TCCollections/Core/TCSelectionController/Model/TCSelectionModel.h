//
//  TCSelectionModel.h
//  TCCollections
//
//  Created by Tayphoon on 24.06.15.
//  Copyright (c) 2015 Tayphoon. All rights reserved.
//

#import "TCTableModel+Subclass.h"
#import "TCSelectionControllerModel.h"

@interface TCSelectionModel : TCTableModel<TCSelectionControllerModel> {
    @protected
    NSMutableArray * _selectedIndexPaths;
}

@property (nonatomic, assign) BOOL allowsMultipleSelection;
@property (nonatomic, assign) BOOL allowsDeselection;

- (BOOL)isItemSelectedAtIndexPath:(NSIndexPath*)indexPath;
- (void)makeItemAtIndexPath:(NSIndexPath*)indexPath selected:(BOOL)selected;

@end
