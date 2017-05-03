//
//  AssetsCell.h
//  try1
//
//  Created by Divya Vuppala on 04/09/15.
//  Copyright (c) 2015 CTS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssetsCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *assetOwnerNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *assetOwnerIDLabel;
@property (retain, nonatomic) IBOutlet UILabel *dateLabel;
@property (retain, nonatomic) IBOutlet UIImageView *auditedImageView;

@end
