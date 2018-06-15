//
//  TCTableSectionViewObject.h
//  TCCollections
//
//  Created by Tayphoon on 10/03/2018.
//  Copyright © 2018 Tayphoon. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TCTableSectionViewObject <NSObject>

- (NSString*)sectionViewReuseIdentifier;

- (Class)sectionViewClass;

@end
