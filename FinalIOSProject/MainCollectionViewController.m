//
//  MainCollectionViewController.m
//  FinalIOSProject
//
//  Created by Shimaa Samir on 5/12/18.
//  Copyright © 2018 Shimaa Samir. All rights reserved.


// 74edd43cccca60b39930b38d66fd33c3

#import "MainCollectionViewController.h"
//#import <SDWebImage/UIImageView+WebCache.h>
//#import "AFNetworking/AFNetworking.h"
//#import <AFNetworking/AFNetworking.h>

@interface MainCollectionViewController ()

@end

@implementation MainCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"All Movies";
    _movies = [NSMutableArray new];
    
    _sortOrder = 0;
    
    _url = [NSURL URLWithString:@"http://api.themoviedb.org/3/discover/movie?sort_by=popularity.desc&api_key=74edd43cccca60b39930b38d66fd33c3"];
    
    _mgr = [DataBaseManager sharedInstance];
       
    [_mgr getConnection];
    
    
    self.getMoviesList;

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

-(void)getMoviesList{
    
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:_url];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    NSLog(@"conn");
    
    [connection start];
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    [manager GET:@"http://api.themoviedb.org/3/discover/movie?sort_by=popularity.desc&api_key=74edd43cccca60b39930b38d66fd33c3" parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
//        NSLog(@"JSON: %@", responseObject);
//    } failure:^(NSURLSessionTask *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];
    
}

- (IBAction)sort:(id)sender {
    
    if(_sortOrder == 0){
        
        _sortOrder++;
    
        _url = [NSURL URLWithString:@"http://api.themoviedb.org/3/discover/movie?sort_by=highest-rated.desc&api_key=74edd43cccca60b39930b38d66fd33c3"];
        
        NSLog(@"%i", _sortOrder);
    
    }else{
        
        _sortOrder--;
        
        _url = [NSURL URLWithString:@"http://api.themoviedb.org/3/discover/movie?sort_by=popularity.desc&api_key=74edd43cccca60b39930b38d66fd33c3"];

        NSLog(@"%i", _sortOrder);
    }
    
    [_movies removeAllObjects];
    
    self.getMoviesList;
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
    _responseData = [NSMutableArray new];
    _data = [NSMutableData new];
    
    NSLog(@"respo");
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    [_data appendData:data];
    
    
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    

    _responseData = [NSJSONSerialization JSONObjectWithData:_data options:NSJSONReadingMutableContainers error:nil];

    for (NSDictionary *item in [_responseData valueForKey:@"results"]) {

        Movies *movie = [Movies new];
        
        movie.title = [item valueForKey:@"title"];

        movie.movieId = [[item valueForKey:@"id"] intValue];
        
        movie.vote_average = [[item valueForKey:@"vote_average"] floatValue];
        
        movie.poster_path = [@"http://image.tmdb.org/t/p/w92/" stringByAppendingString:[item valueForKey:@"poster_path"]];
        
        movie.overView = [item valueForKey:@"overview"];
        
        movie.release_date = [item valueForKey:@"release_date"];
        
        [_movies addObject:movie];
        
        [_mgr insertMovies:movie];
        
        [self.collectionView reloadData];
    }
    

}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    NSLog(@"%@", [error description]);
    
    _movies = [_mgr getAllMovies];
}


@end
