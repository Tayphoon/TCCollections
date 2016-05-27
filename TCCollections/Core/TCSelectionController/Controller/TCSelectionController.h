//
//  TCSelectionController.h
//  Tayphoon
//
//  Created by Tayphoon on 24.06.15.
//  Copyright (c) 2015 Tayphoon. All rights reserved.
//

#import "TCTableBaseController.h"
#import "TCSelectionControllerModel.h"

@class TCSelectionController;
@protocol TCSelectionControllerDelegate <NSObject>

@optional

- (void)selectionControllerController:(TCSelectionController*)controller didSelectItem:(id)item;
- (void)selectionControllerController:(TCSelectionController*)controller didSelectItems:(NSArray*)items;

@end


@interface TCSelectionController : TCTableBaseController

@property (nonatomic, strong) id<TCTableModel, TCSelectionControllerModel> model;
@property (nonatomic, weak)   id delegate;

@end
