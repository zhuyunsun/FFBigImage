//
//  FFBigImageView.m
//  FFTools
//
//  Created by 朱运 on 2020/12/11.
//

#import "FFBigImage.h"
static CGRect oldframe;
@implementation FFBigImage
+(void)bigImageView:(UIImageView *)imageView{
    
    if (imageView.image == nil) {
        NSLog(@"图片不能为空");
        return;
    }
    UIImage *image = imageView.image;
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height =  [UIScreen mainScreen].bounds.size.height;
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, width, height);
    backBtn.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.9];
    backBtn.alpha = 0.01;
    [backBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchDown];
    UIWindow *window;
    if (@available(iOS 13, *)) {
        window =  [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    } else {
        window =  [UIApplication sharedApplication].keyWindow;
    }

    [window.rootViewController.view addSubview:backBtn];
    [window makeKeyAndVisible];
    
    oldframe = [imageView convertRect:imageView.bounds toView:window];//坐标迁移
//    NSLog(@"oldframe");
    
    UIImageView *bigImageView = [[UIImageView alloc]initWithFrame:oldframe];
    bigImageView.image = image;
    bigImageView.tag = 20201211;
    [backBtn addSubview:bigImageView];
    
    [UIView animateWithDuration:0.3 animations:^{
        bigImageView.frame = CGRectMake(0,0,width, image.size.height * width / image.size.width);
        bigImageView.center = CGPointMake(width / 2, height / 2);
        backBtn.alpha = 1;
    } completion:^(BOOL finished) {

    }];

    bigImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [bigImageView addGestureRecognizer:tap];

    UIPinchGestureRecognizer *pin = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pin:)];
    [bigImageView addGestureRecognizer:pin];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [bigImageView addGestureRecognizer:pan];
    //
    CGFloat moreHeight = 0.0;
    if ([self isIPHONEX] == YES) {
        moreHeight = 34.0;
    }
    CGFloat arrowWidth = width *0.037;
    CGFloat arrowHeight = arrowWidth *1.2;
    CGFloat arrowX = width *0.05;
    UIButton *arrowView = [UIButton buttonWithType:UIButtonTypeCustom];
    arrowView.frame = CGRectMake(arrowX,height - arrowHeight - arrowX *1.5 - moreHeight,arrowWidth,arrowHeight);
    arrowView.backgroundColor = [UIColor clearColor];
    [backBtn addSubview:arrowView];
    
    UIColor *color = [UIColor whiteColor];
    CGFloat lineWidth = 1.7;
    //画v图像
    CAShapeLayer *solidShapeLayer = [CAShapeLayer layer];
    CGMutablePathRef solidShapePath =  CGPathCreateMutable();
    [solidShapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    [solidShapeLayer setStrokeColor:[color CGColor]];
    solidShapeLayer.lineWidth = lineWidth;

    CGPathMoveToPoint(solidShapePath, NULL,0,arrowHeight / 2);
    CGPathAddLineToPoint(solidShapePath, NULL,arrowWidth / 2,arrowHeight - 1);
    CGPathAddLineToPoint(solidShapePath, NULL,arrowWidth,arrowHeight / 2);
    
    [solidShapeLayer setPath:solidShapePath];
    CGPathRelease(solidShapePath);
    [arrowView.layer addSublayer:solidShapeLayer];
    //画向下直线
    CAShapeLayer *solidShapeLayer1 = [CAShapeLayer layer];
    CGMutablePathRef solidShapePath1 =  CGPathCreateMutable();
    [solidShapeLayer1 setFillColor:[[UIColor clearColor] CGColor]];
    [solidShapeLayer1 setStrokeColor:[color CGColor]];
    solidShapeLayer1.lineWidth = lineWidth;

    CGPathMoveToPoint(solidShapePath1, NULL,arrowWidth / 2,0);
    CGPathAddLineToPoint(solidShapePath1, NULL,arrowWidth / 2,arrowHeight - 1);
    
    [solidShapeLayer1 setPath:solidShapePath1];
    CGPathRelease(solidShapePath1);
    [arrowView.layer addSublayer:solidShapeLayer1];
    //画下横线
    
    CAShapeLayer *solidShapeLayer2 = [CAShapeLayer layer];
    CGMutablePathRef solidShapePath2 =  CGPathCreateMutable();
    [solidShapeLayer2 setFillColor:[[UIColor clearColor] CGColor]];
    [solidShapeLayer2 setStrokeColor:[color CGColor]];
    solidShapeLayer2.lineWidth = lineWidth;

    CGPathMoveToPoint(solidShapePath2, NULL,0,arrowHeight);
    CGPathAddLineToPoint(solidShapePath2, NULL,arrowWidth,arrowHeight);
    
    [solidShapeLayer2 setPath:solidShapePath2];
    CGPathRelease(solidShapePath2);
    [arrowView.layer addSublayer:solidShapeLayer2];
    
    //画图箭头太小,给个区域更大的btn进行点击
    CGFloat addWidth = arrowHeight + arrowX *0.6;
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(0, 0, addWidth, addWidth);
    addBtn.center = arrowView.center;
    addBtn.backgroundColor = [UIColor clearColor];
    [backBtn addSubview:addBtn];
    [addBtn addTarget:self action:@selector(addArrows:) forControlEvents:UIControlEventTouchDown];
    
}
+(void)btnAction:(UIButton *)btn{
    UIImageView *imageView = (UIImageView*)[btn viewWithTag:20201211];
    [UIView animateWithDuration:0.45 animations:^{
        imageView.frame = oldframe;
        btn.alpha = 0;
    } completion:^(BOOL finished) {
        [btn removeFromSuperview];
    }];
}
+(void)hideImage:(UITapGestureRecognizer*)tap{
    UIImageView *imageView = (UIImageView*)tap.view;
    UIImage *image = imageView.image;
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height =  [UIScreen mainScreen].bounds.size.height;
    CGFloat y = (height - image.size.height * width / image.size.width) / 2;
    
    [UIView animateWithDuration:0.2 animations:^{
        imageView.frame = CGRectMake(0,y,width, image.size.height * width / image.size.width);
    }];
}
+(void)pin:(UIPinchGestureRecognizer *)pin{
    UIImageView *imageView = (UIImageView*)pin.view;
    imageView.transform = CGAffineTransformScale(imageView.transform,pin.scale,pin.scale);
    pin.scale = 1;
}
+(void)pan:(UIPanGestureRecognizer *)pan{
    UIImageView *imageView = (UIImageView*)pan.view;
    CGPoint p = [pan translationInView:imageView];
    imageView.transform = CGAffineTransformTranslate(imageView.transform, p.x, p.y);
    [pan setTranslation:CGPointZero inView:imageView];
}
//点击保存
+(void)addArrows:(UIButton *)btn{
    UIView *v1 = btn.superview;
    UIImageView *i1 = (UIImageView *)[v1 viewWithTag:20201211];
    //保存到手机相册
    UIImageWriteToSavedPhotosAlbum(i1.image,nil,nil,nil);
    //
    CGFloat t1Width = v1.frame.size.width *0.3;
    CGFloat t1Height = v1.frame.size.height *0.07;
    CGFloat t1x = (v1.frame.size.width - t1Width) / 2;
    CGFloat t1y = (v1.frame.size.height - t1Height) / 2;
    UILabel *tipView = [[UILabel alloc]init];
    tipView.frame = CGRectMake(t1x,t1y,t1Width,t1Height);
    tipView.backgroundColor = [UIColor blackColor];
    tipView.text = @"已保存到相册!";
    tipView.textAlignment = NSTextAlignmentCenter;
    tipView.textColor = [UIColor whiteColor];
    tipView.layer.cornerRadius = 5;
    tipView.clipsToBounds = YES;
    tipView.font = [UIFont systemFontOfSize:15];
    tipView.adjustsFontSizeToFitWidth = YES;
    tipView.alpha = 1;
    
    UIView *newV1 = [[UIView alloc]init];
    newV1.frame = v1.bounds;
    [v1 addSubview:newV1];
    [newV1 addSubview:tipView];
    newV1.backgroundColor = [UIColor clearColor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3 animations:^{
            newV1.alpha = 0.01;
        } completion:^(BOOL finished) {
            [newV1 removeFromSuperview];
        }];
    });
}

+(BOOL)isIPHONEX{
    BOOL IS_iPhone = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone);//是iPhone不是iPad
    BOOL IS_iOS11 = ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.f);//全面屏iOS11以上才有
    BOOL iPhoneX = (IS_iOS11 && IS_iPhone && (MIN([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) >= 375 && MAX([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) >= 812));//后面min和max是判断横竖屏宽和高
    if (iPhoneX == YES) {
        NSLog(@"iPhoneX全面屏系列");
        return YES;
    }
    NSLog(@"非iPhoneX全面屏系列");
    return NO;
}
@end
