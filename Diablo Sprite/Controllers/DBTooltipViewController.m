//
//  DBTooltipViewController.m
//  Diablo Sprite
//
//  Created by Yufei Tang on 2014-09-07.
//  Copyright (c) 2014 Archangel. All rights reserved.
//

#import "DBTooltipViewController.h"

@interface DBTooltipViewController () <UIWebViewDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic) BOOL needRefresh;
@property (nonatomic, strong) NSString *tooltipHTML;

@end

@implementation DBTooltipViewController

- (void)setTooltipURL:(NSURL *)tooltipURL
{
    if (!_tooltipURL || ![_tooltipURL.absoluteString isEqualToString:tooltipURL.absoluteString]) {
        self.needRefresh = YES;
        _tooltipURL = tooltipURL;
    }
}

- (NSString *)completeTooltipHTML
{
    return [NSString stringWithFormat:@"<html>"
                           "<head>"
                           "<link href=\"http://us.battle.net/d3/static/css/tooltips.css\" rel=\"stylesheet\" type=\"text/css\">"
                           "<script>"
                           "function updateViewport() {"
                           "var contentWidth = document.getElementById('truebody').offsetWidth+20;"
                           "var viewportTag = document.createElement('meta');"
                           "viewportTag.name = \"viewport\";"
                           "viewportTag.content = \"width=\"+contentWidth+\"; user-scalable=0\";"
                           "document.getElementsByTagName('head')[0].appendChild(viewportTag);"
                           "var content = document.getElementById('truebody');"
                           "var scale = screen.width / window.innerWidth;"
                           "var viewportHeight = %f/scale;"
                           "var contentHeight = content.offsetHeight;"
                           "if (contentHeight < viewportHeight) {"
                           "content.style.top = (viewportHeight - contentHeight)/2;"
                           "}"
                           "}"
                           "</script>"
                           "</head>"
                           "<body style=\"background-color: black\" onload=\"updateViewport();\">"
                           "<div id=\"truebody\" class=\"d3-tooltip-wrapper\">"
                           "<div class=\"d3-tooltip-wrapper-inner\">"
                           "%@"
                           "</div>"
                           "</div>"
                           "</body>"
                           "</html>", self.webView.frame.size.height, self.tooltipHTML];
}

#pragma mark - UIViewController
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.webView.scrollView.backgroundColor = [UIColor blackColor];
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissViewControllerOnTap:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    tapGestureRecognizer.numberOfTouchesRequired = 1;
    tapGestureRecognizer.delegate = self;
    [self.webView addGestureRecognizer:tapGestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.needRefresh) {
        [self.webView setHidden:YES];
        [self.activityIndicator startAnimating];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            NSError *error = nil;
            self.tooltipHTML = [NSString stringWithContentsOfURL:self.tooltipURL encoding:NSUTF8StringEncoding error:&error];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:error.localizedDescription delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
                    [errorAlert show];
                } else {
                    [self.webView loadHTMLString:[self completeTooltipHTML] baseURL:nil];
                }
            });
        });
    }
}

#pragma mark - Actions
- (void)dismissViewControllerOnTap:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // make the webview visible after 300ms to avoid users seeing the offset shift animation caused by onload function
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 300 * NSEC_PER_MSEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        [self.activityIndicator stopAnimating];
        [self.webView setHidden:NO];
        self.needRefresh = NO;
    });
}

@end
