//
//  LSHttpRequest.h
//
//


typedef enum {
    LSHttpGetMethod,
    LSHttpPostMethod,
    LSHttpPutMethod,
    LSHttpDeleteMethod
} LSHttpMethod;


@interface LSHttpRequest : NSObject 

@property(nonatomic) LSHttpMethod method;

@property(strong,nonatomic) NSString *contentType;

@property(strong,nonatomic) NSString *multipartBoundary;

@property(strong,nonatomic) NSMutableArray *parameters;

@property(strong,nonatomic) NSString *url;

+ (instancetype)requestWithURLString:(NSString *)url;
+ (instancetype)requestWithURLString:(NSString *)url parameters:(NSDictionary *)parameters;
- (NSURLRequest *)URLRequest;

@end


@interface LSHttpParameter : NSObject

@property(strong,nonatomic) NSString *name;
@property(strong,nonatomic) id value;

+ (instancetype)parameterWithName:(NSString *)name value:(id)value;

@end
