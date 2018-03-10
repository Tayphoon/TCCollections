//
//  TCSectionHeaderView.h
//  TCCollections
//
//  Created by Tayphoon on 26/03/16.
//  Copyright © 2016 Tayphoon. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TCSectionHeaderView <NSObject>

@required

+ (CGFloat)heightForItem:(id)item constrainedToSize:(CGSize)size;

- (void)setupWithItem:(id)item;

@end
