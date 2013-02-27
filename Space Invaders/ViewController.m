//
//  ViewController.m
//  Space Invaders
//
//  Created by Alex Dzeda on 2/17/13.
//  Copyright (c) 2013 DzDev. All rights reserved.
//

#import "ViewController.h"
#define IS ==

@interface ViewController ()

@end

@implementation ViewController


//Booleans
-(Boolean) pastRBoundary
{
    //Determines if you will go past the right edge of screen on next turn.
    int last= [self lastXRow];
    
    if([[self getAlien:0 :last] getX]+[[self getAlien:0 :last] getWidth] + [[self getAlien:0 :last] getSpeedX] > widthX)
        return true;
    return false;
    
}
-(Boolean) pastLBoundary
{
    int first= [self firstXRow];
    //Determines if you will go past the left edge of screen on next turn.
    if([[self getAlien:0 :first] getX]+ [[self getAlien:0 :first] getSpeedX] < 0)
        return true;
    return false;
}
-(Boolean) allAliensHidden
{
    //Checks if all aliens are hidden from view (i.e. killed)
    for(int r = 0; r<4; r++)
    {
        for(int c =0; c<6;c++)
        {
            if(gameOver == false && [self isHidden:r :c] ==FALSE)
            {
                return false;
            }
        }
    }
    return true;
}
-(Boolean) isBlockHidden: (int) r;
{
    //Returns true if it has been hit, false otherwise.
    if([[self getBlock:r] isHidden] ==TRUE)
        return true;
    return false;
}

-(Boolean) isHidden: (int) r : (int) c;
{
    //Returns true if it has been hit, false otherwise.
    if([[self getAlien:r :c] isHidden] ==TRUE)
        return true;
    return false;
}
-(Boolean) isRowHidden: (int) c;
{
    //counts amount of hidden objects in a row. if not full, then return false.
    int countHidden = 0;
    for(int i = 0; i<6; i++)
    {
        if([self isHidden:c :i])
        {
            countHidden++;
        }
    }
    if(countHidden<6)
        return false;
    return true;
    
}
//Integers
-(int) firstXRow
{
    // Finds and returns first row with live aliens
    int firstXRow = 0;
    
    if([self isHidden:0:0] && [self isHidden:1:0] && [self isHidden:2:0] && [self isHidden:3:0])
    {
        firstXRow=1;
    }
    if([self isHidden:0:1] && [self isHidden:1:1] && [self isHidden:2:1] && [self isHidden:3:1] && firstXRow==1)
    {
        firstXRow=2;
    }
    if([self isHidden:0:2] && [self isHidden:1:2] && [self isHidden:2:2] && [self isHidden:3:2] && firstXRow==2)
    {
        firstXRow=3;
    }
    if([self isHidden:0:3] && [self isHidden:1:3] && [self isHidden:2:3] && [self isHidden:3:3] && firstXRow==3)
    {
        firstXRow=4;
    }
    if([self isHidden:0:4] && [self isHidden:1:4] && [self isHidden:2:4] && [self isHidden:3:4] && firstXRow==4)
    {
        firstXRow=5;
    }
    
    return firstXRow;
    
}
-(int) lastXRow
{
    // Finds and returns last row with live aliens
    int lastXRow = 5;
    if([self isHidden:0:5] && [self isHidden:1:5] && [self isHidden:2:5] && [self isHidden:3:5])
    {
        lastXRow=4;
    }
    if([self isHidden:0:4] && [self isHidden:1:4] && [self isHidden:2:4] && [self isHidden:3:4] && lastXRow==4)
    {
        lastXRow=3;
    }
    if([self isHidden:0:3] && [self isHidden:1:3] && [self isHidden:2:3] && [self isHidden:3:3]&& lastXRow==3)
    {
        lastXRow=2;
    }
    if([self isHidden:0:2] && [self isHidden:1:2] && [self isHidden:2:2] && [self isHidden:3:2] && lastXRow==2)
    {
        lastXRow=1;
    }
    if([self isHidden:0:1] && [self isHidden:1:1] && [self isHidden:2:1] && [self isHidden:3:1] && lastXRow==1)
    {
        lastXRow=0;
    }
    //returns the last row where there are monsters doing their thing.
    return lastXRow;
    
}
-(int) bottomRow
{
    int finalRow = [rowArray count] - 1;
    if([self isRowHidden:1])
    {
        finalRow = 0;
    }
    else if([self isRowHidden:2])
    {
        finalRow = 1;
    }
    else if([self isRowHidden:3])
    {
        finalRow = 2;
    }
    return finalRow;
}
//Movable Object return methods
-(MovableObject*) getAlien: (int) r : (int) c ;
{
    //quicker and neater than getting rowArray
    return [[rowArray objectAtIndex:r] objectAtIndex:c];
    
}
-(MovableObject*) getBlock: (int) r;
{
    //quicker and neater than getting rowArray
    return [blockArray objectAtIndex:r];
    
}
-(MovableObject*) getAlienBullet: (int) index
{
    return [alienBulletArray objectAtIndex:index];
}


