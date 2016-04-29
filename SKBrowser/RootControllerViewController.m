/*
 *
 * Copyright (c) 2016, Marco A. Hudelist. All rights reserved.
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 3 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
 * MA 02110-1301 USA
 */

#import "RootControllerViewController.h"

@interface RootControllerViewController ()
{
    // The mode that the app currently is in.
    AppMode _appMode;
    AssetLoader *_assetLoader;
    BrowserViewController *_browserSame;
    UIStoryboard *_storyboard;
    StartViewController *_startViewController;
    QuestionController *_questionViewController;
    TargetDisplayViewController *_targetViewController;
    SimpleLogger *_logWriter;
    TargetManager *_targetManager;
    InitalUserInformation *_currentUserInitInfo;
    NormalBrowser *_normalBrowserController;
    ThankYou *_thankYouController;
    FinalQuestionController *_finalQuestionController;
    
    // Start of Trial
    NSDate *startTime;
    NSDate *endTime;
    
    Target *_currentTarget;
    Video *_currentVideo;
    NSUInteger _currentTargetSet;
    InitalBrowser _currentBrowser;
    NSUInteger _trialNr;
    
    NSString *_logHeaderInitalData;
    NSString *_logHeaderTrials;
    NSString *_logHeaderQuestionaire;
    NSString *_logHeaderFinalQuestions;
    
    NSTimer *_timeoutTimer;
}

@end

@implementation RootControllerViewController

// Initialization without arguments
- (id)init
{
    self = [super init];
    if (self) {
        [self customInit];
    }
    return self;
}

// Initialization with coder
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self customInit];
    }
    return self;
}

// Initialization with nib
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self customInit];
    }
    return self;
}

