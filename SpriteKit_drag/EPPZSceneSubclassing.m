//
//  EPPZSceneSubclassing.m
//  SpriteKitDrag
//
//  Created by Borbás Geri on 2/23/14.
//  Copyright (c) 2014 eppz! development, LLC.
//
//  follow http://www.twitter.com/_eppz
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//


#import "EPPZSceneSubclassing.h"


@interface EPPZDraggableShapeNode_1 : SKShapeNode
@property (nonatomic) CGPoint touchOffset;
@end


@implementation EPPZDraggableShapeNode_1
@end


@interface EPPZSceneSubclassing ()
@property (nonatomic, weak) EPPZDraggableShapeNode_1 *draggedNode;
@end


@implementation EPPZSceneSubclassing


-(void)didMoveToView:(SKView*) view
{
    self.backgroundColor = [UIColor tealColor];
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.view.bounds];
    
    CGFloat radius = 30.0;
    CGFloat diameter = radius * 2.0;
    CGPathRef centeredCircle = CGPathCreateWithEllipseInRect((CGRect){-radius, -radius, diameter, diameter}, NULL);
    repeat(20, ^{
        
        SKShapeNode *node = [EPPZDraggableShapeNode_1 new];
        node.path = centeredCircle;
        node.fillColor = [UIColor canaryYellowColor];
        node.lineWidth = 0.0;
        node.position = randomPointInFrame(self.view.bounds);
        node.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:radius];
        
        [self addChild:node];
        
    });
}


#pragma mark - Drag considering offset

-(void)touchesBegan:(NSSet*) touches withEvent:(UIEvent*) event
{
    // Get node if any.
    CGPoint touchLocation = [[touches anyObject] locationInNode:self];
    EPPZDraggableShapeNode_1 *touchedNode = (EPPZDraggableShapeNode_1*)[self nodeAtPoint:touchLocation];
    if ([touchedNode isKindOfClass:[EPPZDraggableShapeNode_1 class]] == NO) return; // Checks
    
    // Track and save offset (with the new SKNode feature).
    self.draggedNode = touchedNode;
    self.draggedNode.touchOffset =
    subtractVectorPoints(touchLocation, self.draggedNode.position);
}

-(void)touchesMoved:(NSSet*) touches withEvent:(UIEvent*) event
{
    // Align with offset (if any)
    CGPoint touchLocation = [[touches anyObject] locationInNode:self];
    self.draggedNode.position =
    subtractVectorPoints(touchLocation, self.draggedNode.touchOffset);
}

-(void)touchesEnded:(NSSet*) touches withEvent:(UIEvent*) event
{
    self.draggedNode = nil;
}


#pragma mark - Physics proof

-(void)setDraggedNode:(EPPZDraggableShapeNode_1*) draggedNode
{
    // Previous.
    _draggedNode.physicsBody.affectedByGravity = YES;
    
        _draggedNode = draggedNode; // Set
    
    // New.
    draggedNode.physicsBody.affectedByGravity = NO;
}


@end
