//
//  CityCellViewModel.swift
//  Cities App
//
//  Created by Iaroslav Shkliar on 03/08/2020.
//  Copyright © 2020 Iaroslav Shkliar. All rights reserved.
//

import UIKit

protocol CityCellViewModelProtocol {
    var title: String { get }
    var isFavorite: Bool { get }

    func retrieveImage(completion: @escaping (UIImage?) -> Void)
    func cancelRetrieving()
}

final class CityCellViewModel: CityCellViewModelProtocol {

    // MARK: - Private properties

    private let city: City
    private var task: URLSessionDataTask?
    private var image: UIImage?

    // MARK: - Properties

    var title: String { city.name }
    var id: String { city.id }
    var subtitle: String { city.country }
    var isFavorite: Bool

    // MARK: - Init

    init(city: City, isFavorite: Bool) {
        self.city = city
        self.isFavorite = isFavorite
    }

    // MARK: - Methods

    func retrieveImage(completion: @escaping (UIImage?) -> Void) {
        if let image = image {
            completion(image)
        } else {
            let task = URLSession.shared.dataTask(with: city.image) { data, _, _ in
                guard let data = data, let image = UIImage(data: data) else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                    return
                }

                DispatchQueue.main.async {
                    completion(image)
                }

                self.image = image
            }

            self.task = task
            task.resume()
        }
    }

    func cancelRetrieving() {
        task?.cancel()
    }
}
