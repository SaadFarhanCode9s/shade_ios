/*
Copyright 2024 New Vector Ltd.
Copyright 2017 Vector Creations Ltd

SPDX-License-Identifier: AGPL-3.0-only
Please see LICENSE in the repository root for full details.
 */

#import "RoomMembershipCollapsedBubbleCell.h"

/**
 `RoomMembershipWithPaginationTitleBubbleCell` displays a sum-up of collapsed membership cells with a pagination title.
 */
@interface RoomMembershipCollapsedWithPaginationTitleBubbleCell : RoomMembershipCollapsedBubbleCell

@property (weak, nonatomic) IBOutlet UIView *paginationTitleView;
@property (weak, nonatomic) IBOutlet UILabel *paginationLabel;
@property (weak, nonatomic) IBOutlet UIView *paginationSeparatorView;

@end
