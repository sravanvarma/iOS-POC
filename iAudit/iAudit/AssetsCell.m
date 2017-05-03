
#import "AssetsCell.h"

@implementation AssetsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_deviceNameLabel release];
    [_assetOwnerNameLabel release];
    [_assetOwnerIDLabel release];
    [_dateLabel release];
    [_auditedImageView release];
    [super dealloc];
}
@end
