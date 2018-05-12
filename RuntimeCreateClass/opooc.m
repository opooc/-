//
//  opooc.m
//  RuntimeCreateClass
//
//  Created by doushuyao on 2018/5/12.
//  Copyright © 2018年 秦传龙. All rights reserved.
//

#import "opooc.h"
#import <objc/message.h>

@implementation opooc
+(void)creat{
    Class newC = objc_allocateClassPair([NSObject class], "NewClass", 0);
    BOOL win = class_addIvar(newC, "newIvar", sizeof(NSString *), 0,"@");
    NSLog(@"%@",win?@"ok":@"no");
    
    class_addMethod(newC, @selector(test:), (IMP)test, "v@:");
    objc_registerClassPair(newC);

    id newInstance = objc_msgSend(newC,@selector(alloc));
    objc_msgSend(newInstance,@selector(init));
    [newInstance setValue:@"nnnnnnnnn" forKey:@"newIvar"];
    [newInstance test:@"我是帅哥"];
    
}
static void test (id self ,SEL _cmd,NSString* str){
    Ivar iva = class_getInstanceVariable([self class], "newIvar");
    
    id ivaVal = object_getIvar(self, iva);
    
    NSLog(@"%@",ivaVal);
    NSLog(@"%@",str);
    
}

-(void)test:(NSString*)str{
    
}
@end
