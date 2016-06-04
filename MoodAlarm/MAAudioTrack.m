//
//  MAAudioTrack.m
//  MoodAlarm
//
//  Created by Angelica Bato on 6/4/16.
//  Copyright © 2016 Angelica Bato. All rights reserved.
//

#import "MAAudioTrack.h"

@implementation MAAudioTrack

-(instancetype)init {
    self = [self initWithID:@"" name:@"" artists:@[]];
    return self;
}

-(instancetype)initWithID:(NSString *)identifier
                     name:(NSString *)name
                  artists:(NSArray *)artists {
    
    self = [super init];
    if (self) {
        _name = name;
        _artists = artists;
        _identifier = identifier;
        _acousticness = 0.0;
        _danceability = 0.0;
        _valence = 0.0;
        
    }
    
    return self;
}

- (NSString *)description {
    
    NSString *desc = [NSString stringWithFormat:@"ID: %@ \n Name: %@ \n Artists: %@ \n Acousticness: %f \n danceability: %f \n valence: %f",self.identifier, self.name, self.artists,self.acousticness, self.danceability, self.valence];
    
    return desc;
}

@end
