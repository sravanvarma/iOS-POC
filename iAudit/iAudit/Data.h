
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Data : NSManagedObject

@property (nonatomic, retain) NSString * assetID;
@property (nonatomic, retain) NSString * assetOwnerID;
@property (nonatomic, retain) NSString * assetOwnerName;
@property (nonatomic, retain) NSData * barcodeImage;
@property (nonatomic, retain) NSString * deviceCategory;
@property (nonatomic, retain) NSString * deviceName;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * phoenixReqNo;
@property (nonatomic, retain) NSString * projectManagerName;
@property (nonatomic, retain) NSString * projectName;
@property (nonatomic, retain) NSString * ramsReqNo;
@property (nonatomic, retain) NSDate * recordedDate;
@property (nonatomic, retain) NSString * seatNumber;
@property (nonatomic, retain) NSString * serialNo;
@property (nonatomic, retain) NSNumber * isAvailable;

@end
