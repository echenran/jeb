//
//  JEBCameraViewController.m
//  jeb
//
//  Created by Joyce Yan on 1/20/17.
//  Copyright © 2017 Joyce Yan. All rights reserved.
//

#import "JEBCameraViewController.h"
#import "JEBObjectLabel.h"
#import "JEBPopover.h"


//#ifdef OPENCV
//#include "opencv2/highgui/highgui_c.h"
//#endif


static const int WIDTH_MARGIN = 50;
static const int HEIGHT_MARGIN = 75;
static const int BUTTON_SIZE = 28;
static NSString *const JEBXFont = @"Avenir-Black";

@interface JEBCameraViewController ()

@property (nonatomic, strong) JEBPopover *popover;
@property (nonatomic, strong) UIButton *xbutton;

@end

@implementation JEBCameraViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];

  // Initialize the camera.
  [self initializeCaptureSession];
    _popover = [[JEBPopover alloc] init];
    _xbutton = [[UIButton alloc] init];
  
  // Test out Jeb!
  JEBObjectLabel *jeb = [[JEBObjectLabel alloc] initWithFrame:CGRectMake(115.0f, 150.0f, 80.0f, 40.0f)];
  [jeb setTitle:@"Jeb!" forState:UIControlStateNormal];
  [self.view addSubview:jeb];
  
  // Add selectors to Jeb.
  [jeb addTarget:self action:@selector(onPress:) forControlEvents:UIControlEventTouchDown];
}

- (void)viewDidUnload {
  [super viewDidUnload];
  [cameraCaptureSession stopRunning];
}

#pragma mark - Camera

- (void) initializeCaptureSession {
  // Attempt to initialize AVCaptureDevice with back camera
  NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
  NSLog(@"Video devices: %@", videoDevices);
  AVCaptureDevice *captureDevice = nil;
  for (AVCaptureDevice *device in videoDevices)
  {
    if (device.position == AVCaptureDevicePositionBack) //if device.position == 1
    {
      captureDevice = device; //use the capture device with back camera
      break;
    }
  }
  
  // If camera is accessible by capture session
  if(captureDevice)
  {
    // Desired AVCaptureDevice is available
    NSLog(@"We have the back camera!");
    // Allocate camera capture session
    cameraCaptureSession = [[AVCaptureSession alloc] init];
    cameraCaptureSession.sessionPreset = AVCaptureSessionPresetMedium; //quality of video generated
    
    // Configure capture session input
    AVCaptureDeviceInput *videoIn = [AVCaptureDeviceInput
                                     deviceInputWithDevice:captureDevice
                                     error:nil];
    [cameraCaptureSession addInput:videoIn]; //add object to our capture session
    
    // Configure capture session output
    AVCaptureVideoDataOutput *videoOut = [[AVCaptureVideoDataOutput alloc] init];
    [videoOut setAlwaysDiscardsLateVideoFrames:YES]; //discard frames that are received late
    [cameraCaptureSession addOutput:videoOut];
    //[videoOut release];
    
    // Bind preview layer to capture session data
    //allocate preview layer
    cameraPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:cameraCaptureSession];
    //resize bounds of preview layer to fill device screen
    CGRect layerRect = self.view.bounds;
    cameraPreviewLayer.bounds = self.view.bounds;
    cameraPreviewLayer.position = CGPointMake(CGRectGetMidX(layerRect), CGRectGetMidY(layerRect));
    //sets videoGravity property (controls how frames shoud be rendered in preview layer)
    cameraPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill; //player should preserve
    //video's aspect ratio and fill layer bounds
    
    
    // Add preview layer to UIView layer (makes it visible to user)
    [self.view.layer addSublayer:cameraPreviewLayer];
    
    // Start running!
    [cameraCaptureSession startRunning];
    

    MyUtils *utilobj = [[MyUtils alloc] init];
    
    char* cocodatapath = [utilobj getPath:@"coco" :@"data" :@"."];
    list* options = read_data_cfg(cocodatapath);
      printf("Coco.data path: %s\n", cocodatapath);
    
    int classes = option_find_int(options, "classes", 20);

    char* coconamespath = [utilobj getPath:@"coco" :@"names" :@"."];
    printf("Coco.names path: %s\n", coconamespath);
    //char* name_list = coconamespath;
    char** names = get_labels(coconamespath);
    float thresh = .24;
    int cam_index = 0;
    char* filename = NULL;
    int frame_skip = 0;
    char* prefix = NULL;
    int hier_thresh = .5;
    //demo("tiny-yolo.cfg", "tiny-yolo.weights", thresh, cam_index, filename, names, classes, frame_skip, prefix, hier_thresh);
    
  }
  else
  {
    //  Desired AVCaptureDevice isn't available. Alert the user and bail.
    UIAlertController* alert = [UIAlertController
                                alertControllerWithTitle:@"Some alert"
                                message:@"Back camera not available"
                                preferredStyle:UIAlertControllerStyleAlert];
    
    /*message:@""
     delegate:nil
     cancelButtonTitle:@"Okay"
     otherButtonTitles:nil]; */
    UIAlertAction* defaultAction = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
  }
}

#pragma mark - Touch events

- (void)onPress:(id)sender{
  NSLog(@"hello jeb");
  CGSize screenSize = [UIScreen mainScreen].bounds.size;
  
    // Main popover.
    [_popover setWord:@"smash"];
    [self.view addSubview:_popover];
  
  // X button on top left corner.
  _xbutton.frame = CGRectMake(screenSize.width - WIDTH_MARGIN - BUTTON_SIZE*1.5, HEIGHT_MARGIN + BUTTON_SIZE*0.5, BUTTON_SIZE, BUTTON_SIZE);
  [_xbutton addTarget:self action:@selector(dismissPopover:) forControlEvents:UIControlEventTouchDown];
  [_xbutton setBackgroundColor:[UIColor grayColor]];
  _xbutton.layer.cornerRadius = BUTTON_SIZE/2.0f;
  [_xbutton setTitle:@"X" forState:UIControlStateNormal];
  [_xbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  UIFont *font = [UIFont fontWithName:JEBXFont size:16];
  _xbutton.titleLabel.font = font;
  [self.view addSubview:_xbutton];
}

- (void)dismissPopover:(id)sender
{
  NSLog(@"goodbye jeb");
  [_popover removeFromSuperview];
  [_xbutton removeFromSuperview];
}

#pragma mark - Memory

- (void)dealloc {
  [cameraCaptureSession stopRunning];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
