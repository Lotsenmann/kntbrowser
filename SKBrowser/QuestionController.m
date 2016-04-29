//
//  QuestionController.m
//  ColorVsConcept
//
//  Created by Marco A. Hudelist on 16.04.14.
//  Copyright (c) 2014 Marco A. Hudelist. All rights reserved.
//

#import "QuestionController.h"


@interface QuestionController ()
{
    // Holds normal questions controllers
    NSMutableArray *_normalQuestions;
    
    // XML parser
    NSXMLParser *_xmlParser;
    
    // Reference to the storyboard
    UIStoryboard *_storyboard;
}

@end

@implementation QuestionController

#pragma mark - Initialization

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self customInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self customInit];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self customInit];
    }
    return self;
}

- (void)customInit
{
    _normalQuestions = [[NSMutableArray alloc] initWithCapacity:7];
    
    _storyboard = [UIStoryboard storyboardWithName:@"skstoryboard" bundle:nil];
    
    //[self loadNormalQuestions];
    
    //[self.generalTableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidLayoutSubviews
{
    self.scrollView.contentSize = self.interfaceQuestions.frame.size;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)resetQuestions
{
    [_normalQuestions removeAllObjects];
    [self loadNormalQuestions];
}

#pragma mark - Action Handlers

// User pressed finish button
- (IBAction)finishQuestions:(UIButton *)sender
{
    if (self.demoMode) {
        [self.delegate dismissQuestionViewController];
    } else {
        Questionaire *questionaire = [[Questionaire alloc] init];
        
        for (int i = 0; i < _normalQuestions.count; i++) {
            if ([_normalQuestions[i] class] == [WeightedQuestion class]) {
                WeightedQuestion *wq = _normalQuestions[i];
                
                Question *q = [[Question alloc] init];
                q.questionTitle = wq.titleText;
                q.questionValue = [NSString stringWithFormat:@"%f", wq.weightSlider.value];
                
                [questionaire.questions addObject:q];
            } else if ([_normalQuestions[i] class] == [SKBrowserQuestion class]) {
                SKBrowserQuestion *sk = _normalQuestions[i];
                
                Question *q = [[Question alloc] init];
                q.questionTitle = @"SKBrowserInteraction";
                q.questionValue = [NSString stringWithFormat:@"%@", sk.commentText];
                
                [questionaire.questions addObject:q];
            }
        }
        
        self.showSKBrowserQuestion = NO;
        [self.delegate dismissQuestionViewControllerWith:questionaire];
    }
}

#pragma mark - NSXMLParser Delegate Methods

// Start of element
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:QUESTIONS_NORM_NODE]) {
        NSString *title = [attributeDict valueForKey:QUESTIONS_NORM_TITLE] ;
        NSString *description = [attributeDict valueForKey:QUESTIONS_NORM_DESC];
        NSString *lowText = [attributeDict valueForKey:QUESTIONS_NORM_LOW];
        NSString *highText = [attributeDict valueForKey:QUESTIONS_NORM_HIGH];
        
        WeightedQuestion *q = [_storyboard instantiateViewControllerWithIdentifier:@"weightedQuestion"];
        q.titleText = title;
        q.description = description;
        q.lowText = lowText;
        q.highText = highText;
        
        [_normalQuestions addObject:q];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    if (self.showSKBrowserQuestion) {
        [self loadSKQuestions];
    }
    
    [self.generalTableView reloadData];
    [self.generalTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

#pragma mark - UITableViewDelegate and UITableViewDatasource Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = indexPath.row;
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    
    if (index < _normalQuestions.count) {
        if ([_normalQuestions[index] class] == [WeightedQuestion class]) {
            WeightedQuestion *q = _normalQuestions[index];
            [cell addSubview:q.view];
        } else if ([_normalQuestions[index] class] == [SKBrowserQuestion class]) {
            SKBrowserQuestion *sk = _normalQuestions[index];
            [cell addSubview:sk.view];
        }
    } else {
        UIButton *finishButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 180, 40)];
        [finishButton setTitle:@"FERTIG" forState:UIControlStateNormal];
        finishButton.backgroundColor = [UIColor blueColor];
        [finishButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [finishButton.titleLabel setFont:[UIFont boldSystemFontOfSize:[UIFont systemFontSize]]];
        [finishButton addTarget:self action:@selector(finishQuestions:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:finishButton];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _normalQuestions.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= _normalQuestions.count) {
        return 190;
    } else if ([_normalQuestions[indexPath.row] class] == [WeightedQuestion class]) {
        return 130;
    } else if ([_normalQuestions[indexPath.row] class] == [SKBrowserQuestion class]) {
        return 270;
    } else {
        return 130;
    }
}

#pragma mark - Private Methods

// Loads the target file(s)
- (BOOL)loadNormalQuestions
{
    BOOL loadingStatus = NO;
    
    //Creating Path
    NSString *path = [[NSBundle mainBundle] pathForResource:QUESTIONS_FILENAME_NORMAL ofType:@"xml"];
    
    // Load contents of file
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    // Init parser
    _xmlParser = [[NSXMLParser alloc] initWithData:data];
    _xmlParser.delegate = self;
    
    // Start parser
    loadingStatus = [_xmlParser parse];
    
    return loadingStatus;
}

- (BOOL)loadSKQuestions
{
    SKBrowserQuestion *skQuestion = [_storyboard instantiateViewControllerWithIdentifier:@"skbrowserquestion"];
    
    [_normalQuestions addObject:skQuestion];
    
    return YES;
}

@end
