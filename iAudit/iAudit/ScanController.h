//
//  ScanController.h
//  try1
//
//  Created by Divya Vuppala on 02/09/15.
//  Copyright (c) 2015 CTS. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ScanControllerProtocol<NSObject>

-(void)setScannedText:(NSString *)text;


@end


@interface ScanController : UIViewController


@property(nonatomic,strong) id<ScanControllerProtocol> scanControllerDelegate;


@end


