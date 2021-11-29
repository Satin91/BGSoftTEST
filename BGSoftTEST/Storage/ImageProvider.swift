//
//  ImageProvider.swift
//  BGSoftTEST
//
//  Created by Артур on 29.11.21.
//

import UIKit

public class ImageProvider {
    
    private var operationQueue = OperationQueue ()
    var imageURLString: String = ""
    
    public init(imageURLString: String,completion: @escaping (UIImage?) -> ()) {
        operationQueue.isSuspended = false
        operationQueue.maxConcurrentOperationCount = 50
        operationQueue.qualityOfService = .userInitiated
        
        // Создаем operations
        let dataLoad = ImageLoadOperation(url: imageURLString)
        
        let operations = [dataLoad]
        
        
        operationQueue.addOperations(operations, waitUntilFinished: false)
    }
    public func start() {
        operationQueue.isSuspended = false
    }
    
    public func cancel() {
        operationQueue.cancelAllOperations()
    }
    public func wait() {
        operationQueue.waitUntilAllOperationsAreFinished()
    }
}

class ImageLoadOperation: AsyncOperation {
    private var url: String?
    fileprivate var outputImage: UIImage?
    
    public init(url: String?) {
        self.url = url
        super.init()
    }
    
    override public func main() {
        if self.isCancelled { return}
        
        guard let imageURL = URL(string: url!) else {return}
        
        let task = URLSession.shared.dataTask(with: imageURL){(data, response, error) in
            if self.isCancelled { return }
            if let data = data,
               let imageData = UIImage(data: data) {
                if self.isCancelled { return }
                self.outputImage = imageData
                print(self.outputImage)
                PhotoStorage.imageCashe.setObject(imageData, forKey: self.url! as NSString)
            }
            self.state = .finished
        }
        task.resume()
    }
}



extension AsyncOperation {
    
    override var isReady: Bool {
        return super.isReady && state == .ready
    }
    
    override var isExecuting: Bool {
        return state == .executing
    }
    
    override var isFinished: Bool {
        return state == .finished
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    override func start() {
        if isCancelled {
            state = .finished
            return
        }
        main()
        state = .executing
    }
    override func cancel() {
        super.cancel()
        state = .finished
    }
}
class AsyncOperation: Operation {
    
    public enum State: String {
        case ready
        case executing
        case finished
        
        var keyPath: String {
            return "is" + rawValue.capitalized
        }
    }
    
    public var state = State.ready {
        willSet {
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }
        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }
}



