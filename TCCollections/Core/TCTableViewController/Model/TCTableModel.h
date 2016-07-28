//
//  TCTableModel.h
//  Tayphoon
//
//  Created by Tayphoon on 14.11.14.
//  Copyright (c) 2014 Tayphoon. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TCTableViewModel.h"

@protocol TCTableModel <TCTableViewModel>

- (void)updateModelWithCompletion:(void (^)(NSError * error))completion;

- (void)clearModelData;

@end

@interface TCTableModel : NSObject<TCTableModel>

@property (nonatomic, assign) NSInteger section;
@property (nonatomic, strong) NSArray * items;
@property (nonatomic, strong) NSArray * sortDescriptors;

@property (nonatomic, weak) id<TCTableViewModelDelegate> delegate;

@end
