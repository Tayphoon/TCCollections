//
//  TCTitledCollectionController.h
//  TCCollections
//
//  Created by Tayphoon on 04.02.16.
//  Copyright © 2016 Tayphoon. All rights reserved.
//

#import "TCTitledCollectionModel.h"
#import "TCTitledCollectionView.h"
#import "TCCollectionCell.h"

@interface TCTitledCollectionController : UIViewController<TCCollectionViewModelDelegate, TCTitledCollectionViewDataSource, TCTitledCollectionViewDelegate>

@property (nonatomic, readonly) TCTitledCollectionView * collectionView;
@property (nonatomic, strong) UILabel * noDataLabel;
@property (nonatomic, strong) id<TCTitledCollectionModel> model;

- (void)updateNoDataLabelVisibility;
- (void)showActivityIndicatorAnimated:(BOOL)animated completion:(void (^)(void))completion;
- (void)hideActivityIndicatorAnimated:(BOOL)animated completion:(void (^)(void))completion;
- (void)collectionViewDidScrollToBottom:(TCTitledCollectionView*)collectionView;

@end
