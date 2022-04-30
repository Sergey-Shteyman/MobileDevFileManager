//
//  DocumentsViewController.swift
//  LessonFileManager
//
//  Created by Сергей Штейман on 11.01.2022.
//

import UIKit

// MARK: - DocumentsPageViewController
class DocumentsViewController: UIViewController {
    
    private let tableView = UITableView()
    private var urlDirectory = URL(string: "")
    private var counterFiles = 1
    private var counterFolders = 1
    private var arrayUrls = [URL]()
    private var arrayUrlFolders = [URL]()
    private var arrayUrlFiles = [URL]()
    private var allert = UIAlertController()
    
    private let fileService: FileServiceable
    
    init() {
        self.fileService = FileService()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func initWithFolderUrl(url: URL) -> DocumentsViewController {
        contentsOfDirectory(urlOfDirectory: url)
        addNavigationBarForDocuments(titleUrl: url)
        return self
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        setupViewController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate Impl
extension DocumentsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        contentsOfDirectory(urlOfDirectory: urlDirectory)
        let selectedRow = arrayUrls[indexPath.row]
        if getNameOfDocument(urlWithNameDocument: selectedRow).contains("Folder") {
            let vc = DocumentsViewController()
            let newUrl = selectedRow
            self.navigationController?.pushViewController(vc.initWithFolderUrl(url: newUrl), animated: true)
            

        } else if getNameOfDocument(urlWithNameDocument: selectedRow).contains("File") {
            present(setUpAllertController(randomString: randomString(), indexPath: indexPath), animated: true, completion: nil)
        }
    }
}

// MARK:  - UITableViewDataSource Impl
extension DocumentsViewController:  UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        contentsOfDirectory(urlOfDirectory: urlDirectory)
        return arrayUrls.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.myDequeueReusableCell(type: DocTableViewCell.self, indePath: indexPath)
        let typeOfDocument = arrayUrls[indexPath.row]
        let nameDocument = getNameOfDocument(urlWithNameDocument: typeOfDocument)
        cell.setupCellConfiguration(nameDocument: nameDocument, indexPath: indexPath)
        cell.delegate = self
        return cell
    }
}

// MARK: - DocTableViewCellDelagate Impl
extension DocumentsViewController: DocTableViewCellDelagate {
    
    func didTapDeleteButton(with indexPath: IndexPath) {
        print(indexPath.row)
        contentsOfDirectory(urlOfDirectory: urlDirectory)
        let isRemovedFolder = self.fileService.removeFolder(with: self.arrayUrls[indexPath.row].path)
        if isRemovedFolder {
            arrayUrls.remove(at: indexPath.row)
            contentsOfDirectory(urlOfDirectory: urlDirectory)
            
            tableView.performBatchUpdates {
                tableView.deleteRows(at: [indexPath], with: .fade)
            } completion: { [weak self] _ in
                self?.tableView.reloadData()
            }

        }
    }
}

// MARK: - Private Methods
private extension DocumentsViewController {

    func addNavigationBarForRootViewController() {
        self.navigationItem.title = "Documents"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
    }
    
    func addNavigationBarForDocuments(titleUrl: URL?) {
        guard let titleUrl = titleUrl else { return }
        self.navigationItem.title = (titleUrl.path as NSString).lastPathComponent
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
    }
    
