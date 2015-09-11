//
//  CorporatePaymentsLoginTests.m
//  AnyPresence SDK
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "CorporatePaymentsLogin.h"
#import "CorporatePayments.h"
#import "APDataManager.h"
#import "APObject+Remote.h"
#import "APObject+Local.h"
#import "MockHTTPURLProtocol.h"

static NSString *const APLocalCertificate   = @"MyCertificate";
static NSString *const APCertificateType    = @"cer";

@interface CorporatePaymentsLoginTests : XCTestCase

@end

@implementation CorporatePaymentsLoginTests

- (void)setUp {
    [super setUp];
    [NSURLProtocol registerClass:[MockHTTPURLProtocol class]];
    [APDataManager setDataManager:[[APDataManager alloc] initWithStore:kAPDataManagerStoreInMemory]];
    [CorporatePayments setBaseURL:[NSURL URLWithString:@"http://tests"]];
}

- (void)tearDown {
    [NSURLProtocol unregisterClass:[MockHTTPURLProtocol class]];
    [super tearDown];
}

#pragma mark - Data Source Tests

- (void)testDataSourceMatchesPayloadValue {
    
    NSString *actualDataSource = NSStringFromClass([CorporatePaymentsLogin dataSource]);
    NSString *expectedDataSource = @"CorporatePayments";
    
    XCTAssertTrue([actualDataSource isEqualToString:expectedDataSource], @"CorporatePaymentsLogin data source was not set properly.  Expected %@ but got %@", expectedDataSource, actualDataSource);
}

- (void)testSettingCertificateForDataSource {
    
    NSString *certificatePath = [[NSBundle mainBundle] pathForResource:APLocalCertificate ofType:APCertificateType];
    XCTAssertNotNil(certificatePath, @"CorporatePaymentsLogin certificate path is not valid.  Check that resource exists in SDKTestApp's bundle resources.");
    
    [[CorporatePaymentsLogin dataSource] setSSLCertificate:certificatePath];
    
    XCTAssertTrue([[CorporatePaymentsLogin dataSource] class] == [CorporatePayments class]);
    
    NSData *actualCertData = [CorporatePayments certificate];
    NSData *expectedCertData = [NSData dataWithContentsOfFile:certificatePath];
    
    XCTAssertTrue([actualCertData isEqual:expectedCertData], @"CorporatePaymentsLogin's certificate data was not set properly.");
}

@end
