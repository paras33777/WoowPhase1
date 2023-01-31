//
//  HomeCategoryView.swift
//  WooW
//
//  Created by Rahul Chopra on 07/05/21.
//

import UIKit

class HomeCategoryView: UIView {

    lazy var label: UILabel = {
        let label = UILabel()
        label.text = "Category"
        label.textColor = .white
        label.font = UIFont(name: "Poppins-SemiBold", size: 18.0)!
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("See All", for: .normal)
        button.setTitleColor(UIColor(named: "AccentColor"), for: .normal)
        button.titleLabel?.font = UIFont(name: "Poppins-SemiBold", size: 15.0)!
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    
    // MARK:- LIFE CYCLE METHODS
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setup() {
        self.backgroundColor = .clear
        self.addSubview(label)
        self.addSubview(button)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12.0),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 5.0),
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: 5.0),
            
            button.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5.0),
            button.centerYAnchor.constraint(equalTo: label.centerYAnchor),
            button.heightAnchor.constraint(equalToConstant: 40.0),
            button.widthAnchor.constraint(equalToConstant: 80.0),
        ])
    }
    
}
