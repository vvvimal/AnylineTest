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
            print("error: unable to find JSON config")
            showAlert(message: "Scan view configuration json file issue.")
            return
        }

        // ScanViewConfig
        guard let scanViewConfig: ALScanViewPluginConfig = .withJSONDictionary(jsonDict) else {
            print("error: scan view config")
            showAlert(message: "Scan view configuration issue.")
            return
        }
        
        do {
            self.scanViewPlugin = try ALScanViewPlugin(config: scanViewConfig)
        } catch {
            print("unable to set scan view plugin: \(error.localizedDescription)")
            showAlert(message: error.localizedDescription)
        }
        
        self.scanPlugin = self.scanViewPlugin?.scanPlugin
        self.scanPlugin?.delegate = self

        if self.scanView != nil {
            do {
                try self.scanView?.setScanViewPlugin(scanViewPlugin!)
            } catch {
                print("unable to set scan view plugin: \(error.localizedDescription)")
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
                print("unable to instantiate scan view: \(error.localizedDescription)")
                showAlert(message: error.localizedDescription)
            }
        }
    }
    
    func startScanning() {
        do {
            try self.scanViewPlugin?.start()
        } catch {
            print("unable to instantiate scan view: \(error.localizedDescription)")
            showAlert(message: error.localizedDescription)
        }
    }
    
    func configJSONStrWith(fileName: String) -> NSString? {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
            print("Error: File not found.")
            showAlert(message: "File not found")
            return nil
        }
        do {
            let str = try NSString(contentsOf: url, encoding: 4)
            return str
        } catch {
            print("Error: \(error.localizedDescription)")
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
        self.scanViewPlugin?.stop()
        guard let barcodesFound = scanResult.pluginResult.barcodeResult?.barcodes else {
            print("No Barcodes found")
            return
        }
        
        var resultData = [ALResultEntry]()
        for barcode in barcodesFound {
            resultData.append(ALResultEntry.init(title: "Barcode Result", value: barcode.value, shouldSpellOutValue: true))
            resultData.append(ALResultEntry.init(title: "Barcode Symbology", value: barcode.format, shouldSpellOutValue: true))
        }
        if barcodesFound.count < 1 {
            return
        }
        
        let barcodeImage = scanResult.croppedImage

        let resultVC: ALResultViewController = .init(results: resultData)
        resultVC.imagePrimary = barcodeImage
        self.navigationController?.pushViewController(resultVC, animated: true)

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
        print("Scan Result: ", scanResult.pluginResult.barcodeResult ?? "")
        displayResults(scanResult)
    }
}
