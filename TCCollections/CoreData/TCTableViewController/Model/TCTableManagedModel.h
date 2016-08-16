//
//  TCTableManagedModel.h
//  Tayphoon
//
//  Created by Tayphoon on 14.04.15.
//  Copyright (c) 2015 Tayphoon. All rights reserved.
//

#import <CoreData/CoreData.h>

#import "TCTableModel.h"

@interface TCTableManagedModel : NSObject<TCTableModel, NSFetchedResultsControllerDelegate> {

}

@property (nonatomic, readonly) NSFetchedResultsController * fetchController;

@property (nonatomic, readonly) NSArray * items;
@property (nonatomic, readonly) NSString * entityName;
@property (nonatomic, readonly) NSString * sectionNameKeyPath;
@property (nonatomic, readonly) NSString * cacheFileName;
@property (nonatomic, readonly) NSManagedObjectContext * context;

@property (nonatomic, assign) NSInteger section;
@property (nonatomic, strong) NSArray * sortDescriptors;

@property (nonatomic, weak) id<TCTableViewModelDelegate> delegate;

- (NSPredicate*)fetchPredicate;

- (void)reloadModelSourceControllerWithCompletion:(void (^)(NSError * error))completion;

- (Class)cellClassForIndexPath:(NSIndexPath*)indexPath;

@end
