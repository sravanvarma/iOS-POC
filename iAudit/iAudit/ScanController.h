
#import <UIKit/UIKit.h>


@protocol ScanControllerProtocol<NSObject>

-(void)setScannedText:(NSString *)text;


@end


@interface ScanController : UIViewController


@property(nonatomic,strong) id<ScanControllerProtocol> scanControllerDelegate;


@end


