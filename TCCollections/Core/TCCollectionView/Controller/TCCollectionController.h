//
//  TCCollectionController.h
//  TCCollections
//
//  Created by Tayphoon on 27.08.15.
//  Copyright (c) 2015 Tayphoon. All rights reserved.
//

#import "TCCollectionViewModel.h"

@interface TCCollectionController : UIViewController<TCCollectionViewModelDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, readonly) UICollectionView * collectionView;
@property (nonatomic, strong) UILabel * noDataLabel;
@property (nonatomic, strong) id<TCCollectionViewModel> model;

- (void)updateNoDataLabelVisibility;
- (void)showActivityIndicatorAnimated:(BOOL)animated completion:(void (^)(void))completion;
- (void)hideActivityIndicatorAnimated:(BOOL)animated completion:(void (^)(void))completion;
- (void)collectionViewDidScrollToBottom:(UICollectionView*)collectionView;

@end