// Custom initializations
- (void)customInit
{
    // Setting the app mode to undefined since first start
    _appMode = amUndefined;
    
    // Get reference to storyboard
    _storyboard = [UIStoryboard storyboardWithName:@"skstoryboard" bundle:nil];
    
    // Load the normal browser
    _normalBrowserController = [_storyboard instantiateViewControllerWithIdentifier:@"normalbrowser"];
    _normalBrowserController.delegate = self;
    
    // Load thank you controller
    _thankYouController = [_storyboard instantiateViewControllerWithIdentifier:@"thankyou"];
    
    // Load final question controller
    _finalQuestionController = [_storyboard instantiateViewControllerWithIdentifier:@"finalquestion"];
    _finalQuestionController.delegate = self;
    
    // Load the color concept combination browser
    _browserSame = [_storyboard instantiateViewControllerWithIdentifier:@"browserSame"];
    _browserSame.delegate = self;
    
    // Load the start view controller
    _startViewController = [_storyboard instantiateViewControllerWithIdentifier:@"startviewcontroller"];
    _startViewController.delegate = self;
    
    // Load the question controller
    _questionViewController = [_storyboard instantiateViewControllerWithIdentifier:@"questioncontroller"];
    _questionViewController.delegate = self;
    
    _targetViewController = [_storyboard instantiateViewControllerWithIdentifier:@"targetdisplay"];
    _targetViewController.delegate = self;
    
    // Init asset loader and start loading
    _assetLoader = [[AssetLoader alloc] init];
    _assetLoader.delegate = self;
    [_assetLoader loadAssets];
    _browserSame.assetLoader = _assetLoader;
    _normalBrowserController.assetLoader = _assetLoader;
    _targetViewController.assetLoader = _assetLoader;
    
    // Init Target Manager
    _targetManager = [[TargetManager alloc] init];
    [_targetManager loadTargets];
    NSArray *dummyOrder = @[[NSNumber numberWithInt:0], [NSNumber numberWithInt:1]];
    [_targetManager setTargetSetOrder:dummyOrder];
    
    // Init log writer
    _logWriter = [[SimpleLogger alloc] init];
    
    _trialNr = 0;
    
    // Setup log headers
    _logHeaderInitalData = @"Lastname; Firstname; Age; Gender; Occupation; E-Mail; BrowserOrder; FirstTargetSet";
    _logHeaderTrials = @"TrialNr; Browser; TargetVideo; TargetStartFrame; TargetEndFrame; SubmittedFrame; Result; Time";
    _logHeaderQuestionaire = @"QuestionTitle; QuestionValue";
    _logHeaderFinalQuestions = @"PreferredBrowser;FinalComments";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Starts the study
- (void)startStudy:(InitalUserInformation *)initUserInfo
{
    _currentUserInitInfo = initUserInfo;
    _logWriter.filename = initUserInfo.lastname;
    
    NSString *browserOrder;
    
    if (initUserInfo.initialBrowser == ibNormal) {
        browserOrder = @"Normal_SKBrowser";
    } else {
        browserOrder = @"SKBrowser_Normal";
    }
    
    if (initUserInfo.firstTargetSet == 1) {
        NSArray *order = @[[NSNumber numberWithInt:0], [NSNumber numberWithInt:1]];
        [_targetManager setTargetSetOrder:order];
    } else {
        NSArray *order = @[[NSNumber numberWithInt:1], [NSNumber numberWithInt:0]];
        [_targetManager setTargetSetOrder:order];
    }
    
    NSString *gender;
    if (initUserInfo.gender == gMale) {
        gender = @"Male";
    } else {
        gender = @"Female";
    }
    
    // Construct log message for initial data
    NSString *logmsg = [NSString stringWithFormat:@"%@;%@;%d;%@;%@;%@;%@;%d", initUserInfo.lastname, initUserInfo.firstname, (int)initUserInfo.age, gender, initUserInfo.occupation, initUserInfo.email, browserOrder, (int)initUserInfo.firstTargetSet];
    [_logWriter appendToCurLogfile:_logHeaderInitalData];
    [_logWriter appendToCurLogfile:logmsg];
    [_logWriter appendToCurLogfile:_logHeaderTrials];
    
    
    // Get next target
    _currentTarget = _targetManager.getNextTarget;
    _currentVideo = [_assetLoader getVideoOfName:_currentTarget.videoName];
    _currentTargetSet = _currentTarget.targetSetIndex;
    
    // Set target
    [_targetViewController setTarget:_currentTarget];
    
    _currentBrowser = _currentUserInitInfo.initialBrowser;
    
    _browserSame.demoMode = NO;
    _normalBrowserController.demoMode = NO;
    
    [self dismissViewControllerAnimated:YES completion:^{
        _appMode = amShowTarget;
        [self presentViewController:_targetViewController animated:YES completion:nil];
    }];
}

// Start in demo mode - start with the combination browser
- (void)demoSkBrowserSame
{
    _browserSame.demoMode = YES;
    Video *video = [_assetLoader getVideoOfName:@"Demo"];
    _browserSame.video = video;
    
    [self dismissViewControllerAnimated:YES completion:^{
        _appMode = amSkBrowserDemo;
        [self presentViewController:_browserSame animated:YES completion:nil];
    }];
}

// Start in demo mode - start with the normal browser
- (void)demoNormalBrowser
{
    _normalBrowserController.demoMode = YES;
    Video *video = [_assetLoader getVideoOfName:@"Demo"];
    _normalBrowserController.video = video;
    
    [self dismissViewControllerAnimated:YES completion:^{
        _appMode = amNormalBrowserDemo;
        [self presentViewController:_normalBrowserController animated:YES completion:nil];
    }];
}

- (void)dismissDemo
{
    [self dismissViewControllerAnimated:YES completion:^{
        _appMode = amInitialDataEntry;
        [self presentViewController:_startViewController animated:YES completion:nil];
    }];
}

// Demo the target display
- (void)demoTargetDisplay
{
    [self dismissViewControllerAnimated:YES completion:^{
        _appMode = amTargetDisplayDemo;
        
        [self presentViewController:_targetViewController animated:YES completion:nil];
    }];
}

// Dismiss the start view after completing data entry
- (void)dismissStartViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Dismiss color concept combination controller after completing test
- (void)dismissSkBrowserController
{
    if (_appMode == amSkBrowserDemo) {
        [self dismissViewControllerAnimated:YES completion:^{
            _appMode = amInitialDataEntry;
            [self presentViewController:_startViewController animated:YES completion:nil];
        }];
    }
}

// Dismiss normal browser controller after completing test
- (void)dismissNormalBrowserController
{
    if (_appMode == amNormalBrowserDemo) {
        [self dismissViewControllerAnimated:YES completion:^{
            _appMode = amInitialDataEntry;
            [self presentViewController:_startViewController animated:YES completion:nil];
        }];
    }
}

// Dismiss question controller after data entry
- (void)dismissQuestionViewController
{
    if (_appMode == amQuestionDemo) {
        [self dismissViewControllerAnimated:YES completion:^{
            _appMode = amInitialDataEntry;
            [self presentViewController:_startViewController animated:YES completion:nil];
        }];
    }
}

- (void)timeoutSKBrowser
{
    [self dismissSkBrowserControllerWithFrameNr:-1];
}

- (void)timeoutNormalBrowser
{
    [self dismissNormalBrowserWithFrameNr:-1];
}

// Dismiss target display controller
- (void)dismissTargetDisplayController
{
    if (_appMode == amTargetDisplayDemo) {
        [self dismissViewControllerAnimated:YES completion:^{
            _appMode = amInitialDataEntry;
            [self presentViewController:_startViewController animated:YES completion:nil];
        }];
    } else if (_appMode == amShowTarget) {
        [self dismissViewControllerAnimated:YES completion:^{
            if (_currentBrowser == ibNormal) {
                // Start normal browser
                _normalBrowserController.video = _currentVideo;
                
                
                
                
                
                [self presentViewController:_normalBrowserController animated:YES completion:^{
                    startTime = [NSDate date];
                    _timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:180 target:self selector:@selector(timeoutNormalBrowser) userInfo:nil repeats:NO];
                }];
                
                
                
            } else if (_currentBrowser == ibSkBrowser) {
                // Start sk browser
                _browserSame.video = _currentVideo;
                
                [self presentViewController:_browserSame animated:YES completion:^{
                    startTime = [NSDate date];
                    _timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:180 target:self selector:@selector(timeoutSKBrowser) userInfo:nil repeats:NO];
                }];
            }
    
        }];
    }
}


