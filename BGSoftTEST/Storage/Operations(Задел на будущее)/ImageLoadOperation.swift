//
//  ImageProvider.swift
//  BGSoftTEST
//
//  Created by Артур on 29.11.21.
//

import UIKit


func loadPhotos(url: String, completion: @escaping (UIImage?) -> Void) {
    
    
    
    let queue = OperationQueue()
    queue.qualityOfService = .userInteractive
    queue.maxConcurrentOperationCount = 4
    //queue.isSuspended = true
    let imageOperation = ImageLoadOperation(url: url) { image in
        print("Загрузка началась")
        guard let image = image?.resized(withPercentage: 0.5) else { return }
        Networking.imageCashe.setObject(image, forKey: url as NSString)
        print("Загрузка закончилась")
    }
    queue.addOperation(imageOperation)
}

class ImageLoadOperation: AsyncOperation {
    private var url: String?
    fileprivate var outputImage: UIImage?
    var completion: ((UIImage?) -> ())
    weak var task: URLSessionTask?
    
    public init(url: String?, completion: @escaping (UIImage?) -> ()) {
        self.url = url
        self.completion = completion
        super.init()
    }
    
    override public func main() {
        if self.isCancelled {
            return }
        
        guard let imageURL = URL(string: url!) else {return}
        let task = URLSession.shared.dataTask(with: imageURL) { data, _, error in
            if let data = try? Data(contentsOf: imageURL) {
                if let image = UIImage(data: data) {
                    self.outputImage = image
                    self.completion(image)
                }
            }
        }
        task.resume()
        self.task = task
    }
    override func cancel() {
        super.cancel()
        self.state = .finished
        self.task?.cancel()
    }
}


