//
//  CastCollectionCell.h
//  Flix
//
//  Created by Pranitha Reddy Kona on 6/25/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CastCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@property (weak, nonatomic) IBOutlet UILabel *actorLabel;
@property (weak, nonatomic) IBOutlet UILabel *characterLabel;
@property (weak, nonatomic) IBOutlet UIImageView *cardView;


@end

NS_ASSUME_NONNULL_END