- (void)dismissSkBrowserControllerWithFrameNr:(CGFloat)framenumber
{
    endTime = [NSDate date];
    __block NSString *result = @"Not Set";
    
    [_timeoutTimer invalidate];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        if (framenumber >= _currentTarget.startFrame - 125 && framenumber <= _currentTarget.endFrame + 125) {
            result = @"correct";
        } else if (framenumber != -1){
            result = @"incorrect";
        } else {
            result = @"timeout";
        }
        
        NSTimeInterval timeNeeded = [endTime timeIntervalSinceDate:startTime];
        
        // Write Log file...
        NSString *browser = @"SKBrowser";
        NSString *logmsg = [NSString stringWithFormat:@"%d;%@;%@;%d;%d;%d;%@;%f", (int)_trialNr, browser, _currentTarget.videoName, (int)_currentTarget.startFrame, (int)_currentTarget.endFrame, (int)framenumber, result, timeNeeded];
        _trialNr++;
        [_logWriter appendToCurLogfile:logmsg];
        
        // Still targets for this interface?
        
        _currentTarget = [_targetManager getNextTarget];
        
        if (_currentTarget != nil) {
            _currentVideo = [_assetLoader getVideoOfName:_currentTarget.videoName];
            
            // check if still same target set
            if (_currentTargetSet == _currentTarget.targetSetIndex) {
                [_targetViewController setTarget:_currentTarget];
                
                [self presentViewController:_targetViewController animated:YES completion:nil];
            } else {
                // new target set
                // go to next interface
                _currentBrowser = ibNormal;
                _currentTargetSet = _currentTarget.targetSetIndex;
                [_targetViewController setTarget:_currentTarget];
                
                // Present questions
                _questionViewController.demoMode = NO;
                _questionViewController.showSKBrowserQuestion = YES;
                [_questionViewController resetQuestions];
                [self presentViewController:_questionViewController animated:YES completion:nil];
            }
        } else {
            // no targets anymore
            // test finished
            
            // finish with something (questionaire or so...)
            
            _appMode = amStudyFinished;
            _questionViewController.demoMode = NO;
            _questionViewController.showSKBrowserQuestion = YES;
            [_questionViewController resetQuestions];
            [self presentViewController:_questionViewController animated:YES completion:nil];
            
            
        }
    }];
}

