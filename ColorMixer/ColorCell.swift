//
//  ColorCell.swift
//  ColorMixer
//
//  Created by Николай Игнатов on 26.01.2025.
//


import UIKit

struct ColorCellViewModel {
    let text: String
    let color: UIColor
    let isResultCell: Bool
}

final class ColorCell: UITableViewCell {
    private lazy var containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var colorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
        
    private lazy var colorNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetCell()
    }
    
    func configure(with viewModel: ColorCellViewModel) {
        colorView.backgroundColor = viewModel.color
        colorNameLabel.text = viewModel.text
        contentView.backgroundColor = viewModel.isResultCell ? viewModel.color : nil
    }
}

// MARK: - Private methods
private extension ColorCell {
    func setupSubviews() {
        contentView.addSubview(containerView)
        containerView.addSubview(colorView)
        containerView.addSubview(colorNameLabel)
    }
    
    
    func resetCell() {
        colorNameLabel.text = nil
        colorView.backgroundColor = .clear
        contentView.backgroundColor = .clear
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 120),
            
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            colorView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            colorView.topAnchor.constraint(equalTo: containerView.topAnchor),
            colorView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            colorView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.6),
            
            colorNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -10),
            colorNameLabel.leadingAnchor.constraint(equalTo: colorView.trailingAnchor, constant: 10),
            colorNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            colorNameLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
    }
}
