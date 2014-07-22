//
//  BTGHUDNode.h
//  Space Cat
//
//  Created by Jordan Foreman on 7/21/14.
//  Copyright (c) 2014 Better Than Great. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface BTGHUDNode : SKNode

@property (nonatomic) NSInteger lives;
@property (nonatomic) NSInteger score;

+ (instancetype) hudAtPosition:(CGPoint)position inFrame:(CGRect)frame;
- (void) addPoints:(NSInteger)points;
- (BOOL) loseLife;

@end
