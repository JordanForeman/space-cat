//
//  BTGGameOverNode.m
//  Space Cat
//
//  Created by Jordan Foreman on 7/21/14.
//  Copyright (c) 2014 Better Than Great. All rights reserved.
//

#import "BTGGameOverNode.h"

@implementation BTGGameOverNode

+ (instancetype) gameOverAtPosition:(CGPoint)position {
	BTGGameOverNode	*gameOver = [self node];
	
	SKLabelNode *gameOverLabel = [SKLabelNode labelNodeWithFontNamed:@"Futura-CondensedExtraBold"];
	gameOverLabel.name = @"GameOver";
	gameOverLabel.text = @"Game Over";
	gameOverLabel.fontSize = 48;
	gameOverLabel.position = position;
	[gameOver addChild:gameOverLabel];
	
	return gameOver;
}

@end
