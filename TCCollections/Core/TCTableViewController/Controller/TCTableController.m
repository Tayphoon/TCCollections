//
//  TCTableController.m
//  TCCollections
//
//  Created by Tayphoon on 09/08/16.
//  Copyright © 2016 Tayphoon. All rights reserved.
//

#import "TCTableController.h"

@interface TCTableController ()

@end

@implementation TCTableController

@dynamic model;

- (void)reloadDataWithCompletion:(void (^)(NSError *error))completion {
    void (^completionBlock)(NSError *error) = ^(NSError *error) {
        if(!error) {
            [self.tableView reloadData];
        }
        
        [self updateNoDataLabelVisibility];
        
        if (completion) {
            completion(error);
        }
    };
    
    if(self.model) {
        [self.model updateModelWithCompletion:completionBlock];
    }
    else {
        completionBlock(nil);
    }
}

- (void)showErrorAlertWithMessage:(NSString *)message {
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                                         message:message
                                                        delegate:nil
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
    
    [alertView show];
}

@end
