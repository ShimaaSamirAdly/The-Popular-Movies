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


@interface FavoriteCollectionViewController : UICollectionViewController

@property NSMutableArray *movies;

@property DataBaseManager *mgr;

@end
