#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface AWScreenshot : NSObject
{
}

+ (CGImageRef) takeAsCGImage;

#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
+ (UIImage*) takeAsImage;
#else
+ (CGImageRef) takeAsImage;
#endif

@end