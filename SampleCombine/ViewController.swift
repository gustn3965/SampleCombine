//
//  ViewController.swift
//  SampleCombine
//
//  Created by hyunsu on 2021/05/16.
//

import UIKit
import Combine
//protocol Subscriber {
//    associatedtype Input
//    associatedtype Failure: Error
//
////    func receive(subscription: Sucription)
//}
//protocol Publisher {
//    associatedtype Output
//    associatedtype Failure: Error
//
//    func subscribe<S: Subscriber>(_ subscriber: S) where S.Input == Output, S.Failure == Failure
//}
//struct LabelPublisher: Publisher {
//    func subscribe<S>(_ subscriber: S) where S : Subscriber, Never == S.Failure, UILabel == S.Input {
//        <#code#>
//    }
//
//    typealias Output = String
//    typealias Failure = Never
//}

class ViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    var publisher: NotificationCenter.Publisher?
    var cancel: AnyCancellable?
    override func viewDidLoad() {
        super.viewDidLoad()
        useCombine()
    }
    
    func useCombine() {

        cancel = NotificationCenter.default.publisher(for: Notification.Name(rawValue: "Name"))
            .compactMap { note  in
                return note.userInfo?["changeName"] as? String
            }
            .assign(to: \.text, on: label)
    }

}

extension ViewController {
    @IBAction func clickButton() {
        let a = String([1,2,3,4,5].randomElement()!)
        print(a)
        NotificationCenter.default.post(name: NSNotification.Name("Name"), object: nil, userInfo: ["changeName" : a])
    }
}

