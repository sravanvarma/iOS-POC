//
//  AssetsController.m
//  try1
//
//  Created by Divya Vuppala on 02/09/15.
//  Copyright (c) 2015 CTS. All rights reserved.
//

#import "AssetsController.h"
#import "ViewController.h"
#import "AssetsCell.h"

@interface AssetsController ()<NSFetchedResultsControllerDelegate>
@property(nonatomic,strong)NSManagedObjectContext *context;
@property(nonatomic,strong)NSFetchedResultsController *frc;
@property(nonatomic,strong)NSArray *results;
@end



@implementation AssetsController
{
    NSMutableArray *arr;
    NSArray *nameArrayTemp;
    Data *passedData;
    
    BOOL status;
    NSIndexPath *scannedIndexPath;
    UIBarButtonItem *rightButton;
    UIBarButtonItem *leftButton;
    UIView * printView;
    NSString *scannedText;
    UIView *exportView;
    BOOL mimeTypePDF;
    BOOL mimeTypeCSV;
    UIWebView *webView;
   // UIPopoverController *popover;
    UIView *selectView;
    NSInteger selectedIndex;
    NSString *serialNum;
    
}

- (void)viewDidLoad {
    
    mimeTypePDF=YES;
    mimeTypeCSV=NO;
   // [self scanText:nil];
    
    
    
   
    
    
    //[self searchForData:@"SC07NL195G1HW&AMM00087"];
    arr=[[NSMutableArray alloc]initWithObjects:@"All",@"phones",@"tablets",@"Desktop",@"laptops", nil];
    selectView=[[UIView alloc]initWithFrame:CGRectMake(100, 100, 150, 150)];
    selectView.backgroundColor=[UIColor grayColor];
    for (int i=0; i<arr.count; i++) {
        UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(10, 30*i, 130, 20)];
        [button setTitle:[arr objectAtIndex:i] forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(categoryTypeClicked:) forControlEvents:UIControlEventTouchUpInside];
        button.tag=i;
        [selectView addSubview:button];
    }
    
    AppDelegate *apf=[UIApplication sharedApplication].delegate;
    self.context=apf.managedObjectContext;
    
    NSFetchRequest *fetchrequest=[[NSFetchRequest alloc]initWithEntityName:@"Data"];
    
    
    
    NSSortDescriptor *sortdescriptor=[[NSSortDescriptor alloc]initWithKey:@"deviceCategory" ascending:YES];
    
    
    
    fetchrequest.sortDescriptors=@[sortdescriptor];

    NSError *error = nil;
  
    
    
    
    self.frc=[[NSFetchedResultsController alloc]initWithFetchRequest:fetchrequest managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
    self.frc.delegate=self;
    
    if ([self.frc performFetch:&error]) {
        NSLog(@"data fetched sucessfully");
//        [self csvMethod];
    }
    else{
        NSLog(@"data fetching is failed");
        
    }
    
    //scannedIndexPath=[[NSIndexPath alloc]init];
    status=false;
    
    
    
    
      [self.tableView registerNib:[UINib nibWithNibName:@"AssetsCell" bundle:nil] forCellReuseIdentifier:@"assetsCell"];
//    arr=[[NSMutableArray alloc]init];
//    nameArrayTemp=[[NSArray alloc]initWithObjects:@"iphone 4",@"iphone 4s",@"iphone 5",@"iphone 5s",@"iphone 6",@"iphone 6 Plus",@"ipad 2",@"ipad air",@"ipad air2",@"Mac", nil];
//    for (int i=123456789; arr.count<10; i++) {
//        [arr addObject:[NSString stringWithFormat:@"%d",i]];
//    }
    
    rightButton=[[UIBarButtonItem alloc]initWithTitle:@"Add new" style:UIBarButtonItemStylePlain target:self action:@selector(createNew)];
    
    leftButton=[[UIBarButtonItem alloc]initWithTitle:@"Search" style:UIBarButtonItemStylePlain target:self action:@selector(searchFor)];

    self.navigationItem.rightBarButtonItem=rightButton;
    self.navigationItem.leftBarButtonItem=leftButton;
    
    
    
    
    
//  popover = [[UIPopoverController alloc]initWithContentViewController:[popUpTableViewController getPopUpTableViewControllerInstance]];
//    [popover setPopoverContentSize:CGSizeMake(100,300)];
//    popover.delegate = self;
//    
    
    
}

