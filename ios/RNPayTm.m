#import "RNPayTm.h"
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@implementation RNPayTm


//PGTransactionViewController* txnController;

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(startPayment: (NSDictionary *)details)
{
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
      [storage deleteCookie:cookie];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];

    PGMerchantConfiguration *mc = [PGMerchantConfiguration defaultConfiguration];
    NSMutableDictionary *orderDict = [NSMutableDictionary new];
    NSString* mode = details[@"mode"];

    orderDict[@"MID"] = details[@"MID"];
    orderDict[@"CHANNEL_ID"] = details[@"CHANNEL_ID"];
    orderDict[@"INDUSTRY_TYPE_ID"] = details[@"INDUSTRY_TYPE_ID"];
    orderDict[@"WEBSITE"] = details[@"WEBSITE"];
    orderDict[@"TXN_AMOUNT"] = details[@"TXN_AMOUNT"];
    orderDict[@"ORDER_ID"] = details[@"ORDER_ID"];
    orderDict[@"EMAIL"] = details[@"EMAIL"];
    orderDict[@"MOBILE_NO"] = details[@"MOBILE_NO"];
    orderDict[@"CUST_ID"] = details[@"CUST_ID"];
    orderDict[@"CHECKSUMHASH"] = details[@"CHECKSUMHASH"];
    orderDict[@"CALLBACK_URL"] = details[@"CALLBACK_URL"];

    PGOrder *order = [PGOrder orderWithParams:orderDict];

    PGTransactionViewController *txnController = [[PGTransactionViewController alloc] initTransactionForOrder:order];
    txnController.loggingEnabled = YES;
    
    if ([mode isEqualToString:@"Staging"]) {
        txnController.serverType = eServerTypeStaging;
    } else if ([mode isEqualToString:@"Production"]) {
        txnController.serverType = eServerTypeProduction;
    } else
        return;
    
    txnController.merchant = [PGMerchantConfiguration defaultConfiguration];
    txnController.delegate = self;
    [self.navigationController pushViewController:txnController animated:YES];
    
    //PGTransactionViewController and set the serverType to eServerTypeProduction
//    txnController = [[PGTransactionViewController alloc] initTransactionForOrder:order];
//    txnController.serverType = eServerTypeStaging;
//    txnController.merchant = mc;
//    txnController.delegate = self;
//    txnController.title = @"Paytm payment";
//
//    UIViewController *rootVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
//
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [rootVC presentViewController:txnController animated:YES completion:nil];
//      });

}

- (NSArray<NSString *> *)supportedEvents
{
    return @[@"PayTMResponse"];
}


//this function triggers when transaction gets finished
-(void)didFinishedResponse:(PGTransactionViewController *)controller response:(NSString *)responseString {
    [self sendEventWithName:@"PayTMResponse" body:@{@"status":@"Success", @"response":responseString}];
    [controller.navigationController popViewControllerAnimated:YES];
}
//this function triggers when transaction gets cancelled
-(void)didCancelTrasaction:(PGTransactionViewController *)controller {
    [_statusTimer invalidate];
    NSString *msg = [NSString stringWithFormat:@"UnSuccessful"];

    [[[UIAlertView alloc] initWithTitle:@"Transaction Cancel" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    [self sendEventWithName:@"PayTMResponse" body:@{@"status":@"Cancel", @"response":msg}];
    [controller.navigationController popViewControllerAnimated:YES];
}
//Called when a required parameter is missing.
-(void)errorMisssingParameter:(PGTransactionViewController *)controller error:(NSError *) error {
    [controller.navigationController popViewControllerAnimated:YES];
}




//-(void)didFinishedResponse:(PGTransactionViewController *)controller response:(NSDictionary *)response {
//
//    [self sendEventWithName:@"PayTMResponse" body:@{@"status":@"Response", @"response":response}];
//    [txnController dismissViewControllerAnimated:YES completion:nil];
//}
//
////Called when a transaction has completed. response dictionary will be having details about Transaction.
//- (void)didSucceedTransaction:(PGTransactionViewController *)controller
//     response:(NSDictionary *)response{
//  NSString *str = [NSString stringWithFormat:@"%@", response];
//
//  [self sendEventWithName:@"PayTMResponse" body:@{@"status":@"Success", @"response":str}];
//  [txnController dismissViewControllerAnimated:YES completion:nil];
//}
//
////Called when a transaction is failed with any reason. response dictionary will be having details about failed Transaction.
//- (void)didFailTransaction:(PGTransactionViewController *)controller
//     error:(NSError *)error
//  response:(NSDictionary *)response{
//  NSString *str = [NSString stringWithFormat:@"%@", response];
//
//    [self sendEventWithName:@"PayTMResponse" body:@{@"status":@"Failed", @"response":str}];
//  [txnController dismissViewControllerAnimated:YES completion:nil];
//
//}
//
////Called when a transaction is Canceled by User. response dictionary will be having details about Canceled Transaction.
//- (void)didCancelTransaction:(PGTransactionViewController *)controller
//       error:(NSError *)error
//    response:(NSDictionary *)response{
//  NSString *str = [NSString stringWithFormat:@"%@", response];
//
//        [self sendEventWithName:@"PayTMResponse" body:@{@"status":@"Cancelled", @"response":str}];
//  [txnController dismissViewControllerAnimated:YES completion:nil];
//}
//
//- (void)didFinishCASTransaction:(PGTransactionViewController *)controller
//       error:(NSError *)error
//    response:(NSDictionary *)response{
//  NSString *str = [NSString stringWithFormat:@"%@", response];
//     [self sendEventWithName:@"PayTMResponse" body:@{@"status":@"Checksum Finished", @"response":str}];
//}

@end
