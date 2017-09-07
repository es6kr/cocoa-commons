//
//  LSHttpRequest.m
//
//

#import "LSFoundation.h"
#import "LSHttpRequest.h"


@implementation LSHttpRequest

- (NSData *)multipartBody {
    NSStringEncoding encoding = NSUTF8StringEncoding;
	NSMutableData* body = [NSMutableData data];
    NSString* beginLine = [NSString stringWithFormat:@"--%@\r\n", _multipartBoundary];
	NSString *endLine = @"\r\n";
	
    for (LSHttpParameter *parameter in _parameters) {
        id value = parameter.value;
        // Really, this can only be an NSString. We're cheating here.
        if ([value isKindOfClass:[NSData class]]) {
            NSString *beginLine = [NSString stringWithFormat:@"--%@\r\n", _multipartBoundary];
            NSString *endLine = @"\r\n";
            
            [body appendData:[beginLine dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:
                               @"Content-Disposition: form-data; name=\"%@\"; filename=\"image.jpg\"\r\n",
                               parameter.name]
                              dataUsingEncoding:encoding]];
            [body appendData:[[NSString
                               stringWithFormat:@"Content-Length: %lu\r\n", (unsigned long)[value length]]
                              dataUsingEncoding:encoding]];
            [body appendData:[@"Content-Type: image/jpeg\r\n\r\n"
                              dataUsingEncoding:encoding]];
            [body appendData:value];
            [body appendData:[endLine dataUsingEncoding:NSUTF8StringEncoding]];

        }else{
            [body appendData:[beginLine dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString
                               stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", parameter.name]
                              dataUsingEncoding:encoding]];
            [body appendData:[value dataUsingEncoding:encoding]];
            [body appendData:[endLine dataUsingEncoding:NSUTF8StringEncoding]];
        }
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", _multipartBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    return body;
}

- (NSMutableArray *)parameters {
    return _parameters ?: (_parameters = [NSMutableArray array]);
}

+ (instancetype)requestWithURLString:(NSString *)url {
    LSHttpRequest *request = [self new];
    request.url = url;
    return request;
}

+ (instancetype)requestWithURLString:(NSString *)url parameters:(NSDictionary *)parameters {
    LSHttpRequest *request = [self new];
    request.url = url;
    for(NSString *key in parameters){
        [request.parameters addObject:[LSHttpParameter parameterWithName:key value:parameters[key]]];
    }
    return request;
}

- (NSURLRequest *)URLRequest {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:_url]];
    switch (_method) {
        case LSHttpDeleteMethod:
            [request setHTTPMethod:@"DELETE"];
        case LSHttpGetMethod:{
            NSMutableString *url = [NSMutableString stringWithString:_url];
            if(_parameters){
                [url appendString:@"?"];
                [url appendString:[_parameters componentsJoinedByString:@"&"]];
            }
            [request setURL:[NSURL URLWithString:url]];
            break;
        }
        case LSHttpPostMethod:
        case LSHttpPutMethod: {
            BOOL isMultipart = _multipartBoundary != nil;
//            [request setURL:[NSURL URLWithString:_url]];
            [request setHTTPMethod:_method == LSHttpPostMethod? @"POST":@"PUT"];
            
            NSString *contentType;
            NSData *body = nil;
            
            if( (contentType = _contentType) ){
                NSLog(@"request.contentType: %@", _contentType);
            }else if( isMultipart ){
                contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", _multipartBoundary];
                body = [self multipartBody];
                
            }else{
                contentType = @"application/x-www-form-urlencoded";
                body = [[_parameters componentsJoinedByString:@"&"] dataUsingEncoding:NSUTF8StringEncoding];
            }
            
            [request setValue:[body stringValueForKey:@"length"] forHTTPHeaderField:@"Content-Length"];
            [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
            [request setHTTPBody:body];
        }
    }
    
    return request;
}

@end


@implementation LSHttpParameter

- (NSString *)description {
    NSMutableString *str = [NSMutableString stringWithString:_name];
    [str appendString:@"="];
    if( [_value isKindOfClass:[NSString class]] ){
        [str appendString:[[_value trim] escape]];
    }else{
        [str appendString:[_value description]];
    }
    return str;
}

+ (instancetype)parameterWithName:(NSString *)name value:(id)value {
    LSHttpParameter *parameter = [self new];
    parameter.name = name;
    parameter.value = value;
    return parameter;
}

@end
