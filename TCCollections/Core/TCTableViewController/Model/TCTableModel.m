//
//  TCTableModel.c
//  TCCollections
//
//  Created by Tayphoon on 14.04.15.
//  Copyright (c) 2015 Tayphoon. All rights reserved.
//

#import "TCTableModel.h"
#import "TCTableViewCell.h"

@implementation TCTableModel

- (id)init {
    self = [super init];
    if (self) {
        self.items = [NSMutableArray array];
    }
    return self;
}

- (NSUInteger)numberOfSections {
    return 1;
}

- (CGFloat)heightForHeaderInSection:(NSUInteger)section constrainedToSize:(CGSize)size {
    return 0.0;
}

- (Class)classForHeaderInSection:(NSUInteger)section {
    return nil;
}

- (NSString*)titleForHeaderInSection:(NSInteger)section {
    return nil;
}

- (NSUInteger)numberOfItemsInSection:(NSInteger)section {
    return [self.items count];
}

- (NSString*)reuseIdentifierForIndexPath:(NSIndexPath*)indexPath {
    return nil;
}

- (Class)cellClassForIndexPath:(NSIndexPath*)indexPath {
    return nil;
}

- (CGFloat)heightForItemAtIndexPath:(NSIndexPath*)indexPath constrainedToSize:(CGSize)size {
    Class cellClass = [self cellClassForIndexPath:indexPath];
    if (cellClass && [cellClass respondsToSelector:@selector(heightForItem:constrainedToSize:)]) {
        return [cellClass heightForItem:[self itemAtIndexPath:indexPath] constrainedToSize:size];
    }
    
    return 0.0f;
}

- (id)itemAtIndexPath:(NSIndexPath*)indexPath {
    if(indexPath.section < [self numberOfSections] &&
       indexPath.row < [self numberOfItemsInSection:indexPath.section]) {
        return [self.items objectAtIndex:indexPath.row];
    }
    return nil;
}

- (NSIndexPath*)indexPathOfObject:(id)object {
    NSInteger index = [self.items indexOfObject:object];
    if (index != NSNotFound) {
        return [NSIndexPath indexPathForRow:index inSection:self.section];
    }
    return nil;
}

- (void)updateModelWithCompletion:(void (^)(NSError * error))completion {
    if (completion) {
        completion(nil);
    }
}

- (void)clearModelData {
    self.items = nil;
}

#pragma mark - Private methods

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
