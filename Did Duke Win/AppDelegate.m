//
//  AppDelegate.m
//  Did Duke Win
//
//  Created by Dylan Peters on 7/6/16.
//  Copyright © 2016 Dylan Peters. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property NSString *websiteAsString;
@property NSString *winLossInfo;
@property NSString *scoreInfo;
@property NSURL *scoreURL;

@end

@implementation AppDelegate

bool hasWinLossInfo;
bool hasScoreInfo;
bool hasScoreURL;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"11111");
    @try {
        [self setWebsiteAsString];
        [self setWinLossInfo];
        [self setScoreInfo];
        [self setScoreURL];
    } @catch (NSException *exception) {
        hasWinLossInfo = false;
        hasScoreInfo = false;
        hasScoreURL = false;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to Connect to Internet" message:@"Could not reach website to update score data. Please check your internet connection." delegate:NULL cancelButtonTitle:@"OK" otherButtonTitles:NULL, nil];
        [alert show];
    } @finally {
        
    }
}

- (NSString *) getWebsiteSourceAsString {
    NSURL *url = [NSURL URLWithString:@"https://www.diddukewin.com/"];
    NSString *string = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:NULL];
    if (string == NULL){
        @throw [NSException exceptionWithName:@"could not connect to internet exception" reason:NULL userInfo:NULL];
    }
    return string;
}

- (void) setWebsiteAsString {
    self.websiteAsString = [self getWebsiteSourceAsString];
}

- (void) setWinLossInfo {
    if (self.websiteAsString == NULL || self.websiteAsString == nil || [self.websiteAsString isEqualToString:@""]) {
        hasWinLossInfo = false;
        return;
    }
    NSString *subString = [self.websiteAsString substringWithRange:NSMakeRange([self.websiteAsString rangeOfString:@"</p>"].location-3, 3)];
    if ([[subString lowercaseString] isEqualToString:@"yes"]){
        hasWinLossInfo = true;
        self.winLossInfo = @"YES";
    } else if ([[[subString substringFromIndex:1] lowercaseString] isEqualToString:@"no"]){
        hasWinLossInfo = true;
        self.winLossInfo = @"NO";
    } else {
        hasWinLossInfo = false;
        return;
    }
}

- (bool) hasWinLossInfo {
    return hasWinLossInfo;
}

- (void) setHasWinLossInfo:(bool)newHasWinLossInfo{
    hasWinLossInfo = newHasWinLossInfo;
}

- (NSString *) getWinLossInfo {
    if ([self hasWinLossInfo]){
        return self.winLossInfo;
    }
    return NULL;
}

- (void) setScoreInfo {
    if (self.websiteAsString == NULL || self.websiteAsString == nil || [self.websiteAsString isEqualToString:@""]) {
        hasScoreInfo = false;
        return;
    }
    NSRange range = [self.websiteAsString rangeOfString:@"</a>"];
    NSUInteger index = range.location;
    while (index > 0 && [self.websiteAsString characterAtIndex:index] != (NSUInteger)'>'){
        index--;
    }
    if (index != 0){
        index++;
    }
    NSString *substring = [self.websiteAsString substringWithRange:NSMakeRange(index, range.location-index)];
    if (substring == NULL || self.websiteAsString == nil || [substring isEqualToString:@""]){
        hasScoreInfo = false;
        return;
    } else {
        hasScoreInfo = true;
        self.scoreInfo = substring;
    }
}

- (bool) hasScoreInfo {
    return hasScoreInfo;
}

- (void) setHasScoreInfo:(bool)newHasScoreInfo{
    hasScoreInfo = newHasScoreInfo;
}

- (NSString *) getScoreInfo {
    if ([self hasScoreInfo]) {
        return self.scoreInfo;
    }
    return NULL;
}

- (void) setScoreURL {
    if (self.websiteAsString == NULL || self.websiteAsString == nil || [self.websiteAsString isEqualToString:@""]) {
        hasScoreURL = false;
        return;
    }
    NSRange startingRange = [self.websiteAsString rangeOfString:@"<a href='"];
    NSUInteger index = startingRange.location+startingRange.length;
    while (index < self.websiteAsString.length && [self.websiteAsString characterAtIndex:index] != (NSUInteger)39){
        index++;
    }
    NSString *substring = [self.websiteAsString substringWithRange:NSMakeRange(startingRange.location+startingRange.length,index-startingRange.location-startingRange.length)];
    NSURL *localScoreURL = [NSURL URLWithString:substring];
    if (localScoreURL == NULL || localScoreURL == nil){
        hasScoreURL = false;
        return;
    } else {
        hasScoreURL = true;
        self.scoreURL = localScoreURL;
    }
}

- (bool) hasScoreURL {
    return hasScoreURL;
}

- (void) setHasScoreURL:(bool)newHasScoreURL {
    hasScoreURL = newHasScoreURL;
}

- (NSURL *) getScoreURL {
    if ([self hasScoreURL]){
        return self.scoreURL;
    }
    return NULL;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "Dylan-Peters.Did_Duke_Win" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Did_Duke_Win" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Did_Duke_Win.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
