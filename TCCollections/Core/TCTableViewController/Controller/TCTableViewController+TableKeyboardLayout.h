//
//  TCTableViewController+TableKeyboardLayout.h
//  TCCollections
//
//  Created by Tayphoon on 09/08/16.
//  Copyright © 2016 Tayphoon. All rights reserved.
//

#import "TCTableViewController.h"

@interface TCTableViewController (TableKeyboardLayout)

/**
 Use this if your self.view is subclass of TCTableBaseView
 */
- (void)makeInputViewTransitionWithDownDirection:(BOOL)down notification:(NSNotification *)notification;

@end
