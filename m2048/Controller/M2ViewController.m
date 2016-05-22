//
//  M2ViewController.m
//  m2048
//
//  Created by Danqing on 3/16/14.
//  Copyright (c) 2014 Danqing. All rights reserved.
//

#import "M2ViewController.h"
#import "M2SettingsViewController.h"

#import "M2Scene.h"
#import "M2GameManager.h"
#import "M2ScoreView.h"
#import "M2Overlay.h"
#import "M2GridView.h"

@implementation M2ViewController {
  IBOutlet UIButton *_restartButton;
  IBOutlet UIButton *_settingsButton;
  IBOutlet UILabel *_targetScore;
  IBOutlet UILabel *_subtitle;
  IBOutlet M2ScoreView *_scoreView;
  IBOutlet M2ScoreView *_bestView;
  
  M2Scene *_scene;
  
  IBOutlet M2Overlay *_overlay;
  IBOutlet UIImageView *_overlayBackground;
    UIView * _snapshotView;

}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [self updateState];
  
  _bestView.score.text = [NSString stringWithFormat:@"%ld", (long)[Settings integerForKey:@"Best Score"]];
  
  _restartButton.layer.cornerRadius = [GSTATE cornerRadius];
  _restartButton.layer.masksToBounds = YES;
  
  _settingsButton.layer.cornerRadius = [GSTATE cornerRadius];
  _settingsButton.layer.masksToBounds = YES;
  
  _overlay.hidden = YES;
  _overlayBackground.hidden = YES;
  
  // Configure the view.
  SKView * skView = (SKView *)self.view;
  
  // Create and configure the scene.
  M2Scene * scene = [M2Scene sceneWithSize:skView.bounds.size];
  scene.scaleMode = SKSceneScaleModeAspectFill;
  
  // Present the scene.
  [skView presentScene:scene];
  [self updateScore:0];
  [scene startNewGame];
  
  _scene = scene;
  _scene.controller = self;
}


- (void)updateState
{
  [_scoreView updateAppearance];
  [_bestView updateAppearance];
  
  _restartButton.backgroundColor = [GSTATE buttonColor];
  _restartButton.titleLabel.font = [UIFont fontWithName:[GSTATE boldFontName] size:14];
  
  _settingsButton.backgroundColor = [GSTATE buttonColor];
  _settingsButton.titleLabel.font = [UIFont fontWithName:[GSTATE boldFontName] size:14];
  
  _targetScore.textColor = [GSTATE buttonColor];
  
  long target = [GSTATE valueForLevel:GSTATE.winningLevel];
  
  if (target > 100000) {
    _targetScore.font = [UIFont fontWithName:[GSTATE boldFontName] size:34];
  } else if (target < 10000) {
    _targetScore.font = [UIFont fontWithName:[GSTATE boldFontName] size:42];
  } else {
    _targetScore.font = [UIFont fontWithName:[GSTATE boldFontName] size:40];
  }
  
  _targetScore.text = [NSString stringWithFormat:@"%ld", target];
  
  _subtitle.textColor = [GSTATE buttonColor];
  _subtitle.font = [UIFont fontWithName:[GSTATE regularFontName] size:14];
  _subtitle.text = [NSString stringWithFormat:@"Join the numbers to get to %ld!", target];
  
  _overlay.message.font = [UIFont fontWithName:[GSTATE boldFontName] size:36];
  _overlay.keepPlaying.titleLabel.font = [UIFont fontWithName:[GSTATE boldFontName] size:17];
  _overlay.restartGame.titleLabel.font = [UIFont fontWithName:[GSTATE boldFontName] size:17];
  
  _overlay.message.textColor = [GSTATE buttonColor];
  [_overlay.keepPlaying setTitleColor:[GSTATE buttonColor] forState:UIControlStateNormal];
  [_overlay.restartGame setTitleColor:[GSTATE buttonColor] forState:UIControlStateNormal];
}


- (void)updateScore:(NSInteger)score
{
  _scoreView.score.text = [NSString stringWithFormat:@"%ld", (long)score];
  if ([Settings integerForKey:@"Best Score"] < score) {
    [Settings setInteger:score forKey:@"Best Score"];
    _bestView.score.text = [NSString stringWithFormat:@"%ld", (long)score];
  }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
  // Pause Sprite Kit. Otherwise the dismissal of the modal view would lag.
  ((SKView *)self.view).paused = YES;
}


