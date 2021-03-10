//
//  ViewController.swift
//  Socket
//
//  Created by 陈建蕾 on 2021/3/10.
//

import UIKit
import Starscream

public enum Action: String {
    case connect = "connect"
    case send1 = "send1"
    case send2 = "send2"
    case close = "close"
    case sendName = "sendName"
    case sendTxt = "sendTxt"
}

extension TestViewController: WebSocketDelegate {

    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
        case .text(let txt):
            print(txt)
        case .binary(let data):
            print(data)
        case .error(let error):
            print(error as Any)
        case .cancelled:
            print("cancal")
        case .disconnected(let reason, let code):
            print("reason - \(reason) code - \(code)")
        case .viabilityChanged(let success):
            print("viabilityChanged -- \(success)")
        default:
            break
        }
    }

}

class TestViewController: UITableViewController {
    let arrays: [Action] = {
        return [
            .close,
            .connect,
            .sendName,
            .sendTxt
        ]
    }()

    lazy var socket: WebSocket = {
        var request = URLRequest.init(url: URL.init(string: "http://192.168.1.28:1337")!)
        let s = WebSocket.init(request: request)
        s.delegate = self
        return s
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
    }
}

extension TestViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch arrays[indexPath.row] {
        case .connect:
            socket.connect()
            Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { [weak self] (_) in
                let data = "snh".data(using: .utf8)!
                self?.socket.write(ping: data)
            }.fire()
        case .send1:
            break
        case .send2:
            break
        case .sendName:
            socket.write(string: "cjlsire")
        case .sendTxt:
            let num = "this is test"
            socket.write(string: num)
        case .close:
            socket.disconnect()
        }
    }
}

extension TestViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrays.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self), for: indexPath)
        cell.textLabel?.text = arrays[indexPath.row].rawValue
        return cell
    }
}

class ViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}



