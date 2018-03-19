//
//  ClassA.h
//  LogInTestLaunchpad
//
//  Created by Mircea Dragota on 02/03/2018.
//  Copyright © 2018 Mircea Dragota. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ClassA;
@protocol ClassADelegate <NSObject>
- (void) classDelegateMethod: (ClassA *) sender;
@end

@interface ClassA : NSObject {
    
}
@property (nonatomic, weak) id <ClassADelegate> delegate;


@end
