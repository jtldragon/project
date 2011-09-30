//
//  TimetableConnect.m
//  project
//
//  Created by Yeshu Liu on 30/09/11.
//  Copyright 2011 RMIT. All rights reserved.
//

#import "TimetableConnect.h"

@implementation TimetableConnect


@synthesize timeParams,urlString,jsonData;

@synthesize connection=_connection;

-(id)initWithParams:(NSArray *)params {
    self=[super init];
    if(self!=nil)
    {
        [self setTimeParams:params];
        jsonData=[[NSMutableData alloc]init];
    }
    if ([params count]==2) {
        [self setUrlString:[NSString stringWithFormat:@"%@/%@/date%@",SAMPLE_URL,[timeParams objectAtIndex:0],[timeParams objectAtIndex:1]]];
    }
    else{
        [self setUrlString:[NSString stringWithFormat:@"%@/%@/date%@/additionalDays/7",SAMPLE_URL,[timeParams objectAtIndex:0],[timeParams objectAtIndex:1]]];
    }
    return self;
    
}

-(void)dealloc {
    [super dealloc];
    [timeParams release];
    [urlString release];
    
}
-(NSString *)description{
    return urlString;
    
}
-(void)makeRequest {
    NSURL *url=[NSURL URLWithString:urlString];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"accept"];
    _connection=[[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
}

- (BOOL)isReceiving
{
    return (self.connection != nil);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response  {
    NSHTTPURLResponse *httpResponse=(NSHTTPURLResponse *)response;
    int responseStatusCode=[httpResponse statusCode];
    NSLog(@"接收完响应:%@",response);
    NSLog(@"接收完响应:%1",responseStatusCode);
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data  {
    NSLog(@"接收完数据:");
    [jsonData appendData:data];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error  {
    NSLog(@"数据接收错误:%@",error);
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection  {
    NSLog(@"连接完成:%@",connection);
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


@end
