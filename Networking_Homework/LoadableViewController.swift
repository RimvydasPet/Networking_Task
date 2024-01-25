//
//  LoadableViewController.swift
//  Networking_Homework
//
//  Created by Rimvydas on 2023-10-01.
//

import Foundation

import UIKit

class LoadableViewController: UIViewController {
    
    private var activityIndicator: UIActivityIndicatorView?
    private var backgroundView: UIView?
    
    func startLoading() {
        backgroundView = UIView()
        backgroundView?.backgroundColor = .black.withAlphaComponent(0.5)
        activityIndicator = UIActivityIndicatorView()
        activityIndicator?.startAnimating()
        guard let activityIndicator, let backgroundView else {
            return
        }
        
        backgroundView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor).isActive = true
        view.addSubview(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        backgroundView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    func stopLoading() {
        activityIndicator?.removeFromSuperview()
        activityIndicator = nil
        backgroundView?.removeFromSuperview()
        backgroundView = nil
    }
    
}
