//
//  MainCollectionViewController.h
//  FinalIOSProject
//
//  Created by Shimaa Samir on 5/12/18.
//  Copyright © 2018 Shimaa Samir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movies.h"
#import "ViewController.h"
#import "DataBaseManager.h"


@interface MainCollectionViewController : UICollectionViewController <NSURLConnectionDataDelegate, NSURLConnectionDataDelegate>

@property NSMutableArray *movies;

@property NSMutableDictionary *responseData;

@property NSURL *url;

@property NSMutableData *data;

@property int sortOrder;

@property DataBaseManager *mgr;

-(void)getMoviesList;

- (IBAction)sort:(id)sender;

@end
