//
//  ViewController.swift
//  ImageCaching
//
//  Created by Mani on 08/05/24.
//

import UIKit

class ViewController: UIViewController {
    
    private var viewModel = ImageListViewModel()
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let nib = UINib(nibName: "ImageCollectionViewCell", bundle: nil)
        imageCollectionView?.register(nib, forCellWithReuseIdentifier: "ImageCollectionViewCell")
        
        // Fetch images
        viewModel.fetchImages { [weak self] result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self?.imageCollectionView.reloadData()
                }
            case .failure(let error):
                print("Failed to fetch images: \(error)")
            }
        }
        
    }

}


extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width/3)-10
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.mediaItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        
        // Load image using ImageCacheManager
        if let imageURL = viewModel.mediaItem[indexPath.row].generateImageURL() {
            print(imageURL)
            ImageCacheManager.shared.loadImage(from: imageURL) { image in
                DispatchQueue.main.async {
                    // Check if the cell is still displaying the same mediaItem
                    if let currentIndexPath = collectionView.indexPath(for: cell),
                       currentIndexPath == indexPath {
                        cell.siteImageView.image = image
                    }
                }
            }
        }
        
        return cell
    }
}
