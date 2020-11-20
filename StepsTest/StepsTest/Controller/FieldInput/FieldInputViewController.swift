//
//  FieldInputViewController.swift
//  StepsTest
//
//  Created by Maksym Horbenko on 20.11.2020.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import SkyFloatingLabelTextField

class FieldInputViewController: UIViewController {
    
    private lazy var backgroundButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerRadius = 5
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var lowerBoundTextField: SkyFloatingLabelTextField = {
        let textField = SkyFloatingLabelTextField()
        textField.textColor = .black
        textField.placeholderColor = .darkGray
        textField.titleColor = .systemBlue
        textField.lineColor = .gray
        textField.errorColor = .systemRed
        textField.lineErrorColor = .systemRed
        textField.textErrorColor = .black
        textField.titleErrorColor = .systemRed
        textField.disabledColor = .darkGray
        textField.selectedTitleColor = .systemBlue
        textField.selectedLineColor = .systemBlue
        textField.titleFont = .systemFont(ofSize: 15)
        textField.placeholder = "Lower Bound"
        textField.textContentType = .oneTimeCode
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var upperBoundTextField: SkyFloatingLabelTextField = {
        let textField = SkyFloatingLabelTextField()
        textField.textColor = .black
        textField.placeholderColor = .darkGray
        textField.titleColor = .systemBlue
        textField.lineColor = .gray
        textField.errorColor = .systemRed
        textField.lineErrorColor = .systemRed
        textField.textErrorColor = .black
        textField.titleErrorColor = .systemRed
        textField.disabledColor = .darkGray
        textField.selectedTitleColor = .systemBlue
        textField.selectedLineColor = .systemBlue
        textField.titleFont = .systemFont(ofSize: 15)
        textField.placeholder = "Upper Bound"
        textField.textContentType = .oneTimeCode
        textField.keyboardType = .numberPad
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.cornerRadius = 5
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let viewModel: FieldInputViewModel
    
    init(viewModel: FieldInputViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var disposeBag = DisposeBag()
    private var validator = Validator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBindings()
        viewModel.prepare()
        setupViewLayout()
    }
    
    private func setupBindings() {
        lowerBoundTextField.rx.text.orEmpty
            .bind(to: viewModel.lowerBound)
            .disposed(by: disposeBag)
        
        upperBoundTextField.rx.text.orEmpty
            .bind(to: viewModel.upperBound)
            .disposed(by: disposeBag)
        
        Observable.combineLatest(viewModel.lowerBound, viewModel.upperBound)
            .skipWhile({ $0.0.isEmpty || $0.1.isEmpty })
            .subscribe(onNext: { [weak self] (lowerBound, upperBound) in
                guard let self = self else { return }
                do {
                    try self.validator.validate(lowerBound: Int(lowerBound), upperBound: Int(upperBound))
                    self.lowerBoundTextField.errorMessage = nil
                    self.upperBoundTextField.errorMessage = nil
                } catch {
                    self.lowerBoundTextField.errorMessage = error.localizedDescription
                    self.upperBoundTextField.errorMessage = error.localizedDescription
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.isDoneActive
            .do(onNext: { [weak self] (isEnabled) in
                guard let self = self else { return }
                self.doneButton.backgroundColor = isEnabled ? .systemBlue : .darkGray
                self.doneButton.setTitleColor(.white, for: .normal)
            })
            .bind(to: doneButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        doneButton.rx.tap
            .bind { [weak self] in self?.viewModel.onDone() }
            .disposed(by: disposeBag)
    }
    
    private func setupViewLayout() {
        navigationItem.title = "Steps Test App"
        view.backgroundColor = .systemGray
        setConstraints()
        setupStackView()
    }
    
    private func setConstraints() {
        view.addSubview(backgroundButton)
        backgroundButton.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { (make) in
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.centerY.equalTo(view)
        }
        
        backgroundView.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.top.equalTo(backgroundView)
            make.trailing.equalTo(backgroundView)
            make.leading.equalTo(backgroundView)
            make.height.equalTo(45)
        }
        
        backgroundView.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.top.equalTo(topView.snp.bottom)
            make.bottom.equalTo(backgroundView)
            make.left.equalTo(backgroundView)
            make.right.equalTo(backgroundView)
        }
        
        contentView.addSubview(contentStackView)
        contentStackView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView).inset(20)
        }
    }
    
    private func setupStackView() {
        contentStackView.alignment = .center
        contentStackView.spacing = 10
        contentStackView.distribution = .fill
        contentStackView.axis = .vertical
        
        let titleLabel = UILabel()
        titleLabel.text = "Input lower and upper bounds in the fields below"
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 17)
        titleLabel.textColor = .black
        
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(lowerBoundTextField)
        contentStackView.addArrangedSubview(upperBoundTextField)
        contentStackView.addArrangedSubview(doneButton)
        
        lowerBoundTextField.snp.makeConstraints { (make) in
            make.left.equalTo(contentStackView.snp.left)
            make.right.equalTo(contentStackView.snp.right)
        }

        upperBoundTextField.snp.makeConstraints { (make) in
            make.left.equalTo(contentStackView.snp.left)
            make.right.equalTo(contentStackView.snp.right)
        }

        doneButton.snp.makeConstraints { (make) in
            make.left.equalTo(contentStackView.snp.left)
            make.right.equalTo(contentStackView.snp.right)
        }

    }
    
}
