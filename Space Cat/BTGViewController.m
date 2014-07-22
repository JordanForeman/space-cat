//
//  BTGViewController.m
//  Space Cat
//
//  Created by Jordan Foreman on 7/15/14.
//  Copyright (c) 2014 Better Than Great. All rights reserved.
//

#import "BTGViewController.h"
#import "BTGTitleScene.h"
#import "BTGUtil.h"

@implementation BTGViewController

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = ([BTGUtil getBuildTarget] == BTGProductionBuild) ? NO : YES;
    skView.showsNodeCount = ([BTGUtil getBuildTarget] == BTGProductionBuild) ? NO : YES;
    
    // Create and configure the scene.
    SKScene * scene = [BTGTitleScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
