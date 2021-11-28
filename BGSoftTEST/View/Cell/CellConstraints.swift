//
//  Constraints.swift
//  BGSoftTEST
//
//  Created by Артур on 27.11.21.
//

import UIKit

extension PhotoCollectionViewCell {
    
    func constraints() {
        
        self.photoLinkButton.translatesAutoresizingMaskIntoConstraints = false
        self.userLinkButton.translatesAutoresizingMaskIntoConstraints = false
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.photo.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(photoLinkButton)
        stackView.addArrangedSubview(userLinkButton)
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        
        NSLayoutConstraint.activate([
            
            // stackView constraints
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 30),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant: -30),
            stackView.heightAnchor.constraint(equalToConstant: 70),
           
            // label constraints
            label.topAnchor.constraint(equalTo: self.topAnchor,constant: 30),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 30),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant: -30),
//            // photo constraints
           // photo.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            photo.topAnchor.constraint(equalTo: self.topAnchor),
            photo.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            photo.leadingAnchor.constraint(equalTo: self.leadingAnchor),
          //  photo.heightAnchor.constraint(equalToConstant: self.bounds.height),
        //    photo.widthAnchor.constraint(equalToConstant: self.bounds.width),
            photo.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
//        self.imageCenterXLayoutConstraint = NSLayoutConstraint(item: photo!, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0.0)
////      //  self.imageCenterXLayoutConstraint.constant = parallaxOffset
//        self.imageCenterXLayoutConstraint.isActive = true
        
    }
}
