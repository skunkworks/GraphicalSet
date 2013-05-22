//
//  RegExTesterViewController.m
//  GraphicalSet
//
//  Created by Richard Shin on 5/21/13.
//  Copyright (c) 2013 Richard Shin. All rights reserved.
//

#import "RegExTesterViewController.h"
#import "FlipResultView.h"
#import "PlayingCardView.h"
#import "SetCardView.h"

@interface RegExTesterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet FlipResultView *flipResultView;

@end

@implementation RegExTesterViewController

- (IBAction)buttonPressed:(id)sender {
    NSString *string = [self.textField text];
    
    NSMutableArray *resultStringArray = [[NSMutableArray alloc] init];
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\[.*?]"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *textCheckingResults = [regex matchesInString:string options:0 range:NSMakeRange(0, string.length)];
    if ([textCheckingResults count]) {
        int trailingIndex = 0;
        for (NSTextCheckingResult *textCheckingResult in textCheckingResults) {
            NSRange cardRange = [textCheckingResult range];
            [resultStringArray addObject:[string substringWithRange:NSMakeRange(trailingIndex, cardRange.location-trailingIndex)]];
            trailingIndex = cardRange.location + cardRange.length;
        }
        if (trailingIndex != string.length) {
            [resultStringArray addObject:[string substringWithRange:NSMakeRange(trailingIndex, string.length-trailingIndex)]];
        }
    } else {
        [resultStringArray addObject:string];
    }
    
    self.label.text = [resultStringArray componentsJoinedByString:@"|"];
    
    SetCardView *setCardView1 = [[SetCardView alloc] init];
    setCardView1.number = 3;
    setCardView1.shade = 1;
    setCardView1.symbol = 1;
    setCardView1.color = 1;
    SetCardView *setCardView2 = [[SetCardView alloc] init];
    setCardView2.number = 3;
    setCardView2.shade = 2;
    setCardView2.symbol = 2;
    setCardView2.color = 2;
    SetCardView *setCardView3 = [[SetCardView alloc] init];
    setCardView3.number = 3;
    setCardView3.shade = 3;
    setCardView3.symbol = 3;
    setCardView3.color = 3;
    [self.flipResultView displayResultString:self.textField.text withCardSubviews:@[setCardView1, setCardView2, setCardView3]];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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

@end
