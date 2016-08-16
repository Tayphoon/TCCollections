//
//  TCCollectionManagedModel.m
//  Tayphoon
//
//  Created by Tayphoon on 27.08.15.
//  Copyright (c) 2015 Tayphoon. All rights reserved.
//

#import "TCCollectionManagedModel.h"

@interface TCCollectionManagedModel() {
    NSFetchedResultsController * _fetchController;
}

@end

@implementation TCCollectionManagedModel

- (NSFetchedResultsController*)fetchController {
    return _fetchController;
}

- (NSArray*)items {
    return _fetchController.fetchedObjects;
}

- (NSUInteger)numberOfSections {
    return [_fetchController.sections count];
}

- (NSString*)titleForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath*)indexPath {
    id<NSFetchedResultsSectionInfo> sectionInfo = [_fetchController.sections objectAtIndex:indexPath.section];
    return sectionInfo.name;
}

- (NSUInteger)numberOfItemsInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = [_fetchController.sections objectAtIndex:section];
    return [sectionInfo numberOfObjects];
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
    if(indexPath.section < [self numberOfSections] &&
       indexPath.row < [self numberOfItemsInSection:indexPath.section]) {
        return [_fetchController objectAtIndexPath:indexPath];
    }
    
    return nil;
}

- (NSIndexPath*)indexPathOfObject:(id)object {
    return [_fetchController indexPathForObject:object];
}

- (void)updateModelWithCompletion:(void (^)(NSError *))completion {
    if (completion) {
        completion(nil);
    }
}

- (void)clearModelData {
    if (self.cacheFileName) {
        [NSFetchedResultsController deleteCacheWithName:self.cacheFileName];
    }
    
    if(_fetchController) {
        [_fetchController.fetchRequest setPredicate:[NSPredicate predicateWithValue:NO]];
        [_fetchController performFetch:nil];
        [_fetchController setDelegate:nil];
        _fetchController = nil;
    }
}

- (NSPredicate*)fetchPredicate {
    return nil;
}

- (void)reloadModelSourceControllerWithCompletion:(void (^)(NSError * error))completion {
    NSError * fetchError = nil;

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
    
    if(completion) {
        completion(fetchError);
    }
}

#pragma mark - NSFetchedResultsControllerDelegate

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
