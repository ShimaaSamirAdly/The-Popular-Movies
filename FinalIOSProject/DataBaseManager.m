//
//  DataBaseManager.m
//  FriendsProject
//
//  Created by Shimaa Samir on 5/5/18.
//  Copyright © 2018 Shimaa Samir. All rights reserved.
//

#import "DataBaseManager.h"

@implementation DataBaseManager

static DataBaseManager *sharedInstance2 = nil;

+(DataBaseManager*)sharedInstance{
    NSLog(@"innnn");
    static DataBaseManager *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        NSLog(@"innnntanyy");
        
        sharedInstance = [[DataBaseManager alloc]initPrivate];
        sharedInstance2 = sharedInstance;
        
    });
    
    return sharedInstance;
}

-(instancetype)init{
    
    if(sharedInstance2 == nil){
        return [[self class] sharedInstance];
    }else{
        return sharedInstance2;
    }
    
}

-(instancetype)initPrivate{
    
    self = [super init];
    //    if (self) {
    //    }
    return self;
}

-(void) getConnection{
    
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    _databasePath = [[NSString alloc]
                     initWithString: [docsDir stringByAppendingPathComponent:
                                      @"movies.db"]];
    
    
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_moviesDB) == SQLITE_OK)
    {
        char *errMsg;
        const char *sql_stmt =
        "CREATE TABLE IF NOT EXISTS MOVIES (ID INTEGER PRIMARY KEY, TITLE TEXT, VOTE TEXT, POSTER TEXT, OVERVIEW TEXT, RELEASEDATE TEXT, FAVORITE INTEGER)";
        
        if (sqlite3_exec(_moviesDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
        {
            NSLog(@"Failed to create table");
        }
        sqlite3_close(_moviesDB);
    } else {
        NSLog(@"Failed to open/create database");
    }
    
}

-(void) insertMovies:(Movies*)movies{
    
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    NSLog(@"%@", movies.title);
    if (sqlite3_open(dbpath, &_moviesDB) == SQLITE_OK)
    {
        NSLog(@"first If");
        
        NSString *insertSQL = [NSString stringWithFormat:
                               @"INSERT INTO MOVIES (ID, TITLE, VOTE, POSTER, OVERVIEW, RELEASEDATE, FAVORITE) VALUES (\"%d\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%d\")",
                               movies.movieId, movies.title, [NSString stringWithFormat:@"%f", movies.vote_average], movies.poster_path, movies.overView, movies.release_date, 0];
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(_moviesDB, insert_stmt,
                           -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Contact added");
            
        } else {
            NSLog(@"Failed to add contact");
        }
        sqlite3_finalize(statement);
        sqlite3_close(_moviesDB);
    }
    
}

-(NSMutableArray *) getAllMovies{
    
    NSMutableArray *moviesList = [NSMutableArray new];
    
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &_moviesDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT * FROM movies"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_moviesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                int idField = sqlite3_column_int(statement,0);
                
                NSString *titleField = [[NSString alloc]
                                       initWithUTF8String:
                                       (const char *) sqlite3_column_text(
                                                                          statement, 1)];
                
                float voteField = [[[NSString alloc]
                                   initWithUTF8String:
                                   (const char *) sqlite3_column_text(
                                                statement, 2)] floatValue];
                
                NSString *posterField = [[NSString alloc]
                                        initWithUTF8String:(const char *)
                                        sqlite3_column_text(statement, 3)];
                NSString *overViewField = [[NSString alloc]
                                        initWithUTF8String:(const char *)
                                        sqlite3_column_text(statement,4)];
                
                NSString *releaseDateField = [[NSString alloc]
                                           initWithUTF8String:(const char *)
                                           sqlite3_column_text(statement,5)];
                
                Movies *m = [[Movies new] getMovie:idField :titleField :voteField :posterField :overViewField :releaseDateField];
                
                [moviesList addObject:m];
                
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_moviesDB);
        
    }
    return moviesList;
}

-(NSMutableArray *) getFavorites{
    
    NSMutableArray *moviesList = [NSMutableArray new];
    
    const char *dbpath = [_databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &_moviesDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT * FROM movies where favorite=\"%d\"", 1];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(_moviesDB,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                int idField = sqlite3_column_int(statement,0);
                
                NSString *titleField = [[NSString alloc]
                                        initWithUTF8String:
                                        (const char *) sqlite3_column_text(
                                                                           statement, 1)];
                
                float voteField = [[[NSString alloc]
                                    initWithUTF8String:
                                    (const char *) sqlite3_column_text(
                                                                       statement, 2)] floatValue];
                
                NSString *posterField = [[NSString alloc]
                                         initWithUTF8String:(const char *)
                                         sqlite3_column_text(statement, 3)];
                NSString *overViewField = [[NSString alloc]
                                           initWithUTF8String:(const char *)
                                           sqlite3_column_text(statement,4)];
                
                NSString *releaseDateField = [[NSString alloc]
                                              initWithUTF8String:(const char *)
                                              sqlite3_column_text(statement,5)];
                
                Movies *m = [[Movies new] getMovie:idField :titleField :voteField :posterField :overViewField :releaseDateField];
                
                [moviesList addObject:m];
                
            }
            sqlite3_finalize(statement);
        }
        sqlite3_close(_moviesDB);
        
    }
    return moviesList;

    
}

-(void)setFavorite:(int)movieId{
    
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    if (sqlite3_open(dbpath, &_moviesDB) == SQLITE_OK)
    {
        NSLog(@"first If");
        
        NSString *insertSQL = [NSString stringWithFormat:
                               @"UPDATE MOVIES SET FAVORITE=\"%d\" WHERE ID=\"%d\"", 1 , movieId];
                              
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(_moviesDB, insert_stmt,
                           -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Contact added");
            
        } else {
            NSLog(@"Failed to add contact");
        }
        sqlite3_finalize(statement);
        sqlite3_close(_moviesDB);
    }

}

-(void) deleteMovie:(Movies*)movie{
    
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_moviesDB) == SQLITE_OK)
    {
        
        //        NSLog(@"%d", indexPath.row);
        
        NSString *deleteSQL = [NSString stringWithFormat:
                               @"DELETE FROM MOVIES where ID=\"%d\"", movie.movieId];
        
        const char *delete_stmt = [deleteSQL UTF8String];
        sqlite3_prepare_v2(_moviesDB, delete_stmt,
                           -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Contact deleted");
            
        } else {
            NSLog(@"Failed to delete contact");
        }
        sqlite3_finalize(statement);
        sqlite3_close(_moviesDB);
    }
}


@end
