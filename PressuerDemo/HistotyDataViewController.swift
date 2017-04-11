//
//  HistotyDataViewController.swift
//  PressuerDemo
//
//  Created by ThienTX on 3/16/17.
//  Copyright © 2017 ThienTX. All rights reserved.
//

import UIKit

class HistotyDataViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var dataList = [Altimeter]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let nibCell = UINib(nibName: "AltimeterTableViewCell", bundle: nil)
        tableView.register(nibCell, forCellReuseIdentifier: "AltimeterTableViewCell")
        
        dataList = altimeterRepo.all()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension HistotyDataViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AltimeterTableViewCell") as? AltimeterTableViewCell
        cell?.pressure.text = String(format:"%.2f In/Hg", dataList[indexPath.row].pressure!)
        cell?.alimeter.text = String(format:"%.2f m", dataList[indexPath.row].alimeterM!)
        cell?.altimeterFt.text = String(format:"%.2f ft", dataList[indexPath.row].alimeterFt!)
        
        return cell!
    }
    
}
