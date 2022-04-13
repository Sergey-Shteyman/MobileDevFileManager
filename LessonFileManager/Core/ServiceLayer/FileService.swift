//
//  FileService.swift
//  LessonFileManager
//
//  Created by Сергей Штейман on 04.04.2022.
//

import UIKit

// MARK: - FileServiceable
protocol FileServiceable {
    func fetchRootUrl() -> URL?
    func createFolder(with name: String, in url: URL) -> Bool
    func createFile(with name: String, in url: URL) -> Bool
    func removeFolder(with path: String) -> Bool
    func contentsOfDirectory(at url: URL) -> [URL]?
}

// MARK: - FileService
final class FileService {
    
    private let fileManager = FileManager.default
}

// MARK: - FileServiceable Impl
extension FileService: FileServiceable {
    
    func fetchRootUrl() -> URL? {
        fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    func createFolder(with name: String, in url: URL) -> Bool {
        let newFolderUrl = url.appendingPathComponent(name)
        do {
            try fileManager.createDirectory(at: newFolderUrl, withIntermediateDirectories: true, attributes: [:])
            return true
        } catch {
            print(error)
            return false
        }
    }
    
    func createFile(with name: String, in url: URL) -> Bool {
        let newFile = url.appendingPathComponent(name)
        return fileManager.createFile(atPath: newFile.path, contents: nil)
    }
    
    func removeFolder(with path: String) -> Bool {
        guard fileManager.fileExists(atPath: path) else {
            return false
        }
        do {
            try fileManager.removeItem(atPath: path)
            return true
        } catch {
            print(error)
            return false
        }
    }
    
    func contentsOfDirectory(at url: URL) -> [URL]? {
        do {
            let urls = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            return urls
         } catch {
             print(error, error.localizedDescription)
             return nil
        }
    }
}