    func setupNavigationBarButtons() {
        let newFolderButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createNewFile))
        let newFileButton = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(createNewFolder))
        self.navigationItem.rightBarButtonItems = [newFolderButton, newFileButton]
    }
    
    func setUrl() {
        guard let rootURL = fileService.fetchRootUrl() else {
            return
        }
        print(rootURL.path)
        urlDirectory = rootURL
        contentsOfDirectory(urlOfDirectory: urlDirectory)
    }
    
    func contentsOfDirectory(urlOfDirectory: URL?) {
        guard let urlOfDirectory = urlOfDirectory else { return setUrl() }
        urlDirectory = urlOfDirectory
        guard let urls = fileService.contentsOfDirectory(at: urlOfDirectory) else {
            return
        }
        arrayUrls = urls
        if !arrayUrls.isEmpty {
            arrayUrls = sortArray(arrayUrlsOfDir: arrayUrls)
        }
    }
    
    func sortArray(arrayUrlsOfDir: [URL]) -> [URL] {
        var txtFiles = [URL]()
        var foldersArray = [URL]()
        var sortedArray = [URL]()
        for url in arrayUrlsOfDir {
            if url.path.contains("File") {
                txtFiles.append(url)
            } else {
                foldersArray.append(url)
            }
        }
        
        let sortedFolders = foldersArray.sorted { p1, p2 in
            findeNumber(urlDocument: p1) < findeNumber(urlDocument: p2)
        }
        
        let sortedFiles = txtFiles.sorted { p1, p2 in
            findeNumber(urlDocument: p1) < findeNumber(urlDocument: p2)
        }
        
        arrayUrlFiles = sortedFiles
        arrayUrlFolders = sortedFolders
        sortedArray += sortedFolders
        sortedArray += sortedFiles
        return sortedArray
    }
    
    func getNameOfDocument(urlWithNameDocument: URL) -> String {
        let nameDocument = (urlWithNameDocument.path as NSString).lastPathComponent
        return nameDocument
    }
    
    func findeNumber(urlDocument: URL) -> Int {
        let stringUrlWithNameDocument = getNameOfDocument(urlWithNameDocument: urlDocument)
        var number = ""
        for char in stringUrlWithNameDocument {
            let intChar = Int(String(char))
            if let intChar = intChar {
                number += String(intChar)
            }
        }
        let intNumber = Int(number)
        guard let intNumber = intNumber else { return 0 }
        return intNumber
    }

    
    @objc func createNewFolder(sender: UIBarButtonItem) {
        guard let urlDirectory = urlDirectory else { return }
        counterFolders = 1
        contentsOfDirectory(urlOfDirectory: urlDirectory)
        
        if arrayUrls.count != 0 {
            for url in arrayUrlFolders {
                if findeNumber(urlDocument: url) == counterFolders {
                    counterFolders += 1
                } else {
                    break
                }
            }
        }
        
        let folderName = "Folder" + String(counterFolders)
        let isFolderCreated = fileService.createFolder(with: folderName , in: urlDirectory)
        if !isFolderCreated {
            print("Can't create Folder with name \(folderName)")
        }
        
        let indexPath = IndexPath(item: counterFolders - 1, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .fade)
    }
    
    @objc func createNewFile() {
        guard let urlDirectory = urlDirectory else { return }
        counterFiles = 1
        contentsOfDirectory(urlOfDirectory: urlDirectory)
        if !arrayUrls.isEmpty {
            for url in arrayUrlFiles {
                if findeNumber(urlDocument: url) == counterFiles {
                    counterFiles += 1
                } else {
                    break
                }
            }
        }
        
        let fileName = "File\(String(counterFiles)).txt"
        if fileService.createFile(with: fileName, in: urlDirectory) {
            contentsOfDirectory(urlOfDirectory: urlDirectory)
        } else {
            print("Can't create File with name \(fileName)")
        }
        
        contentsOfDirectory(urlOfDirectory: self.urlDirectory)
        let indexPath = IndexPath(item: (counterFiles - 1) + arrayUrlFolders.count, section: 0)
        self.tableView.insertRows(at: [indexPath], with: .fade)
    }
    
    func setUpAllertController(randomString: String, indexPath: IndexPath) -> UIAlertController {
        allert = .init(title: getNameOfDocument(urlWithNameDocument: arrayUrls[indexPath.row]), message: randomString, preferredStyle: .alert)
        allert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return allert
    }
    
    func randomString() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<200).map{ _ in letters.randomElement()! })
    }
    
    func setupViewController() {
        addNavigationBarForRootViewController()
        addNavigationBarForDocuments(titleUrl: urlDirectory)
        setupUITable()
        setupNavigationBarButtons()
        contentsOfDirectory(urlOfDirectory: urlDirectory)
        tableView.reloadData()
    }
    
    func setupUITable() {
        tableView.myRegister(DocTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        view.myAddSubView(tableView)
        addConstraints()
    }
    
    func addConstraints() {
        NSLayoutConstraint.activate([tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                                     tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                                     tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                                     tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)])
    }
}

