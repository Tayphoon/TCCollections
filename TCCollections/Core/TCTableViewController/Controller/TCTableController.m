//
//  TCTableController.m
//  TCCollections
//
//  Created by Tayphoon on 09/08/16.
//  Copyright © 2016 Tayphoon. All rights reserved.
//

#import "TCTableController.h"
#import "TCTableBaseView.h"

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

- (void)makeInputViewTransitionWithDownDirection:(BOOL)down notification:(NSNotification *)notification {
    if ([self.view isKindOfClass:[TCTableBaseView class]]) {
        TCTableBaseView * baseView = (TCTableBaseView*)self.view;
        
        NSDictionary *userInfo = [notification userInfo];
        NSTimeInterval animationDuration;
        UIViewAnimationCurve animationCurve;
        
        [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
        [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
        
        CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:animationDuration];
        [UIView setAnimationCurve:animationCurve];
        
        CGFloat inset = MIN(keyboardRect.size.height, keyboardRect.size.width);
        baseView.tableViewViewBottomMargin = down ? 0.0f : inset;
        
        [UIView commitAnimations];
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
