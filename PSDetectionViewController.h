//
//  PSDetectionViewController.h
//  PrivacySnooper
//
//  Created by Harishma Dayanidhi on 11/24/15.
//  Copyright © 2015 Carnegie Mellon University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EstimoteSDK/EstimoteSDK.h>

@interface PSDetectionViewController : UIViewController<ESTEddystoneManagerDelegate>

//UI Elements
@property (weak, nonatomic) IBOutlet UIButton *audioSurveillanceButton;
@property (weak, nonatomic) IBOutlet UIButton *videoSurveillanceButton;
@property (weak, nonatomic) IBOutlet UIButton *beaconsButton;
@property (weak, nonatomic) IBOutlet UILabel *notificationLabel;

- (IBAction)audioSurveillanceSelected:(id)sender;
- (IBAction)beaconSelected:(id)sender;
- (IBAction)videoSurveillanceSelected:(id)sender;

@end
