//
//  Task+CoreDataClass.m
//  Todo
//
//  Created by Ng Hui Qin on 5/4/19.
//  Copyright © 2019 huiqinlab. All rights reserved.
//
//

#import "Task+CoreDataClass.h"

static NSString *const kDetailKey = @"detail";
static NSString *const kDateKey = @"created_at";
static NSString *const kBoardKey = @"board";

@implementation Task

- (void)awakeFromInsert {
    [super awakeFromInsert];
    self.created_at = [NSDate date];
}

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    [aCoder encodeObject:self.created_at forKey:kDateKey];
    [aCoder encodeObject:self.detail forKey:kDetailKey];
    [aCoder encodeObject:self.board forKey:kBoardKey];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)aDecoder {
    if (self = [super init])
    {
        self.created_at = [aDecoder decodeObjectForKey:kDateKey];
        self.detail = [aDecoder decodeObjectForKey:kDetailKey];
        self.board = [aDecoder decodeObjectForKey:kBoardKey];
        return self;
    }
    return nil;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

@end
