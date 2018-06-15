//
//  TCCollectionModel+Subclass.h
//  TCCollections
//
//  Created by Tayphoon on 27.08.15.
//  Copyright (c) 2015 Tayphoon. All rights reserved.
//

#import "TCCollectionModel.h"

@interface TCCollectionModel (Subclass)

- (void)modelWillChangeContent;

- (void)modelDidChangeSectionAtIndex:(NSUInteger)sectionIndex forChangeType:(NSInteger)type;

- (void)modelDidChangeObject:(id)anObject
                 atIndexPath:(NSIndexPath *)indexPath
               forChangeType:(NSInteger)type
                newIndexPath:(NSIndexPath *)newIndexPath;

- (void)modelDidChangeContent;

- (void)modelDidChanged;

@end
