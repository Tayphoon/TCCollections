//
//  TCSelectionController.m
//  Tayphoon
//
//  Created by Tayphoon on 24.06.15.
//  Copyright (c) 2015 Tayphoon. All rights reserved.
//

#import "TCSelectionController.h"

@interface TCSelectionController ()

@end

@implementation TCSelectionController

@dynamic model;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (BOOL)isLeftMenuEnabled {
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - UITableView DataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell<TCTableViewCell> * cell = (UITableViewCell<TCTableViewCell>*)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    BOOL isCellSelected = [self.model isItemSelectedAtIndexPath:indexPath];
    [cell setAccessoryType:(isCellSelected) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone];
    
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath * selectedIndexPath = [self.model selectedIndexPathForSection:indexPath.section];
    if (self.model.allowsMultipleSelection) {
        BOOL isItemSelected = [self.model isItemSelectedAtIndexPath:indexPath];
        [self.model makeItemAtIndexPath:indexPath selected:!isItemSelected];
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
        
        if ([self.delegate respondsToSelector:@selector(selectionControllerController:didSelectItems:)]) {
            [self.delegate selectionControllerController:self didSelectItems:[self.model selectedItems]];
        }
    }
    else if((selectedIndexPath && [selectedIndexPath compare:indexPath] != NSOrderedSame) || !selectedIndexPath) {
        [self.model makeItemAtIndexPath:selectedIndexPath selected:NO];
        [self.model makeItemAtIndexPath:indexPath selected:YES];
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        if (selectedIndexPath) {
            [self.tableView reloadRowsAtIndexPaths:@[selectedIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        [self.tableView endUpdates];
        
        id item = [self.model itemAtIndexPath:indexPath];
        if ([self.delegate respondsToSelector:@selector(selectionControllerController:didSelectItem:)]) {
            [self.delegate selectionControllerController:self didSelectItem:item];
        }
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL selectionDisabled = (!self.model.allowsDeselection && [self.model isItemSelectedAtIndexPath:indexPath]);
    return (!selectionDisabled) ? indexPath : nil;
}

#pragma mark - Private methods

@end
