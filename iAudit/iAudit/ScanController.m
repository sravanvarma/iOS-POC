//
//  ScanController.m
//  try1
//
//  Created by Divya Vuppala on 02/09/15.
//  Copyright (c) 2015 CTS. All rights reserved.
//
#import <AVFoundation/AVFoundation.h>
#import "ScanController.h"
#import "AssetsController.h"

@interface ScanController() <AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureSession *_session;
    AVCaptureDevice *_device;
    AVCaptureDeviceInput *_input;
    AVCaptureMetadataOutput *_output;
    AVCaptureVideoPreviewLayer *_prevLayer;
    AVCaptureVideoPreviewLayer *_transparentLayer;
    UIView *_highlightView;
    UILabel *_label;
    NSString *s;
}
@end

@implementation ScanController

- (void)viewDidLoad
    {
        [super viewDidLoad];
       // [self sample];
        s=nil;
        
        //[self dataFetchedWas:@"xbcdgcxbcvxb"];
        _highlightView = [[UIView alloc] init];
        _highlightView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
        _highlightView.layer.borderColor = [UIColor greenColor].CGColor;
        _highlightView.layer.borderWidth = 3;
        [self.view addSubview:_highlightView];
        
        _label = [[UILabel alloc] init];
        _label.frame = CGRectMake(40, self.view.frame.size.height - 40, self.view.frame.size.width, 40);
        _label.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        _label.backgroundColor = [UIColor colorWithWhite:0.15 alpha:0.65];
        _label.textColor = [UIColor whiteColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.text = @"(none)";
        [self.view addSubview:_label];
        
        UIButton *sample=[[UIButton alloc]initWithFrame:CGRectMake(0, 50, 120, 50)];
        [sample setBackgroundColor:[UIColor grayColor]];
        [sample setTitle:@"Dismiss" forState:UIControlStateNormal];
        [self.view addSubview:sample];
        [sample addTarget:self action:@selector(sampleAction) forControlEvents:UIControlEventAllEvents];
        
        
        _session = [[AVCaptureSession alloc] init];
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        NSError *error = nil;
        
        _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
        if (_input) {
            [_session addInput:_input];
        } else {
            NSLog(@"Error: %@", error);
        }
        
        _output = [[AVCaptureMetadataOutput alloc] init];
        [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        [_session addOutput:_output];
        
        _output.metadataObjectTypes = [_output availableMetadataObjectTypes];
        _prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
        _prevLayer.frame = CGRectMake(80, self.view.frame.size.height-180, self.view.frame.size.width-80, 300);
        _prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [self.view.layer addSublayer:_prevLayer];
        
        [_session startRunning];
        
        [self.view bringSubviewToFront:_highlightView];
        [self.view bringSubviewToFront:_label];
    }
    
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
    {
        CGRect highlightViewRect = CGRectZero;
        AVMetadataMachineReadableCodeObject *barCodeObject;
        AVMetadataMachineReadableCodeObject *barCodeObject1;

        NSString *detectionString = nil;
        NSArray *barCodeTypes = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code,
                                  AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code,
                                  AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode];
        
        for (AVMetadataObject *metadata in metadataObjects) {
            for (NSString *type in barCodeTypes) {
                if ([metadata.type isEqualToString:type])
                {
                    barCodeObject = (AVMetadataMachineReadableCodeObject *)[_prevLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
                    highlightViewRect = barCodeObject.bounds;
                    detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                    barCodeObject1 = (AVMetadataMachineReadableCodeObject *)[_transparentLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
                    highlightViewRect = barCodeObject.bounds;
//                    detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                    break;
                }
            }
            
            if (detectionString != nil)
            {
                _label.text = detectionString;
                s=detectionString;
                [self dataFetchedWas:detectionString];
                break;
            }
            else
                _label.text = @"(none)";
            
        }
        
        _highlightView.frame = highlightViewRect;
    }

-(void)dataFetchedWas:(NSString *)string
{

    [_session stopRunning];
    s=string;
    [self sampleAction];
}

-(void)sampleAction
{
    
        [self dismissViewControllerAnimated:YES completion:^{
        if (s.length>0) {
            [self.scanControllerDelegate setScannedText:s];
            s=nil;
        }
        }];
}
@end
