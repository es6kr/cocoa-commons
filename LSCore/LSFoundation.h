//
//  LSFoundation.h
//
//

typedef void(^LSVoidBlock)(void);

#import "LSHttpRequest.h"
#import "LSInvocation.h"
#import "NSData+LSData.h"
#import "NSObject+LSCoreObject.h"
#import "NSString+LSCoreString.h"
#import "NSUUID+Base64.h"


@interface LSFoundation : NSObject

+ (NSString*)machineName;

@end


@interface NSArray (LSCoreArray)

- (BOOL)containsObjects:(NSArray *)objects;

/*! Returns the object located at the specified index without throwing exception. */
- (id)valueAtIndex:(NSUInteger)index;

@end


@interface NSDate (LSCoreDate)

- (NSDateComponents *)components:(NSUInteger)unitFlags;
+ (NSDateFormatter *)dateFormatter:(NSString *)format;

@end


@interface NSMutableDictionary (LSCoreDictionary)

- (id)keyAtIndex:(NSUInteger)index;
- (id)objectSortedAtIndex:(NSUInteger)index;
- (NSArray *)sortedKeys;

@end

@interface NSURLRequest (LSCoreURLRequest)

/*! Loads the data for a URL request and executes a handler block on the main thread when the request completes. */
- (void)sendWithDataHandler:(void (^)(NSData *data))handler;

@end
