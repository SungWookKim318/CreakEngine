//
//  ViewController.swift
//  CreakInitial
//
//  Created by 김성욱 on 2022/08/27.
//

import Cocoa

class MainViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func createOpenGLAction(_ sender: NSButton) {
        print("try create openGL View")
        let result = renderingView?.createOGLView()
        print("result \(String(describing: result))")
    }
    @IBOutlet private var renderingView: CreakNSView?
}


extension MainViewController {
}
