//
//  PSDetectionViewController.m
//  PrivacySnooper
//
//  Created by Harishma Dayanidhi on 11/24/15.
//  Copyright © 2015 Carnegie Mellon University. All rights reserved.
//

#import "PSDetectionViewController.h"
#import "PSPolicyDisplayViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface PSDetectionViewController ()


@property (nonatomic, strong) ESTEddystoneManager *eddystoneManager;
@property (nonatomic, strong) ESTEddystoneFilterUID *uidFilter;
@property (nonatomic, strong) NSArray *devices;

@end


@implementation PSDetectionViewController

bool videoSurveillanceDetected;
bool audioSurveillanceDetected;
bool beaconDataCollectedDetected;

#pragma mark - configuration functions

-(void)setup
{
    //Configure Label and set Navigation bar title
    UILabel *labelt = [[UILabel alloc] initWithFrame:CGRectZero];
    labelt.backgroundColor = [UIColor clearColor];
    labelt.font = [UIFont fontWithName:@"Snell Roundhand" size:30];
    labelt.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    labelt.textAlignment = NSTextAlignmentCenter;
    labelt.textColor = [UIColor colorWithRed:153/255.0 green:76/255.0 blue:0 alpha:1];
    self.navigationItem.titleView = labelt;
    labelt.text =@"Privacy Snooper";
    [labelt sizeToFit];
    
    
    //Eddystone setup
    self.eddystoneManager = [[ESTEddystoneManager alloc] init];
    self.eddystoneManager.delegate = self;
    
    
    //Notification setup
    UIUserNotificationType types = UIUserNotificationTypeBadge |
    UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    UIUserNotificationSettings *mySettings =
    [UIUserNotificationSettings settingsForTypes:types categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
}

-(void) resetBeaconsStates
{
    videoSurveillanceDetected = false;
    audioSurveillanceDetected = true;
    beaconDataCollectedDetected = false;
}

-(void) configureButtons
{
    //Set all buttons to rounded rects
    int cornerRadius = 10;
    self.videoSurveillanceButton.layer.cornerRadius = cornerRadius;
    self.audioSurveillanceButton.layer.cornerRadius = cornerRadius;
    self.beaconsButton.layer.cornerRadius = cornerRadius;
    self.videoSurveillanceButton.imageView.layer.cornerRadius = cornerRadius;
    self.audioSurveillanceButton.imageView.layer.cornerRadius = cornerRadius;
    self.beaconsButton.imageView.layer.cornerRadius = cornerRadius;
    
    [[self.videoSurveillanceButton.imageView layer] setBorderWidth:4.0f];
    if(!videoSurveillanceDetected)
        [[self.videoSurveillanceButton.imageView layer] setBorderColor:[UIColor colorWithRed:153/255.0 green:76/255.0 blue:0 alpha:1].CGColor];
    else
        [[self.videoSurveillanceButton.imageView layer] setBorderColor:[UIColor yellowColor].CGColor];
    
    [[self.audioSurveillanceButton.imageView layer] setBorderWidth:4.0f];
    if(!audioSurveillanceDetected)
        [[self.audioSurveillanceButton.imageView layer] setBorderColor:[UIColor colorWithRed:153/255.0 green:76/255.0 blue:0 alpha:1].CGColor];
    else
        [[self.audioSurveillanceButton.imageView layer] setBorderColor:[UIColor yellowColor].CGColor];

    [[self.beaconsButton.imageView layer] setBorderWidth:4.0f];
    if(!beaconDataCollectedDetected)
        [[self.beaconsButton.imageView layer] setBorderColor:[UIColor colorWithRed:153/255.0 green:76/255.0 blue:0 alpha:1].CGColor];
    else
        [[self.beaconsButton.imageView layer] setBorderColor:[UIColor yellowColor].CGColor];
    
    //All buttons are disabled by default
    if(!videoSurveillanceDetected)
    {
        [self.videoSurveillanceButton setUserInteractionEnabled:false];
        [self.videoSurveillanceButton setAlpha:0.5];
    }
    else
    {
        [self.videoSurveillanceButton setUserInteractionEnabled:true];
        [self.videoSurveillanceButton setAlpha:1];
    }
    if(!audioSurveillanceDetected)
    {
        [self.audioSurveillanceButton setUserInteractionEnabled:false];
        [self.audioSurveillanceButton setAlpha:0.5];
    }
    else
    {
        [self.audioSurveillanceButton setUserInteractionEnabled:true];
        [self.audioSurveillanceButton setAlpha:1];
    }
    if(!beaconDataCollectedDetected)
    {
        [self.beaconsButton setUserInteractionEnabled:false];
        [self.beaconsButton setAlpha:0.5];
    }
    else
    {
        [self.beaconsButton setUserInteractionEnabled:true];
        [self.beaconsButton setAlpha:1];
    }
    
}

-(void) configureViewState
{
    
    //configure label for notification view
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor colorWithRed:153/255.0 green:76/255.0 blue:0 alpha:1];
    [label sizeToFit];
    label.font = [UIFont systemFontOfSize:12 weight:2];
    NSMutableString* surveillanceString = [NSMutableString stringWithFormat:@""];
    label.shadowColor = nil;
    label.textAlignment = NSTextAlignmentCenter;
    if(videoSurveillanceDetected)
    {
        [surveillanceString appendString:@"Video Surviellance"];
    }
    if(audioSurveillanceDetected)
    {
        if([surveillanceString isEqualToString:@""])
            [surveillanceString appendString:@"Audio Surviellance "];
        else
            [surveillanceString appendString:@" ,Audio Surviellance "];
    }
    if(beaconDataCollectedDetected)
    {
        if([surveillanceString isEqualToString:@""])
            [surveillanceString appendString:@"Beacon Surviellance"];
        else
            [surveillanceString appendString:@" ,Beacon Surviellance "];
    }
    if([surveillanceString isEqualToString:@""])
    {
        [surveillanceString appendString:@"No Surviellance!"];
            
    }
    else
    {
        [surveillanceString appendString:@"!"];
    }
    NSMutableString * beginningString = [NSMutableString stringWithFormat:@"You are under "];
    [beginningString appendString:surveillanceString];
    label.text = beginningString;
    
    label.frame = self.notificationLabel.frame;
    
    for(UIView* view in [self.view subviews])
    {
        if(![view isEqual:self.notificationLabel] && [view isKindOfClass:[UILabel class]])
            [view removeFromSuperview];
    }
    
    [self.view addSubview:label];
    
}

