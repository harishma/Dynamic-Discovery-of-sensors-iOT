//
//  PSPolicyDisplayViewController.h
//  PrivacySnooper
//
//  Created by Harishma Dayanidhi on 11/24/15.
//  Copyright © 2015 Carnegie Mellon University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSPolicyDisplayViewController : UIViewController<UIWebViewDelegate>

@property (strong, nonatomic) NSString* policyURL;
@property (strong, nonatomic) IBOutlet UIWebView *pdwebView;

@end
