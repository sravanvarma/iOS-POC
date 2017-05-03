//
//  ViewController.m
//  try1
//
//  Created by Divya Vuppala on 02/09/15.
//  Copyright (c) 2015 CTS. All rights reserved.
//

#import "ViewController.h"
#import "ScanController.h"
#import "AssetsCell.h"

#import "AppDelegate.h"
@interface ViewController ()<NSFetchedResultsControllerDelegate>
{
    BOOL push,new;
    NSManagedObjectContext *context;
    UIView *pickerView;
    UIButton *doneButton;
    UIPickerView *categoryPicker;
    NSArray *pickerArray;
    UIBarButtonItem *editButton;
    UITableView *deviceHistoryTableView;
    NSMutableArray *deviceHistoryDataArray;
    BOOL deviceTableViewPresent;
     Data *sampleData;
}


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    deviceTableViewPresent=NO;
    new=NO;
    self.serailNumberTextField.delegate=self;
    pickerArray=[[NSArray alloc]initWithObjects:@"tablets",@"phones",@"Desktop",@"laptops", nil];
    
    pickerView=[[UIView alloc]init];
    pickerView.backgroundColor=[UIColor grayColor];
    
    categoryPicker=[[UIPickerView alloc]init];
    categoryPicker.backgroundColor=[UIColor grayColor];
    
    doneButton=[[UIButton alloc]init];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(doneButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    categoryPicker.delegate=self;
    categoryPicker.dataSource=self;
    
    AppDelegate *apd=[UIApplication sharedApplication].delegate;
    context=apd.managedObjectContext;
    NSFetchRequest *fetchrequest=[[NSFetchRequest alloc]initWithEntityName:@"Data"];
    
    
    
    NSSortDescriptor *sortdescriptor=[[NSSortDescriptor alloc]initWithKey:@"deviceCategory" ascending:YES];
    
    
    
    fetchrequest.sortDescriptors=@[sortdescriptor];
    

    
    
    self.frc=[[NSFetchedResultsController alloc]initWithFetchRequest:fetchrequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    self.frc.delegate=self;
    NSError *error = nil;
    if ([self.frc performFetch:&error]) {
        NSLog(@"data fetched sucessfully");
        //        [self csvMethod];
    }
    else{
        NSLog(@"data fetching is failed");
        
    }
    
    push=YES;
    NSLog(@"View did load");
    NSString * rightBarButtonText=@"";
   
    if (self.passedData !=nil) {
        self.categoryPickerButtonOutlet.hidden=YES;
        [self.contentsView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-60)];
        self.contentsView.hidden=NO;
        NSLog(@"%@",self.passedData);
//        NSDictionary *sampleData=[self.passedDictionary objectForKey:@"Data"];
        //self.barcodeImageView.image=[UIImage imageWithData:self.passedData.barcodeImage];
        self.barcodeImageView.image=[self getTheBarcodeImageForString:self.serailNumberTextField.text];
        self.serialTextLabel.text=self.passedData.serialNo;
        self.textField1.text=self.passedData.assetOwnerName;
        self.textField2.text=self.passedData.assetOwnerID;
        self.textField3.text=self.passedData.projectManagerName;
        self.textField4.text=self.passedData.projectName;
        self.deviceNameTextField.text=self.passedData.deviceName;
        self.textView.text=self.passedData.notes;
        self.categoryLabel.text=self.passedData.deviceCategory;
        self.seatNoTextField.text=self.passedData.seatNumber;
        self.assetIDLabel.text=self.passedData.assetID;
        self.RAMSReqNoTextField.text=self.passedData.ramsReqNo;
        self.phoenixReqNoTextField.text=self.passedData.phoenixReqNo;
        
        deviceHistoryDataArray=[[NSMutableArray alloc]init];
        [self getDeviceHistory];
        NSTimeInterval distanceBetweenDates = [[NSDate date] timeIntervalSinceDate:self.passedData.recordedDate];
        if (distanceBetweenDates/86400>30) {
        UIButton *manualScan=[[UIButton alloc]initWithFrame:CGRectMake(20,self.categoryLabel.frame.size.height+self.categoryLabel.frame.origin.y+80, 80, 40)];
        [manualScan setBackgroundColor:[UIColor grayColor]];
        [manualScan setTitle:@"AUDIT" forState:UIControlStateNormal];
        [manualScan addTarget:self action:@selector(scanCodeAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:manualScan];
          
        }
        self.detailsView.hidden=YES;
      rightBarButtonText=@"Edit";
       
    }
    if ([rightBarButtonText isEqualToString:@""]) {
        rightBarButtonText=@"Save";
        new=YES;
    }
    if (self.passedString.length>0) {
        [self scanText:self.passedString];
        
//        if ([self.passedString rangeOfString:@"&"].location == NSNotFound)
//        {
//            self.serailNumberTextField.text=self.passedString;
//            self.serialTextLabel.text=self.passedString;
//            self.assetIDLabel.text=self.passedString;
//        }
//        else
//        {
//            NSRange range=[self.passedString rangeOfString:@"&"];
//            NSUInteger i=range.location;
//            NSString *temp=[self.passedString substringToIndex:i];
//            self.serailNumberTextField.text=temp;
//            range=[self.passedString rangeOfString:@"&"];
//            i=range.location+1;
//            temp=[self.passedString substringFromIndex:i];
//            self.assetIDLabel.text=temp;
//            self.passedString=nil;
////            self.serailNumberTextField.text=self.passedString;
////            self.serialTextLabel.text=self.passedString;
////            self.assetIDLabel.text=self.passedString;
//        }
        
        //self.serailNumberTextField.text=self.passedString;
        //self.assetIDLabel.text=self.passedString;
        [self generateBarCode:nil];
    }
    editButton=[[UIBarButtonItem alloc]initWithTitle:rightBarButtonText style:UIBarButtonItemStylePlain target:self action:@selector(editingBegin:)];
    if ([self.passedData.isAvailable isEqualToNumber:@0]) {
        [editButton setEnabled:NO];
        [editButton setTitle:@"Record can't be edited"];
    }
    self.navigationItem.rightBarButtonItem=editButton;
//    self.barcodeImageView.image=[self getTheBarcodeImageForString:@"SC07NW133G1"];
//    self.textField1.text=@"SC07NW133G1";
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField==self.serailNumberTextField) {
        self.scanOutlet.hidden=YES;
    }
}


