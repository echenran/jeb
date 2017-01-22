//
//  utils.h
//  jeb
//
//  Created by Joyce Yan on 1/21/17.
//  Copyright © 2017 Joyce Yan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyUtils:NSObject

- (MyUtils*)init;
- (char*)getPath:(NSString*)name :(NSString*)type :(NSString*)folder;

@end
