//
//  RegistrationVc.m
//
//  Created by Bhadresh Patel on 9/22/16.
//  Copyright © 2016 Bhadresh Patel. All rights reserved.
//

#import "RegistrationVc.h"

@interface RegistrationVc ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation RegistrationVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  //  _scrlView.contentSize = CGSizeMake(self.view.frame.size.width, 500);
    strtype = @"1";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)regisrationNow:(id)sender {
               NSDictionary *parameters = @{@"request": @"registration",
                                    @"name" : _txtName.text,
                                    @"number":_txtPhone.text,
                                    @"email":_txtEmail.text,
                                    @"password":_txtPassword.text,
                                    @"address":_txtAddress.text,
                                    @"rate":@"0",
                                    @"type":strtype,
                                    @"latitude":@"0",
                                    @"longitude":@"0",
                                    @"isonline":@"0"};
        

        NSData *imgData = UIImageJPEGRepresentation(_imgUserProPic.image, 1.0);

        NSString *string = [NSString stringWithFormat:@ApiUrl];
        
        AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
        
        
        NSMutableURLRequest *request =
        [serializer multipartFormRequestWithMethod:@"POST" URLString:string
                                        parameters:parameters
                         constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                             [formData appendPartWithFileData:imgData
                                                         name:@"profile_photo"
                                                     fileName:@"profile_photo"
                                                     mimeType:@"image/jpg" ];
                         }];
        
    
    // 3. Create and use `AFHTTPRequestOperationManager` to create an `AFHTTPRequestOperation` from the `NSMutableURLRequest` that we just created.
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFHTTPRequestOperation *operation =
    [manager HTTPRequestOperationWithRequest:request
                                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                         NSLog(@"Success %@", responseObject);
                                         
                                         UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Success!" message:operation.responseObject[@"msg"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                         [alert show];
                                         
                                         [self.navigationController popViewControllerAnimated:YES];
                                     
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         NSLog(@"Failure %@", operation.responseObject[@"msg"]);
                                         UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:operation.responseObject[@"msg"] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                                         [alert show];
                                     }];
    
    // 4. Set the progress block of the operation.
    [operation setUploadProgressBlock:^(NSUInteger __unused bytesWritten,
                                        long long totalBytesWritten,
                                        long long totalBytesExpectedToWrite)
     {
         NSLog(@"Wrote %lld/%lld", totalBytesWritten, totalBytesExpectedToWrite);
       
     }];
    
    // 5. Begin!
    [operation start];
}

- (IBAction)btnActionOnwer:(id)sender {
    strtype = @"1";
    [_btnOutlateOwner setBackgroundImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateNormal];
    [_btnOutlateWalker setBackgroundImage:[UIImage imageNamed:@"Deselected"] forState:UIControlStateNormal];
    
}

- (IBAction)btnActionWalker:(id)sender {
    strtype = @"0";
    [_btnOutlateWalker setBackgroundImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateNormal];
    [_btnOutlateOwner setBackgroundImage:[UIImage imageNamed:@"Deselected"] forState:UIControlStateNormal];

}

- (IBAction)btnProPicUplode:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:@"Cancel"
                                                    otherButtonTitles:@"Take Photo", @"Choose From Library", nil];
    [actionSheet showInView:self.view];
    

}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //NSLog(@"Index = %d - Title = %@", buttonIndex, [actionSheet buttonTitleAtIndex:buttonIndex]);
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (buttonIndex == 1)
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        picker.allowsEditing = YES;
        [self presentViewController:picker animated:YES completion:nil];
    }
    else if (buttonIndex == 2)
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate = self;
        picker.allowsEditing = YES;
        [self presentViewController:picker animated:YES completion:nil];
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    
    _imgUserProPic.image = [self imageWithImage:chosenImage scaledToFillSize:CGSizeMake(150, 150)];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (UIImage *)imageWithImage:(UIImage *)image scaledToFillSize:(CGSize)size
{
    CGFloat scale = MAX(size.width/image.size.width, size.height/image.size.height);
    CGFloat width = image.size.width * scale;
    CGFloat height = image.size.height * scale;
    CGRect imageRect = CGRectMake((size.width - width)/2.0f,
                                  (size.height - height)/2.0f,
                                  width,
                                  height);
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [image drawInRect:imageRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