- (void)viewDidLayoutSubviews
{
    if (push) {
    self.contentsView.layer.frame = CGRectInset(CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height-60), 0, 0);
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)editingBegin:(UIBarButtonItem *)button
{
    if ([button.title isEqualToString: @"Done"]) {
         if (self.textField1.text.length>0&&self.textField2.text.length>0&&self.textField3.text.length>0&&self.textField4.text.length>0&&self.deviceNameTextField.text.length>0&&self.seatNoTextField.text.length>0&&self.deviceNameTextField.text.length>0)
         {
        [button setTitle:@"Edit"];
        [self enableTextFieldEditing:NO];
       
        if(self.passedData)
        {
            self.passedData.assetOwnerID=self.textField2.text;
            self.passedData.assetOwnerName=self.textField1.text;
            self.passedData.projectManagerName=self.textField3.text;
            self.passedData.projectName=self.textField4.text;
            self.passedData.deviceName=self.deviceNameTextField.text;
            self.passedData.deviceCategory=self.categoryLabel.text;
            self.passedData.assetID=self.assetIDLabel.text;
            self.passedData.seatNumber=self.seatNoTextField.text;
            self.passedData.ramsReqNo=self.RAMSReqNoTextField.text;
            self.passedData.phoenixReqNo=self.phoenixReqNoTextField.text;
            self.passedData.notes=self.textView.text;
            self.passedData.isAvailable=@1;
            
            NSError *error;
            if ([context save:&error]) {
                 NSLog(@"saved");
              [self.navigationController popViewControllerAnimated:YES]; 
            }
            
        }
         }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Empty fields detected" message:@"Fields can't be empty" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
            [alert show];
        }
         }
    else if([button.title isEqualToString:@"Edit"])
    {
    [button setTitle:@"Done"];
         [self enableTextFieldEditing:YES];
        
    }
    else
    {
        //BOOL present=YES;
        if (self.textField1.text.length>0&&self.textField2.text.length>0&&self.textField3.text.length>0&&self.textField4.text.length>0&&self.deviceNameTextField.text.length>0&&self.seatNoTextField.text.length>0&&self.deviceNameTextField.text.length>0) {
//           Data  *list=[NSEntityDescription insertNewObjectForEntityForName:@"Data"inManagedObjectContext:context];
//            if (list!=nil) {
//                list.serialNo=self.serialTextLabel.text;
//                NSData *imageData=UIImagePNGRepresentation(self.barcodeImageView.image);
//                list.barcodeImage=imageData;
//                list.assetOwnerID=self.textField2.text;
//                list.assetOwnerName=self.textField1.text;
//                list.projectManagerName=self.textField3.text;
//                list.projectName=self.textField4.text;
//                list.deviceName=self.deviceNameTextField.text;
//                list.notes=self.textView.text;
//                list.deviceCategory=self.categoryLabel.text;
//                list.seatNumber=self.seatNoTextField.text;
//                list.assetID=self.assetIDLabel.text;
//                
//                NSDate *currentDate=[NSDate date];
//                list.recordedDate=currentDate;
//                NSError *error;
//                
////                Data *sampleData;
////                for (int i=0; i<self.frc.fetchedObjects.count; i++) {
////                    sampleData=[self.frc.fetchedObjects objectAtIndex:i];
////                    if ([sampleData.serialNo isEqualToString:list.serialNo] || [sampleData.assetID isEqualToString:list.assetID]) {
////                        UIAlertView * alert=[[UIAlertView alloc]
////                        initWithTitle:@"Record is available in database" message:@"Duplicate records are not allowed" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:nil, nil];
////                        [alert show];
////                        present=NO;
////                    }
////                }
////                
//                if (present) {
//                if ([context save:&error]) {
//                    NSLog(@"data is saved");
//                    
//                }else{
//                    NSLog(@"failed to save data ");
//                }
//
//            }
//            else
//            {
//                NSLog(@"failed to create list object");
//            }
//        }
//        [self.navigationController popViewControllerAnimated:YES];
            [self createNew];
           
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"OOPS..!!" message:@"Generate Barcode and Give all the Textfields" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:nil, nil];
            [alert show
             ];

        }
    }
}

