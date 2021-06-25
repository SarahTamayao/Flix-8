//
//  ReviewModalViewController.m
//  Flix
//
//  Created by Pranitha Reddy Kona on 6/24/21.
//

#import "ReviewModalViewController.h"

@interface ReviewModalViewController ()
@property (weak, nonatomic) IBOutlet UILabel *reviewLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cardView;

@end

@implementation ReviewModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.reviewLabel.text = self.review[@"content"];
    self.cardView.layer.cornerRadius = 15.0;
    
    //[self.reviewLabel sizeToFit];
}
- (IBAction)onTap:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
