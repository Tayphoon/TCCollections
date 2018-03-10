//
//  TCTableViewCellObject.h
//  Cropstream
//
//  Created by Tayphoon on 01.12.16.
//  Copyright © 2016 InfoService. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TCTableViewCellObject <NSObject>

- (NSString*)cellReuseIdentifier;

- (Class)cellClass;

@end
