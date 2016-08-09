//
//  TCTableManagedModel.h
//  Tayphoon
//
//  Created by Tayphoon on 14.04.15.
//  Copyright (c) 2015 Tayphoon. All rights reserved.
//

#import "TCTableModel.h"

#ifndef _COREDATADEFINES_H
@interface TCTableManagedModel : NSObject<TCTableModel>
#else
@interface TCTableManagedModel : NSObject<TCTableModel, NSFetchedResultsControllerDelegate> {

}

@property (nonatomic, readonly) NSFetchedResultsController * fetchController;

#endif

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
