//
//  opooc.m
//  RuntimeCreateClass
//
//  Created by doushuyao on 2018/5/12.
//  Copyright © 2018年 opooc. All rights reserved.
//

#import "opooc.h"
//用这个包，可是调用msgSend(class,SEL)
//里面已经导入了runtime.h
#import <objc/message.h>

@implementation opooc
+(void)creat{
    //创建自定义一个继承自NSObject的类
    Class newC = objc_allocateClassPair([NSObject class], "NewClass", 0);
    //添加实例变量
    BOOL win = class_addIvar(newC, "newIvar", sizeof(NSString *), 0,"@");
    NSLog(@"%@",win?@"ok":@"no");
    
    //添加方法 ，SEL的名称和IMP的名称要相同
    //"v@:"为Apple的Type Encoding
    class_addMethod(newC, @selector(test:), (IMP)test, "v@:");
    //注册类对 ，添加实例变量，协议，方法要在这个方法之前
    objc_registerClassPair(newC);

    //生成对象，同等于[[newC alloc]init]
    id newInstance = objc_msgSend(newC,@selector(alloc));
    objc_msgSend(newInstance,@selector(init));
    
    //通过KVC给实例变量赋值
    [newInstance setValue:@"nnnnnnnnn" forKey:@"newIvar"];
    //调用test方法
    
    [newInstance test:@"我是帅气潇洒的豆子"];
    
}
//self和_cmd是必须的，在之后可以随意添加其他参数
static void test (id self ,SEL _cmd,NSString* str){
    // 获取整个成员变量列表
    //   Ivar * class_copyIvarList ( Class cls, unsigned intint * outCount );
    // 获取类中指定名称实例成员变量的信息
    //   Ivar class_getInstanceVariable ( Class cls, const charchar *name );
    // 获取类成员变量的信息
    //   Ivar class_getClassVariable ( Class cls, const charchar *name );
    
    
    
    
    
    //获取添加上的实例变量的方法，需要通过两步，第一步先通过class_getInstanceVariable拿到ivar
                                    //  第二步通过object_getIvar拿到val
    
    Ivar iva = class_getInstanceVariable([self class], "newIvar");
    
    id ivaVal = object_getIvar(self, iva);
    
    NSLog(@"%@",ivaVal);
    NSLog(@"%@",str);
    
}
//这个方法实际上没有被调用,但是必须实现否则不会调用下面的方法
-(void)test:(NSString*)str{
    
}
@end