-(void) fixDirection
{
    //calls methods to determine if monsters will pass boundaries upon next move and if so changes direction + makes them go down predefined pixel amount
    if([self pastLBoundary] || [self pastRBoundary])
    {
        for(int i = 0; i<4; i++)
        {
            for(int j = 0; j<6; j++)
            {
                [[self getAlien:i :j] setSpeedX: [[self getAlien:i :j] getSpeedX]*-1];
                [[self getAlien:i :j] setY: [[self getAlien:i :j] getY]+20];
            }
        }
    }
    
}
-(void) alienMove //Master Alien movement method
{
    //Makes sure aliens go the correct direction, and then actually move them.
    [self fixDirection];
    [self moveAliens];
}

-(void) alienAttack
{
    [self alienBulletCreate];
    [self alienBlockCollisionCheck];
}
-(void) alienBlockCollisionCheck
{
    //Determines if a valid alien hits a valid block
    for(int i = 0; i<4; i++)
    {
        for(int k = 0; k<6; k++)
        {
            for(int j = 0; j<4; j++)
            {
                if([[self getAlien:i :k]  intersects: [self getBlock:j]] && [self isBlockHidden:j]==false && [self isHidden: i :k]==false && [[self getBlock:j] getSpeedX] >= 0)
                {
                    [self updateBlockState:j :0];
                    [[self getAlien:i :k] setHidden: TRUE];
                }
            }
        }
    }
}
-(void) alienShipCollisionCheck
{
    for(int i = 0; i<4; i++)
    {
        for(int k = 0; k<6; k++)
        {
            if([self isHidden:i :k]==FALSE && [[self getAlien:i :k] intersects: ship])
            {
                
                [ship removeFromSuperview];
                [self gameIsOver:1];
                
            }
        }
    }
    
}
-(void) gameIsOver: (int) typeOfGameOver
{
    // handle game over scenarios depending upon an integer sent.
    //key: 0: game not started, 1: shot/hit and killed by them. 2: they invade, 3=advance lvl
    gameOver=true;
    if(typeOfGameOver<3)
    {
        level=0;
        [self updateLosses];
    }
    else
    {
        [self updateWins];
    }
    [self gameOverMessage:typeOfGameOver];
    [self gameOverRemoveButtons];
    [self createStartButton:typeOfGameOver];
    
    
}
-(void) gameOverRemoveButtons
{
    [self removeButtonsAfterGame];
    //[self createStartButton:0];
}
-(void) gameOverMessage:(int) typeOfGameOver
{
    UIAlertView *alert;
    if(typeOfGameOver==1){
        alert = [self makeAlert:@"Ouch!" :@"You've been killed!" :@"Ok"];
    }
    else if(typeOfGameOver==2)
    {
        alert = [self makeAlert:@"Ouch!" :@"You let the monsters invade!" :@"Ok"];
    }
    else{
        alert = [self makeAlert:@"Wow!" :@"You've advanced to the next level!" :@"Ok"];
    }
    [alert show];
}
-(UIAlertView*) makeAlert:(NSString*) titles :(NSString*) messages : (NSString*) cancelButton
{
    return  [[UIAlertView alloc] initWithTitle:titles message:messages delegate:self cancelButtonTitle:cancelButton otherButtonTitles:nil , nil];
}
-(void) alienInvasionCheck
{
    if(gameOver==false)
    {
        for(int i = 0; i<4; i++)
        {
            for(int k = 0; k<6; k++)
            {
                if([self isHidden:i :k]==FALSE && [[self getAlien:i :k] getY] >= heightY-200)
                {
                    
                    [ship removeFromSuperview];
                    [self gameIsOver:2];
                    [self createStartButton:0];
                    
                }
            }
        }
    }
    
}
-(void) updateLosses
{
    NSString *strNum;
    losses++;
    strNum = [NSString stringWithFormat:@"%i",wins];
    [[NSUserDefaults standardUserDefaults] setObject:strNum forKey:@"wins"];
    strNum = [NSString stringWithFormat:@"%i",losses];
    [[NSUserDefaults standardUserDefaults] setObject:strNum forKey:@"losses"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

-(void) updateWins
{
    
    NSString *strNum;
    wins++;
    strNum = [NSString stringWithFormat:@"%i",wins];
    [[NSUserDefaults standardUserDefaults] setObject:strNum forKey:@"wins"];
    strNum = [NSString stringWithFormat:@"%i",losses];
    [[NSUserDefaults standardUserDefaults] setObject:strNum forKey:@"losses"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

-(void) alienBulletCreate
{
    /*
     aliens that are not dead fire a bullet at a random chance and are added to an array.
     also creates a timer for the aliens bullets (I bet there's a way to make it more efficient.
     Perhaps instead of just using the bottom row I'll make a method that finds the first open one on each column.
     */
    for(int i =0; i<6; i++)
    {
        int randomNumber = rand() % (1000 - level*5);
        if(randomNumber == 1 && [self isHidden:[self bottomRow] :i] == NO)
        {
            //make this a separate method later
            MovableObject *bullet = [[MovableObject alloc] initWithX:[[self getAlien:[self bottomRow] :i] getX]+24 withY:[[self getAlien:[self bottomRow] :i] getY]+90 withWidth: 8 withHeight:55];
            [bullet setSpeedY: 5 + level/2];
            [self.view addSubview:bullet];
            [bullet setImage:[UIImage imageNamed:@"alienLaserFire.png"]];
            [alienBulletArray addObject:bullet];
            [NSTimer scheduledTimerWithTimeInterval:.1f target: self selector: @selector(handleAlienBulletTimer:) userInfo: nil repeats: YES];
        }
        
    }
}
//Timers
-(void) handleObjectTimer:(NSTimer *) objecttimer
{
    if(isPaused==true)
    {
        
    }
    else if(gameOver == false){
        
        //Moves aliens and ensures they go the right direction and go all around board
        [self alienMove];
        //Handles bullets and collisions (could be branched differently)
        [self alienAttack];
        //Checks for collisions with the blocks
        [self alienBlockCollisionCheck];
        //Checks for collision with user
        [self alienShipCollisionCheck];
        //Checks if you screwed up and lost the game
        [self alienInvasionCheck];
        
    }
    else{
        [objecttimer invalidate];
        objecttimer = nil;
    }
}
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    int k = (int)(acceleration.x*15);
    k=k;
    if(isPaused IS false)
    {
    [ship moveToAccel:k];
    if([ship getX] <0)
    {
        [ship setX:0];
    }
    else if([ship getX] + [ship getWidth] > widthX)
    {
        [ship setX: widthX- [ship getWidth]];
    }
    }
}

-(void) handleAlienBulletTimer:(NSTimer *) timer
{
    
    if(isPaused IS true)
    {
        
    }
    else if(gameOver IS false)
    {
        [self checkAlienBulletBoundary];
        [self bulletIntersectBlock];
    }
    else
    {
        [timer invalidate];
        timer = nil;
    }
}
- (void) handleTimer:(NSTimer *) mytimer
{
    if(isPaused==true)
    {
        
    }
    else if(gameOver == TRUE)
    {
        [mytimer invalidate];
        mytimer = nil;
        
    }
    else{
        if(timerStarted ==0)
        {
            [NSTimer scheduledTimerWithTimeInterval:.1f target: self selector: @selector(handleObjectTimer:) userInfo: nil repeats: YES];
            timerStarted = 1;
        }
    }
}
-(void) hideAllAliens
{
    for(int k = 0; k<[rowArray count]; k++)
    {
        for(int i = 0; i<[[rowArray objectAtIndex:1] count]; i++)
        {
            [[self getAlien:k:i] removeFromSuperview];
        }
    }
}
-(void) hideAllBlocks
{
    for(int i = 0; i<[blockArray count]; i++)
    {
        [[self getBlock:i] removeFromSuperview];
        
    }
}
-(void) returnAllBlocks
{
    for(int i=0; i<[blockArray count]; i++)
    {
        [self.view addSubview:[self getBlock:i]];
    }
}
-(void) hideShip
{
    [ship removeFromSuperview];
    
}
-(void) hideAllUserBullets
{
    for(int b = 0; b<[bulletArray count]; b++)
    {
        [[bulletArray objectAtIndex:b] removeFromSuperview];
    }
}
-(void) returnAllUserBullets
{
    for(int b = 0; b<[bulletArray count]; b++)
    {
        [self.view addSubview:[bulletArray objectAtIndex:b]];
    }
}
-(void) pauseRemoveObjects
{
    //[self hideAllAliens];
    //[self hideAllBlocks];
    //[self hideShip];
    [self removeButtonsAfterGame];
    //[self hideAllAlienBullets];
    //[self hideAllUserBullets];
    
    
}
-(void) hideAllAlienBullets
{
    for(int b = 0; b<[alienBulletArray count]; b++)
    {
        [[alienBulletArray objectAtIndex:b] removeFromSuperview];
    }
}
-(void) returnAllAlienBullets
{
    for(int b = 0; b<[alienBulletArray count]; b++)
    {
        [self.view addSubview:[alienBulletArray objectAtIndex:b]];
        
    }
}
-(void) restoreAliens
{
    for(int k = 0; k<[rowArray count]; k++)
    {
        for(int i = 0; i<[[rowArray objectAtIndex:1] count]; i++)
        {
            if([self getAlien:k :i])
            {
                [self.view addSubview:[self getAlien:k :i]];
            }
        }
    }
}
-(void) restartGame
{
    [self returnAllUserBullets];
    [self returnShip];
    [self returnAllAlienBullets];
    [self restoreAliens];
    [self returnAllBlocks];
    [self.view addSubview:fireButton];
   /* if(gameOver==false)
    {
        [self createFireButton];
    }
    */
    
    
}
-(void) returnShip
{
    [self.view addSubview:ship];
}

-(void) moveAliens //Moves Aliens
{
    for(int r=0; r<4; r++)
    {
        for(int c =0; c<6; c++)
        {
            [[[rowArray objectAtIndex:r] objectAtIndex:c] move];
        }
    }
    
}
-(void) bulletIntersectBlock
{
    int countInt = [alienBulletArray count];
    int countBlocks = [blockArray count];
    for(int i = 0; i<countInt; i++)
    {
        for(int b = 0; b<countBlocks; b++)
        {
            if(countInt > 0 && [[self getAlienBullet:i] intersects:[self getBlock:b]] == TRUE && [[self getBlock:b] getSpeedX] >= 0 && [self isBlockHidden:b]==FALSE)
            {
                [[self getAlienBullet:i] removeFromSuperview];
                [alienBulletArray removeObjectAtIndex: i];
                [self updateBlockState:b:[[self getBlock:b] getSpeedX]];
                countInt = [alienBulletArray count];
                i=0;
                b=0;
            }
        }
        countInt = [alienBulletArray count];
    }
}
-(void) checkAlienBulletBoundary
{
    int countInt = [alienBulletArray count];
    for(int i = 0; i<countInt; i++)
    {
        if(countInt >0)
        {
            [[self getAlienBullet:i] moveDown ];
            if([[self getAlienBullet:i] getY] >800)
            {
                [[self getAlienBullet:i] removeFromSuperview];
                [alienBulletArray removeObjectAtIndex: i];
                countInt = [alienBulletArray count];
                i--;
            }
            else if([[self getAlienBullet:i] intersects:ship])
            {
                i = [alienBulletArray count];
                [self gameIsOver:1];
            }
        }
    }
    
}

-(void) updateScore:(int) amount
{
    score = score+amount;
    NSString *scoreString = [NSString stringWithFormat:@"Score: %d",score];
    scoreLabel.text = scoreString;
}
-(void) bulletBoundaryCheck
{
    int countBullets = [bulletArray count];
    for(int i = 0; i<countBullets; i++)
    {
        if(countBullets >0)
        {
            [[bulletArray objectAtIndex:i] moveUp];
            if([[bulletArray objectAtIndex: i] getY] <=20)
            {
                [[bulletArray objectAtIndex:i] removeFromSuperview];
                [bulletArray removeObjectAtIndex: i];
                
                countBullets = [bulletArray count];
                i--;
                [self updateScore:-1];
            }
        }
    }
}
-(void) bulletInterceptCheck
{
    //Checks for collisions between bullets.
    for(int b = 0; b<[bulletArray count]; b++)
    {
        for(int a =0; a< [alienBulletArray count]; a++)
        {
            if([bulletArray count] > 0 && [alienBulletArray count]>0 &&[[bulletArray objectAtIndex:b] intersects:[alienBulletArray objectAtIndex:a]])
            {
                [[bulletArray objectAtIndex:b] removeFromSuperview];
                [bulletArray removeObjectAtIndex:b];
                [[self getAlienBullet:a] removeFromSuperview];
                [alienBulletArray removeObjectAtIndex:a];
                b=0;
                a=0;
            }
        }
    }
}
-(void) bulletAlienCheck
{
    // Checks if a user bullet hits an alien and if that alien was alive.
    for(int b = 0; b<[bulletArray count]; b++)
    {
        for(int r = 0; r<4; r++)
        {
            for(int c =0; c<6;c++)
            {
                if([bulletArray count] >0)
                {
                    
                    if([[bulletArray objectAtIndex:b] intersects:[[rowArray objectAtIndex:r] objectAtIndex:c]] && [[[rowArray objectAtIndex:r] objectAtIndex:c] isHidden]==false)
                    {
                        [[self getAlien:r:c]removeFromSuperview];
                        [[self getAlien:r:c] setHidden:TRUE];
                        [[bulletArray objectAtIndex:b] removeFromSuperview];
                        [bulletArray removeObjectAtIndex: b];
                        r=0;
                        c=0;
                        b=0;
                        [self updateScore:5];
                    }
                }
            }
        }
    }
    
}
-(void) userBulletIntersectBlockCheck
{
    int countInt = [bulletArray count];
    int countBlocks = [blockArray count];
    for(int i = 0; i<countInt; i++)
    {
        for(int b = 0; b<countBlocks; b++)
        {
            if(countInt > 0 && [[bulletArray objectAtIndex:i] intersects:[self getBlock:b]] == TRUE && [[self getBlock:b] getSpeedX] >= 0 && [self isBlockHidden:b]==FALSE)
            {
                [[bulletArray objectAtIndex:i] removeFromSuperview];
                [bulletArray removeObjectAtIndex: i];
                [self updateBlockState:b:[[self getBlock:b] getSpeedX]];
                countInt = [bulletArray count];
                i=0;
                b=0;
            }
        }
        countInt = [bulletArray count];
    }
}
-(void) handleFireTimer:(NSTimer *) mytimer
{
    if(isPaused==true)
    {
        
    }
    else if(gameOver == false ){
        catcher++;
        [self bulletBoundaryCheck];
        [self userBulletIntersectBlockCheck];
        if(catcher>0)
        {
            [self bulletAlienCheck];
            [self bulletInterceptCheck];
            if([self allAliensHidden] && gameOver == false)
            {
                [self gameIsOver:3];
            }
        }
    }
    else{
        [mytimer invalidate];
        mytimer = nil;
        
    }
    
}
-(void) handleLaserTimer:(NSTimer *) mytimer
{
    if(isPaused==true )
    {
        
    }
    else if(gameOver == false && [laser getTime]>1 ){
        for(int i = 0; i<4; i++)
        {
            for(int j = 0; j<6; j++)
            {
                if([laser intersects:[self getAlien:i :j]] && [self isHidden:i :j] == false)
                {
                    [self updateScore: 5];
                    [[self getAlien:i :j] setHidden:TRUE];
                    
                    
                }
            }
        }
        if([self allAliensHidden] && gameOver == false)
        {
            [self gameIsOver:3];
        }
        [laser setTime:[laser getTime]-1];
        
    }
    else{
        [laser removeFromSuperview];
        [mytimer invalidate];
        mytimer = nil;
        
        
    }
    
}
-(void) removeButtonsAfterGame
{
    // [leftButton removeFromSuperview];
    //   [rightButton removeFromSuperview];
    [fireButton removeFromSuperview];
}

-(void) createUser
{
    //creates the User controlled object (the ship)
    ship = [[MovableObject alloc] initWithX:widthX/2-50 withY:heightY-200 withWidth:80 withHeight:44];
    [ship setImage:[UIImage imageNamed:@"spaceship2.png"]];
    [ship setSpeed: 8];
    [self.view addSubview:ship];
}
-(void) allocArrays
{
    rowArray = [[NSMutableArray alloc]init];
    bulletArray = [[NSMutableArray alloc]init];
    blockArray = [[NSMutableArray alloc]init];
    alienBulletArray = [[NSMutableArray alloc]init];
    if(level==1)
    {
        row0 = [[NSMutableArray alloc]init];
        row1 = [[NSMutableArray alloc]init];
        row2 = [[NSMutableArray alloc]init];
        row3 = [[NSMutableArray alloc]init];
    }
}
// screen 1024 x 768
// 4x4
//320-55 265.
//768 wide, 20 down, 192 each
-(void) mainStartButtonTouched: (UIButton *) sender
{
    if(isPaused==TRUE)
    {
        
    }
    else{
        [self firstLevelInit];
        catcher = 0;
        level++;
        [self levelInitialize];
        gameOver =false;
        [NSTimer scheduledTimerWithTimeInterval:.02f target: self selector: @selector(handleObjectTimer:) userInfo: nil repeats: YES];
    }
}
-(void) firstLevelInit
{
    if(level==0)
    {
        score=10;
    }
}
-(void) levelInitialize
{
    [mainStartButton removeFromSuperview];
    [self initContentView];
    [self allocArrays];
    [self addRowsToArray];
    [self createUser];
    [self createBlocks];
    [self createFireButton];
    [self initWinLoss];
    [self createLabels];
    [self replenishAliens];
}
-(void) createNewAliens
{
    for(int r =0; r<4; r++)
    {
        for(int c =0; c<6; c++)
        {
            int speedway = (level+1)/2;
            MovableObject *temp = [[MovableObject alloc] initWithX:18+c*90 withY:40+r*80 withWidth: 60 withHeight:60 withSpeed:speedway];
            [self.view addSubview:temp];
            [temp setImage:[UIImage imageNamed:@"aliensHD.png"]];
            if(r==0)
            {
                [row0 addObject:temp];
            }
            else if(r==1)
            {
                [row1 addObject:temp];
            }
            else if(r==2)
            {
                [row2 addObject:temp];
            }
            else
            {
                [row3 addObject:temp];
            }
        }
    }
    
    
}
-(void) replenishAliens
{
    //replenishes aliens on screen after new level started
    if(level<=1)
    {
        [self createNewAliens];
    }
    else
    {
        for(int r =0; r<4; r++)
        {
            for(int c =0; c<6; c++)
            {
                int speedway = (level+1)/2;
                [[self getAlien:r :c] restartMonster:18+c*90 withY:40+r*80 withWidth: 60 withHeight:60 withSpeed:speedway];
                [[self getAlien:r :c] setHidden:false];
                [self.view addSubview:[self getAlien:r :c]];
            }
        }
    }
    
}

//Creating buttons and labels (inits)
-(void) createLabels
{
    [self createLevelLabel];
    [self createScoreLabel];
    [self createResetButton];
    [self createWinLossLabel];
    
}


-(void) createStartButton:(int) type //Creates either start or next level button
{
    mainStartButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [mainStartButton setFrame:CGRectMake(300,heightY-142, 168, 142)];
    if(type<3){
        [mainStartButton setTitle:@"Start Game" forState:UIControlStateNormal];
    }
    else{
        [mainStartButton setTitle:@"Next Level" forState:UIControlStateNormal];
    }
    [mainStartButton addTarget:self action:@selector(mainStartButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mainStartButton];
}

-(void) createFireButton
{
    //creates the button used to fire bullets.
    fireButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [fireButton setFrame: CGRectMake(300,heightY-142, 168, 142)];
    //[fireButton addTarget: self action:@selector(fireSuperWeapon:) forControlEvents: UIControlEventTouchUpInside];
    [fireButton addTarget: self action:@selector(fireAtAlien:) forControlEvents: UIControlEventTouchUpInside];
    
    [self.view addSubview: fireButton];
    [fireButton setImage:[UIImage imageNamed:@"fireButton.png"] forState:UIControlStateNormal];
}

-(void) createLevelLabel
{
    //creates a label that displays the level.
    levelLabel = [[UILabel alloc] initWithFrame:CGRectMake(768-192*2, 0, 192, 20)];
    NSString *levelString = [NSString stringWithFormat:@"Level: %d",level];
    levelLabel.text = levelString;
    levelLabel.backgroundColor = [UIColor orangeColor];
    [self.view addSubview: levelLabel];
}
-(void) createResetButton
{
    //creates a button to reset the score. will be changed
    resetButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[resetButton setFrame:CGRectMake(768-192,0, 192, 20)];
	[resetButton setTitle:@"Pause Game" forState:UIControlStateNormal];
	//[resetButton addTarget:self action:@selector(resetStats:) forControlEvents:UIControlEventTouchUpInside];
    [resetButton addTarget:self action:@selector(upgradeScreen:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:resetButton];
    [resetButton setBackgroundColor:[UIColor orangeColor]];
}
-(void) createScoreLabel
{
    //creates a label that displays the user score.
    scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 192, 20)];
    NSString *scoreString = [NSString stringWithFormat:@"Score: %d",score];
    scoreLabel.text = scoreString;
    scoreLabel.backgroundColor = [UIColor orangeColor];
    [self.view addSubview: scoreLabel];
}
-(void) addRowsToArray
{
    [rowArray addObject:row0];
    [rowArray addObject:row1];
    [rowArray addObject:row2];
    [rowArray addObject:row3];
}

//Block Methods
-(void) createBlocks
{
    [self placeBlocksInPosition];
    [self addBlocksToView];
    [self assignImageToBlocks];
    [self addBlocksToArray];
}
-(void) placeBlocksInPosition
{
    blockOne = [[MovableObject alloc] initWithX:74 withY:heightY-275 withWidth:100 withHeight:50 withSpeed:2];
    blockTwo= [[MovableObject alloc] initWithX:74*2+100 withY:heightY-275 withWidth:100 withHeight:50 withSpeed:2];
    blockThree= [[MovableObject alloc] initWithX:74*3+200 withY:heightY-275 withWidth:100 withHeight:50 withSpeed:2];
    blockFour= [[MovableObject alloc] initWithX:74*4+300 withY:heightY-275 withWidth:100 withHeight:50 withSpeed:2];
}
-(void) addBlocksToView
{
    [self.view addSubview:blockOne];
    [self.view addSubview:blockTwo];
    [self.view addSubview:blockThree];
    [self.view addSubview:blockFour];
}
-(void) assignImageToBlocks
{
    [blockOne setImage:[UIImage imageNamed:@"fullblockHR.png"]];
    [blockTwo setImage:[UIImage imageNamed:@"fullblockHR.png"]];
    [blockThree setImage:[UIImage imageNamed:@"fullblockHR.png"]];
    [blockFour setImage:[UIImage imageNamed:@"fullblockHR.png"]];
}
-(void) addBlocksToArray
{
    [blockArray addObject:blockOne];
    [blockArray addObject:blockTwo];
    [blockArray addObject:blockThree];
    [blockArray addObject:blockFour];
}
-(void) updateBlockState: (int) blockNumber : (int) blockState //Updates blocks
{
    if(blockState==0)
    {
        //Normally, the 0 would be repetitive, but one method skips stages and goes right to this
        [[self getBlock: blockNumber] setSpeedX:0];
        [[self getBlock: blockNumber] setHidden:TRUE];
    }
    else if(blockState==2)
    {
        [[self getBlock: blockNumber] setSpeedX:1];
        [[self getBlock: blockNumber] setImage: [UIImage imageNamed:@"blockHitOne.png"]];
    }
    else if(blockState==1)
    {
        [[self getBlock: blockNumber] setSpeedX:0];
        [[self getBlock: blockNumber] setImage: [UIImage imageNamed:@"blockHitTwo.png"]];
    }
}
//Initializing methods
-(void) initContentView
{
    //initializes the View for the application and the width and height of the screen
    CGRect appRect = [[UIScreen mainScreen] applicationFrame];
    UIView *contentView = [[UIView alloc] initWithFrame:appRect];
	contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"galaxyBackground.png"]];
	contentView.autoresizesSubviews = YES;
    
	contentView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
	self.view = contentView;
    widthX = appRect.size.width;
    heightY = appRect.size.height;
}
- (void)loadView
{
    gameOver = true;
    score = 0;
    level = 0;
    [self initContentView];
    [self initWinLoss];
    [self createStartButton:0];
    [self createLabels];
    self.accelerometer = [UIAccelerometer sharedAccelerometer];
    self.accelerometer.updateInterval = .02;
    self.accelerometer.delegate = self;
}
-(void) initWinLoss
{
    NSString *strNum = [[NSUserDefaults standardUserDefaults] objectForKey: @"wins"];
    wins = 0;
    if(strNum !=nil)
        wins = [strNum intValue];
    
    strNum= [[NSUserDefaults standardUserDefaults] objectForKey: @"losses"];
    losses = 0;
    if(strNum !=nil)
        losses = [strNum intValue];
}
-(void)createWinLossLabel
{
    winLossLabel = [[UILabel alloc] initWithFrame:CGRectMake(192, 0, 192, 20)];
    NSString *winLossString = [NSString stringWithFormat:@"W: %d L: %d",wins,losses];
    winLossLabel.text = winLossString;
    winLossLabel.backgroundColor = [UIColor orangeColor];
    [self.view addSubview: winLossLabel];
}
//Button actions
-(IBAction)fireAtAlien:(id)sender
{
    if(sender == fireButton && gameOver == false)
    {
        MovableObject *bullet = [[MovableObject alloc] initWithX:[ship getX]+35 withY:[ship getY]-50 withWidth: 10 withHeight:50];
        [bullet setSpeedY: 20];
        [self.view addSubview:bullet];
        [bullet setImage:[UIImage imageNamed:@"shipLaser.png"]];
        [bulletArray addObject:bullet];
        [NSTimer scheduledTimerWithTimeInterval:.1f target: self selector: @selector(handleFireTimer:) userInfo: nil repeats: YES];
    }
}
-(IBAction) fireSuperWeapon:(id) sender
{
    [laser removeFromSuperview];
    laser = [[MovableObject alloc] initWithX:[ship getX] withY:50 withWidth:[ship getWidth] withHeight:750];
    [laser setTime: 27];
    [self.view addSubview:laser];
    [laser setImage: [UIImage imageNamed:@"bullet.png"]];
    
    [NSTimer scheduledTimerWithTimeInterval:.1f target: self selector: @selector(handleLaserTimer:) userInfo: nil repeats: YES];
    
}
-(IBAction) upgradeScreen:(id) sender
{
    isPaused=true;
    [self pauseRemoveObjects];
    [resetButton setTitle:@"Resume Game" forState:UIControlStateNormal];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pausedBackground.png"]];
    [resetButton addTarget:self action:@selector(restartScreen:) forControlEvents:UIControlEventTouchUpInside];
}
-(IBAction) restartScreen:(id) sender
{
    [self restartGame];
    isPaused=false;
    [resetButton setTitle:@"Pause Game" forState:UIControlStateNormal];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"galaxyBackground.png"]];
    [resetButton addTarget:self action:@selector(upgradeScreen:) forControlEvents:UIControlEventTouchUpInside];
}


-(void) superWeaponUsed
{
    superWeaponCount--;
}
/*
 -(void) createUpgradeOptionButtons
 {
 
 }
 -(void) initExtraLifeUpgrade
 {
 [self createExtraLifeBuyButton];
 [self createExtraLifeLabel];
 }
 -(void) createExtraLifeLabel
 {
 
 }
 -(void) createExtraLifeBuyButton
 {
 
 }
 */
-(IBAction) resetStats:(id) sender
{
    wins=0;
    losses = 0;
    NSString *strNum;
    strNum = [NSString stringWithFormat:@"%i",wins];
    [[NSUserDefaults standardUserDefaults] setObject:strNum forKey:@"wins"];
    strNum = [NSString stringWithFormat:@"%i",losses];
    [[NSUserDefaults standardUserDefaults] setObject:strNum forKey:@"losses"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    winLossLabel = [[UILabel alloc] initWithFrame:CGRectMake(192, 0, 192, 20)];
    NSString *winLossString = [NSString stringWithFormat:@"W: %d L: %d",wins,losses];
    winLossLabel.text = winLossString;
    winLossLabel.backgroundColor = [UIColor orangeColor];
    [self.view addSubview: winLossLabel];
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}


@end