-(void)enableTextFieldEditing:(BOOL)value
{
    self.textField1.userInteractionEnabled=value;
    self.textField2.userInteractionEnabled=value;
    self.textField3.userInteractionEnabled=value;
    self.textField4.userInteractionEnabled=value;
    self.textView.userInteractionEnabled=value;
    self.deviceNameTextField.userInteractionEnabled=value;
    self.seatNoTextField.userInteractionEnabled=value;
    self.RAMSReqNoTextField.userInteractionEnabled=value;
    self.phoenixReqNoTextField.userInteractionEnabled=value;
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.passedString=nil;
}

- (void)dealloc {
    [_barcodeImageView release];
    [_textField1 release];
    [_textField2 release];
    [_textField3 release];
    [_textField4 release];
    [_textView release];
    [_serailNumberTextField release];
    [_contentsView release];
    self.passedString=nil;
    [_detailsView release];
    [_serialTextLabel release];
    [_deviceNameTextField release];
    [_categoryLabel release];
    [_categoryPickerButtonOutlet release];
    [_assetIDLabel release];
    [_seatNoTextField release];
    [_generateBarCodeBtnOutlet release];
    [_scanOutlet release];
    [_RAMSReqNoTextField release];
    [_phoenixReqNoTextField release];
    //[_textView release];
    [super dealloc];
}

