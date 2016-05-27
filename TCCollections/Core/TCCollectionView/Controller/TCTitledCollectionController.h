//
//  TCTitledCollectionController.h
//  Tayphoon
//
//  Created by Tayphoon on 04.02.16.
//  Copyright © 2016 Proarise. All rights reserved.
//

#import "TCTitledCollectionModel.h"
#import "TCTitledCollectionView.h"
#import "TCCollectionCell.h"

@interface TCTitledCollectionController : UIViewController<TCCollectionModelDelegate, TCTitledCollectionViewDataSource, TCTitledCollectionViewDelegate>

@property (nonatomic, readonly) TCTitledCollectionView * collectionView;
@property (nonatomic, strong) UILabel * noDataLabel;
@property (nonatomic, strong) id<TCTitledCollectionModel> model;

- (void)reloadDataWithCompletion:(void (^)(NSError *error))completion;
- (void)updateNoDataLabelVisibility;
- (void)showActivityIndicatorAnimated:(BOOL)animated completion:(void (^)(void))completion;
- (void)hideActivityIndicatorAnimated:(BOOL)animated completion:(void (^)(void))completion;
- (void)collectionViewDidScrollToBottom:(TCTitledCollectionView*)collectionView;

@end
