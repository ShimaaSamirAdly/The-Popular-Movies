//
//  ViewController.h
//  FinalIOSProject
//
//  Created by Shimaa Samir on 5/12/18.
//  Copyright © 2018 Shimaa Samir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movies.h"
#import "DataBaseManager.h"

@interface ViewController : UIViewController <NSURLConnectionDataDelegate, NSURLConnectionDataDelegate>

@property (weak, nonatomic) IBOutlet UILabel *name;


@property (weak, nonatomic) IBOutlet UIImageView *img;

@property (weak, nonatomic) IBOutlet UIButton *videoText;

@property (weak, nonatomic) IBOutlet UILabel *year;

@property (weak, nonatomic) IBOutlet UILabel *rate;

@property (weak, nonatomic) IBOutlet UITextView *overView;

@property NSMutableData *videoData;

@property NSURL *url;

@property NSMutableDictionary *responseData;

@property DataBaseManager *mgr;

@property NSString *videoUrl;

@property Movies *movie;

- (IBAction)addToFavorite:(id)sender;

- (IBAction)showTrailer:(id)sender;




@end

