//
//  AVHUGCluesViewController.m
//  AVHeadsUpGame
//
//  Created by Ayuna Vogel on 2/21/16.
//  Copyright © 2016 Ayuna Vogel. All rights reserved.
//

#import "AVHUGCluesViewController.h"

@interface AVHUGCluesViewController ()

@property (nonatomic) NSArray *subjects;

@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;

@property (nonatomic) NSInteger cluesCount;
@property (nonatomic) NSInteger cluesCountGuessedRight;
@property (nonatomic) NSInteger timerCount;
@property (nonatomic) NSInteger index;

// http://brandcolors.net
@property (nonatomic) UIColor *twitterBlue;
@property (nonatomic) UIColor *fiveHundredPxRed;

@end

@implementation AVHUGCluesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.twitterBlue = [UIColor colorWithRed:85.00/255.0 green:172.00/255.0 blue:238.00/255.0 alpha:1.0];
    self.fiveHundredPxRed = [UIColor colorWithRed:255.00/255.0 green:76.00/255.0 blue:76.00/255.0 alpha:1.0];

    self.subjects = [[NSArray alloc]init];
    self.subjects = self.category[@"subjects"];
    NSLog(@"subjects.count in CluesViewController is %ld", self.subjects.count);
    
    self.cluesCount = 0;
    self.cluesCountGuessedRight = 0;
    
    
    [self startGetReadyTimer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Get Ready timer setup

- (void)startGetReadyTimer {
    self.view.backgroundColor = self.twitterBlue;
    self.subjectLabel.text = @"GET READY";
    
    NSTimer *getReadyTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(getReadyTimerFired:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:getReadyTimer forMode:NSRunLoopCommonModes];
    self.timerCount = 5;
    [getReadyTimer fire];
}

#pragma mark - GameTimer setup 

- (void)startGameTimer {
    NSTimer *gameTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(gameTimerFired:) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:gameTimer forMode:NSRunLoopCommonModes];
    self.timerCount = 60;
    [gameTimer fire];
    
    self.index = 0;
    self.subjectLabel.text = self.category[@"subjects"][self.index];

    [self setupGestureRecognizers];
    
}

#pragma mark - Timer Methods 

- (void)getReadyTimerFired:(NSTimer *)timer {
   
    if (self.timerCount == 0) {
        [timer invalidate];
        [self startGameTimer];
    }
    
    NSString *convertTimerCountToString = [[NSNumber numberWithInteger:self.timerCount]stringValue];
    self.timerLabel.text = convertTimerCountToString;
    
    self.timerCount--;
}

- (void)gameTimerFired:(NSTimer *)timer {
    
    if (self.timerCount == 0) {
        [timer invalidate];
        self.subjectLabel.text = @"TIME'S UP";
        self.view.backgroundColor = self.fiveHundredPxRed;
        
        // show ui alert view controller with results of the game
        //        @"%ld/%ld", self.cluesCountGuessedRight, self.cluesCount;
    }
    
    NSString *convertTimerCountToString = [[NSNumber numberWithInteger:self.timerCount]stringValue];
    self.timerLabel.text = convertTimerCountToString;
    
    self.timerCount--;
}


- (void)setupGestureRecognizers {
    UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipe:)];
    left.direction = UISwipeGestureRecognizerDirectionLeft;
    
    UISwipeGestureRecognizer *right = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipe:)];
    right.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:left];
    [self.view addGestureRecognizer:right];
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)gesture {
    
    switch (gesture.direction) {
        case UISwipeGestureRecognizerDirectionLeft: // guessed correct
            self.view.backgroundColor = [UIColor greenColor];
            self.cluesCountGuessedRight++;
            self.cluesCount++;
            self.index++;
            self.subjectLabel.text = @"CORRECT";
            break;
        case UISwipeGestureRecognizerDirectionRight: // guessed wrong
            self.view.backgroundColor = [UIColor orangeColor];
            self.cluesCount++;
            self.index++;
            self.subjectLabel.text = @"PASS";
            break;
        default:
            return;
    }
    
}

- (void)showNextClue {
    self.view.backgroundColor = self.twitterBlue;
    self.subjectLabel.text = self.category[@"subjects"][self.index];
}

@end
