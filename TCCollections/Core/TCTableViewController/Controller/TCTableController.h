//
//  TCTableController.h
//  TCCollections
//
//  Created by Tayphoon on 09/08/16.
//  Copyright © 2016 Tayphoon. All rights reserved.
//

#import "TCTableViewController.h"
#import "TCTableModel.h"
#import "TCTableViewController+TableKeyboardLayout.h"

/**
 *  Table controll implement TCTableModel methods
 */
@interface TCTableController : TCTableViewController

@property (nonatomic, strong) id<TCTableModel> model;

- (void)reloadDataWithCompletion:(void (^)(NSError *error))completion;

- (void)showErrorAlertWithMessage:(NSString*)message;

@end
