//
//  BTGMachineNode.m
//  Space Cat
//
//  Created by Jordan Foreman on 7/15/14.
//  Copyright (c) 2014 Better Than Great. All rights reserved.
//

#import "BTGMachineNode.h"

@implementation BTGMachineNode

+ (instancetype) machineAtPosition:(CGPoint)position {
	BTGMachineNode *machine = [self spriteNodeWithImageNamed:@"machine_1"];
	machine.position = position;
	machine.anchorPoint = CGPointMake(0.5, 0);
	machine.name = @"Machine";
	
	NSArray *textures = @[[SKTexture textureWithImageNamed:@"machine_1"],
						  [SKTexture textureWithImageNamed:@"machine_2"]];
	
	SKAction *machineAnimation = [SKAction animateWithTextures:textures timePerFrame:0.1];
	SKAction *machineRepeat = [SKAction repeatActionForever:machineAnimation];
	[machine runAction:machineRepeat];
	
	return machine;
}

@end
