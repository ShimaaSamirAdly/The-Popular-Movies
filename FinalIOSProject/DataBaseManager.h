//
//  DataBaseManager.h
//  FriendsProject
//
//  Created by Shimaa Samir on 5/5/18.
//  Copyright © 2018 Shimaa Samir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Movies.h"

@interface DataBaseManager : NSObject

@property (strong , nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *moviesDB;

+(DataBaseManager*)sharedInstance;

-(void) getConnection;
-(void) insertMovies:(Movies *)movies;
-(NSMutableArray *) getAllMovies;
-(void) deleteMovie:(Movies*)movie;
-(void)setFavorite:(int)movieId;
-(NSMutableArray *) getFavorites;

@end
