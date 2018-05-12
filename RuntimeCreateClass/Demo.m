//
//  Demo.m
//  RuntimeCreateClass
//
//  Created by hezhijingwei on 2016/12/29.
//  Copyright © 2016年 秦传龙. All rights reserved.
//

#import "Demo.h"
#import <objc/message.h>
@implementation Demo

/*
 objc_allocateClassPair
 class_addIvar
 class_addMethod()
 objc_registerClassPair(xx);
 class_getInstance
 
 
 */

+ (void)createClass {
    
    // 1、 添加一个集成NSObject的类  类名是MyClass
    // 注意：调用的c语言的方法  所以不要使用@""表示字符串 应该使用""
    Class MyClass = objc_allocateClassPair([NSObject class], "MyClass", 0);
    
    // 2、增加实例变量
    // 参数一、类名
    // 参数二、属性名称
    // 参数三、开辟字节长度
    // 参数四、对其方式
    // 参数五、参数类型 “@” 官方解释 An object (whether statically typed or typed id) （对象 静态类型或者id类型） 具体类型可参照 https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
    // return: BOOL 是否添加成功
    BOOL isSuccess = class_addIvar(MyClass, "test", sizeof(NSString *), 0, "@");
    
    // 三目运算符
    isSuccess?NSLog(@"添加变量成功"):NSLog(@"添加变量失败");
    
    // 3、增加方法
    
    class_addMethod(MyClass, @selector(addMethodForMyClass:), (IMP)addMethodForMyClass, "V@:");

    //注册这个类到runtime系统中就可以使用他了
    objc_registerClassPair(MyClass);
    
//    id myObjc = [[MyClass alloc] init];
//    NSLog(@"%@",myObjc);
    
//    在OC中，我们对方法的调用都会被转换成内部的消息发送执行对objc_msgSend方法的调用，掌握好消息发送，可以让我们在编程中更方便灵活。
    
    // 上面的id myObjc = [[MyClass alloc] init]; 我们可以通过runtime 消息发送objc_msgSend去实现
    
    // 实现[MyClass alloc] 去开辟空间
    id myobjc = objc_msgSend(MyClass, @selector(alloc));
    
    //
    myobjc = objc_msgSend(myobjc, @selector(init));
    
    NSLog(@"%@",myobjc);
    
    
    NSString *str = @"我是test";
    
    // 通过KVC的方式给myObj对象的test属性赋值
    [myobjc setValue:str forKey:@"test"];
    
    
    // 如果不调用- (void)addMethodForMyClass:(NSString *)string 这个方法，就不会调用static void addMethodForMyClass(id self, SEL _cmd, NSString *test) 函数
    [myobjc addMethodForMyClass:@"参数"];
    
    
}

//self和_cmd是必须的，在之后可以随意添加其他参数
static void addMethodForMyClass(id self, SEL _cmd, NSString *test) {
    
    // 获取类中指定名称实例成员变量的信息
    Ivar ivar = class_getInstanceVariable([self class], "test");
    
// 获取整个成员变量列表
//   Ivar * class_copyIvarList ( Class cls, unsigned intint * outCount );
// 获取类中指定名称实例成员变量的信息
//   Ivar class_getInstanceVariable ( Class cls, const charchar *name );
// 获取类成员变量的信息
//   Ivar class_getClassVariable ( Class cls, const charchar *name );
    
    
    // 返回名为test的ivar变量的值
    id obj = object_getIvar(self, ivar);
    
    NSLog(@"%@",obj);
    NSLog(@"addMethodForMyClass:参数：%@",test);
    NSLog(@"ClassName：%@",NSStringFromClass([self class]));
    
}


//这个方法实际上没有被调用,但是必须实现否则不会调用下面的方法
- (void)addMethodForMyClass:(NSString *)string {
    
    
    
}


@end
