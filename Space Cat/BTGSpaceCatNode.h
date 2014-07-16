//
//  BTGSpaceCatNode.h
//  Space Cat
//
//  Created by Jordan Foreman on 7/15/14.
//  Copyright (c) 2014 Better Than Great. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface BTGSpaceCatNode : SKSpriteNode

+ (instancetype) spaceCatAtPosition:(CGPoint) position;
- (void) performTap;

@end
