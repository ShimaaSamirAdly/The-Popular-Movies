//
//  Movies.h
//  FinalIOSProject
//
//  Created by Shimaa Samir on 5/16/18.
//  Copyright © 2018 Shimaa Samir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movies : NSObject

@property int movieId;

@property NSString *title;

@property float vote_average;

@property NSString *poster_path;

@property NSString *video;

@property NSString *overView;

@property NSString *release_date;

-(Movies*) getMovie:(int)movieId :(NSString*)title :(float)vote :(NSString*)poster :(NSString*)overview :(NSString*)releaseDate;

@end
