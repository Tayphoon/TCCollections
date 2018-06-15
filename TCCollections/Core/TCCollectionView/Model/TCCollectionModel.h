//
//  TCCollectionModel.h
//  TCCollections
//
//  Created by Tayphoon on 27.08.15.
//  Copyright (c) 2015 Tayphoon. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TCCollectionViewModel.h"

@protocol TCCollectionModel <TCCollectionViewModel>

- (void)updateModelWithCompletion:(void (^)(NSError * error))completion;

- (void)clearModelData;

@end

@interface TCCollectionModel : NSObject<TCCollectionModel> {
    NSArray * _items;
}

@property (nonatomic, readonly) NSArray * items;
@property (nonatomic, strong) NSArray * sortDescriptors;

@property (nonatomic, weak) id<TCCollectionViewModelDelegate> delegate;

@end
