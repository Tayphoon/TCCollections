//
//  TCObjectsTableViewModel.h
//  TCCollections
//
//  Created by Tayphoon on 10/03/2018.
//  Copyright © 2018 Tayphoon. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TCTableModel.h"

@protocol TCObjectsTableViewModel<TCTableViewModel>

@end

@interface TCObjectsTableModel : TCTableModel<TCObjectsTableViewModel>

@end
