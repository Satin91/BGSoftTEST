//
//  PhotoModel.swift
//  BGSoftTEST
//
//  Created by Артур on 25.11.21.
//

import Foundation
import UIKit


class PhotoStorage {
    
    let jsonFileURL = "http://dev.bgsoft.biz/task/credits.json"
    let queue = Queue()
    
    //: MARK: Кэш для фотографий
    
    static var imageCashe = NSCache<AnyObject,AnyObject>()
    
    //: MARK: Создает очередь для асинхронной загрузки фотографий
    
    fileprivate func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    var ip = [ImageProvider]()
    //: MARK: Загружает фотографию
    
    func loadPhoto(from url: String, completion: @escaping (UIImage) -> Void) {
        guard let imageURL = URL(string: url) else { return }
        if PhotoStorage.imageCashe.object(forKey: url as NSString) == nil {
            self.getData(from: imageURL) { data, response, error in
                guard let data = data, error == nil else { return }
                guard let image = UIImage(data: data)?.resized(withPercentage: 0.7) else { return }
                PhotoStorage.imageCashe.setObject(image as UIImage, forKey: url as NSString)
             //   print(url)
                completion(image)
            }
        }
    }

    //MARK: Возвращает массиив с моделями фотографий
   
    func getPhotos() -> [PhotoModel]{
        var sortedPhotoCollection: [PhotoModel] = []
        
        
        do {
            if let file = URL(string: self.jsonFileURL) {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                guard let object = json as? [String: Any] else { return [] }
                for dict in object {
                    let photoModel = PhotoModel(dictionary: dict.value as! [String:Any], name: dict.key)
                    sortedPhotoCollection.append(photoModel)
                }
                // Сортировка по имени
                sortedPhotoCollection.sort{ ($0.user_name < $1.user_name) }
                        for model in sortedPhotoCollection {
                            
                            let url = "http://dev.bgsoft.biz/task/" + model.name + ".jpg"
                            ip.append(ImageProvider(imageURLString: url, completion: { image in
                                OperationQueue.main.addOperation {
                                   
                                    //PhotoStorage.imageCashe.setObject(image as UIImage, forKey: url as NSString)
                                }
                            }))
//                                self.loadPhoto(from: url) { image in
//                                }

                            model.imageURL = url
                        }
                
            }
        } catch {
            print(error.localizedDescription)
        }
        for i in ip {
            i.start()
        }
        guard !sortedPhotoCollection.isEmpty else { return [] }
        let firstHalf = sortedPhotoCollection
        // Добавляет первый элемент в конец массива для того, чтобы с него перешагнуть на первый ( такой же )
        sortedPhotoCollection.append(sortedPhotoCollection.first!)
        let totalArray = firstHalf + sortedPhotoCollection
        return totalArray
    }
}

extension UIImageView {
    func assignPhoto(imageUrl: String, completion: @escaping (Bool)-> Void ) {
        guard URL(string: imageUrl) != nil else { return }
        if let image = PhotoStorage.imageCashe.object(forKey: imageUrl as NSString) as? UIImage {
            self.image = image
            return
        }
//
//        DispatchQueue.global(qos: .userInteractive).async {
//            PhotoStorage().loadPhoto(from: imageUrl) { img in
//                    PhotoStorage.imageCashe.setObject(img, forKey: imageUrl as NSString)
//                DispatchQueue.main.async {
//                    self.image = img
//                    print("Completion \(imageUrl)")
//                    completion(true)
//                }
//        }
//        }
     
}
}



public class Filter : ImageTakeOperation {
    
    override public func main() {
        if isCancelled { return }
        guard let inputImage = inputImage else { return }
 
        if isCancelled { return }
        outputImage =  inputImage.resized(withPercentage: 0.5)
    }
}



public class ImageProvider {
private var operationQueue = OperationQueue ()
    
   public init(imageURLString: String,completion: @escaping (UIImage?) -> ()) {
        operationQueue.isSuspended = true
        operationQueue.maxConcurrentOperationCount = 10
        
        if let imageURL = URL(string: imageURLString){
            
            // Создаем operations
            let dataLoad = ImageLoadOperation(url: imageURL)
           
            let filter = Filter(image: nil)
            let output = ImageOutputOperation(){image in
                OperationQueue.main.addOperation {completion (image)
                    
                    
                }}
            
            let operations = [dataLoad, filter, output]
            
            // Добавляем dependencies
            filter.addDependency(dataLoad)
            output.addDependency(filter)
            
            operationQueue.addOperations(operations, waitUntilFinished: false)
        }
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
   private var url: URL?
   fileprivate var outputImage: UIImage?
   
   public init(url: URL?) {
       self.url = url
       super.init()
      
   }
   
   override public func main() {
       if self.isCancelled { return}
       
       guard let imageURL = url else {return}
       
       let task = URLSession.shared.dataTask(with: imageURL){(data, response, error) in
           if self.isCancelled { return }
           if let data = data,
               let imageData = UIImage(data: data) {
               if self.isCancelled { return }
               self.outputImage = imageData
               
             //  PhotoStorage.imageCashe.setObject(<#T##obj: AnyObject##AnyObject#>, forKey: <#T##AnyObject#>)
           }
           self.state = .finished
       }
       task.resume()
   }
}

public class ImageOutputOperation: ImageTakeOperation {
    
    private let completion: (UIImage?) -> ()
    
    public init(completion: @escaping (UIImage?) -> ()) {
        
        self.completion = completion
        super.init(image: nil)
    }
    
    override public func main() {
        if isCancelled { return }
        completion(inputImage)
        print(inputImage)
    }
}


protocol ImagePass {
    var image: UIImage? { get }
}

open class ImageTakeOperation: Operation {
    var outputImage: UIImage?
    private let _inputImage: UIImage?
    
    public init(image: UIImage?) {
        _inputImage = image
        super.init()
    }
    
    public var inputImage: UIImage? {
        var image: UIImage?
        if let inputImage = _inputImage {
            image = inputImage
        } else if let dataProvider = dependencies
            .filter({ $0 is ImagePass })
            .first as? ImagePass {
            image = dataProvider.image
        }
        return image
    }
}

extension ImageTakeOperation: ImagePass {
    var image: UIImage? {
        return outputImage
    }
}








class ArraySumOperation: Operation {
   let inputArray: [(Int,Int)]
   var outputArray = [Int]()
   
   init(input: [(Int, Int)]) {
       inputArray = input
       super.init()
   }
   public func slowAdd(_ input: (Int, Int)) -> Int {
       sleep(1)
       return input.0 + input.1
   }
   
   override func main() {
       for pair in inputArray {
           if isCancelled { return }
           outputArray.append(slowAdd(pair))
       }
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




