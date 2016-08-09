//
//  TCTableViewController+TableKeyboardLayout.m
//  TCCollections
//
//  Created by Tayphoon on 09/08/16.
//  Copyright © 2016 Tayphoon. All rights reserved.
//

#import "TCTableViewController+TableKeyboardLayout.h"
#import "TCTableViewContainer.h"

@implementation TCTableViewController (TableKeyboardLayout)

- (void)makeInputViewTransitionWithDownDirection:(BOOL)down notification:(NSNotification *)notification {
    if ([self.view conformsToProtocol:@protocol(TCTableViewContainer)]) {
        UIView<TCTableViewContainer> * baseView = (UIView<TCTableViewContainer>*)self.view;
        
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

@end
