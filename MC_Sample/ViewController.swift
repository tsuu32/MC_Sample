//
//  ViewController.swift
//  MC_Sample
//
//  Created by Masahiro Nakamura on 2019/10/16.
//  Copyright © 2019 Masahiro Nakamura. All rights reserved.
//


// kMCSessionMinimumNumberOfPeers 2
// kMCSessionMaximumNumberOfPeers 8
// であることから接続グループは最大8人最小2人

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController {
    
    private var session: MCSession?
    private let serviceType = "p2p-test"
 
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        let peerID = MCPeerID(displayName: UIDevice.current.name)
        session = MCSession(peer: peerID)
        session?.delegate = self
    }
    
    @IBAction func startHosting(_ sender: Any) {
        guard let session = session else {
            print("Couldn't create advertiserAssistant")
            return
        }
        let advertiserAssistant = MCAdvertiserAssistant(serviceType: serviceType, discoveryInfo: nil, session: session)
        advertiserAssistant.delegate = self
        advertiserAssistant.start()
    }
    
    @IBAction func joinSession(_ sender: Any) {
        guard let session = session else {
            print("Couldn't create browserViewController")
            return
        }
        let browserViewController = MCBrowserViewController(serviceType: serviceType, session: session)
        browserViewController.delegate = self
        present(browserViewController, animated: true, completion: nil)
    }
}

// MARK: - MCSessionDelegate
extension ViewController: MCSessionDelegate {
    // Called when the state of a nearby peer changes.
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print(#function)
    }
    
    // Indicates that an NSData object has been received from a nearby peer.
    // MCSession の sendに対応
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print(#function)
    }
    
    // Called when a nearby peer opens a byte stream connection to the local peer.
    // MCSession sendStream に対応
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print(#function)
    }
    
    // Indicates that the local peer began receiving a resource from a nearby peer.
    // MCSession sendResource に対応
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print(#function)
    }
    
    // Indicates that the local peer finished receiving a resource from a nearby peer.
    // MCSession sendResource に対応
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        print(#function)
    }
    
    
}

// MARK: - MCAdvertiserAssistantDelegate

extension ViewController: MCAdvertiserAssistantDelegate {
    
}

// MARK: - MCBrowserViewControllerDelegate
extension ViewController: MCBrowserViewControllerDelegate {
    // ユーザがDoneしたとき
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        browserViewController.dismiss(animated: true, completion: nil)
    }
    
    // ユーザがCancelしたとき
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        browserViewController.dismiss(animated: true, completion: nil)
    }

    // UI表示中に新しくピアが見つかったときの処理
    // trueを返すと見つかったピアがUIに反映される
    func browserViewController(_ browserViewController: MCBrowserViewController, shouldPresentNearbyPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) -> Bool {
        return true
    }
}
