//
//  CreakNSView.swift
//  CreakInitial
//
//  Created by 김성욱 on 2022/08/27.
//

import Foundation
import AppKit

class CreakNSView: NSView {
    init() {
        super.init(frame: .zero)
        self.setup()
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        self.setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func createOGLView() -> Bool {
        guard rendererView == nil else {
            print("Already exist view")
            return false
        }
        let oglView = CreakOglNSView()
        oglView.useHiDPI = true
//        oglView.autoresizingMask = .none
        self.addSubview(oglView)
        oglView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            oglView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            oglView.topAnchor.constraint(equalTo: self.topAnchor),
            oglView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            oglView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        self.rendererView = oglView
        return true
    }
    
    public func deleteOGLView() {
        rendererView?.removeFromSuperview()
        rendererView = nil
    }
    
    private var rendererView: CreakOglNSView?
}

private extension CreakNSView {
    private func setup() {
    }
}
