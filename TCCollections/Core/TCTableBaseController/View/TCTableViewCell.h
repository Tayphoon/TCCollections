//
//  TCTableViewCell.h
//  Tayphoon
//
//  Created by Tayphoon on 16.10.15.
//  Copyright © 2015 Tayphoon. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TCTableViewCell <NSObject>

@property (nonatomic, strong) id item;

+ (CGFloat)heightForItem:(id)item constrainedToSize:(CGSize)size;

@end
