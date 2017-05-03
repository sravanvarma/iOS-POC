
#import <UIKit/UIKit.h>

@interface AssetsCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *assetOwnerNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *assetOwnerIDLabel;
@property (retain, nonatomic) IBOutlet UILabel *dateLabel;
@property (retain, nonatomic) IBOutlet UIImageView *auditedImageView;

@end