#pragma mark - view related functions

-(void) viewWillAppear:(BOOL)animated
{
    
    [self configureButtons];
    [self configureViewState];
}

-(void) viewDidAppear:(BOOL)animated
{
    /*
     * UUID filter allows to discover devices working in Eddystone UUID mode.
     * You should provide NamespaceID and optionally InstanceID.
     */
    
    ESTEddystoneUID *eddystoneUID = [[ESTEddystoneUID alloc] initWithNamespaceID:ESTIMOTE_EDDYSTONE_NAMESPACE_ID];
    self.uidFilter = [[ESTEddystoneFilterUID alloc] initWithUID:eddystoneUID];
    
    /*
     * Eddystone discovery is based on filtering mechanism. `startEddystoneDiscoveryWithFilter:` method
     * can be invoked multiple times with different filters provided as a param.
     * Delegate method `eddystoneManager:didDiscoverEddystones:withFilter:` informs about device discovery
     * delivering both device details in `ESTEddystone` object as well as filter (`ESTFilter` subclass) that it fulfilled.
     */
    
    [self.eddystoneManager startEddystoneDiscoveryWithFilter:self.uidFilter];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    [self setup];
    [self resetBeaconsStates];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ESTEddystoneManagerDelegate

- (void)eddystoneManager:(ESTEddystoneManager *)manager
   didDiscoverEddystones:(NSArray *)eddystones
              withFilter:(ESTEddystoneFilter *)eddystoneFilter
{
    
    self.devices = eddystones;
    if([self changeinSurveillanceState])
    {
        [self configureViewState];
        [self configureButtons];
        [self notifyUser];
    }
}

- (void)eddystoneManagerDidFailDiscovery:(ESTEddystoneManager *)manager
{
    NSLog(@"Eddystone discovery process failed.");
}

#pragma mark - utility functions

-(int) changeinSurveillanceState
{
    bool VSState = false, ASState = false, BSState = false;
    
    for( ESTEddystone* device in self.devices)
    {
        NSString* url = device.url;
        if(url!=nil)
        {
            if([url containsString:@"video"])
                VSState = 1;
            if([url containsString:@"audio"])
                ASState = 1;
            if([url containsString:@"beacons"])
                BSState = 1;
        }
    }
    
    /* only a hack to make audio always be true! DO NOT FORGET TO REMOVE */
    ASState = 1;
    
    bool val = ((videoSurveillanceDetected^VSState)||(audioSurveillanceDetected^ASState)||(beaconDataCollectedDetected^BSState));
    
    videoSurveillanceDetected = VSState;
    audioSurveillanceDetected = ASState;
    beaconDataCollectedDetected = BSState;
    
    return val;
}

-(void) notifyUser
{
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    
    if (localNotif == nil)
        return;
    localNotif.fireDate = [NSDate date];
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    
    localNotif.alertBody = [NSString stringWithFormat:@"Your Surveillance Status has changed"];
    localNotif.alertAction = NSLocalizedString(@"View Details", nil);
    localNotif.alertTitle = NSLocalizedString(@"Attention!", nil);
    
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.applicationIconBadgeNumber = 1;

    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
     
     PSPolicyDisplayViewController* receiver = [segue destinationViewController];
     if([sender isEqual:self.videoSurveillanceButton])
     {
         for(ESTEddystone* device in self.devices)
         {
             NSString* url = device.url;
             if(url!=nil)
             {
                 if([url containsString:@"video"])
                     receiver.policyURL = url;
            }
         }
     }
     else if ([sender isEqual:self.audioSurveillanceButton])
     {
         for(ESTEddystone* device in self.devices)
         {
             NSString* url = device.url;
             if(url!=nil)
             {
                 if([url containsString:@"audio"])
                     receiver.policyURL = url;
             }
         }
     }
     else if ([sender isEqual:self.beaconsButton])
     {
         for(ESTEddystone* device in self.devices)
         {
             NSString* url = device.url;
             if(url!=nil)
             {
                 if([url containsString:@"beacons"])
                     receiver.policyURL = url;
             }
         }
     }
     
}

#pragma view controller functions

- (IBAction)videoSurveillanceSelected:(id)sender {
    
    [self.videoSurveillanceButton setHighlighted:YES];
}

- (IBAction)audioSurveillanceSelected:(id)sender {
    [self.videoSurveillanceButton setHighlighted:YES];
}

- (IBAction)beaconSelected:(id)sender {
}

#pragma mark - ESTUtilityManagerDelegate functions



@end
