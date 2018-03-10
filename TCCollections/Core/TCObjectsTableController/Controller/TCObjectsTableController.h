//
//  TCObjectsTableController.h
//  TCCollections
//
//  Created by Tayphoon on 10/03/2018.
//  Copyright © 2018 Tayphoon. All rights reserved.
//

#import "TCTableViewController.h"
#import "TCObjectsTableViewModel.h"

@interface TCObjectsTableController : TCTableViewController

@property (nonatomic, strong) id<TCObjectsTableViewModel> tableViewModel;

@end
