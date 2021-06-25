//
//  ReviewCell.h
//  Flix
//
//  Created by Pranitha Reddy Kona on 6/24/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ReviewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *reviewLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cardView;

@end

NS_ASSUME_NONNULL_END