- (IBAction)restart:(id)sender
{
  [self hideOverlay];
  [self updateScore:0];
  [_scene startNewGame];
//    
//   //    Do any additional setup after loading the view.
//    
//    //    BOOL afterScreenUpdates = YES;
//    UIScreen *mainScreen = [UIScreen mainScreen];
//    CGSize screenSize = mainScreen.bounds.size;
//    
//    //    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
//    
//    
//    
//    
//    //    UIView *snapshotView = [UIWindow snapshotViewAfterScreenUpdates:YES];
//    //    UIImage *snapshotImage = [self imageFromView:snapshotView];
//    
//    //    UIImage *myImage = UIGraphicsGetImageFromCurrentImageContext();
//    ////    UIView *snapshotView = [mainScreen snapshotViewAfterScreenUpdates:afterScreenUpdates];
//    UIGraphicsBeginImageContextWithOptions(screenSize, YES, 0);
//    //
//    //   UIView *keyWindowSnapshotView = [keyWindow snapshotViewAfterScreenUpdates:YES];
//    //
//    //    UIView *windowSnapshot = [[keyWindow rootViewController].view snapshotViewAfterScreenUpdates:NO];
//    //
//    //    [keyWindow addSubview:keyWindowSnapshotView];
//    //
//    //    CGContextRef context = UIGraphicsGetCurrentContext();
//    //    [keyWindowSnapshotView drawViewHierarchyInRect:CGRectMake(0, 0, screenSize.width, screenSize.height) afterScreenUpdates:YES];
//    ////    [keyWindow.layer renderInContext:context];
//    
//    ////    [snapshotView drawViewHierarchyInRect:snapshotView.bounds afterScreenUpdates:afterScreenUpdates];
//    //    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
//    //            [window.layer renderInContext:context];
//    ////        [window drawViewHierarchyInRect:CGRectMake(0, 0, screenSize.width, screenSize.height) afterScreenUpdates:NO];
//    //        UIView *windowSnapshot = [window snapshotViewAfterScreenUpdates:NO];
//    //        windowSnapshot drawViewHierarchyInRect:<#(CGRect)#> afterScreenUpdates:<#(BOOL)#>
//    ////        UIView *rootViewControllerSnapshot = [window.rootViewController.view snapshotViewAfterScreenUpdates:afterScreenUpdates];
//    ////        UIView *snapShotView = [window snapshotViewAfterScreenUpdates:afterScreenUpdates];
//    //            CGContextRef context = UIGraphicsGetCurrentContext();
//    //        CALayer *windowLayer = [window layer];
//    //        [windowLayer drawInContext:context];
//    //        [windowSnapshot drawViewHierarchyInRect:CGRectMake(0, 0, screenSize.width, screenSize.height) afterScreenUpdates:NO];
//    //}
//    
//    if(_snapshotView) {
//        [_snapshotView drawViewHierarchyInRect:CGRectMake(0, 0, screenSize.width, screenSize.height) afterScreenUpdates:NO];
//    }
//    
//    _snapshotView = [[UIScreen mainScreen] snapshotViewAfterScreenUpdates:NO];
//    //    [[self view] addSubview:screenView];
//    //    [screenView drawViewHierarchyInRect:CGRectMake(0, 0, screenSize.width, screenSize.height) afterScreenUpdates:YES];
//    
//    
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    // Generate the new view here
//    _snapshotView =[[UIScreen mainScreen] snapshotViewAfterScreenUpdates:NO];
//    _snapshotView.hidden = false;
//    
////    [[[self view]superview]addSubview:_snapshotView];
//    
//    [[[UIApplication sharedApplication] windows][1] addSubview:_snapshotView];
//    
//   
//    NSString *uuidString = [[NSUUID UUID] UUIDString];
//    NSString *filename = [NSString stringWithFormat:@"/Library/Caches/screencap-%0d-%@.jpg", 1, uuidString];
//    //    NSLog(@"Vending out temp filename: %@", filename);
//    NSString *outputPath = [NSHomeDirectory() stringByAppendingPathComponent:filename];
//    NSData *jpgRepresentation = UIImageJPEGRepresentation(image, 0.9);
//    BOOL success = [jpgRepresentation writeToFile:outputPath atomically:YES];
//    NSLog(@"Saved image to file %@: %d", outputPath, success);
    
    
}


- (IBAction)keepPlaying:(id)sender
{
  [self hideOverlay];
}


- (IBAction)done:(UIStoryboardSegue *)segue
{
  ((SKView *)self.view).paused = NO;
  if (GSTATE.needRefresh) {
    [GSTATE loadGlobalState];
    [self updateState];
    [self updateScore:0];
    [_scene startNewGame];
  }
}


- (void)endGame:(BOOL)won
{
  _overlay.hidden = NO;
  _overlay.alpha = 0;
  _overlayBackground.hidden = NO;
  _overlayBackground.alpha = 0;
  
  if (!won) {
    _overlay.keepPlaying.hidden = YES;
    _overlay.message.text = @"Game Over";
  } else {
    _overlay.keepPlaying.hidden = NO;
    _overlay.message.text = @"You Win!";
  }
  
  // Fake the overlay background as a mask on the board.
  _overlayBackground.image = [M2GridView gridImageWithOverlay];
  
  // Center the overlay in the board.
  CGFloat verticalOffset = [[UIScreen mainScreen] bounds].size.height - GSTATE.verticalOffset;
  NSInteger side = GSTATE.dimension * (GSTATE.tileSize + GSTATE.borderWidth) + GSTATE.borderWidth;
  _overlay.center = CGPointMake(GSTATE.horizontalOffset + side / 2, verticalOffset - side / 2);
  
  [UIView animateWithDuration:0.5 delay:1.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
    _overlay.alpha = 1;
    _overlayBackground.alpha = 1;
  } completion:^(BOOL finished) {
    // Freeze the current game.
    ((SKView *)self.view).paused = YES;
  }];
}


- (void)hideOverlay
{
  ((SKView *)self.view).paused = NO;
  if (!_overlay.hidden) {
    [UIView animateWithDuration:0.5 animations:^{
      _overlay.alpha = 0;
      _overlayBackground.alpha = 0;
    } completion:^(BOOL finished) {
      _overlay.hidden = YES;
      _overlayBackground.hidden = YES;
    }];
  }
}


- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Release any cached data, images, etc that aren't in use.
}

@end
