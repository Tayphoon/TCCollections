//
//  TCObjectsTableController.m
//  TCCollections
//
//  Created by Tayphoon on 10/03/2018.
//  Copyright © 2018 Tayphoon. All rights reserved.
//

#import "TCObjectsTableController.h"
#import "TCTableViewCellObject.h"
#import "TCTableViewCell.h"

@interface TCObjectsTableController ()

@end

@implementation TCObjectsTableController

@dynamic tableViewModel;

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    id<TCTableViewCellObject> cellObject = [self.tableViewModel itemAtIndexPath:indexPath];
    
    [tableView registerClass:[cellObject cellClass] forCellReuseIdentifier:[cellObject cellReuseIdentifier]];

    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:[cellObject cellReuseIdentifier]];
    
    if ([cell conformsToProtocol:@protocol(TCTableViewCell)]) {
        UITableViewCell<TCTableViewCell> * tableCell = (UITableViewCell<TCTableViewCell>*)cell;
        tableCell.item = [self.tableViewModel itemAtIndexPath:indexPath];
    }
    
    return cell;
}

@end