-(void)categoryTypeClicked:(UIButton*)sender
{
    selectedIndex=sender.tag;
    UIButton *printButton=[[UIButton alloc]initWithFrame:CGRectMake(250, 45, 50, 50)];
    [printButton setTitle:@"Mail" forState:UIControlStateNormal];
    [printView addSubview:printButton];
    [printButton addTarget:self action:@selector(printButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    NSLog(@"%ld",(long)selectedIndex);
    [selectView removeFromSuperview];
    [self createPDFfromUIView:nil saveToDocumentsWithFileName:@"mypdf.pdf"];

}

-(void)csvMethod{
    
    NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString* documentDirectory = [documentDirectories objectAtIndex:0];
    NSString* documentDirectoryFilename = [documentDirectory stringByAppendingPathComponent:@"excelData.csv"];
    
    
    //NSString* documentDirectoryFilenamexls = [documentDirectory stringByAppendingPathComponent:@"sample.xls"];
    
    CHCSVWriter *csvWriter=[[CHCSVWriter alloc]initForWritingToCSVFile:documentDirectoryFilename];
    
    // NSLog(@"%d",[currentRow count]);
    [csvWriter writeField:@"Device Name"];
    [csvWriter writeField:@"Device Category"];
    [csvWriter writeField:@"Asset Owner"];
    [csvWriter writeField:@"Asset Owner ID"];
    [csvWriter writeField:@"Seat Number"];
    [csvWriter writeField:@"Asset ID"];
    [csvWriter writeField:@"Serial Number"];
    [csvWriter writeField:@"Project Manager"];
    [csvWriter writeField:@"Project Name"];
    [csvWriter writeField:@"Recorded Date"];
    [csvWriter writeField:@"RAMS Req No"];
    [csvWriter writeField:@"Phoenix Req No"];
    [csvWriter writeField:@"Notes"];

    
    [csvWriter finishLine];
    
     
    for (int i=0; i<self.frc.fetchedObjects.count; i++) {
        Data *currentObject=[self.frc.fetchedObjects objectAtIndex:i];
        if ([currentObject.isAvailable isEqual:@1]) {
        [csvWriter writeField:currentObject.deviceName];
        [csvWriter writeField:currentObject.deviceCategory];
        [csvWriter writeField:currentObject.assetOwnerName];
        [csvWriter writeField:currentObject.assetOwnerID];
        [csvWriter writeField:currentObject.seatNumber];
        [csvWriter writeField:currentObject.assetID];
        [csvWriter writeField:currentObject.serialNo];
        [csvWriter writeField:currentObject.projectManagerName];
        [csvWriter writeField:currentObject.projectName];
        [csvWriter writeField:currentObject.recordedDate];
               [csvWriter writeField:currentObject.ramsReqNo];
        [csvWriter writeField:currentObject.phoenixReqNo];
        [csvWriter writeField:currentObject.notes];

        [csvWriter finishLine];
        }
    }
 [csvWriter closeStream];
    NSLog(@"%@",documentDirectoryFilename);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
     return self.frc.sections.count;
}
//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
////    return [NSString stringWithFormat:@"%@",self.frc.sectionNameKeyPath];
//    return @"header";
//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id  sectionInfo =
    [[self.frc sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
    // Return the number of rows in the section.
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    AssetsCell *assetsCell=[tableView dequeueReusableCellWithIdentifier:@"assetsCell" forIndexPath:indexPath];
    if (assetsCell==nil) {
        
        assetsCell=[[AssetsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"assetsCell"];
    }
    Data *dataObj=[self.frc objectAtIndexPath:indexPath];
    assetsCell.deviceNameLabel.text=dataObj.deviceName;
    assetsCell.assetOwnerIDLabel.text=dataObj.assetOwnerID;
    assetsCell.assetOwnerNameLabel.text=dataObj.assetOwnerName;
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];     [dateFormatter setDateFormat:@"dd-MM-yyyy"];
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
        imageName=@"signal7.png";
        assetsCell.dateLabel.textColor=[UIColor grayColor];
    }
   // NSLog(@"xfgdxfgdfgh   %f",distanceBetweenDates);
    assetsCell.auditedImageView.image=[UIImage imageNamed:imageName];
    return assetsCell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    passedData=[self.frc objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"transfer" sender:nil];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    Data *list=[self.frc objectAtIndexPath:indexPath];
    [[self   context]deleteObject:list];
    
    if ([list isDeleted]) {
        NSError *error=nil;
        if ([[self context]save:&error]) {
            NSLog(@"deleted");
        }
        else{
            NSLog(@"not deleted");
        }
    }
}

#pragma mark nsfetchresultdelegate
-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller{
    [self.tableView beginUpdates];
}
-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath{
    if (type==NSFetchedResultsChangeDelete) {
        [self.tableView deleteRowsAtIndexPaths:@[indexPath ] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else if(type==NSFetchedResultsChangeUpdate)
    {
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    //if the order of objects has been changed
    else if (type==NSFetchedResultsChangeMove)
    {
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else if(type==NSFetchedResultsChangeInsert){
        [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    [self.tableView endUpdates];
}


-(void)searchFor
{
    ScanController *svc=[[ScanController alloc]init];
    svc.scanControllerDelegate=self;
    [self presentViewController:svc animated:YES completion:nil];
    //[self.navigationController pushViewController:svc animated:YES];
}

-(void)createNew
{
    [self performSegueWithIdentifier:@"transfer" sender:nil];
}



- (IBAction)segmentControlAction:(UISegmentedControl *)sender {
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    
    mimeTypePDF=YES;
    
    
    if (selectedSegment == 0)
    {
        
        [self.tableView setContentOffset:CGPointMake(0, -60) animated:YES];
        self.tableView.scrollEnabled=YES;
        //self.tableView.scrollsToTop=YES;
        //toggle the correct view to be visible
      //  printView.hidden=YES;
        [selectView removeFromSuperview];
        [printView removeFromSuperview];
        [exportView removeFromSuperview];
        rightButton.title=@"Add new";
        leftButton.title=@"Search";
        rightButton.enabled=true;
        leftButton.enabled=true;
    }
    else if(selectedSegment ==1){
        //self.tableView.scrollsToTop=YES;
    
        [self.tableView setContentOffset:CGPointMake(0, -60) animated:YES];
         self.tableView.scrollEnabled=NO;
       printView =[[UIScrollView alloc]initWithFrame:CGRectMake(0,0, self.tableView.frame.size.width,self.tableView.frame.size.height)];
        [printView setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:printView];
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPressed)];
        [printView addGestureRecognizer:tap];
        UIButton *generatePDFButton=[[UIButton alloc]initWithFrame:CGRectMake(100, 45, 150, 50)];
        [generatePDFButton setTitle:@"Generate PDF" forState:UIControlStateNormal];
        [printView addSubview:generatePDFButton];
        [generatePDFButton addTarget:self action:@selector(generatePDFButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
      //  [self generatePDFButtonPressed];
      
       // printView.hidden=NO;
        rightButton.title=@"";
        leftButton.title=@"";
        rightButton.enabled=false;
        leftButton.enabled=false;
        [exportView removeFromSuperview];
        //toggle the correct view to be visible
    }
    else if(selectedSegment ==2)
    {
       
        //self.tableView.scrollsToTop=YES;
        
        [self.tableView setContentOffset:CGPointMake(0, -60) animated:YES];
        self.tableView.scrollEnabled=NO;
        mimeTypeCSV=YES;
        rightButton.title=@"";
        leftButton.title=@"";
        rightButton.enabled=false;
        leftButton.enabled=false;
        [printView removeFromSuperview];
       exportView=[[UIScrollView alloc]initWithFrame:CGRectMake(0,0, self.view.frame.size.width,self.view.frame.size.height)];
        [exportView setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:exportView];
        [selectView removeFromSuperview];
//        UIButton *excelButton=[[UIButton alloc]initWithFrame:CGRectMake(20, 150, 200, 200)];
//        [excelButton setTitle:@"Mail" forState:UIControlStateNormal];
//        //[excelButton setBackgroundColor:[UIColor redColor]];
//        [excelButton addTarget:self action:@selector(excelButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//        [exportView addSubview:excelButton];
        [self excelButtonPressed];
    }
    else
    {
     
        [printView removeFromSuperview];
        [exportView removeFromSuperview];
        self.tableView.scrollEnabled=YES;
        // sample Code Action
         
        QZWorkbook *excelReader = [[QZWorkbook alloc] initWithContentsOfXLS:[[NSBundle mainBundle] URLForResource:@"1" withExtension:@"xls"]];
        QZWorkSheet *firstWorkSheet = excelReader.workSheets.firstObject;
        [firstWorkSheet open];
        // [ViewController getFilterdDataFromCSV];
        
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];
        
        for (int i=0; i<firstWorkSheet.rows.count; i++) {
            NSArray *keybj = firstWorkSheet.rows[i];
            
            NSMutableArray *keyArray =[[NSMutableArray alloc] init];
            for (int j=0; j<keybj.count; j++) {
                
                [keyArray addObject:((QZCell*)[keybj objectAtIndex:j]).content ? ((QZCell*)[keybj objectAtIndex:j]).content :@" "];
            }
            [dataArray addObject:keyArray];
            
        }
        
        NSArray *keysArray = [dataArray objectAtIndex:0];
        
        [dataArray removeObjectAtIndex:0];
        NSMutableArray *finalArray = [[NSMutableArray alloc] init];
        for (int i=0; i<dataArray.count; i++) {
            
            NSArray *valueArray = [dataArray objectAtIndex:i];
            
            
            NSMutableDictionary *dict =[[NSMutableDictionary alloc] initWithObjects:valueArray forKeys:keysArray];
            
            [finalArray addObject:dict];
            
            
        }
        
        
        //NSLog(@"%@",finalArray[0]);
        if (self.frc.fetchedObjects.count>0) {
             [self storeDatatoDBfromArray:finalArray dumpAllData:NO];
        }
        else
        {
             [self storeDatatoDBfromArray:finalArray dumpAllData:YES];
        }
       
//        [self fetchDataFromDB];
    }
    
}

-(void)createRecord:(NSDictionary *)dict
{
    int i=0;
    NSArray *array=[[NSArray alloc]initWithObjects:dict, nil];
    
    Data  *list=[NSEntityDescription insertNewObjectForEntityForName:@"Data"inManagedObjectContext:self.context];
    if (list!=nil) {
        
        list.deviceName=[[array objectAtIndex:i]objectForKey:@"Device Name"];
        list.deviceCategory=[[array objectAtIndex:i]objectForKey:@"Device Category"];
        list.assetOwnerName=[[array objectAtIndex:i]objectForKey:@"Asset Owner"];
        NSNumber *ID=[[array objectAtIndex:i] objectForKey:@"Asset Owner ID"];
        list.assetOwnerID=[NSString stringWithFormat:@"%@",ID];
        list.assetID=[[array objectAtIndex:i]objectForKey:@"Asset ID"];
        list.serialNo=[[array objectAtIndex:i]objectForKey:@"Serial Number"];
        list.seatNumber=[[array objectAtIndex:i]objectForKey:@"Seat Number"];
        list.projectManagerName=[[array objectAtIndex:i]objectForKey:@"Project Manager"];
        list.projectName=[[array objectAtIndex:i]objectForKey:@"Project Name"];
        list.ramsReqNo=[[array objectAtIndex:i]objectForKey:@"RAMS Req No"];
        list.phoenixReqNo=[NSString stringWithFormat:@"%@",[[array objectAtIndex:i]objectForKey:@"Phoenix Req No"]];
        list.recordedDate=[NSDate date];
        list.notes=[[array objectAtIndex:i]objectForKey:@"Notes"];
        list.isAvailable=@1;
    }
    NSError *error;
    
    if ([self.context save:&error])
    {
        NSLog(@"data is saved");
        
    }
    else
    {
        NSLog(@"failed to save data ");
    }

}

-(void)storeDatatoDBfromArray:(NSMutableArray *)array dumpAllData:(BOOL)presentStatus{
    
    if (presentStatus) {
        for(int i=0;i<array.count;i++)
        {
            [self createRecord:array[i]];
        }

    }
    else
    {
   
    for(int i=0;i<array.count;i++)
    {
        [self serachDatabaseWithDictionary:array[i]];
    }
    }
        
    self.segmentControlOutlet.selectedSegmentIndex=0;
    
  
}


-(void)serachDatabaseWithDictionary:(NSDictionary *)dict
{
    //not avialble then store it
    BOOL present=NO,same=NO;
    int i;
    Data *sampleData;
    NSError *error;
    NSNumber *n=[dict objectForKey:@"Asset Owner ID"];
    for (i=0; i<self.frc.fetchedObjects.count; i++) {
        sampleData=self.frc.fetchedObjects[i];
        if ([sampleData.isAvailable isEqual:@1]) {
            NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
            f.numberStyle = NSNumberFormatterDecimalStyle;
           // NSNumber *myNumber = [f numberFromString:sampleData.assetOwnerID];
            if ([sampleData.serialNo isEqualToString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"Serial Number"]]]&&[sampleData.assetID isEqualToString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"Asset ID"]]])
            {
                same=YES;
                if (![sampleData.assetOwnerID isEqualToString:[n stringValue]])
                {
                present=YES;
                //sampleData=self.frc.fetchedObjects[i];
                sampleData.isAvailable=@0;
                [self.context save:&error];
                [self createRecord:dict];
                break;
                }
                else
                {
                    sampleData.deviceName=[dict objectForKey:@"Device Name"];
                    sampleData.deviceCategory=[dict objectForKey:@"Device Category"];
                    sampleData.assetOwnerName=[dict objectForKey:@"Asset Owner"];
                    NSNumber *ID=[dict  objectForKey:@"Asset Owner ID"];
                    sampleData.assetOwnerID=[NSString stringWithFormat:@"%@",ID];
                    sampleData.assetID=[dict objectForKey:@"Asset ID"];
                    sampleData.serialNo=[dict objectForKey:@"Serial Number"];
                    sampleData.seatNumber=[dict objectForKey:@"Seat Number"];
                    sampleData.projectManagerName=[dict objectForKey:@"Project Manager"];
                    sampleData.projectName=[dict objectForKey:@"Project Name"];
                    sampleData.ramsReqNo=[dict objectForKey:@"RAMS Req No"];
                    sampleData.phoenixReqNo=[NSString stringWithFormat:@"%@",[dict objectForKey:@"Phoenix Req No"]];
                    sampleData.recordedDate=[NSDate date];
                    sampleData.notes=[dict objectForKey:@"Notes"];
                    sampleData.isAvailable=@1;
                    [self.context save:&error];
                }
                    
            }
        }
    }
    
    if (!present&&!same) {
        [self createRecord:dict];
    }
}


-(void)tapPressed
{
   [selectView removeFromSuperview];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //[selectView removeFromSuperview];
    selectView.hidden=YES;
}
-(void)excelButtonPressed
{
    mimeTypePDF=NO;
    mimeTypeCSV=YES;
    //create excel here
    [self csvMethod];
    [self printButtonPressed];
}
-(void)printButtonPressed{
    if (self.frc.fetchedObjects.count>0) {
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
    mailController.mailComposeDelegate = self;
    mailController.modalPresentationStyle = UIModalPresentationFormSheet;
    NSMutableArray *recipients = [NSMutableArray array];

    [recipients addObject:@"GummaRama.Gopalakrishnasastry@cognizant.com"];
        [recipients addObject:@"SravanKumar.Appana@cognizant.com"];
    
    
    if ([recipients count] > 0)
    {
        [mailController setToRecipients:recipients];
    }
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd-MM-YYYY"];
    
    [mailController setSubject:[NSString stringWithFormat:@"%@ - %@", @"Details of the Devices", [df stringFromDate:[NSDate date]]]];

    // ATTACHING A SCREENSHOT
    
    NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString* documentDirectory = [documentDirectories objectAtIndex:0];
   [mailController setSubject:@"Details of the devices"];
        if (mimeTypePDF) {
            NSString* documentDirectoryFilename = [documentDirectory stringByAppendingPathComponent:@"mypdf.pdf"];
            [mailController addAttachmentData:[NSData dataWithContentsOfFile:documentDirectoryFilename] mimeType:@"application/pdf" fileName:@"mypdf.pdf"];
            
        }
        else if (mimeTypeCSV){
            NSString* documentDirectoryFilename = [documentDirectory stringByAppendingPathComponent:@"excelData.csv"];
            //[mailController addAttachmentData:[NSData   dataWithContentsOfFile:documentDirectoryFilename] mimeType:@"text/csv" fileName:@"excelData.csv"];
          
             NSString* documentDirectoryFilenamexls = [documentDirectory stringByAppendingPathComponent:@"sample.xls"];
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            [fileManager createFileAtPath:documentDirectoryFilenamexls contents:[NSData dataWithContentsOfFile:documentDirectoryFilename] attributes:nil];
            [mailController addAttachmentData:[NSData   dataWithContentsOfFile:documentDirectoryFilename] mimeType:@"application/vnd.ms-excel" fileName:@"sample.xls"];

            
            mimeTypePDF=YES;
        }
 
    
        if (mailController == nil) {
        return;
    }
    
    // SHOWING MAIL VIEW
    [self presentViewController:mailController animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
    //[controller dismissModalViewControllerAnimated:YES];
    [controller dismissViewControllerAnimated:YES completion:nil];
}


-(void)generatePDFButtonPressed{

   // [popUpTableController.view setFrame:CGRectMake(100, 300, 100, 70)];

//  
//    [popover presentPopoverFromRect:CGRectMake(100, 45, 150, 50)
//                                       inView:self.view
//                     permittedArrowDirections:UIPopoverArrowDirectionLeft
//                                     animated:YES];
//    popUpTableViewController *obj=[popUpTableViewController getPopUpTableViewControllerInstance];
//    
//    if([obj getTheSelectedString]!=nil)
//    {
    
    [self.view addSubview:selectView];
    
    
//    }

}

-(void)searchForData:(NSString *)s
{
         NSString *value;
    NSString *assetIDVal;
    NSString *func;
    NSString *sample=s;
    status=false;
   //s=@"xbcdgcxbcvxb";
    Data *tempData;
    scannedIndexPath=nil;
    NSString *temp;
     if ([s rangeOfString:@"&"].location == NSNotFound)
     {
          temp=s;
  
     }
    if (serialNum)
    {
//        NSRange range=[s rangeOfString:@"&"];
//        NSUInteger i=range.location;
//        temp=[s substringToIndex:i];
        temp=serialNum;
    }
    for (NSInteger i=0; i<self.frc.fetchedObjects.count; i++) {
        tempData=[self.frc.fetchedObjects objectAtIndex:i];
        if ([temp isEqualToString:tempData.serialNo]) {
            status=true;
            assetIDVal=tempData.assetID;
            scannedIndexPath=[NSIndexPath indexPathForRow:i inSection:0];
            break;
        }
    }
    if (status) {
        value=@"Data Available";
        func=@"Okay";
    }
    else
    {
        scannedText=sample;
        value=@"Data not available";
        func=@"Add it";
        
    }
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"Serial number and AssetID: %@ & %@",temp,assetIDVal] message:value delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:func, nil, nil];
    alert.delegate=self; 
    [alert show];
    serialNum=nil;
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex>0) {
    if (status) {
       //[self.tableView selectRowAtIndexPath:scannedIndexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
//        AssetsCell *cell=(AssetsCell *)[self.tableView cellForRowAtIndexPath:scannedIndexPath];
////        cell.selected=YES;
//        cell.highlighted=YES;
        status=false;
        
    }
    else {
        [self createNew];

    }
    
    }
    else
    {
        scannedText=nil;
    }
}
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

     
        ViewController *vc=segue.destinationViewController;
     if ([segue.identifier isEqualToString:@"transfer"]) {
         vc.passedString=scannedText;
         scannedText=nil;
         //vc.passedString=@"SC07NL195G1HW&AMM00087";
         vc.passedData=passedData;
         passedData=nil;
     }
    
 }         

-(void)setScannedText:(NSString *)text
{
    NSLog(@"%@",text);
    [self scanText:text];
  
}
-(void)createPDFfromUIView:(UIView*)aView saveToDocumentsWithFileName:(NSString*)aFilename
{
    
    [webView removeFromSuperview];
    
    NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString* documentDirectory = [documentDirectories objectAtIndex:0];
    NSString *pdfFileName = [documentDirectory stringByAppendingPathComponent:@"mypdf.pdf"];
    CGRect bounds=CGRectMake(0, 20, 612, self.frc.fetchedObjects.count*200);
    UIGraphicsBeginPDFContextToFile(pdfFileName, bounds, nil);
    UIGraphicsBeginPDFPage();
    UIColor*color = [UIColor blackColor];
    NSDictionary*att = @{NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Bold" size:13], NSForegroundColorAttributeName:color};
//    NSString *myString = @"Contents";
//    [myString drawWithRect:CGRectMake(0, 5, 250, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:att context:nil];
    NSMutableArray *dataArray=[[NSMutableArray alloc]init];
    Data *data;
    if (selectedIndex!=0) {
        for (int i=0; i<self.frc.fetchedObjects.count; i++)
        {
            data=[self.frc.fetchedObjects objectAtIndex:i];
            if ([data.deviceCategory isEqualToString:arr[selectedIndex]])
            {
                [dataArray addObject:data];
            }
        }
    } else {
        dataArray=[self.frc.fetchedObjects mutableCopy];
    }
    int k=0;
   
        for (int i=0; i<dataArray.count; i++)
        {
            Data *selectedData=[dataArray objectAtIndex:i];
            [@"property of COGNIZANT" drawWithRect:CGRectMake(20, i*100+30+k, 250, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:att context:nil];
            
           // NSData *data1=[self getTheBarcodeImageForString:selectedData.serialNo];
            
            [[self getTheBarcodeImageForString:selectedData.serialNo] drawInRect:CGRectMake(20, i*100+60+k, 250, 40)];
            [[NSString stringWithFormat:@"Device name: %@",selectedData.deviceName] drawWithRect:CGRectMake(290, i*100+60+k, 250, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:att context:nil];
            [[NSString stringWithFormat:@"Device Owner: %@",selectedData.assetOwnerName] drawWithRect:CGRectMake(290, i*100+80+k, 250, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:att context:nil];
            [[NSString stringWithFormat:@"Owner ID: %@",selectedData.assetOwnerID] drawWithRect:CGRectMake(290, i*100+100+k, 250, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:att context:nil];
            [selectedData.serialNo drawWithRect:CGRectMake(20, i*100+120+k, 250, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:att context:nil];
            // [[self getTheBarcodeImageForString:selectedData.serialNo] drawInRect:CGRectMake(20, i*100+60+k, 250, 2)];
            k+=20;
        }
       
     
    
    
    UIGraphicsEndPDFContext();
    NSLog(@"documentDirectoryFileName: %@",pdfFileName);
    NSURL *targetURL = [NSURL fileURLWithPath:pdfFileName];
    webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 150, self.view.frame.size.width, self.view.frame.size.height-250)];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [webView loadRequest:request];

    [printView addSubview:webView];
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

- (void)dealloc {
   // [_printView release];
    [_segmentControlOutlet release];
    [super dealloc];
}

/* EXCEL */

-(void) parserDidBeginDocument:(CHCSVParser *)parser
{
}

-(void) parserDidEndDocument:(CHCSVParser *)parser
{
}

- (void) parser:(CHCSVParser *)parser didFailWithError:(NSError *)error
{
    NSLog(@"Parser failed with error: %@ %@", [error localizedDescription], [error userInfo]);
}

-(void)parser:(CHCSVParser *)parser didBeginLine:(NSUInteger)recordNumber
{
}

-(void)parser:(CHCSVParser *)parser didReadField:(NSString *)field atIndex:(NSInteger)fieldIndex
{
}

- (void) parser:(CHCSVParser *)parser didEndLine:(NSUInteger)lineNumber
{
}

-(void)scanText:(NSString *)text
{
    NSUInteger i,j;
    NSString *assetID;
   
    NSString *string = text;
    if (([string rangeOfString:@":"].location == NSNotFound)||([string rangeOfString:@"PO#"].location == NSNotFound)||([string rangeOfString:@"Serial number#"].location == NSNotFound)||([string rangeOfString:@"Warranty"].location == NSNotFound)) {
        NSLog(@"string is not in the expected format");
        [self searchForData:text];

        
    } else {
        //NSLog(@"string contains bla!");
        NSRange range=[string rangeOfString:@":"];
        i=range.location+1;
        range=[string rangeOfString:@"PO#"];
        j=range.location;
        assetID=[[string substringFromIndex:i] substringToIndex:j-i];
        
        range=[string rangeOfString:@"Serial number#"];
        i=range.location+14;
        range=[string rangeOfString:@"Warranty"];
        j=range.location;
        serialNum=[[string substringFromIndex:i] substringToIndex:j-i];
        //NSString *s=[NSString stringWithFormat:@"%@&%@",serialNum,assetID];
        [self searchForData:text];

    }
}

@end
