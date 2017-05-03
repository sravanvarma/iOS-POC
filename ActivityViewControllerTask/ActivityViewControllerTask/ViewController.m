//
//  ViewController.m
//  ActivityViewControllerTask
//
//  Created by Divya Vuppala on 20/03/15.
//  Copyright (c) 2015 CTS. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIStepper *stepper;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
//    NSString *text = @"How to add Facebook and Twitter sharing to an iOS app";
//    NSURL *url = [NSURL URLWithString:@"http://roadfiresoftware.com/2014/02/how-to-add-facebook-and-twitter-sharing-to-an-ios-app/"];
//    UIImage *image = [UIImage imageNamed:@"1.jpeg"];
//    
//    UIActivityViewController *controller =
//    [[UIActivityViewController alloc]
//     initWithActivityItems:@[text, url, image]
//     applicationActivities:nil];
//    
//    [self presentViewController:controller animated:YES completion:nil];
    
   

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)activityButton:(UIButton *)sender {
//    NSString *textToShare = @"Look at this awesome website for aspiring iOS Developers!";
//    NSURL *myWebsite = [NSURL URLWithString:@"http://www.codingexplorer.com/"];
//    
//    NSArray *objectsToShare = @[textToShare, myWebsite];
//    
//    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
//    
////    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
////                                   UIActivityTypePrint,
////                                   UIActivityTypeAssignToContact,
////                                   UIActivityTypeSaveToCameraRoll,
////                                   UIActivityTypeAddToReadingList,
////                                   UIActivityTypePostToFlickr,
////                                   UIActivityTypePostToVimeo];
////    
////    activityVC.excludedActivityTypes = excludeActivities;
//    
//    [self presentViewController:activityVC animated:YES completion:nil];
    NSLog(@"%f",self.stepper.value);
        NSString *text = @"How to add Facebook and Twitter sharing to an iOS app";
        NSURL *url = [NSURL URLWithString:@"http://roadfiresoftware.com/2014/02/how-to-add-facebook-and-twitter-sharing-to-an-ios-app/"];
        UIImage *image = [UIImage imageNamed:@"1.jpeg"];
    
        UIActivityViewController *controller =
        [[UIActivityViewController alloc]
         initWithActivityItems:@[text, url, image]
         applicationActivities:nil];
    
    
    
        [self presentViewController:controller animated:YES completion:nil];
}
@end
