//
//  ViewController.m
//  FinalIOSProject
//
//  Created by Shimaa Samir on 5/12/18.
//  Copyright © 2018 Shimaa Samir. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _responseData = [NSMutableArray new];
    _videoData = [NSMutableData new];
    
    _rate.text = [NSString stringWithFormat:@"%f", _movie.vote_average];
    
    _name.text = _movie.title;
    
    _year.text = _movie.release_date;
    
    _overView.text = _movie.overView;
    
    
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:_movie.poster_path]];
        if ( data == nil ){
            NSLog(@"niiiiiil");
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [_img setImage:[UIImage imageWithData: data]];
        });
    });
}


    


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addToFavorite:(id)sender {
    
    _mgr = [DataBaseManager sharedInstance];
    
    [_mgr getConnection];
    
    [_mgr setFavorite:_movie.movieId];
}

- (IBAction)showTrailer:(id)sender {
    
    self.getConnection;
}

-(void)getConnection{
    
    _url = [NSURL URLWithString:[[@"http://api.themoviedb.org/3/movie/" stringByAppendingString:[NSString stringWithFormat:@"%i", _movie.movieId]] stringByAppendingString:@"/videos?api_key=74edd43cccca60b39930b38d66fd33c3"]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:_url];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    NSLog(@"conn");
    
    [connection start];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    
    [_videoData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    
    _responseData = [NSJSONSerialization JSONObjectWithData:_videoData options:NSJSONReadingMutableContainers error:nil];

    NSArray *array = [_responseData valueForKey:@"results"];
    
    if(array.count != 0){
        
    NSDictionary *item = [array objectAtIndex:0];

    _videoUrl = [item valueForKey:@"key"];
    
    NSString *Name = _videoUrl;
    
    NSURL *linkToApp = [NSURL URLWithString:[NSString stringWithFormat:@"youtube://watch?v=%@",Name]]; // I dont know excatly this one
    NSURL *linkToWeb = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.youtube.com/watch?v=%@",Name]]; // this is correct
    
    
    if ([[UIApplication sharedApplication] canOpenURL:linkToApp]) {
        // Can open the youtube app URL so launch the youTube app with this URL
        [[UIApplication sharedApplication] openURL:linkToApp];
    }
    else{
        // Can't open the youtube app URL so launch Safari instead
        [[UIApplication sharedApplication] openURL:linkToWeb];
    }
    }else{
        
        _videoText.titleLabel.text = @"No Trailer";
    }
}
@end
