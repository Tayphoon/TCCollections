//
//  TCTableManagedModel+Subclass.h
//  TCCollections
//
//  Created by Tayphoon on 26.06.15.
//  Copyright (c) 2015 Tayphoon. All rights reserved.
//

#import "TCTableManagedModel.h"

@interface TCTableManagedModel (Subclass)

- (void)reloadModelSourceControllerWithCompletion:(void (^)(NSError * error))completion;

- (void)modelWillChangeContent;

- (void)modelDidChangeSectionAtIndex:(NSUInteger)sectionIndex forChangeType:(NSInteger)type;

- (void)modelDidChangeObject:(id)anObject
                 atIndexPath:(NSIndexPath *)indexPath
               forChangeType:(NSInteger)type
                newIndexPath:(NSIndexPath *)newIndexPath;

- (void)modelDidChangeContent;

- (void)modelDidChanged;

@end