- (void)dismissQuestionViewControllerWith:(Questionaire *)questionaire
{
    // Write questions into log
    [_logWriter appendToCurLogfile:@""];
    [_logWriter appendToCurLogfile:_logHeaderQuestionaire];
    
    for (Question *q in questionaire.questions){
        NSString *logmsg = [NSString stringWithFormat:@"%@;%@", q.questionTitle, q.questionValue];
        [_logWriter appendToCurLogfile:logmsg];
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (_appMode == amStudyFinished) {
            [self presentViewController:_finalQuestionController animated:YES completion:nil];
            
        } else {
            [_logWriter appendToCurLogfile:_logHeaderTrials];
            [self presentViewController:_targetViewController animated:YES completion:nil];
            
        }
    }];
}

- (void)dismissFinalQuestionControllerWith:(FinalQuestions *)fq
{
    // Write questions into log
    [_logWriter appendToCurLogfile:@""];
    [_logWriter appendToCurLogfile:_logHeaderFinalQuestions];
    
    NSString *logmsg = [NSString stringWithFormat:@"%@;%@", fq.preferredBrowser, fq.comments];
    [_logWriter appendToCurLogfile:logmsg];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [_logWriter appendToCurLogfile:@"Study finished!"];
        [self presentViewController:_thankYouController animated:YES completion:nil];
    }];
}

- (void)dismissNormalBrowserWithFrameNr:(CGFloat)framenumber
{
    endTime = [NSDate date];
    __block NSString *result = @"Not Set";
    
    [_timeoutTimer invalidate];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        if (framenumber >= _currentTarget.startFrame - 125 && framenumber <= _currentTarget.endFrame + 125) {
            result = @"correct";
        } else if (framenumber != -1) {
            result = @"incorrect";
        } else {
            result = @"timeout";
        }
        
        NSTimeInterval timeNeeded = [endTime timeIntervalSinceDate:startTime];
        
        // Write Log file...
        NSString *browser = @"Normal";
        NSString *logmsg = [NSString stringWithFormat:@"%d;%@;%@;%d;%d;%d;%@;%f", (int)_trialNr, browser, _currentTarget.videoName, (int)_currentTarget.startFrame, (int)_currentTarget.endFrame, (int)framenumber, result, timeNeeded];
        _trialNr++;
        [_logWriter appendToCurLogfile:logmsg];
        
        
        
        // Still targets for this interface?
        
        _currentTarget = [_targetManager getNextTarget];
        
        if (_currentTarget != nil) {
            _currentVideo = [_assetLoader getVideoOfName:_currentTarget.videoName];
            
            // check if still same target set
            if (_currentTargetSet == _currentTarget.targetSetIndex) {
                [_targetViewController setTarget:_currentTarget];
                
                [self presentViewController:_targetViewController animated:YES completion:nil];
            } else {
                // new target set
                // go to next interface
                _currentBrowser = ibSkBrowser;
                _currentTargetSet = _currentTarget.targetSetIndex;
                [_targetViewController setTarget:_currentTarget];
                _questionViewController.showSKBrowserQuestion = NO;
                _questionViewController.demoMode = NO;
                [_questionViewController resetQuestions];
                [self presentViewController:_questionViewController animated:YES completion:nil];
            }
        } else {
            // no targets anymore
            // test finished
            
            _appMode = amStudyFinished;
            _questionViewController.demoMode = NO;
            _questionViewController.showSKBrowserQuestion = NO;
            [_questionViewController resetQuestions];
            [self presentViewController:_questionViewController animated:YES completion:nil];
            
            
        }
    }];
}



- (void)demoQuestionaire
{
    [self dismissViewControllerAnimated:YES completion:^{
        _appMode = amQuestionDemo;
        _questionViewController.demoMode = YES;
        _questionViewController.showSKBrowserQuestion = YES;
        [_questionViewController resetQuestions];
        [self presentViewController:_questionViewController animated:YES completion:nil];
    }];
}

- (void)loadingFinished
{
    if (_appMode == amUndefined) {
        _appMode = amInitialDataEntry;
        [self presentViewController:_startViewController animated:YES completion:nil];
    }
}


@end
