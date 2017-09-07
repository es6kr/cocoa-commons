//
//  LSFoundation
//
//

#import <sys/utsname.h>
#import "LSFoundation.h"


@implementation LSFoundation

+ (NSString*)machineName {
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

@end


@implementation NSArray (LSCoreArray)

- (BOOL)containsObjects:(NSArray *)objects {
    for(id object in objects){
        if(![self containsObject:object]) return NO;
    }
    return YES;
}

- (id)valueAtIndex:(NSUInteger)index {
    NSUInteger count = self.count;
    if( count < index + 1 || index == UINT_MAX ){
        return nil;
    }
    return self[index];
}

@end


@implementation NSDate (LSCoreDate)

- (NSDateComponents *)components:(NSUInteger)unitFlags {
    return [[NSCalendar currentCalendar] components:unitFlags fromDate:self];
}

+ (NSDateFormatter *)dateFormatter:(NSString *)format {
    NSDateFormatter *date = [NSDateFormatter new];
    [date setDateFormat:format];
    return date;
}

@end


@implementation NSDictionary (LSCoreDictionary)

// Determine if we can handle the unknown selector sel
- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    NSMethodSignature *sig = [super methodSignatureForSelector:sel];
    return sig ?: [super methodSignatureForSelector:@selector(valueForKey:)];
}

// Call valueForKey: and setValue:forKey:
- (void)forwardInvocation:(NSInvocation *)invocation {
    id value = [self valueForKey:NSStringFromSelector([invocation selector])];
    [invocation setReturnValue:&value];
}

@end


@implementation NSMutableDictionary (LSDictionary)

- (id)keyAtIndex:(NSUInteger)index {
    return [self.sortedKeys valueAtIndex:index];
}

- (id)objectSortedAtIndex:(NSUInteger)index {
    id key = [self.sortedKeys valueAtIndex:index];
    return self[key];
}

- (NSArray *)sortedKeys {
    return [self.allKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
}

// Determine if we can handle the unknown selector sel
- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    NSMethodSignature *sig = [super methodSignatureForSelector:sel];
    if(sig) return sig;
    
    NSString *stringSelector = NSStringFromSelector(sel);
    NSInteger parameterCount = [[stringSelector componentsSeparatedByString:@":"] count]-1;
    
    // Zero argument, forward to valueForKey:
    if (parameterCount == 0)
        return [super methodSignatureForSelector:@selector(valueForKey:)];
    
    // One argument starting with set, forward to setValue:forKey:
    if (parameterCount == 1 && [stringSelector hasPrefix:@"set"])
        return [super methodSignatureForSelector:@selector(setValue:forKey:)];
    
    return nil;
}

// Call valueForKey: and setValue:forKey:
- (void)forwardInvocation:(NSInvocation *)invocation {
    NSString *stringSelector = NSStringFromSelector([invocation selector]);
    NSInteger parameterCount = [[stringSelector componentsSeparatedByString:@":"] count] - 1;
    
    if (parameterCount == 0) { // Forwarding to valueForKey:
        [super forwardInvocation:invocation];
        return;
    }
    
    // Forwarding to setValue:forKey:
    id value;
    // The first parameter to an ObjC method is the third argument
    // ObjC methods are C functions taking instance and selector as their first two arguments
    [invocation getArgument:&value atIndex:2];
    
    // Get key name by converting setMyValue: to myValue
    id key = [NSString stringWithFormat:@"%@%@", [[stringSelector substringWithRange:NSMakeRange(3, 1)] lowercaseString], [stringSelector substringWithRange:NSMakeRange(4, [stringSelector length]-5)]];
    
    // Set
    self[key] = value;
}

@end

@implementation NSURLRequest (LSCoreURLRequest)

- (void)sendWithDataHandler:(void (^)(NSData *))handler {
    [NSURLConnection sendAsynchronousRequest:self queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *resp, NSData *data, NSError *error) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)resp;
        if( error ){
            NSLog(@"%lud#sendWithDataHandler error: %@", (unsigned long)self.hash, error);
            return;
        }
        
        if( response.statusCode >= 400 ){
            NSLog(@"%lud#sendWithDataHandler statusCode: %ld", (unsigned long)self.hash, (long)response.statusCode);
            return;
        }
        
        @try {
            if(handler) handler(data);
        }
        @catch (NSException *exception) {
            NSLog(@"%lud#sendWithDataHandler exception: %@", (unsigned long)self.hash, exception);
        }
    }];
}

@end
