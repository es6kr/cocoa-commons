//
//  LSInvocation.h
//
//

#import "LSFoundation.h"

@interface LSInvocation : NSObject

@property(readonly,strong) id object;
@property(readonly) IMP imp;
@property(readonly,strong) NSString *types;

@end
