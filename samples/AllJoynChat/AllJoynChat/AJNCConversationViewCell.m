////////////////////////////////////////////////////////////////////////////////
// Copyright 2012, Qualcomm Innovation Center, Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
////////////////////////////////////////////////////////////////////////////////

#import "AJNCConversationViewCell.h"

@interface AJNCBadgeView : UIView

@property (nonatomic, weak) AJNCConversationViewCell *cell;

- (id)initWithFrame:(CGRect)frame parentCell:(AJNCConversationViewCell*)cell;

@end

@implementation AJNCBadgeView

@synthesize cell = _cell;

- (id)initWithFrame:(CGRect)frame parentCell:(AJNCConversationViewCell*)cell
{
    self = [super initWithFrame:frame];
    if (self) {
        self.cell = cell;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor *currentSummaryColor = [UIColor blackColor];
    UIColor *currentDetailColor = [UIColor grayColor];
    UIColor *currentBadgeColor = self.cell.badgeColor ? self.cell.badgeColor : [UIColor colorWithRed:0.53 green:0.6 blue:0.738 alpha:1.0];
    
    if (self.cell.isHighlighted || self.cell.isSelected) {
        currentSummaryColor = [UIColor whiteColor];
        currentDetailColor = [UIColor whiteColor];
        currentBadgeColor = self.cell.badgeHighlightColor ? self.cell.badgeHighlightColor : [UIColor whiteColor];
    }
    
    CGSize badgeTextSize = [self.cell.badgeText sizeWithFont:[UIFont boldSystemFontOfSize:13]];
    CGRect badgeViewFrame = CGRectIntegral(CGRectMake(rect.size.width - badgeTextSize.width - 24, (rect.size.height - badgeTextSize.height - 4) / 2, badgeTextSize.width + 14, badgeTextSize.height + 4));
    CGContextSaveGState(context);
    CGContextSetFillColorWithColor(context, currentBadgeColor.CGColor);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddArc(path, NULL, badgeViewFrame.origin.x + badgeViewFrame.size.width - badgeViewFrame.size.height / 2.0, badgeViewFrame.origin.y + badgeViewFrame.size.height / 2.0, badgeViewFrame.size.height / 2.0, M_PI / 2.0, M_PI * 3.0 / 2.0, YES);
    CGPathAddArc(path, NULL, badgeViewFrame.origin.x + badgeViewFrame.size.height / 2.0, badgeViewFrame.origin.y + badgeViewFrame.size.height / 2.0, badgeViewFrame.size.height / 2.0, M_PI * 3.0 / 2.0, M_PI / 2.0, true);
    CGContextAddPath(context, path);
    CGContextDrawPath(context, kCGPathFill);
    CFRelease(path);
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    CGContextSetBlendMode(context, kCGBlendModeClear);
    [self.cell.badgeText drawInRect:CGRectInset(badgeViewFrame, 7, 2) withFont:[UIFont boldSystemFontOfSize:13.0]];
    CGContextRestoreGState(context);
    
    [currentSummaryColor set];
    [self.cell.summary drawAtPoint:CGPointMake(10.0, 10.0) forWidth:(rect.size.width - badgeViewFrame.size.width - 24.0) withFont:[UIFont boldSystemFontOfSize:18.0] lineBreakMode:UILineBreakModeTailTruncation];
    
    [currentDetailColor set];
    [self.cell.detail drawAtPoint:CGPointMake(10.0, 32.0) forWidth:(rect.size.width - badgeViewFrame.size.width - 24.0) withFont:[UIFont systemFontOfSize:14.0] lineBreakMode:UILineBreakModeTailTruncation];
}

@end


@interface AJNCConversationViewCell()

@property (nonatomic, strong) AJNCBadgeView *badgeView;

@end

@implementation AJNCConversationViewCell

@synthesize summary = _summary;
@synthesize detail = _detail;
@synthesize badgeText = _badgeText;
@synthesize badgeColor = _badgeColor;
@synthesize badgeHighlightColor = _badgeHighlightColor;
@synthesize badgeView = _badgeView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.badgeView = [[AJNCBadgeView alloc] initWithFrame:self.contentView.bounds parentCell:self];
        self.badgeView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.badgeView.contentMode = UIViewContentModeRedraw;
        self.badgeView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.badgeView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.badgeView = [[AJNCBadgeView alloc] initWithFrame:self.contentView.bounds parentCell:self];
        self.badgeView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.badgeView.contentMode = UIViewContentModeRedraw;
        self.badgeView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.badgeView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    //
    [self.badgeView setNeedsDisplay];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    
    // Configure the view for the highlighted state
    //
    [self.badgeView setNeedsDisplay];
}

@end
