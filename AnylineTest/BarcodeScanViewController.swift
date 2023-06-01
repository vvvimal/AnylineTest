//
//  BarcodeScanViewController.swift
//  AnylineTest
//
//  Created by Vimal Venugopalan on 26/05/23.
//

import UIKit
import Anyline

class BarcodeScanViewController: UIViewController, ALScanViewDelegate {
    var scanViewPlugin: ALScanViewPlugin? = nil
    var scanPlugin: ALScanPlugin? = nil
    var scanView: ALScanView? = nil
    var scanViewConfigJSONStr: String = ""
    
    let configJSONFilename = "sample_barcode_config"

    var scannedBarcodes: [String] = []
    @IBOutlet weak var displayTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startScanning()
    }
    
    func initialSetup() {
        guard let jsonStr = self.configJSONStrWith(fileName: configJSONFilename),
              let jsonDict = (jsonStr as NSString).asJSONObject() as? [String : Any] else {
            showAlert(message: "Scan view configuration json file issue.")
            return
        }

        // ScanViewConfig
        guard let scanViewConfig: ALScanViewPluginConfig = .withJSONDictionary(jsonDict) else {
            showAlert(message: "Scan view configuration issue.")
            return
        }
        
        do {
            self.scanViewPlugin = try ALScanViewPlugin(config: scanViewConfig)
        } catch {
            showAlert(message: error.localizedDescription)
        }
        
        self.scanPlugin = self.scanViewPlugin?.scanPlugin
        self.scanPlugin?.delegate = self

        if self.scanView != nil {
            do {
                try self.scanView?.setScanViewPlugin(scanViewPlugin!)
            } catch {
                showAlert(message: error.localizedDescription)
            }
        } else { // create a scanView
            do {
                self.scanView = try .init(frame: .zero,
                                          scanViewPlugin: scanViewPlugin!)
                self.scanView?.delegate = self
                if let scanView = self.scanView {
                    self.installScanView(scanView)
                    self.scanView?.delegate = self
                    self.view.sendSubviewToBack(scanView)
                    scanView.startCamera()
                }
            } catch {
                showAlert(message: error.localizedDescription)
            }
        }
    }
    
    func startScanning() {
        do {
            try self.scanViewPlugin?.start()
        } catch {
            showAlert(message: error.localizedDescription)
        }
    }
    
    func configJSONStrWith(fileName: String) -> NSString? {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            showAlert(message: "File not found")
            return nil
        }
        do {
            let str = try NSString(contentsOf: url, encoding: 4)
            return str
        } catch {
            showAlert(message: error.localizedDescription)
            return nil
        }
    }

    func installScanView(_ scanView: ALScanView) {
        self.view.addSubview(scanView)

        scanView.translatesAutoresizingMaskIntoConstraints = false
        
        scanView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scanView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scanView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        scanView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    func displayResults(_ scanResult: ALScanResult) {
        guard let barcodesFound = scanResult.pluginResult.barcodeResult?.barcodes else {
            showAlert(message: "No Barcodes found")
            return
        }
        
        let barcodeStringArr = barcodesFound.map({$0.value}).filter({ barcodeStr in
            !scannedBarcodes.contains(barcodeStr)
        })
        
        scannedBarcodes.append(contentsOf: barcodeStringArr)
        self.displayTextView.text = scannedBarcodes.joined(separator: ", " )
    }

    func showAlert(title: String? = nil, message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: { _ in
            // Cancel Action
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension BarcodeScanViewController: ALScanPluginDelegate {
    func scanPlugin(_ scanPlugin: ALScanPlugin, resultReceived scanResult: ALScanResult) {
        displayResults(scanResult)
    }
}