-(UIImage *)getTheBarcodeImageForString:(NSString *)number
{
    if ([number isEqualToString:@""]) {
        number=@"123";
    }
    NKDExtendedCode39Barcode *barcode;
    barcode = [NKDExtendedCode39Barcode alloc];
    barcode = [barcode initWithContent:number printsCaption:0];
    [barcode calculateWidth];
    NSLog(@"%@",[barcode description]);
    return  [UIImage imageFromBarcode:barcode];
}
- (IBAction)generateBarCode:(UIButton *)sender {
    if (self.serailNumberTextField.text.length>0) {
        self.serailNumberTextField.userInteractionEnabled=NO;
        self.barcodeImageView.image=[self getTheBarcodeImageForString:self.serailNumberTextField.text];
        self.serialTextLabel.text=self.serailNumberTextField.text;
           self.contentsView.hidden=NO;
       
        //self.assetIDLabel.text=self.serailNumberTextField.text;
     
        self.categoryLabel.text=pickerArray[0];
        //self.detailsView.hidden=YES;
        [self enableTextFieldEditing:YES];
        push=NO;
        if (new &&self.scanOutlet.hidden) {
            self.assetIDLabel.text=self.serailNumberTextField.text;
            [self check];
        }
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Serial number misssing" message:@"Enter serial number" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:nil, nil];
        [alert show
         ];
    }
}

#pragma mark- Pickerview Delegate methods

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return pickerArray.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return pickerArray[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.categoryLabel.text=pickerArray[row];
    NSLog(@"%f",categoryPicker.bounds.size.height);
}

-(void)doneButtonPressed{
    [pickerView removeFromSuperview];
}

- (IBAction)categoryPickerButton:(UIButton *)sender {
    [self.view addSubview:pickerView];
    [pickerView setFrame:CGRectMake(self.categoryPickerButtonOutlet.frame.origin.x+30, self.categoryPickerButtonOutlet.frame.origin.y+250, 150,100)];
    
    
    
    [pickerView addSubview:categoryPicker];
    [categoryPicker setFrame:CGRectMake(0,-20, 150,80)];
    
    [pickerView addSubview:doneButton];
    
    [doneButton setFrame:CGRectMake(pickerView.frame.size.width/2,0,50,20)];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [pickerView removeFromSuperview];
   
}
- (IBAction)scanCodeAction:(UIButton *)sender {
    NSLog(@"sdkfhbklasdf");
    ScanController *svc=[[ScanController alloc]init];
    svc.scanControllerDelegate=self;
    [self presentViewController:svc animated:YES completion:nil];
}

