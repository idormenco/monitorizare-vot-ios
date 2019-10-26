//
//  QuestionListViewModel.swift
//  MonitorizareVot
//
//  Created by Cristi Habliuc on 26/10/2019.
//  Copyright © 2019 Code4Ro. All rights reserved.
//

import UIKit

struct QuestionCellModel {
    var questionId: Int
    var questionCode: String
    var questionText: String
    var isAnswered: Bool
}

class QuestionListViewModel: NSObject {
    fileprivate var form: FormResponse
    fileprivate var sections: [FormSectionResponse]
    
    var title: String {
        return form.description
    }
    
    var sectionTitles: [String] {
        return sections.map { $0.description }
    }
    
    init?(withFormUsingCode code: String) {
        guard let form = LocalStorage.shared.getFormSummary(withCode: code),
            let sections = LocalStorage.shared.loadForm(withId: form.id) else { return nil }
        self.form = form
        self.sections = sections
        super.init()
    }
    
    func questions(inSection section: Int) -> [QuestionCellModel] {
        guard sections.count > section,
            let county = PreferencesManager.shared.county,
            let stationId = PreferencesManager.shared.section
            else { return [] }
        
        
        let sectionInfo = DBSyncer.shared.sectionInfo(for: county, sectie: stationId)
        let storedQuestions = sectionInfo.questions?.allObjects as? [Question] ?? []
        let mappedQuestions = storedQuestions.reduce(into: [Int: Question]()) { $0[Int($1.id)] = $1 }
        
        return sections[section].questions.map { questionResponse -> QuestionCellModel in
            let stored = mappedQuestions[questionResponse.id]
            return QuestionCellModel(
                questionId: questionResponse.id,
                questionCode: questionResponse.code,
                questionText: questionResponse.text,
                isAnswered: stored?.answered ?? false)
        }
    }
    
}
