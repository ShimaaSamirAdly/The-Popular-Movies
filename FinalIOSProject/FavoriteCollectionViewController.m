//
//  MainCollectionViewController.m
//  FinalIOSProject
//
//  Created by Shimaa Samir on 5/12/18.
//  Copyright © 2018 Shimaa Samir. All rights reserved.


// 74edd43cccca60b39930b38d66fd33c3

#import "FavoriteCollectionViewController.h"
//#import <SDWebImage/UIImageView+WebCache.h>
//#import "AFNetworking/AFNetworking.h"
//#import <AFNetworking/AFNetworking.h>

@interface FavoriteCollectionViewController ()

@end

@implementation FavoriteCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Favorites Movies";
    
    _mgr = [DataBaseManager sharedInstance];
    
    [_mgr getConnection];
    
    
    _movies = [_mgr getFavorites];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    }


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [_movies count];
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    UIImageView *poster = [cell viewWithTag:1];
    
    //    [poster sd_setImageWithURL:[NSURL URLWithString:@"http://image.tmdb.org/t/p/w92//nBNZadXqJSdt05SHLqgT0HuC5Gm.jpg"] placeholderImage:nil];
    
    if(_movies.count != 0){
        
        Movies *m = _movies[indexPath.row];
        
        dispatch_async(dispatch_get_global_queue(0,0), ^{
            NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:m.poster_path]];
            if ( data == nil ){
                NSLog(@"niiiiiil");
                return;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [poster setImage:[UIImage imageWithData: data]];
            });
        });
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ViewController *view = [self.storyboard instantiateViewControllerWithIdentifier:@"details"];
    
    view.movie = _movies[indexPath.row];
    
    [self.navigationController pushViewController:view animated:YES];
    
}



@end
