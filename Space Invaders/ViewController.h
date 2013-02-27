//
//  ViewController.h
//  Space Invaders
//
//  Created by Alex Dzeda on 2/17/13.
//  Copyright (c) 2013 DzDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MovableObject.h"
@interface ViewController : UIViewController <UIAccelerometerDelegate>{
    NSMutableArray *rowArray;
    NSMutableArray *bulletArray;
    NSMutableArray *alienBulletArray;
    NSMutableArray *blockArray;
    NSMutableArray *row0;
    NSMutableArray *row1;
    NSMutableArray *row2;
    NSMutableArray *row3;
    NSMutableArray *row4;
    NSMutableArray *row5;
    Boolean gameOver;
    Boolean isPaused;
    Boolean hasSuperWeapon;
    Boolean isTicking;
    MovableObject *blockOne;
    MovableObject *blockTwo;
    MovableObject *blockThree;
    MovableObject *blockFour;
    MovableObject *blockFive;
    MovableObject *ship;
    MovableObject *laser;
    int level;
    int score;
    int timerStarted;
    int wins;
    int losses;
    int catcher;
    int currency;
    int extraLifeCount;
    int superWeaponCount;
    IBOutlet UIButton *scoreCount;
    IBOutlet UIButton *mainStartButton;
    IBOutlet UIButton *levelCount;
    IBOutlet UIButton *fireButton;
    IBOutlet UILabel *scoreLabel;
    IBOutlet UILabel *winLossLabel;
    IBOutlet UILabel *levelLabel;
    IBOutlet UIButton *resetButton;
    float heightY;
    float widthX;
    NSTimer *timer2;
    
    
}
@property (nonatomic, retain) UIAccelerometer *accelerometer;
-(IBAction) fireAtAlien: (id)sender;
-(IBAction) resetStats: (id) sender;
@end
