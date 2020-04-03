#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "log4swift.h"
#import "LoggerClient.h"
#import "LoggerCommon.h"
#import "NSLogger.h"
#import "ASLWrapper.h"

FOUNDATION_EXPORT double Log4swiftVersionNumber;
FOUNDATION_EXPORT const unsigned char Log4swiftVersionString[];

