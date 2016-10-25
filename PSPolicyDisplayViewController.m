//
//  PSPolicyDisplayViewController.m
//  PrivacySnooper
//
//  Created by Harishma Dayanidhi on 11/24/15.
//  Copyright © 2015 Carnegie Mellon University. All rights reserved.
//

#import "PSPolicyDisplayViewController.h"

@interface PSPolicyDisplayViewController ()

@end

@implementation PSPolicyDisplayViewController

-(void)setup
{
    [self.pdwebView setFrame:self.view.frame];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:153/255.0 green:76/255.0 blue:0 alpha:1];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:231/255.0 green:233/255.0 blue:201/255.0 alpha:1];
    
    [self.pdwebView setScalesPageToFit:YES];
    self.pdwebView.delegate = self;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self setup];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    if(self.policyURL == nil)
        [self.pdwebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.google.com"]]];
    else
        [self.pdwebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.policyURL]]];
}

-(void)viewDidAppear:(BOOL)animated
{
}

#pragma UIWebViewDelegate Functions


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Error : %@",error);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
