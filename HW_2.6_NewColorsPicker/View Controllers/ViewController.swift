//
//  ViewController.swift
//  HW_2.6_NewColorsPicker
//
//  Created by Vitaly Zubenko on 27.05.2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let setColorVC = segue.destination as! ColorPickerViewController
        setColorVC.delegate = self
        setColorVC.mainViewColor = view.backgroundColor
        // мы создали сначала объект ColorPickerViewController'a
        // затем передали ему объект текущего главного вью экрана
        // затем чтобы передать этот цвет обратно на экран настроек
    }

}

extension ViewController: ColorPickerViewControllerDelegate {
    func sendColor(color: UIColor) {
        self.view.backgroundColor = color
    }
}
