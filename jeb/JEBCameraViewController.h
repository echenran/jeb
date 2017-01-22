//
//  JEBCameraViewController.h
//  jeb
//
//  Created by Joyce Yan on 1/20/17.
//  Copyright © 2017 Joyce Yan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#include <stdio.h>
#include <stdlib.h>
#include "MyUtils.h"
#include "network.h"
#include "region_layer.h"
#include "cost_layer.h"
#include "utils.h"
#include "parser.h"
#include "box.h"
#include "data.h"
#include "demo.h"
#include "option_list.h"
#include "list.h"

#import <opencv2/highgui/cap_ios.h>
#include <opencv2/opencv.hpp>
//#import "../opencv.hpp"

@interface JEBCameraViewController : UIViewController
{
  AVCaptureSession *cameraCaptureSession; //media "pipeline"
  AVCaptureVideoPreviewLayer *cameraPreviewLayer; //display video output streamed from camera
}

- (void) initializeCaptureSession; //initialize the cameraCaptureSession, link cameraPreviewLayer with
//cameraCaptureSession, and add cameraCaptureSession to the view


@end
