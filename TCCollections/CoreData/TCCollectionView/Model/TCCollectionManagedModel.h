//
//  TCCollectionManagedModel.h
//  TCCollections
//
//  Created by Tayphoon on 27.08.15.
//  Copyright (c) 2015 Tayphoon. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "TCCollectionModel.h"

@interface TCCollectionManagedModel : NSObject<TCCollectionModel, NSFetchedResultsControllerDelegate> {

}

@property (nonatomic, readonly) NSFetchedResultsController * fetchController;

@property (nonatomic, readonly) NSArray * items;
@property (nonatomic, readonly) NSString * entityName;
@property (nonatomic, readonly) NSString * sectionNameKeyPath;
@property (nonatomic, readonly) NSString * cacheFileName;
@property (nonatomic, readonly) NSManagedObjectContext * context;

@property (nonatomic, assign) NSInteger section;
@property (nonatomic, strong) NSArray * sortDescriptors;

@property (nonatomic, weak) id<TCCollectionViewModelDelegate> delegate;

- (NSPredicate*)fetchPredicate;

- (void)reloadModelSourceControllerWithCompletion:(void (^)(NSError * error))completion;

@end
