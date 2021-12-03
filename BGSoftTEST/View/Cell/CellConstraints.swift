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
        self.deleteButton.translatesAutoresizingMaskIntoConstraints = false
      //  self.photo.translatesAutoresizingMaskIntoConstraints = false
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
            
            // deleteButton constraints
            deleteButton.widthAnchor.constraint(equalToConstant: 40),
            deleteButton.heightAnchor.constraint(equalToConstant: 40),
            deleteButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            deleteButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),

        ])

    }
}
