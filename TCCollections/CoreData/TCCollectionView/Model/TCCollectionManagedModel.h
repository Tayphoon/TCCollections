//
//  TCCollectionManagedModel.h
//  Tayphoon
//
//  Created by Tayphoon on 27.08.15.
//  Copyright (c) 2015 Tayphoon. All rights reserved.
//

#import "TCCollectionModel.h"

#ifndef _COREDATADEFINES_H
@interface TCCollectionManagedModel : NSObject<TCCollectionModel>
#else
@interface TCCollectionManagedModel : NSObject<TCCollectionModel, NSFetchedResultsControllerDelegate> {
@protected
    NSFetchedResultsController * _fetchController;
}
#endif

@property (nonatomic, readonly) NSArray * items;
@property (nonatomic, readonly) NSString * entityName;
@property (nonatomic, readonly) NSString * sectionNameKeyPath;
@property (nonatomic, readonly) NSString * cacheFileName;
#ifdef _COREDATADEFINES_H
@property (nonatomic, readonly) NSManagedObjectContext * context;
#endif

@property (nonatomic, assign) NSInteger section;
@property (nonatomic, strong) NSArray * sortDescriptors;

@property (nonatomic, weak) id<TCCollectionViewModelDelegate> delegate;

- (NSPredicate*)fetchPredicate;

- (void)reloadModelSourceControllerWithCompletion:(void (^)(NSError * error))completion;

@end
