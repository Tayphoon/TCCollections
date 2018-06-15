//
//  TCCollectionManagedModel+Subclass.h
//  TCCollections
//
//  Created by Tayphoon on 25.03.16.
//  Copyright (c) 2015 Tayphoon. All rights reserved.
//

#import "TCCollectionManagedModel.h"

@interface TCCollectionManagedModel (Subclass)

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
