//
//  BTGSpaceCatNode.m
//  Space Cat
//
//  Created by Jordan Foreman on 7/15/14.
//  Copyright (c) 2014 Better Than Great. All rights reserved.
//

#import "BTGSpaceCatNode.h"

@interface BTGSpaceCatNode ()
@property (nonatomic) SKAction *tapAction;
@end

@implementation BTGSpaceCatNode

+ (instancetype) spaceCatAtPosition:(CGPoint)position {
	BTGSpaceCatNode *spaceCat = [self spriteNodeWithImageNamed:@"spacecat_1"];
	spaceCat.anchorPoint = CGPointMake(0.5, 0);
	spaceCat.position = position;
	spaceCat.zPosition = 9;
	spaceCat.name = @"SpaceCat";
	
	return spaceCat;
}

- (void) performTap {
	[self runAction:self.tapAction];
}

- (SKAction *) tapAction {
	if (_tapAction != nil){
		return _tapAction;
	}
	
	NSArray *textures = @[[SKTexture textureWithImageNamed:@"spacecat_2"],
						  [SKTexture textureWithImageNamed:@"spacecat_1"]];
	
	_tapAction = [SKAction animateWithTextures:textures timePerFrame:0.25];
	return _tapAction;
}

@end
