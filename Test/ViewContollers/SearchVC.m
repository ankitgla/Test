//
//  SearchVC.m
//  Test
//
//  Created by Ankit Bhardwaj on 13/09/18.
//  Copyright © 2018 Ankit Bhardwaj. All rights reserved.
//

#import "SearchVC.h"
#import "CollectionCell.h"
#import "PhotoSearchCall.h"
#import "PhotoData.h"
#import "NetworkQueueManager.h"
#import "ImageDownloader.h"

@interface SearchVC ()
@property (nonatomic, retain) PhotoData* localPhotoData;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, retain) PhotoSearchCall* searchCall;
@end

@implementation SearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [_collectionView registerNib:[UINib nibWithNibName:@"CollectionCell" bundle:nil]
      forCellWithReuseIdentifier:@"CollectionCell"];
    
    _flowLayout.minimumLineSpacing = 0;
    _flowLayout.minimumInteritemSpacing = 0;
    
    _searchCall = [[PhotoSearchCall alloc] init];    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.collectionView addGestureRecognizer:tapGesture];
}

- (void) hideKeyboard {
    [_searchBar resignFirstResponder];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //Update Search Data
    __weak typeof(self) weakself = self;
    [_searchCall setCompletionHandler:^(PhotoData *photoData) {
        weakself.localPhotoData = photoData;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself.collectionView reloadData];
        });
    }];
    
    [[ImageDownloader sharedInstance] setCompletionHandler:^(UIImage *image, NSIndexPath* indexPath) {
        dispatch_async(dispatch_get_main_queue(), ^{
            CollectionCell *cell = (CollectionCell *) [self.collectionView cellForItemAtIndexPath:indexPath];
            Photo* photo = [weakself.localPhotoData.photoList objectAtIndex:indexPath.row];
            photo.photoImage = image;
            [cell updateView:kDefault withPhoto:photo];            
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    [[NetworkQueueManager sharedInstance] cancelAllOperation];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSUInteger totalPhoto = _localPhotoData.photoList == nil ? 0 : _localPhotoData.photoList.count;
    return totalPhoto + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    if (_localPhotoData.photoList == nil || (indexPath.row == _localPhotoData.photoList.count)) {
        if ([self.searchCall isPhotoSearchCallInProgress]) {
            [cell updateView:kCallInProgress withPhoto:nil];
        } else if (_localPhotoData != nil && ([_searchCall getCurrentPageNo] == _localPhotoData.totalPage)) {
            [cell updateView:kENDOFResult withPhoto:nil];
        } else {
            [cell updateView:kNoResult withPhoto:nil];
        }
    } else {
        Photo* photo = [_localPhotoData.photoList objectAtIndex:indexPath.row];
        [cell updateView:kDefault withPhoto:photo];
        
        if (self.collectionView.dragging == NO && self.collectionView.decelerating == NO) {
            [[ImageDownloader sharedInstance] downloadImageFor:photo forIndexPath:indexPath];
        }
    }    
    
    //Make next call for image Load
    if (((float)indexPath.row/_localPhotoData.photoList.count) > 0.6) {
        //Do in background thread
        __weak typeof(self) weakself = self;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [weakself.searchCall loadNextPage];
        });        
    }
        
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_localPhotoData.photoList == nil || (indexPath.row == _localPhotoData.photoList.count)) {
        CGFloat width = CGRectGetWidth([[UIScreen mainScreen] bounds]);
        return CGSizeMake(width, 50);
    } else {
        CGFloat width = CGRectGetWidth([[UIScreen mainScreen] bounds])/3;
        return CGSizeMake(width, width);
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [_flowLayout invalidateLayout];
}

- (void)loadCurrentImage {
    NSArray *visiblePaths = [self.collectionView indexPathsForVisibleItems];
    for (NSIndexPath *indexPath in visiblePaths) {
        //Don't load for last cell
        if (indexPath.row >= _localPhotoData.photoList.count) {
            continue;
        }
        Photo* photo = [_localPhotoData.photoList objectAtIndex:indexPath.row];
        if (!photo.photoImage) {
            [[ImageDownloader sharedInstance] downloadImageFor:photo
                                                  forIndexPath:indexPath];
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_searchBar resignFirstResponder];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self loadCurrentImage];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self loadCurrentImage];
}

//MARK: UISearchbar delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    _localPhotoData = nil;
    [_collectionView reloadData];
    
    [_searchCall searchForKeyWord:searchBar.text];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchBar.text isEqualToString:@""]) {
        _localPhotoData = nil;
        [_collectionView reloadData];
    }
}

@end
