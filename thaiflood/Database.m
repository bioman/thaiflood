//
//  Database.m
//  thaiflood
//

#import "Database.h"

static Database *_instance;
@implementation Database
@synthesize numbers;

#pragma mark -
#pragma mark Singleton Methods

+ (Database*)sharedDatabase
{
	@synchronized(self) {
		
        if (_instance == nil) {
			
            _instance = [[self alloc] init];
            
            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"UsefulNumber" ofType:@"plist"];
            NSDictionary *plist = [[NSDictionary alloc] initWithContentsOfFile:filePath];
            _instance.numbers = plist;
            [plist release];
        }
    }
    return _instance;
}

+ (id)allocWithZone:(NSZone *)zone

{	
    @synchronized(self) {
		
        if (_instance == nil) {
			
            _instance = [super allocWithZone:zone];			
            return _instance;  // assignment and return on first allocation
        }
    }
	
    return nil; //on subsequent allocation attempts return nil	
}


- (id)copyWithZone:(NSZone *)zone
{
    return self;	
}

- (id)retain
{	
    return self;	
}

- (unsigned)retainCount
{
    return UINT_MAX;  //denotes an object that cannot be released
}

- (oneway void)release
{
    //do nothing
}

- (id)autorelease
{
    return self;	
}

#pragma mark -
#pragma mark Useful Numnber Methods

- (NSMutableArray*) emergencyNumbers
{
    NSMutableArray *_numbers = [[NSMutableArray alloc] init];
    NSArray *_plistArray = [_instance.numbers objectForKey:@"Emergency"];
    for (NSDictionary *_rawNumber in _plistArray) {
        NSString *_name = [_rawNumber objectForKey:@"name"];
        NSString *_number = [_rawNumber objectForKey:@"number"];
        Number *number = [[Number alloc]initWithName:_name number:_number];
        [_numbers addObject:number];
        [number release];
    }
    return [_numbers autorelease];
}

- (NSMutableArray*) hospitalNumbers
{
    NSMutableArray *_numbers = [[NSMutableArray alloc] init];
    NSArray *_plistArray = [_instance.numbers objectForKey:@"Hospital"];
    for (NSDictionary *_rawNumber in _plistArray) {
        NSString *_name = [_rawNumber objectForKey:@"name"];
        NSString *_number = [_rawNumber objectForKey:@"number"];
        Number *number = [[Number alloc]initWithName:_name number:_number];
        [_numbers addObject:number];
        [number release];
    }
    return [_numbers autorelease];
}

- (NSMutableArray*) askTheWayNumbers
{
    NSMutableArray *_numbers = [[NSMutableArray alloc] init];
    NSArray *_plistArray = [_instance.numbers objectForKey:@"Way"];
    for (NSDictionary *_rawNumber in _plistArray) {
        NSString *_name = [_rawNumber objectForKey:@"name"];
        NSString *_number = [_rawNumber objectForKey:@"number"];
        Number *number = [[Number alloc]initWithName:_name number:_number];
        [_numbers addObject:number];
        [number release];
    }
    return [_numbers autorelease];
}

- (NSMutableArray*) policeNumbers
{
    NSMutableArray *_numbers = [[NSMutableArray alloc] init];
    NSArray *_plistArray = [_instance.numbers objectForKey:@"Police"];
    for (NSDictionary *_rawNumber in _plistArray) {
        NSString *_name = [_rawNumber objectForKey:@"name"];
        NSString *_number = [_rawNumber objectForKey:@"number"];
        Number *number = [[Number alloc]initWithName:_name number:_number];
        [_numbers addObject:number];
        [number release];
    }
    return [_numbers autorelease];
}

- (NSMutableArray*) otherNumbers
{
    NSMutableArray *_numbers = [[NSMutableArray alloc] init];
    NSArray *_plistArray = [_instance.numbers objectForKey:@"Other"];
    for (NSDictionary *_rawNumber in _plistArray) {
        NSString *_name = [_rawNumber objectForKey:@"name"];
        NSString *_number = [_rawNumber objectForKey:@"number"];
        Number *number = [[Number alloc]initWithName:_name number:_number];
        [_numbers addObject:number];
        [number release];
    }
    return [_numbers autorelease];
}

@end
