//
//  User.m
//  Firebase1
//
//  Created by Nielson Rolim on 12/9/14.
//  Copyright (c) 2014 Mobilife. All rights reserved.
//

#import "User.h"

@implementation User

-(NSDictionary*)toObject {
    return [self dictionaryWithValuesForKeys:@[@"name"]];
}

@end
