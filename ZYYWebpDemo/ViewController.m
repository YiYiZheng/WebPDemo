//
//  ViewController.m
//  ZYYWebpDemo
//
//  Created by ZYY on 2020/9/17.
//

#import "ViewController.h"
#import "UIImage+Webp.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.imageView.image = [UIImage createWebpImage:@"test0"];
}


@end
