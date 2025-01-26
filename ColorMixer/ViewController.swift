//
//  ViewController.swift
//  ColorMixer
//
//  Created by Николай Игнатов on 21.01.2025.
//

import UIKit

// MARK: - Models
private struct ColorItem {
    let color: UIColor
    let name: String
}

private enum AppLanguage: String {
    case ru
    case en
}

final class ColorMixerViewController: UIViewController {
    // MARK: - Properties
    private var selectedColors: [ColorItem] = []
    private var resultColor: UIColor = .white
    private var resultEmptyText = "Добавьте цвета для смешивания"
    private var resultColorName: String {
        resultColor.accessibilityName
    }
    
    private var currentLanguage: AppLanguage = .ru {
        didSet {
            updateLanguage()
        }
    }
    
    private lazy var screenTitle: UILabel = {
        let label = UILabel()
        label.text = "Цветомешалка"
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var languageSwitcher: UISegmentedControl = {
        let switcher = UISegmentedControl(items: ["RU", "EN"])
        switcher.selectedSegmentIndex = 0
        switcher.addTarget(self, action: #selector(languageDidChange), for: .valueChanged)
        switcher.translatesAutoresizingMaskIntoConstraints = false
        return switcher
    }()
    
    private lazy var colorPicker: UIColorPickerViewController = {
        let picker = UIColorPickerViewController()
        picker.delegate = self
        return picker
    }()
    
    private lazy var colorTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 120
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.register(ColorCell.self, forCellReuseIdentifier: "ColorCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var addColorButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Добавить цвет", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(addColorButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
}

// MARK: - UITableViewDataSource
extension ColorMixerViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            1
        default:
            selectedColors.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            createResultCell(for: tableView, at: indexPath)
        default:
            createColorCell(for: tableView, at: indexPath)
        }
    }
    
    func createResultCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ColorCell", for: indexPath) as? ColorCell else { return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        if selectedColors.isEmpty {
            configureEmptyResultCell(cell)
        } else {
            configureFilledResultCell(cell)
        }
        return cell
    }
}

// MARK: - UITableViewDelegate
extension ColorMixerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        indexPath.section == 1
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            selectedColors.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            mixColors()
            tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        }
    }
}

// MARK: - UIColorPickerViewControllerDelegate
extension ColorMixerViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        guard !continuously else { return }
        
        let colorName = color.accessibilityName
        selectedColors.append(ColorItem(color: color, name: colorName))
        mixColors()
        colorTableView.reloadData()
        colorPicker.dismiss(animated: true)
    }
}

// MARK: - Private Methods
private extension ColorMixerViewController {
    /// Магия смешивания цветов
    func mixColors() {
        guard !selectedColors.isEmpty else { return }
        
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        for color in selectedColors.map(\.color) {
            var components = (red: CGFloat(0), green: CGFloat(0), blue: CGFloat(0), alpha: CGFloat(0))
            color.getRed(&components.red, green: &components.green, blue: &components.blue, alpha: &components.alpha)
            red += components.red
            green += components.green
            blue += components.blue
            alpha += components.alpha
        }
        
        let count = CGFloat(selectedColors.count)
        resultColor = UIColor(red: red / count, green: green / count, blue: blue / count, alpha: alpha / count)
    }
    
    func setupView() {
        view.backgroundColor = .white
        view.addSubview(screenTitle)
        view.addSubview(colorTableView)
        view.addSubview(addColorButton)
        view.addSubview(languageSwitcher)
    }
    
    func configureEmptyResultCell(_ cell: ColorCell) {
        let viewModel = ColorCellViewModel(text: resultEmptyText, color: .white, isResultCell: true)
        cell.configure(with: viewModel)
    }
    
    func configureFilledResultCell(_ cell: ColorCell) {
        let viewModel = ColorCellViewModel(text: resultColorName, color: resultColor, isResultCell: true)
        cell.configure(with: viewModel)
    }
    
    func createColorCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ColorCell", for: indexPath) as? ColorCell else { return UITableViewCell()
        }
        let colorItem = selectedColors[indexPath.row]
        let viewModel = ColorCellViewModel(text: colorItem.name, color: colorItem.color, isResultCell: false)
        cell.configure(with: viewModel)
        return cell
    }
    
    private func updateLanguage() {
        switch currentLanguage {
        case .ru:
            addColorButton.setTitle("Добавить цвет", for: .normal)
            screenTitle.text = "Цветомешалка"
            resultEmptyText = "Добавьте цвета для смешивания"
        case .en:
            addColorButton.setTitle("Add Color", for: .normal)
            screenTitle.text = "MixColors"
            resultEmptyText = "Add colors for mix"
        }

        colorTableView.reloadData()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            screenTitle.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            screenTitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            languageSwitcher.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            languageSwitcher.centerYAnchor.constraint(equalTo: screenTitle.centerYAnchor),
            
            colorTableView.topAnchor.constraint(equalTo: screenTitle.bottomAnchor, constant: 16),
            colorTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            colorTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            colorTableView.bottomAnchor.constraint(equalTo: addColorButton.topAnchor, constant: -16),
            
            addColorButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            addColorButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            addColorButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addColorButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func addColorButtonTapped() {
        present(colorPicker, animated: true)
    }
    
    @objc func languageDidChange() {
        currentLanguage = languageSwitcher.selectedSegmentIndex == 0 ? .ru : .en
    }
}
