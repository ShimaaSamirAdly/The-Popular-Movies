//
//  Movies.m
//  FinalIOSProject
//
//  Created by Shimaa Samir on 5/16/18.
//  Copyright © 2018 Shimaa Samir. All rights reserved.
//

#import "Movies.h"

@implementation Movies

-(Movies*) getMovie:(int)movieId :(NSString*)title :(float)vote :(NSString*)poster :(NSString*)overview :(NSString*)releaseDate{
    
    self.movieId = movieId;
    self.title = title;
    self.vote_average = vote;
    self.poster_path = poster;
    self.overView = overview;
    self.release_date = releaseDate;
    
    return self;
}


@end
