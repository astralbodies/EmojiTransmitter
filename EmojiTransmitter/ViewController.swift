/**
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit
import Starscream

class ViewController: UIViewController {
  @IBOutlet var emojiLabel: UILabel!
  @IBOutlet var usernameLabel: UILabel!
  var username = ""
  
  var socket = WebSocket(url: URL(string: "ws://localhost:1337/")!, protocols: ["chat"])
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    socket.delegate = self
    socket.connect()
    
    navigationItem.hidesBackButton = true
  }

  deinit {
    socket.disconnect(forceTimeout: 0)
  }
  
  @IBAction func selectedEmojiUnwind(unwindSegue: UIStoryboardSegue) {
    if let vc = unwindSegue.source as? CollectionViewController,
      let emoji = vc.selectedEmoji() {
      sendMessage(emoji)
    }
  }
  
  private func sendMessage(_ message: String) {
    socket.write(string: message)
  }
}

extension ViewController : WebSocketDelegate {
  public func websocketDidConnect(_ socket: Starscream.WebSocket) {
    socket.write(string: username)
  }
  
  public func websocketDidDisconnect(_ socket: Starscream.WebSocket, error: NSError?) {
    performSegue(withIdentifier: "websocketDisconnected", sender: self)
  }
  
  /* Message format:
   * {"type":"message","data":{"time":1472513071731,"text":"😍","author":"iPhone Simulator","color":"orange"}}
   */
  public func websocketDidReceiveMessage(_ socket: Starscream.WebSocket, text: String) {
    guard let data = text.data(using: .utf16),
      let jsonData = try? JSONSerialization.jsonObject(with: data, options: []),
      let jsonDict = jsonData as? NSDictionary,
      let messageType = jsonDict["type"] as? String else {
        return
    }
    
    if messageType == "message",
      let messageData = jsonDict["data"] as? NSDictionary,
      let messageAuthor = messageData["author"] as? String,
      let messageText = messageData["text"] as? String {
      emojiLabel.text = messageText
      usernameLabel.text = messageAuthor
    }
    
  }
  
  public func websocketDidReceiveData(_ socket: Starscream.WebSocket, data: Data) {
    
  }
}

