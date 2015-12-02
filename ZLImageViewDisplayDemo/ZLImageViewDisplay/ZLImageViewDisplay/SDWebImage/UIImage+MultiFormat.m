//
//  UIImage+MultiFormat.m
//  SDWebImage
//
//  Created by Olivier Poitrey on 07/06/13.
//  Copyright (c) 2013 Dailymotion. All rights reserved.
//

#import "UIImage+MultiFormat.h"
#import "UIImage+GIF.h"
#import "NSData+ImageContentType.h"
#import <ImageIO/ImageIO.h>

#ifdef SD_WEBP
#import "UIImage+WebP.h"
#endif

@implementation UIImage (MultiFormat)

+ (UIImage *)sd_imageWithData:(NSData *)data {
    if (!data) {
        return nil;
    }
    
    UIImage *image;
    NSString *imageContentType = [NSData sd_contentTypeForImageData:data];
    if ([imageContentType isEqualToString:@"image/gif"]) {
        image = [UIImage sd_animatedGIFWithData:data];
    }
#ifdef SD_WEBP
    else if ([imageContentType isEqualToString:@"image/webp"])
    {
        image = [UIImage sd_imageWithWebPData:data];
    }
#endif
    else {
        image = [[UIImage alloc] initWithData:data];
        /*
        //begin, hejichang 添加 :图片大于1M，进行缩小
        if (data.length/1024 > 1024) {
            image = [self compressImageWith:image];
        }
        //end,hejichang
        */
        UIImageOrientation orientation = [self sd_imageOrientationFromImageData:data];
        if (orientation != UIImageOrientationUp) {
            image = [UIImage imageWithCGImage:image.CGImage
                                        scale:image.scale
                                  orientation:orientation];
        }
    }


    return image;
}


+(UIImageOrientation)sd_imageOrientationFromImageData:(NSData *)imageData {
    UIImageOrientation result = UIImageOrientationUp;
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)imageData, NULL);
    if (imageSource) {
        CFDictionaryRef properties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, NULL);
        if (properties) {
            CFTypeRef val;
            int exifOrientation;
            val = CFDictionaryGetValue(properties, kCGImagePropertyOrientation);
            if (val) {
                CFNumberGetValue(val, kCFNumberIntType, &exifOrientation);
                result = [self sd_exifOrientationToiOSOrientation:exifOrientation];
            } // else - if it's not set it remains at up
            CFRelease((CFTypeRef) properties);
        } else {
            //NSLog(@"NO PROPERTIES, FAIL");
        }
        CFRelease(imageSource);
    }
    return result;
}

#pragma mark EXIF orientation tag converter
// Convert an EXIF image orientation to an iOS one.
// reference see here: http://sylvana.net/jpegcrop/exif_orientation.html
+ (UIImageOrientation) sd_exifOrientationToiOSOrientation:(int)exifOrientation {
    UIImageOrientation orientation = UIImageOrientationUp;
    switch (exifOrientation) {
        case 1:
            orientation = UIImageOrientationUp;
            break;

        case 3:
            orientation = UIImageOrientationDown;
            break;

        case 8:
            orientation = UIImageOrientationLeft;
            break;

        case 6:
            orientation = UIImageOrientationRight;
            break;

        case 2:
            orientation = UIImageOrientationUpMirrored;
            break;

        case 4:
            orientation = UIImageOrientationDownMirrored;
            break;

        case 5:
            orientation = UIImageOrientationLeftMirrored;
            break;

        case 7:
            orientation = UIImageOrientationRightMirrored;
            break;
        default:
            break;
    }
    return orientation;
}


/*

//begin,hejichang 添加，圈子 的图片 加载 会导致内存过大，虽然不会崩溃，但是效果不好。
+(UIImage *)compressImageWith:(UIImage *)image
{
    float imageWidth = image.size.width;
    float imageHeight = image.size.height;
    float width = 640;
    float height = image.size.height/(image.size.width/width);
    
    float widthScale = imageWidth /width;
    float heightScale = imageHeight /height;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    
    if (widthScale > heightScale) {
        [image drawInRect:CGRectMake(0, 0, imageWidth /heightScale , height)];
    }
    else {
        [image drawInRect:CGRectMake(0, 0, width , imageHeight /widthScale)];
    }
    
    // 从当前context中创建一个改变大小后的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    return newImage;
    
}
//end,hejichang
*/

@end
