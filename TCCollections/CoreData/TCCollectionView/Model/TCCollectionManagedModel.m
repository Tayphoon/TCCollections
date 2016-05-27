//
//  TCCollectionManagedModel.m
//  Tayphoon
//
//  Created by Tayphoon on 27.08.15.
//  Copyright (c) 2015 Tayphoon. All rights reserved.
//

#import "TCCollectionManagedModel.h"

@implementation TCCollectionManagedModel

- (NSArray*)items {
#ifdef _COREDATADEFINES_H
    return _fetchController.fetchedObjects;
#else
    return nil;
#endif
}

- (NSUInteger)numberOfSections {
#ifdef _COREDATADEFINES_H
    return [_fetchController.sections count];
#else
    return 0;
#endif
}

- (NSString*)titleForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath*)indexPath {
#ifdef _COREDATADEFINES_H
    id<NSFetchedResultsSectionInfo> sectionInfo = [_fetchController.sections objectAtIndex:indexPath.section];
    return sectionInfo.name;
#else
    return nil;
#endif
}

- (NSUInteger)numberOfItemsInSection:(NSInteger)section {
#ifdef _COREDATADEFINES_H
    id<NSFetchedResultsSectionInfo> sectionInfo = [_fetchController.sections objectAtIndex:section];
    return [sectionInfo numberOfObjects];
#else
    return 0;
#endif
}

- (NSString*)reuseIdentifierForCellAtIndexPath:(NSIndexPath*)indexPath {
    return nil;
}

- (NSString*)reuseIdentifierForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath*)indexPath {
    return nil;
}

- (CGSize)sizeForItemAtIndexPath:(NSIndexPath*)indexPath constrainedToSize:(CGSize)size {
    return CGSizeZero;
}

- (id)itemAtIndexPath:(NSIndexPath*)indexPath {
#ifdef _COREDATADEFINES_H
    if(indexPath.section < [self numberOfSections] &&
       indexPath.row < [self numberOfItemsInSection:indexPath.section]) {
        return [_fetchController objectAtIndexPath:indexPath];
    }
#endif
    return nil;
}

- (NSIndexPath*)indexPathOfObject:(id)object {
#ifdef _COREDATADEFINES_H
    return [_fetchController indexPathForObject:object];
#else
    return nil;
#endif
}

- (void)updateModelWithCompletion:(void (^)(NSError *))completion {
    if (completion) {
        completion(nil);
    }
}

- (void)clearModelData {
#ifdef _COREDATADEFINES_H
    if (self.cacheFileName) {
        [NSFetchedResultsController deleteCacheWithName:self.cacheFileName];
    }
    
    if(_fetchController) {
        [_fetchController.fetchRequest setPredicate:[NSPredicate predicateWithValue:NO]];
        [_fetchController performFetch:nil];
        [_fetchController setDelegate:nil];
        _fetchController = nil;
    }
#endif
}

- (NSPredicate*)fetchPredicate {
    return nil;
}

- (void)reloadModelSourceControllerWithCompletion:(void (^)(NSError * error))completion {
    NSError * fetchError = nil;

#ifdef _COREDATADEFINES_H
    _fetchController.delegate = nil;
    
    if (self.cacheFileName) {
        [NSFetchedResultsController deleteCacheWithName:self.cacheFileName];
    }
    
    if(!_fetchController && self.context && self.entityName) {
        NSPredicate * predicate = [self fetchPredicate];
        NSFetchRequest * fetchRequest = [NSFetchRequest fetchRequestWithEntityName:self.entityName];
        [fetchRequest setPredicate:predicate];
        [fetchRequest setSortDescriptors:_sortDescriptors];
        
        _fetchController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                               managedObjectContext:self.context
                                                                 sectionNameKeyPath:self.sectionNameKeyPath
                                                                          cacheName:self.cacheFileName];
    }
    
    NSPredicate * predicate = [self fetchPredicate];
    
    [_fetchController.fetchRequest setPredicate:predicate];
    [_fetchController.fetchRequest setSortDescriptors:_sortDescriptors];
    [_fetchController setDelegate:self];
    [_fetchController performFetch:&fetchError];
#endif
    
    if(completion) {
        completion(fetchError);
    }
}

#pragma mark - NSFetchedResultsControllerDelegate

#ifdef _COREDATADEFINES_H
- (void)controllerWillChangeContent:(NSFetchedResultsController*)controller {
    [self modelWillChangeContent];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type {
    [self modelDidChangeSectionAtIndex:sectionIndex
                         forChangeType:type];
}

- (void)controller:(NSFetchedResultsController*)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    [self modelDidChangeObject:anObject
                   atIndexPath:indexPath
                 forChangeType:type
                  newIndexPath:newIndexPath];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController*)controller {
    [self modelDidChangeContent];
}
#endif

#pragma mark - Delegate methods

- (void)modelWillChangeContent {
    if ([self.delegate respondsToSelector:@selector(modelWillChangeContent:)]) {
        [self.delegate modelWillChangeContent:self];
    }
}

- (void)modelDidChangeSectionAtIndex:(NSUInteger)sectionIndex forChangeType:(NSInteger)type {
    if ([self.delegate respondsToSelector:@selector(model:didChangeSectionAtIndex:forChangeType:)]) {
        [self.delegate model:self didChangeSectionAtIndex:sectionIndex forChangeType:type];
    }
}

- (void)modelDidChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSInteger)type newIndexPath:(NSIndexPath *)newIndexPath {
    if ([self.delegate respondsToSelector:@selector(model:didChangeObject:atIndexPath:forChangeType:newIndexPath:)]) {
        [self.delegate model:self didChangeObject:anObject atIndexPath:indexPath forChangeType:type newIndexPath:newIndexPath];
    }
}

- (void)modelDidChangeContent {
    if ([self.delegate respondsToSelector:@selector(modelDidChangeContent:)]) {
        [self.delegate modelDidChangeContent:self];
    }
}

- (void)modelDidChanged {
    if([self.delegate respondsToSelector:@selector(modelDidChanged:)]) {
        [self.delegate modelDidChanged:self];
    }
}

@end
