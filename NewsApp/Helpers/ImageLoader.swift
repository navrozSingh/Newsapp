//
//  ImageDownloader.swift
//  NewsApp
//
//  Created by Navroz on 26/03/20.
//  Copyright © 2020 Navroz. All rights reserved.
//

import Combine
import UIKit
import SwiftUI
class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    
    private(set) var isLoading = false
    
    private let url: URL?
    private var cache: ImageCache?
    private var cancellable: AnyCancellable?
    
    private static let imageProcessingQueue = DispatchQueue(label: "image-processing")
    
    init(url: URL, cache: ImageCache? = nil) {
        self.url = url
        self.cache = cache
    }
    init(img: UIImage, cache: ImageCache? = nil) {
        self.image = img
        self.cache = cache
        self.url = nil
    }
    deinit {
        cancellable?.cancel()
    }
    
    func load() {
        guard !isLoading, let url = url else { return }

        if let image = cache?[url] {
            self.image = image
            return
        }
        
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .handleEvents(receiveSubscription: { [weak self] _ in self?.onStart() },
                          receiveOutput: { [weak self] in self?.cache($0) },
                          receiveCompletion: { [weak self] _ in self?.onFinish() },
                          receiveCancel: { [weak self] in self?.onFinish() })
            .subscribe(on: Self.imageProcessingQueue)
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
    }
    
    func cancel() {
        cancellable?.cancel()
    }
    
    private func onStart() {
        isLoading = true
    }
    
    private func onFinish() {
        isLoading = false
    }
    
    private func cache(_ image: UIImage?) {
        guard let url = url else {
            return
        }
        image.map { cache?[url] = $0 }
    }
}
//-----------
struct ImageCacheKey: EnvironmentKey {
    static let defaultValue: ImageCache = TemporaryImageCache()
}

extension EnvironmentValues {
    var imageCache: ImageCache {
        get { self[ImageCacheKey.self] }
        set { self[ImageCacheKey.self] = newValue }
    }
}
//----------------
protocol ImageCache {
    subscript(_ url: URL) -> UIImage? { get set }
}

struct TemporaryImageCache: ImageCache {
    private let cache = NSCache<NSURL, UIImage>()
    
    subscript(_ key: URL) -> UIImage? {
        get { cache.object(forKey: key as NSURL) }
        set { newValue == nil ? cache.removeObject(forKey: key as NSURL) : cache.setObject(newValue!, forKey: key as NSURL) }
    }
}
//-----------------
struct AsyncImage: View {
    @ObservedObject private var loader: ImageLoader
    private let configuration: (Image) -> Image
    
    init(urlString: String?, cache: ImageCache? = nil, configuration: @escaping (Image) -> Image = { $0 }) {
        if let urLString = urlString, let url = URL(string: urLString)  {
            loader = ImageLoader(url: url, cache: cache)
        } else {
            guard let image = UIImage(named: "Placholder") else { fatalError("Add Placholder image in asset") }
            loader = ImageLoader(img: image, cache: cache)
        }
        self.configuration = configuration
    }
    
    var body: some View {
        image
            .onAppear(perform: loader.load)
            .onDisappear(perform: loader.cancel)
    }
    
    private var image: some View {
     //   GeometryReader{ geo in
            Group {
                if self.loader.image != nil {
                    self.configuration(Image(uiImage: self.loader.image!))
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipped()
                } else {
                    Image(systemName: "Placholder")
                }
            }
    //    }
    }
}



