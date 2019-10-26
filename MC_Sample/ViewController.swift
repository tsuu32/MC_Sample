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
    
    var peerID :MCPeerID!
    var session: MCSession!
    let serviceType = "mc-message"
    var advertiserAssistant: MCAdvertiserAssistant!
    var browserViewController: MCBrowserViewController!

    @IBOutlet weak var textField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        peerID = MCPeerID(displayName: UIDevice.current.name)
        session = MCSession(peer: peerID)
        session.delegate = self

        advertiserAssistant = MCAdvertiserAssistant(serviceType: serviceType, discoveryInfo: nil, session:
            session)
        advertiserAssistant.delegate = self

        browserViewController = MCBrowserViewController(serviceType: serviceType, session: session)
        browserViewController.delegate = self

        textField.delegate = self
    }

    @IBAction func startHosting(_ sender: Any) {
        advertiserAssistant.start()
        print(#function)
    }

    @IBAction func joinSession(_ sender: Any) {
        present(browserViewController, animated: true, completion: nil)
        print(#function)
    }

    @IBAction func sendMessage(_ sender: Any) {
        guard let session = session else {
            print("Couldn't send Message")
            return
        }
        guard let message = textField.text, !message.isEmpty else { return }
        do {
            let data = message.data(using: String.Encoding.utf8)
            try session.send(data!, toPeers: session.connectedPeers, with: MCSessionSendDataMode.reliable)
        } catch let error {
            print(error.localizedDescription)
        }
        print(#function)
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
        guard let message = String(data: data, encoding: String.Encoding.utf8) else { return }
        textField.text = message
    }
    
    // Called when a nearby peer opens a byte stream connection to the local peer.
    // MCSession sendStream に対応
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print(#function)
        // Do nothing
    }
    
    // Indicates that the local peer began receiving a resource from a nearby peer.
    // MCSession sendResource に対応
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print(#function)
        // Do nothing
    }
    
    // Indicates that the local peer finished receiving a resource from a nearby peer.
    // MCSession sendResource に対応
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        print(#function)
        // Do nothing
    }
}

// MARK: - MCAdvertiserAssistantDelegate

extension ViewController: MCAdvertiserAssistantDelegate {
    func advertiserAssistantDidDismissInvitation(_ advertiserAssistant: MCAdvertiserAssistant) {
        print(#function)
    }
    
    func advertiserAssistantWillPresentInvitation(_ advertiserAssistant: MCAdvertiserAssistant) {
        print(#function)
    }
}

// MARK: - MCBrowserViewControllerDelegate
extension ViewController: MCBrowserViewControllerDelegate {
    // ユーザがDoneしたとき
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // ユーザがCancelしたとき
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }

    // UI表示中に新しくピアが見つかったときの処理
    // trueを返すと見つかったピアがUIに反映される
    func browserViewController(_ browserViewController: MCBrowserViewController, shouldPresentNearbyPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) -> Bool {
        return true
    }
}

// MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
