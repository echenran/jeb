//
//  JEBPopover.m
//  jeb
//
//  Created by Joyce Yan on 1/21/17.
//  Copyright © 2017 Joyce Yan. All rights reserved.
//

#import "JEBPopover.h"

@implementation JEBPopover

static const int WIDTH_MARGIN = 50;
static const int HEIGHT_MARGIN = 75;
static const int INNER_MARGIN = 15;
static const int TITLE_HEIGHT = 30;
static NSString *const JEBFont = @"Avenir-Light";

- (void)setWord:(NSString *) word {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    NSString *type;
    NSString *definition;
    NSString *example;
    
    // Determine the URL and send the GET request.
    NSString *urlFirstHalf = @"https://owlbot.info/api/v1/dictionary/";
    NSString *urlSecondHalf = @"?format=json";
    NSString *url = [NSString stringWithFormat:@"%@%@%@", urlFirstHalf, word, urlSecondHalf];
    NSMutableURLRequest *request =
    [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                            cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                        timeoutInterval:10
     ];
    [request setHTTPMethod: @"GET"];
    
    // Parse the URL response.
    NSError *requestError = nil;
    NSURLResponse *urlResponse = nil;
    NSData *response =
    [NSURLConnection sendSynchronousRequest:request
                          returningResponse:&urlResponse error:&requestError];
    if (requestError == nil) {
        NSError *error;
        NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:response
                                                             options:kNilOptions
                                                               error:&error];
        if (error == nil) {
            NSDictionary *dick = jsonArray[0];
            type = [dick objectForKey:@"type"];
            definition = [dick objectForKey:@"defenition"];
            example = [dick objectForKey:@"example"];
        }
    }
    
    // Base rectangle.
    UIView *rect = [[UIView alloc] initWithFrame:
                    CGRectMake(WIDTH_MARGIN, HEIGHT_MARGIN, screenSize.width - 2*WIDTH_MARGIN, screenSize.height - 2*HEIGHT_MARGIN)];
    rect.backgroundColor = [UIColor whiteColor];
    rect.layer.masksToBounds = YES;
    rect.layer.cornerRadius = 8;
    [self addSubview:rect];
    
    // Top-level label featuring the object name.
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH_MARGIN + INNER_MARGIN, HEIGHT_MARGIN + INNER_MARGIN, screenSize.width - 2*WIDTH_MARGIN - INNER_MARGIN, TITLE_HEIGHT)];
    title.text = word;
    title.textColor = [UIColor blackColor];
    UIFont *titleFont = [UIFont fontWithName:JEBFont size:26];
    title.font = titleFont;
    [self addSubview:title];
    
    // Type label.
    UILabel *typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH_MARGIN + INNER_MARGIN, HEIGHT_MARGIN + INNER_MARGIN + TITLE_HEIGHT, screenSize.width - 2*WIDTH_MARGIN - INNER_MARGIN, TITLE_HEIGHT)];
    typeLabel.text = type;
    typeLabel.textColor = [UIColor blackColor];
    UIFont *typeFont = [UIFont fontWithName:@"Avenir-LightOblique" size:18];
    typeLabel.font = typeFont;
    [self addSubview:typeLabel];
    
    // Definition label.
    UITextView *definitionLabel = [[UITextView alloc] initWithFrame:CGRectMake(WIDTH_MARGIN + INNER_MARGIN, HEIGHT_MARGIN + INNER_MARGIN + TITLE_HEIGHT*2, screenSize.width - 2*WIDTH_MARGIN - INNER_MARGIN, TITLE_HEIGHT)];
    definitionLabel.text = definition;
    UIFont *labelFont = [UIFont fontWithName:JEBFont size:18];
    definitionLabel.font = labelFont;
    CGRect frame;
    frame = definitionLabel.frame;
    frame.size.height = [definitionLabel contentSize].height;
    definitionLabel.frame = frame;
    [self addSubview:definitionLabel];
    
    // Sample sentence label.
    if (![example isEqual:[NSNull null]]) {
        UITextView *sentence = [[UITextView alloc] initWithFrame:CGRectMake(WIDTH_MARGIN + INNER_MARGIN, HEIGHT_MARGIN + INNER_MARGIN + TITLE_HEIGHT*2 + frame.size.height, screenSize.width - 2*WIDTH_MARGIN - INNER_MARGIN, TITLE_HEIGHT)];
        sentence.text = example;
        sentence.font = labelFont;
        CGRect sentenceFrame;
        sentenceFrame = sentence.frame;
        sentenceFrame.size.height = [sentence contentSize].height;
        sentence.frame = sentenceFrame;
        [self addSubview:sentence];
    }
}

@end
