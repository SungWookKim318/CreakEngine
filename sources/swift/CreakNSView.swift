//
//  CreakNSView.swift
//  CreakInitial
//
//  Created by 김성욱 on 2022/08/27.
//

import Foundation
import AppKit
import MetalKit
import CreakCoreAppKit

public class CreakNSView: NSView {
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
    
    public override func awakeFromNib() {
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
    
    public func createMetalView() -> Bool {
        guard rendererView == nil else {
            print("Already exist view")
            return false
        }
        let mtkView = MTKView()
        mtkView.device = MTLCreateSystemDefaultDevice()
        if self.rendererMetal == nil {
            self.rendererMetal = CreakCoreMetalRenderer(metalKitView: mtkView, size: self.layer?.bounds.size ?? .zero)
        }
        self.addSubview(mtkView)
        mtkView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mtkView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mtkView.topAnchor.constraint(equalTo: self.topAnchor),
            mtkView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mtkView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        self.rendererView = mtkView
        return true
    }
    
    public func deleteRenderView() {
        rendererView?.removeFromSuperview()
        rendererMetal = nil
        rendererView = nil
    }
    
    private(set) var rendererView: NSView?
    private(set) var rendererMetal: CreakCoreMetalRenderer?
}

private extension CreakNSView {
    private func setup() {
    }
}
