//
//  ViewController.m
//  FFBigImage
//
//  Created by 朱运 on 2020/12/14.
//

#import "ViewController.h"
#import "FFBigImage.h"
@interface ViewController (){
    UIImageView *showImage;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUInteger i;
    i = 3;
    NSString *str = [NSString stringWithFormat:@"d%ld",i];
    UIImage *image = [UIImage imageNamed:str];
    NSLog(@"size = %f,%f",image.size.width,image.size.height);
    CGFloat scanle = image.size.width / image.size.height;
    
    CGFloat imageWidth = self.view.frame.size.width *0.5;
    showImage = [[UIImageView alloc]init];
    showImage.frame = CGRectMake(0, 0, imageWidth, imageWidth / scanle);
    showImage.image = image;
    showImage.center = self.view.center;
    [self.view addSubview:showImage];
    
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [FFBigImage bigImageView:showImage];
}
@end
