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

final class UsernameViewController : UIViewController {
  @IBOutlet var nextButtonItem: UIBarButtonItem!
  var username = ""
  
  @IBAction func usernameDidChange(textField: UITextField) {
    if let text = textField.text {
      let hasText = text.characters.count > 0
      nextButtonItem.isEnabled = hasText
      username = text
    } else {
      nextButtonItem.isEnabled = false
      username = ""
    }
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "usernameSelected",
      let viewController = segue.destination as? ViewController {
      viewController.username = username
    }
  }

  @IBAction func websocketDisconnectedUnwind(unwindSegue: UIStoryboardSegue) {
    username = ""
    nextButtonItem.isEnabled = false
  }
}
