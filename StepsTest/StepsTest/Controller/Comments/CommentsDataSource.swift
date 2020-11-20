//
//  File.swift
//  StepsTest
//
//  Created by Maksym Horbenko on 20.11.2020.
//

import Foundation
import RxSwift
import RxDataSources

struct CommentsDataSource {
    
    static func configureTableView() -> RxTableViewSectionedAnimatedDataSource<SectionCommentsData> {
        return RxTableViewSectionedAnimatedDataSource<SectionCommentsData>(
        configureCell: { dataSource, tableView, indexPath, item in
            switch item {
            case .comment(let comment):
                let cell = tableView.dequeue(cell: CommentTableViewCell.self)
                cell.configure(with: comment)
                return cell
            }
        })
    }
    
}

struct SectionCommentsData {
    var header: String
    var items: [CellItem]

    enum CellItem: IdentifiableType, Equatable {
        case comment(comment: Comment)

        typealias Identity = Int

        var identity : Identity {
            switch self {
            case .comment(let comment):
                return comment.id
            }
        }

        static func == (lhs: SectionCommentsData.CellItem, rhs: SectionCommentsData.CellItem) -> Bool {
            return lhs.identity == rhs.identity
        }
    }
}

extension SectionCommentsData: AnimatableSectionModelType {
    typealias Item = CellItem

    typealias Identity = String
    var identity: String {
        return header
    }

    init(original: SectionCommentsData, items: [Item]) {
        self = original
        self.items = items
    }
}
