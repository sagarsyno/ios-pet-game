//
//  AttackSelectionView.h
//  PetsAlliance
//
//  Created by Mark Miyashita on 6/14/13.
//  Copyright (c) 2013 Mark Miyashita. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BattleOptionsview.h"
#import "InBattleViewController.h"

#import "AttackAnimationManager.h"

#import "Turn.h"

@class InBattleViewController;
@interface AttackSelectionView : UIView {
    InBattleViewController *inBattleController;
    NSMutableArray *attackButtons;
}

@property (nonatomic, assign) InBattleViewController *inBattleController;
@property (nonatomic, retain) NSMutableArray *attackButtons;

@end
