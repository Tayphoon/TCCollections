//
//  TCSelectionManagedModel.h
//  Tayphoon
//
//  Created by Tayphoon on 26.06.15.
//  Copyright (c) 2015 Tayphoon. All rights reserved.
//

#import "TCTableManagedModel+Subclass.h"
#import "TCSelectionControllerModel.h"

@interface TCSelectionManagedModel : TCTableManagedModel<TCSelectionControllerModel> {
@protected
    NSMutableArray * _selectedIndexPaths;
}

@property (nonatomic, assign) BOOL allowsMultipleSelection;
@property (nonatomic, assign) BOOL allowsDeselection;

- (BOOL)isItemSelectedAtIndexPath:(NSIndexPath *)indexPath;
- (void)makeItemAtIndexPath:(NSIndexPath *)indexPath selected:(BOOL)selected;

@end
