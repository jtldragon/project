//
//  TimetableConnect.m
//  project
//
//  Created by Yeshu Liu on 30/09/11.
//  Copyright 2011 RMIT. All rights reserved.
//

#import "TimetableConnect.h"
#import <YAJLiOS/YAJL.h>


@implementation TimetableConnect


@synthesize timeParams,urlString,timetablesArray,connIsFin,lectures;

@synthesize connection=_connection;

#pragma mark - nsobject
-(id)initWithParams:(NSArray *)params {
    self=[super init];
    if(self!=nil)
    {
        [self setTimeParams:params];
        [self setUrlString:@""];
        [self setConnIsFin:NO];
        lectures=[[NSMutableArray alloc]init];
        timetablesArray =[[NSMutableArray alloc]init];
        
    }
    if ([params count]==2) {
        [self setUrlString:[NSString stringWithFormat:@"%@/%@/date/%@",SAMPLE_URL,[timeParams objectAtIndex:0],[timeParams objectAtIndex:1]]];
    }
    else{
        [self setUrlString:[NSString stringWithFormat:@"%@/%@/date/%@/additionalDays/7",SAMPLE_URL,[timeParams objectAtIndex:0],[timeParams objectAtIndex:1]]];
    }
    NSLog(@"%@",urlString);
    return self;
    
}

-(void)dealloc {
    [super dealloc];
    [timeParams release];
    [urlString release];
    [timetablesArray release];
    [lectures release];
    
}
-(NSString *)description{
    return urlString;
    
}

#pragma mark - urlconnection
-(void)makeRequest {
    NSURL *url=[NSURL URLWithString:urlString];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL:url];
    [request setValue:@"application/json" forHTTPHeaderField:@"accept"];
    _connection=[[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    
}

- (BOOL)isReceiving
{
    return (_connection != nil);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response  {
    NSHTTPURLResponse *httpResponse=(NSHTTPURLResponse *)response;
    int responseStatusCode=[httpResponse statusCode];
    NSLog(@"接收完响应:%@",response);
    NSLog(@"接收完响应:%i",responseStatusCode);
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data  {
    NSLog(@"接收完数据:");
    //NSString *json_string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
   //NSLog(@"%@",json_string);
   //use yajl to parse JSON object
    NSDictionary *jsonDictionary = [data yajl_JSON];
    NSArray *timesArray=[jsonDictionary valueForKey:@"timetables"];
    
   // for (NSDictionary *dict in timetablesArray) {
        //NSLog(@"%@\n ",dict);
   // }
    [timetablesArray addObjectsFromArray:timesArray];
   // NSLog(@"count==%i",[timesArray count]);
   // NSLog(@"%@",[timesArray objectAtIndex:1]);
    
    
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error  {
    NSLog(@"数据接收错误:%@",error);
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection  {
    NSLog(@"连接完成:%@",connection);
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    connIsFin=YES;
    if ([timeParams count]==3) {
        //lectures=[self getLectures];
    }
    
}


#pragma mark - custom methods
-(NSMutableArray *)getLectures {
    NSLog(@"1");
    NSLog(@"count==%i",[timetablesArray count]);
    //NSLog(@"%@",[timesArray objectAtIndex:1]);
    
    NSMutableArray *lecturesArray=[[NSMutableArray alloc]init];
    for (NSDictionary *dict in timetablesArray) {
        NSLog(@"%@\n ",dict);
        if ([[dict valueForKey:@"activityType"] isEqualToString:@"Lecture"]) {
            NSString *title=[dict valueForKey:@"title"];
            //check whether there is a duplicate
            if ([lecturesArray count]==0) {
                [lecturesArray addObject:title];
            }
            else {
                BOOL addflag=YES;
                //check whether there is a duplicate
                for (int i=0; i<[lecturesArray count];i++ ) {
                    NSString *a=[lecturesArray objectAtIndex:i];
                    if ([a isEqualToString:title]) {
                        addflag=NO;
                    }
                }
                if (addflag) {
                    [lecturesArray addObject:title];
                }
                
            }
            
        }
    }
    /*
    //check whether there is a duplicate
    for (int i=0; i<[lecturesArray count];i++ ) {
        NSString *a=[lecturesArray objectAtIndex:i];
        for (int j=i+1; j<[lecturesArray count]; j++) {
            if ([[lecturesArray objectAtIndex:j]isEqualToString:a]) {
                [lecturesArray removeObjectAtIndex:j];
            }
        }
    }
     */
    for (NSString *s in lecturesArray) {
        NSLog(@"%@\n",s);
    }
    return lecturesArray;
}
@end
