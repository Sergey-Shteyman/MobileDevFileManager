//
//  TestCell.swift
//  LessonFileManager
//
//  Created by Сергей Штейман on 26.03.2022.
//


import UIKit

// MARK: DocTableViewCellDelagate
protocol DocTableViewCellDelagate: AnyObject {
    func didTapDeleteButton(with indexPath: IndexPath)
}

// MARK: - MainTableViewCell
final class DocTableViewCell: UITableViewCell {
    
    weak var delegate: DocTableViewCellDelagate?
    
    private var indexPath: IndexPath?
    
    enum TypeDocument: String {
        case file = "FileLogo"
        case folder = "FolderLogo"
        case deleteButton = "DeleteLogo"
    }
        
    private lazy var folderImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: TypeDocument.folder.rawValue)
        return imageView
    }()
    
    private lazy var fileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: TypeDocument.file.rawValue)
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.imageView?.contentMode = .scaleAspectFill
        button.setImage(UIImage(named: TypeDocument.deleteButton.rawValue), for: .normal)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    @objc func didTapButton() {
        guard let indexPath = indexPath else {
            return
        }
        delegate?.didTapDeleteButton(with: indexPath)
    }
    
}

// MARK: - Public Methods
extension DocTableViewCell {
    
    func setupCellConfiguration(nameDocument: String?, indexPath: IndexPath) {
        self.indexPath = indexPath
        titleLabel.text = nameDocument
        setupDocumentImage(nameDocument)
    }
}

// MARK: - Private Methods
private extension DocTableViewCell {
    
    func setupCell() {
        setupsubViews()
        addTargets()
        setupConstraints()
    }
    
    func setupDocumentImage(_ nameDocument: String?) {
        guard let nameDocument = nameDocument else {
            return
        }

        folderImage.isHidden = nameDocument.contains("File") ? true : false
        fileImage.isHidden = nameDocument.contains("File") ? false : true
    }
    
    func addTargets() {
        deleteButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    func setupsubViews() {
        let arraySubViews = [titleLabel, deleteButton, fileImage, folderImage]
        contentView.myAddSubViews(from: arraySubViews)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([fileImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),
                                     fileImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
                                     fileImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30),
                                     fileImage.widthAnchor.constraint(equalToConstant: 40),
                                     fileImage.heightAnchor.constraint(equalToConstant: 40)])
        
        NSLayoutConstraint.activate([folderImage.widthAnchor.constraint(equalToConstant: 40),
                                     folderImage.heightAnchor.constraint(equalToConstant: 40),
                                     folderImage.centerXAnchor.constraint(equalTo: fileImage.centerXAnchor),
                                     folderImage.centerYAnchor.constraint(equalTo: fileImage.centerYAnchor)])
        
        NSLayoutConstraint.activate([deleteButton.heightAnchor.constraint(equalToConstant: 30),
                                     deleteButton.widthAnchor.constraint(equalToConstant: 30),
                                     deleteButton.centerYAnchor.constraint(equalTo: fileImage.centerYAnchor),
                                     deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)])
        
        NSLayoutConstraint.activate([titleLabel.centerYAnchor.constraint(equalTo: fileImage.centerYAnchor),
                                     titleLabel.leadingAnchor.constraint(equalTo: fileImage.trailingAnchor, constant: 12),
                                     titleLabel.trailingAnchor.constraint(equalTo: deleteButton.leadingAnchor, constant: -20)])
        
    }
}
