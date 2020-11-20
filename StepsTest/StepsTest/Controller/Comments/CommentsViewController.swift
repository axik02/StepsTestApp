//
//  CommentsViewController.swift
//  StepsTest
//
//  Created by Maksym Horbenko on 20.11.2020.
//

import UIKit
import RxSwift
import RxCocoa

class CommentsViewController: UIViewController {

    private lazy var commentsTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemGray6
        tableView.separatorStyle = .none
        tableView.registerNibForCell(CommentTableViewCell.self)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.refreshControl = refreshControl
        return tableView
    }()
    
    private lazy var refreshControl = UIRefreshControl()
    
    let viewModel: CommentsViewModel
    
    init(viewModel: CommentsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var commentsDataSource = CommentsDataSource.configureTableView()
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        viewModel.prepare()
        setupViewLayout()
    }
    
    private func setupBindings() {
        viewModel.loading
            .bind(onNext: { [weak self] (loading) in
                loading ? self?.refreshControl.beginRefreshing() : self?.refreshControl.endRefreshing()
            })
            .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .bind(onNext: { [weak self] in self?.viewModel.onRefresh() })
            .disposed(by: disposeBag)
        
        commentsTableView.delegate = nil
        commentsTableView.dataSource = nil
        
        commentsTableView.rowHeight = UITableView.automaticDimension
        commentsTableView.estimatedRowHeight = 200
        
        commentsTableView.rx.reachedBottom
            .observeOn(MainScheduler.asyncInstance)
            .bind(onNext: { [weak self] in self?.viewModel.onBottomReached() })
            .disposed(by: disposeBag)
        
        viewModel.sectionsCommentsData
            .bind(to: commentsTableView.rx.items(dataSource: commentsDataSource))
            .disposed(by: disposeBag)
        
        commentsDataSource.animationConfiguration = .init(insertAnimation: .left, reloadAnimation: .automatic, deleteAnimation: .right)
    }
    
    private func setupViewLayout() {
        navigationItem.title = "Comments"
        view.backgroundColor = .systemGray6
        setConstraints()
    }
    
    private func setConstraints() {
        view.addSubview(commentsTableView)
        commentsTableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
    }
}
