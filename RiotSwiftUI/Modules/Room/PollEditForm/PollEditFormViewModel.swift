//
// Copyright 2021-2024 New Vector Ltd.
//
// SPDX-License-Identifier: AGPL-3.0-only OR LicenseRef-Element-Commercial
// Please see LICENSE files in the repository root for full details.
//

import Combine
import SwiftUI

struct PollEditFormViewModelParameters {
    let mode: PollEditFormMode
    let pollDetails: EditFormPollDetails
}

typealias PollEditFormViewModelType = StateStoreViewModel<PollEditFormViewState, PollEditFormViewAction>

class PollEditFormViewModel: PollEditFormViewModelType, PollEditFormViewModelProtocol {
    private enum Constants {
        static let minAnswerOptionsCount = 2
        static let maxAnswerOptionsCount = 20
        static let maxQuestionLength = 340
        static let maxAnswerOptionLength = 340
    }

    // MARK: - Properties

    // MARK: Private
    
    // MARK: Public
    
    var completion: ((PollEditFormViewModelResult) -> Void)?
    
    // MARK: - Setup
    
    init(parameters: PollEditFormViewModelParameters) {
        let state = PollEditFormViewState(
            minAnswerOptionsCount: Constants.minAnswerOptionsCount,
            maxAnswerOptionsCount: Constants.maxAnswerOptionsCount,
            mode: parameters.mode,
            bindings: PollEditFormViewStateBindings(
                question: PollEditFormQuestion(text: parameters.pollDetails.question, maxLength: Constants.maxQuestionLength),
                answerOptions: parameters.pollDetails.answerOptions.map { PollEditFormAnswerOption(text: $0, maxLength: Constants.maxAnswerOptionLength) },
                type: parameters.pollDetails.type
            )
        )
        
        super.init(initialViewState: state)
    }
    
    // MARK: - Public
    
    override func process(viewAction: PollEditFormViewAction) {
        switch viewAction {
        case .cancel:
            completion?(.cancel)
        case .create:
            completion?(.create(buildPollDetails()))
        case .update:
            completion?(.update(buildPollDetails()))
        case .addAnswerOption:
            state.bindings.answerOptions.append(PollEditFormAnswerOption(text: "", maxLength: Constants.maxAnswerOptionLength))
        case .deleteAnswerOption(let answerOption):
            state.bindings.answerOptions.removeAll { $0 == answerOption }
        }
    }
    
    // MARK: - PollEditFormViewModelProtocol
    
    func startLoading() {
        state.showLoadingIndicator = true
    }
    
    func stopLoading(errorAlertType: PollEditFormErrorAlertInfo.AlertType?) {
        state.showLoadingIndicator = false
        
        switch errorAlertType {
        case .failedCreatingPoll:
            state.bindings.alertInfo = PollEditFormErrorAlertInfo(id: .failedCreatingPoll,
                                                                  title: VectorL10n.pollEditFormPostFailureTitle,
                                                                  subtitle: VectorL10n.pollEditFormPostFailureSubtitle)
        case .failedUpdatingPoll:
            state.bindings.alertInfo = PollEditFormErrorAlertInfo(id: .failedUpdatingPoll,
                                                                  title: VectorL10n.pollEditFormUpdateFailureTitle,
                                                                  subtitle: VectorL10n.pollEditFormUpdateFailureSubtitle)
        case .none:
            break
        }
    }
    
    // MARK: - Private
    
    private func buildPollDetails() -> EditFormPollDetails {
        EditFormPollDetails(type: state.bindings.type,
                            question: state.bindings.question.text.trimmingCharacters(in: .whitespacesAndNewlines),
                            answerOptions: state.bindings.answerOptions.compactMap { answerOption in
                                let text = answerOption.text.trimmingCharacters(in: .whitespacesAndNewlines)
                                return text.isEmpty ? nil : text
                            })
    }
}