-(void)setScannedText:(NSString *)text
{
    NSTimeInterval distanceBetweenDates = [[NSDate date] timeIntervalSinceDate:self.passedData.recordedDate];
    if (distanceBetweenDates/86400>30) {
        if ([text isEqualToString:self.serialTextLabel.text]) {
          
            self.passedData.recordedDate=[NSDate date];
            NSError *error;
            if ([context save:&error]) {
                NSLog(@"saved");
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Audited successfully" message:@"Device has been audited" delegate:nil
                                                   cancelButtonTitle:@"cancel" otherButtonTitles:nil, nil];
                [alert show];
                [self createNew];
//                [self.navigationController popViewControllerAnimated:YES];
            }
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Different barcode detected" message:@"Invalid Barcode" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    else
    {
    //self.serailNumberTextField.text=text;
        [self scanText:text];
    //[self generateBarCode:nil];
    }
}

-(void)scanText:(NSString *)scannedText
{
    NSUInteger i,j;
    NSString *assetID;
    NSString *serialNum;
    NSString *string =scannedText;
    if (([string rangeOfString:@":"].location == NSNotFound)||([string rangeOfString:@"PO#"].location == NSNotFound)||([string rangeOfString:@"Serial number#"].location == NSNotFound)||([string rangeOfString:@"Warranty"].location == NSNotFound)) {
        NSLog(@"string does not contain bla");
        self.serailNumberTextField.text=string;
        self.serialTextLabel.text=string;
        self.assetIDLabel.text=string;
        [self check];
        
    } else {
        //NSLog(@"string contains bla!");
        NSRange range=[string rangeOfString:@":"];
        i=range.location+1;
        range=[string rangeOfString:@"PO#"];
        j=range.location;
        assetID=[[string substringFromIndex:i] substringToIndex:j-i];
        self.assetIDLabel.text=assetID;
        range=[string rangeOfString:@"Serial number#"];
        i=range.location+14;
        range=[string rangeOfString:@"Warranty"];
        j=range.location;
        serialNum=[[string substringFromIndex:i] substringToIndex:j-i];
        self.serailNumberTextField.text=serialNum;
        self.serialTextLabel.text=serialNum;
        
        [self check];
    }
}


-(void)check
{
        BOOL present =NO ;
    for (int i=0; i<self.frc.fetchedObjects.count; i++) {
        sampleData=[self.frc.fetchedObjects objectAtIndex:i];
        if ([sampleData.isAvailable isEqualToNumber:@1]) {
        if ([sampleData.serialNo isEqualToString:self.serialTextLabel.text] || [sampleData.assetID isEqualToString:self.assetIDLabel.text]) {
            
            UIAlertView * alert=[[UIAlertView alloc]
                                 initWithTitle:@"Record is available in database" message:@"Duplicate records are not allowed" delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"Change Asset Owner", nil];
            [alert show];
           
            present=YES;
            self.generateBarCodeBtnOutlet.hidden=YES;
            self.contentsView.hidden=YES;
            editButton.enabled=NO;
            editButton.title=@"";
            self.scanOutlet.hidden=YES;
            
            break;
        }
    }
    if (!present && !self.contentsView.hidden && !new) {
        [self generateBarCode:nil];
    }
    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        self.contentsView.hidden=NO;
        self.barcodeImageView.image=[UIImage imageWithData:sampleData.barcodeImage];
        self.serialTextLabel.text=sampleData.serialNo;
        self.textField1.text=sampleData.assetOwnerName;
        self.textField2.text=sampleData.assetOwnerID;
        self.textField3.text=sampleData.projectManagerName;
        self.textField4.text=sampleData.projectName;
        self.deviceNameTextField.text=sampleData.deviceName;
        self.textView.text=sampleData.notes;
        self.categoryLabel.text=sampleData.deviceCategory;
        self.seatNoTextField.text=sampleData.seatNumber;
        self.assetIDLabel.text=sampleData.assetID;
        self.RAMSReqNoTextField.text=sampleData.ramsReqNo;
        self.phoenixReqNoTextField.text=sampleData.phoenixReqNo;
        sampleData.isAvailable=@0;
        NSError *error;
        [context save:&error];
        [self enableTextFieldEditing:YES];
        editButton.enabled=YES;
        editButton.title=@"Save";
        }
}

-(void)createNew
{
    BOOL present=YES;
    Data  *list=[NSEntityDescription insertNewObjectForEntityForName:@"Data"inManagedObjectContext:context];
    if (list!=nil) {
        list.serialNo=self.serialTextLabel.text;
        NSData *imageData=UIImagePNGRepresentation(self.barcodeImageView.image);
        list.barcodeImage=imageData;
        list.assetOwnerID=self.textField2.text;
        list.assetOwnerName=self.textField1.text;
        list.projectManagerName=self.textField3.text;
        list.projectName=self.textField4.text;
        list.deviceName=self.deviceNameTextField.text;
        list.notes=self.textView.text;
        list.deviceCategory=self.categoryLabel.text;
        list.seatNumber=self.seatNoTextField.text;
        list.assetID=self.assetIDLabel.text;
        list.ramsReqNo=self.RAMSReqNoTextField.text;
        list.phoenixReqNo=self.phoenixReqNoTextField.text;
        list.isAvailable=@1;
        
        NSDate *currentDate=[NSDate date];
        list.recordedDate=currentDate;
        NSError *error;
        
        //                Data *sampleData;
        //                for (int i=0; i<self.frc.fetchedObjects.count; i++) {
        //                    sampleData=[self.frc.fetchedObjects objectAtIndex:i];
        //                    if ([sampleData.serialNo isEqualToString:list.serialNo] || [sampleData.assetID isEqualToString:list.assetID]) {
        //                        UIAlertView * alert=[[UIAlertView alloc]
        //                        initWithTitle:@"Record is available in database" message:@"Duplicate records are not allowed" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:nil, nil];
        //                        [alert show];
        //                        present=NO;
        //                    }
        //                }
        //
        if (present) {
            if ([context save:&error]) {
                NSLog(@"data is saved");
                
            }else{
                NSLog(@"failed to save data ");
            }
            
        }
        else
        {
            NSLog(@"failed to create list object");
        }
    }
    [self.navigationController popViewControllerAnimated:YES];

}

#pragma tableview methods

-(void)getDeviceHistory
{
    
    //serach for the records and add itr to the data array
    
    //[self.textView setFrame:CGRectMake(10, 20, 150, 50)];
    //[self.textView removeFromSuperview];
    Data *sampleData1;
    for (int i=0; i<self.frc.fetchedObjects.count; i++) {
        sampleData1=[self.frc.fetchedObjects objectAtIndex:i];
        if ([sampleData1.serialNo isEqualToString:self.serialTextLabel.text] || [sampleData1.assetID isEqualToString:self.assetIDLabel.text]) {
            [deviceHistoryDataArray addObject:sampleData1];
        }
    }
    
    //CGRectMake(0, 60+self.contentsView.frame.size.height+20, self.view.frame.size.width, 260)
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, self.textView.frame.size.height+self.textView.frame.origin.y+2, self.view.frame.size.width,3)];
    [self.contentsView addSubview:lineView];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, self.textView.frame.size.height+self.textView.frame.origin.y+5, self.view.frame.size.width, 40)];
    label.text=@"Device's previous history";
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setBackgroundColor:[UIColor grayColor]];
    [self.contentsView addSubview:label];
    deviceHistoryTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, self.textView.frame.size.height+self.textView.frame.origin.y+label.frame.size.height+20, self.view.frame.size.width, self.view.frame.size.height-(self.textView.frame.size.height+self.textView.frame.origin.y)) style:UITableViewStylePlain];
    deviceHistoryTableView.delegate=self;
    deviceHistoryTableView.dataSource=self;
    [deviceHistoryTableView registerNib:[UINib nibWithNibName:@"AssetsCell" bundle:nil] forCellReuseIdentifier:@"assetsCell"];
    //[deviceHistoryTableView setBackgroundColor:[UIColor redColor]];
    [self.view bringSubviewToFront:deviceHistoryTableView];
    [self.contentsView addSubview:deviceHistoryTableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
  return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return deviceHistoryDataArray.count;
    // Return the number of rows in the section.
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130.f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AssetsCell *assetsCell=[tableView dequeueReusableCellWithIdentifier:@"assetsCell" forIndexPath:indexPath];
    if (assetsCell==nil) {
        
        assetsCell=[[AssetsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"assetsCell"];
    }
    
    Data *dataObj=[deviceHistoryDataArray objectAtIndex:indexPath.row];
    
    assetsCell.deviceNameLabel.text=dataObj.deviceName;
    assetsCell.assetOwnerIDLabel.text=dataObj.assetOwnerID;
    assetsCell.assetOwnerNameLabel.text=dataObj.assetOwnerName;
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *convertedDateString = [dateFormatter stringFromDate:dataObj.recordedDate];
    
    
    assetsCell.dateLabel.text=[NSString stringWithFormat:@"Last audited on %@",convertedDateString];
    
    NSTimeInterval distanceBetweenDates = [[NSDate date] timeIntervalSinceDate:dataObj.recordedDate];
    NSString *imageName;
    if ([dataObj.isAvailable isEqual:@1]) {
    if (distanceBetweenDates/86400>30) {
        imageName=@"cross108.png";
        assetsCell.dateLabel.textColor=[UIColor redColor];
    }
    else {
        imageName= @"circle108.png";
        assetsCell.dateLabel.textColor=[UIColor greenColor];
    }
    }
    else
    {
        imageName= @"signal7.png";
        assetsCell.dateLabel.textColor=[UIColor grayColor];
    }
    // NSLog(@"xfgdxfgdfgh   %f",distanceBetweenDates);
    assetsCell.auditedImageView.image=[UIImage imageNamed:imageName];
    
    return assetsCell;
}
@end