//import SwiftUI
//import Combine
//public class ViewLoader: ObservableObject {
//
//    @Published var data = Data()
//    let url:String
//    public init(url:String){
//        self.url = url
//    }
//    public func loadData() {
//        guard let url = URL(string:url) else {
//            return
//        }
//        if let cachedData = URlSession.handler.cache.object(forKey: url as AnyObject) as? Data {
//            self.data = cachedData
//        } else {
//            URLSession.shared.dataTask(with: url){(data,_,_) in
//                guard let data = data else {return}
//                DispatchQueue.main.async {
//                    self.data = data
//                    URlSession.handler.cache.setObject(data as AnyObject , forKey: url as AnyObject)
//
//                }
//            }.resume()
//        }
//    }
//
//    public func getData() -> Data {
//        return data
//    }
//
//    public func getUrl() -> String {
//        return url
//    }
//}
//
//public struct ViewWithActivityIndicator<Content:View> : View {
//
//    private let style: UIActivityIndicatorView.Style = .medium
//
//    @ObservedObject private var viewLoader:ViewLoader
////    private var content: () -> Content
//    private let placeHolder:String
//    private let showActivityIndicator:Bool
//    @State private var downloadingImage = true
//
//    public init(placeHolder: String = "Placholder",showActivityIndicator:Bool = true, viewLoader:ViewLoader, @ViewBuilder _ content: @escaping () -> Content){
//        self.placeHolder = placeHolder
//        self.showActivityIndicator = showActivityIndicator
//        self.viewLoader = viewLoader
////        self.content = content
//    }
//
//    public var body: some View {
//            ZStack(){
//                if  (viewLoader.data.isEmpty) {
//                    if (placeHolder != "") {
//                        Image(placeHolder)
//                            .resizable()
//                            .scaledToFit()
//                    }
//                    if showActivityIndicator {
//                        ActivityIndicator(shouldAnimate: $downloadingImage)
//                    }
//                }
//                else{
//                    content()
//                }
//            }.onAppear(perform: loadImage)
//    }
//
//    private  func loadImage() {
//        self.viewLoader.loadData()
//    }
//
//}
//import SwiftUI
//import Combine
//import Foundation
//
//class ImageDownloader: ObservableObject {
//    @Published var img: UIImage
//    init(_ urlString: String?) {
//        guard let placholderImage = UIImage(named: "Placholder") else {fatalError("Add Placholder image to assest")}
//        img = placholderImage
//        guard let urlString = urlString, let url = URL(string: urlString) else { return }
//        if let image = URlSession.handler.cache.object(forKey: url as AnyObject) as? UIImage {
//            img = image
//        } else {
//            downloadFromURL(url)
//        }
//    }
//    fileprivate func downloadFromURL(_ url: URL) {
//        DispatchQueue.global().async { [weak self] in
//            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
//                URlSession.handler.cache.setObject(image as AnyObject , forKey: url as AnyObject)
//                self?.img = image
//            }
//        }
//    }
//}

//
//
//final class ImageCache {
//
//    // 1st level cache, that contains encoded images
//    private lazy var imageCache: NSCache<AnyObject, AnyObject> = {
//        let cache = NSCache<AnyObject, AnyObject>()
//        cache.countLimit = config.countLimit
//        return cache
//    }()
//    // 2nd level cache, that contains decoded images
//    private lazy var decodedImageCache: NSCache<AnyObject, AnyObject> = {
//        let cache = NSCache<AnyObject, AnyObject>()
//        cache.totalCostLimit = config.memoryLimit
//        return cache
//    }()
//    private let lock = NSLock()
//    private let config: Config
//
//    struct Config {
//        let countLimit: Int
//        let memoryLimit: Int
//
//        static let defaultConfig = Config(countLimit: 100, memoryLimit: 1024 * 1024 * 100) // 100 MB
//    }
//
//    init(config: Config = Config.defaultConfig) {
//        self.config = config
//    }
//}


