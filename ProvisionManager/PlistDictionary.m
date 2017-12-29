//
//  PlistDictionary.m
//  ProvisionManager
//
//  Created by Alexander Smyshlaev on 3/26/17.
//  Copyright © 2017 Alexander Smyshlaev. All rights reserved.
//

#import "PlistDictionary.h"

NSDictionary* dictionaryFromPlistString(NSString* string) {
    NSData* plistData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSPropertyListFormat format;
    NSDictionary* plist = [NSPropertyListSerialization propertyListWithData:plistData options:NSPropertyListImmutable format:&format error:&error];
    return plist;
}
