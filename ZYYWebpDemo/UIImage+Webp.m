//
//  UIImage+Webp.m
//  ZYYWebpDemo
//
//  Created by ZYY on 2020/9/17.
//

#import "UIImage+Webp.h"
#import <WebP/decode.h>

@implementation UIImage (Webp)

+ (UIImage *)createWebpImage:(NSString *)imageName {
    NSURL *imageURL = [[NSBundle mainBundle] URLForResource:imageName withExtension:@"webp"];

    return [self createWebpImageWithURL: imageURL];
}

+ (UIImage *)createWebpImageWithURL:(NSURL *)url {
    // Find the path of the selected WebP image in the bundle and read it into memory
//    NSData *myData = [NSData dataWithContentsOfFile:filePath];
    NSData *myData = [NSData dataWithContentsOfURL:url];

    // Get the width and height of the selected WebP image
    int width = 0;
    int height = 0;
    WebPGetInfo([myData bytes], [myData length], &width, &height);

    // Decode the WebP image data into a RGBA value array
    uint8_t *data = WebPDecodeRGBA([myData bytes], [myData length], &width, &height);


    // Construct a UIImage from the decoded RGBA value array
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, data, width*height * 4, free_image_data);

    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaNoneSkipLast;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    CGImageRef imageRef = CGImageCreate(width, height, 8, 32, 4*width, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);
    UIImage *newImage = [UIImage imageWithCGImage:imageRef];

    CGImageRelease(imageRef);
    CGColorSpaceRelease(colorSpaceRef);
    CGDataProviderRelease(provider);

    return newImage;
}

/*
 This gets called when the UIImage gets collected and frees the underlying image.
 */
static void free_image_data(void *info, const void *data, size_t size)
{
    if(info != NULL)
    {
        WebPFreeDecBuffer(&(((WebPDecoderConfig *)info)->output));
    }
    else
    {
        free((void *)data);
    }
}

@end
