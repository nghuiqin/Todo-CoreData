//
//  Board+CoreDataClass.m
//  Todo
//
//  Created by Ng Hui Qin on 5/4/19.
//  Copyright © 2019 huiqinlab. All rights reserved.
//
//

#import "Board+CoreDataClass.h"

static NSString *const kNameKey = @"name";
static NSString *const kOrderKey = @"order";
static NSString *const kTasksKey = @"tasks";

@implementation Board

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:kNameKey];
    [aCoder encodeInt32:self.order forKey:kOrderKey];
    [aCoder encodeObject:self.tasks forKey:kTasksKey];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder {
    if (self = [super init])
    {
        self.name = [aDecoder decodeObjectForKey:kNameKey];
        self.order = [aDecoder decodeInt32ForKey:kOrderKey];
        self.tasks = [aDecoder decodeObjectForKey:kTasksKey];
        return self;
    }
    return nil;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end
