//
//  BookCoverImageView.swift
//  OpenWorm
//
//  Created by Pierre-Jean Quilleré on 2021-10-17.
//

import UIKit

class BookCoverImageView: UIImageView {
    
    #warning("TODO: refactor download code to an ImageDownloader to have a central cache for all images")
    
    static let cache = NSCache<NSString, UIImage>()
    
    private let coverPlaceholder = UIImage(named: "book-cover-placeholder")
    private var loadingTask: URLSessionTask?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(with url: URL?) {
        // reset to placeholder
        image = coverPlaceholder

        guard let url = url else { return }

        let key = url.absoluteString
        if let image = BookCoverImageView.cache.object(forKey: NSString(string: key)) {
            self.image = image
            return
        }

        loadingTask?.cancel()
        loadingTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }

            guard error == nil else { return }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            guard let data = data else { return }

            guard let image = UIImage(data: data) else { return }
            guard image.size != CGSize(width: 1, height: 1) else { return }

            BookCoverImageView.cache.setObject(image, forKey: key as NSString)

            DispatchQueue.main.async {
                self.image = image
            }
        }
        loadingTask?.resume()
    }
    
    private func configure() {
        layer.cornerRadius = 12
        layer.cornerCurve = .continuous
        layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        layer.borderWidth = 1
        
        image = coverPlaceholder
        contentMode = .scaleAspectFill
        clipsToBounds = true
    }
}
