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
            // photo constraints
            photo.heightAnchor.constraint(equalTo: self.heightAnchor),
            photo.widthAnchor.constraint(equalTo: self.widthAnchor),
        ])
        self.imageCenterXLayoutConstraint = NSLayoutConstraint(item: photo!, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0.0)
    }
}
