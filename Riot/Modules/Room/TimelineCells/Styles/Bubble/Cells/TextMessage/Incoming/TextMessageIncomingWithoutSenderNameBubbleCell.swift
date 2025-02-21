// 
// Copyright 2021-2024 New Vector Ltd.
//
// SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Element-Commercial
// Please see LICENSE files in the repository root for full details.
//

import UIKit

class TextMessageIncomingWithoutSenderNameBubbleCell: TextMessageIncomingBubbleCell {
    
    override func setupViews() {
        super.setupViews()
        
        roomCellContentView?.showSenderName = false
    }
}
