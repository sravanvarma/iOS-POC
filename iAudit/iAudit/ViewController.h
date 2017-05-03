#import <UIKit/UIKit.h>
#import "NKDBarcodeFramework.h"
#import "Data.h"
#import "ScanController.h"


@interface ViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource,ScanControllerProtocol,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (retain, nonatomic) IBOutlet UIImageView *barcodeImageView;
@property (retain, nonatomic) IBOutlet UITextField *textField1;
@property (retain, nonatomic) IBOutlet UITextField *textField2;
@property (retain, nonatomic) IBOutlet UITextField *textField3;
@property (retain, nonatomic) IBOutlet UITextField *textField4;
//@property (retain, nonatomic) IBOutlet UITextView *textView;
@property (retain, nonatomic) IBOutlet UITextField *textView;

@property (retain, nonatomic) IBOutlet UILabel *assetIDLabel;
@property (retain, nonatomic) IBOutlet UITextField *seatNoTextField;
@property (retain, nonatomic) IBOutlet UITextField *RAMSReqNoTextField;
@property (retain, nonatomic) IBOutlet UITextField *phoenixReqNoTextField;


@property(nonatomic,strong)NSFetchedResultsController *frc;

@property (strong,nonatomic) Data *passedData;
@property (strong,nonatomic) NSString *passedString;

@property (retain, nonatomic) IBOutlet UITextField *serailNumberTextField;
- (IBAction)generateBarCode:(UIButton *)sender;
@property (retain, nonatomic) IBOutlet UIView *contentsView;
@property (retain, nonatomic) IBOutlet UIView *detailsView;
@property (retain, nonatomic) IBOutlet UILabel *serialTextLabel;
@property (retain, nonatomic) IBOutlet UITextField *deviceNameTextField;

@property (retain, nonatomic) IBOutlet UILabel *categoryLabel;
- (IBAction)categoryPickerButton:(UIButton *)sender;
@property (retain, nonatomic) IBOutlet UIButton *categoryPickerButtonOutlet;

- (IBAction)scanCodeAction:(UIButton *)sender;

@property (retain, nonatomic) IBOutlet UIButton *generateBarCodeBtnOutlet;
@property (retain, nonatomic) IBOutlet UIButton *scanOutlet;

@end

