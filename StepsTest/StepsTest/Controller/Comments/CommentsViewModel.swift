//
//  CommentsViewModel.swift
//  StepsTest
//
//  Created by Maksym Horbenko on 20.11.2020.
//

import Foundation
import RxSwift

class CommentsViewModel: ViewModel {
    
    weak var coordinator: AppCoordinator?
    
    private unowned let networkManager: NetworkManager
    let bounds: Bounds
    
    required init(coordinator: AppCoordinator, networkManager: NetworkManager, bounds: Bounds) {
        self.coordinator = coordinator
        self.networkManager = networkManager
        self.bounds = bounds
    }
    
    let loading = BehaviorSubject<Bool>(value: false)
    
    private var disposeBag = DisposeBag()
    private(set) var sectionsCommentsData = BehaviorSubject<[SectionCommentsData]>(value: [SectionCommentsData(header: "Comments", items: [])])
    
    // Pagination
    private var start = 0
    private var currentCount = 0
    private let pageLimit: Int = 10
    private var lastID: Int?
    
    private func clearCounters() {
        start = 0
        currentCount = 0
        lastID = nil
    }
        
    func prepare() {
        getComments()
    }
    
    func onBottomReached() {
        guard let lastID = lastID,
              lastID < bounds.upper
        else { return }
        start += pageLimit
        getComments()
    }
    
    func getComments(refreshing: Bool = false) {
        loading.onNext(true)
        networkManager.getComments(start: start, limit: pageLimit) { [weak self] (comments) in
            guard let self = self else { return }
            if comments.map({ $0.id }).contains(where: { (self.bounds.lower...self.bounds.upper).contains($0) }) {
                self.onNew(comments: comments, refreshing: refreshing)
                self.loading.onNext(false)
            } else {
                guard !comments.isEmpty, self.start < self.bounds.upper else { return }
                self.start += self.pageLimit
                self.getComments(refreshing: refreshing)
            }
        } onError: { [weak self] (error) in
            self?.coordinator?.showError(error)
            self?.loading.onNext(false)
        }
    }
    
    private func onNew(comments: [Comment], refreshing: Bool) {
        var newItems: [SectionCommentsData.CellItem] = []
        lastID = comments.last?.id
        if refreshing {
            comments.forEach { (comment) in
                if (bounds.lower...bounds.upper).contains(comment.id) {
                    newItems.append(.comment(comment: comment))
                }
            }
            currentCount += newItems.count
            sectionsCommentsData.onNext([SectionCommentsData(header: "Comments", items: newItems)])
        } else {
            guard let originalData = try? self.sectionsCommentsData.value().first else { return }
            let originalItems = originalData.items
            comments.forEach { (comment) in
                if (bounds.lower...bounds.upper).contains(comment.id) {
                    newItems.append(.comment(comment: comment))
                }
            }
            currentCount += originalItems.count + newItems.count
            sectionsCommentsData.onNext([SectionCommentsData(original: originalData, items: originalItems + newItems)])
        }
        
        if currentCount < 5, self.start < self.bounds.upper {
            self.start += self.pageLimit
            self.getComments()
        }
    }
    
    func onRefresh() {
        clearCounters()
        getComments(refreshing: true)
    }
    
}
