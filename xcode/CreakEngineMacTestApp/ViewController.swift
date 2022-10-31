//
//  ViewController.swift
//  CreakEngineMacTestApp
//
//  Created by 김성욱 on 2022/10/31.
//

import Cocoa
import CreakEngineAppKit

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

