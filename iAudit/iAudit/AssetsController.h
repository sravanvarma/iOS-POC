
#import <UIKit/UIKit.h>
#import "Data.h"
#import "AppDelegate.h"
#import "ScanController.h"
#import <MessageUI/MessageUI.h>
#import "CHCSVParser.h"
#import "StoreKit/StoreKit.h"
#import "parseCSV.h"
#import "QZXLSReader.h"

//#import "popupSingleton.h"

@interface AssetsController : UITableViewController<UIAlertViewDelegate,ScanControllerProtocol,MFMailComposeViewControllerDelegate,CHCSVParserDelegate,UIPopoverControllerDelegate>

@property(strong,nonatomic) NSString *detectedString;
//@property(strong,nonatomic) NSString *selectedString;

- (IBAction)segmentControlAction:(UISegmentedControl *)sender;
@property (retain, nonatomic) IBOutlet UISegmentedControl *segmentControlOutlet;


-(void)searchForData:(NSString *)s;


@end
