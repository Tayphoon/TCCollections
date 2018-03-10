//
//  TCTableSectionObject.h
//  TCCollections
//
//  Created by Tayphoon on 10/03/2018.
//  Copyright © 2018 Tayphoon. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TCTableViewCellObject;
@protocol TCTableSectionViewObject;

@protocol TCTableSectionObject <NSObject>

@property (nonatomic, strong) NSArray<id<TCTableViewCellObject>> * cellObjects;
@property (nonatomic, strong) NSArray<id<TCTableSectionViewObject>> * sectionViewObjects;

@end