//import Foundation
//import UIKit.UIImage
//import Combine
//
//public final class ImageLoader : ObservableObject {
//    public static let shared = ImageLoader()
//
//    private let cache: ImageCacheType
//    private lazy var backgroundQueue: OperationQueue = {
//        let queue = OperationQueue()
//        queue.maxConcurrentOperationCount = 5
//        return queue
//    }()
//
//    public init(cache: ImageCacheType = ImageCache()) {
//        self.cache = cache
//    }
//
//    public func loadImage(from url: URL) -> AnyPublisher<UIImage, Never> {
//        if let image = cache[url] {
//            return Just(image).eraseToAnyPublisher()
//        }
//        return URLSession.shared.dataTaskPublisher(for: url)
//            .map { (data, response) -> UIImage? in return UIImage(data: data)  }
//            .catch { error in return Just(UIImage(named: "Placholder")) }
//            .handleEvents(receiveOutput: {[unowned self] image in
//                guard let image = image else { return }
//                self.cache[url] = image
//            })
//            .print("Image loading \(url):")
//            .subscribe(on: backgroundQueue)
//            .receive(on: RunLoop.main)
//            .eraseToAnyPublisher()
//    }
//}
//
//
//
//public protocol ImageCacheType: class {
//    // Returns the image associated with a given url
//    func image(for url: URL) -> UIImage?
//    // Inserts the image of the specified url in the cache
//    func insertImage(_ image: UIImage?, for url: URL)
//    // Removes the image of the specified url in the cache
//    func removeImage(for url: URL)
//    // Removes all images from the cache
//    func removeAllImages()
//    // Accesses the value associated with the given key for reading and writing
//    subscript(_ url: URL) -> UIImage? { get set }
//}
//
//public final class ImageCache: ImageCacheType {
//
//    // 1st level cache, that contains encoded images
//    private lazy var imageCache: NSCache<AnyObject, AnyObject> = {
//        let cache = NSCache<AnyObject, AnyObject>()
//        cache.countLimit = config.countLimit
//        return cache
//    }()
//    // 2nd level cache, that contains decoded images
//    private lazy var decodedImageCache: NSCache<AnyObject, AnyObject> = {
//        let cache = NSCache<AnyObject, AnyObject>()
//        cache.totalCostLimit = config.memoryLimit
//        return cache
//    }()
//    private let lock = NSLock()
//    private let config: Config
//
//    public struct Config {
//        public let countLimit: Int
//        public let memoryLimit: Int
//
//        public static let defaultConfig = Config(countLimit: 100, memoryLimit: 1024 * 1024 * 100) // 100 MB
//    }
//
//    public init(config: Config = Config.defaultConfig) {
//        self.config = config
//    }
//
//    public func image(for url: URL) -> UIImage? {
//        lock.lock(); defer { lock.unlock() }
//        // the best case scenario -> there is a decoded image in memory
//        if let decodedImage = decodedImageCache.object(forKey: url as AnyObject) as? UIImage {
//            return decodedImage
//        }
//        // search for image data
//        if let image = imageCache.object(forKey: url as AnyObject) as? UIImage {
//            let decodedImage = image.decodedImage()
//            decodedImageCache.setObject(image as AnyObject, forKey: url as AnyObject, cost: decodedImage.diskSize)
//            return decodedImage
//        }
//        return nil
//    }
//
//    public func insertImage(_ image: UIImage?, for url: URL) {
//        guard let image = image else { return removeImage(for: url) }
//        let decompressedImage = image.decodedImage()
//
//        lock.lock(); defer { lock.unlock() }
//        imageCache.setObject(decompressedImage, forKey: url as AnyObject, cost: 1)
//        decodedImageCache.setObject(image as AnyObject, forKey: url as AnyObject, cost: decompressedImage.diskSize)
//    }
//
//    public func removeImage(for url: URL) {
//        lock.lock(); defer { lock.unlock() }
//        imageCache.removeObject(forKey: url as AnyObject)
//        decodedImageCache.removeObject(forKey: url as AnyObject)
//    }
//
//    public func removeAllImages() {
//        lock.lock(); defer { lock.unlock() }
//        imageCache.removeAllObjects()
//        decodedImageCache.removeAllObjects()
//    }
//
//    public subscript(_ key: URL) -> UIImage? {
//        get {
//            return image(for: key)
//        }
//        set {
//            return insertImage(newValue, for: key)
//        }
//    }
//}
//
//fileprivate extension UIImage {
//
//    func decodedImage() -> UIImage {
//        guard let cgImage = cgImage else { return self }
//        let size = CGSize(width: cgImage.width, height: cgImage.height)
//        let colorSpace = CGColorSpaceCreateDeviceRGB()
//        let context = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: cgImage.bytesPerRow, space: colorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
//        context?.draw(cgImage, in: CGRect(origin: .zero, size: size))
//        guard let decodedImage = context?.makeImage() else { return self }
//        return UIImage(cgImage: decodedImage)
//    }
//
//    // Rough estimation of how much memory image uses in bytes
//    var diskSize: Int {
//        guard let cgImage = cgImage else { return 0 }
//        return cgImage.bytesPerRow * cgImage.height
//    }
//}
