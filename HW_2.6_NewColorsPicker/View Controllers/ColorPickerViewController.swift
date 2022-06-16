//
//  ColorPickerViewController.swift
//  HW_2.6_NewColorsPicker
//
//  Created by Vitaly Zubenko on 28.05.2022.
//
// лучше использовать navigation controller, так как цвет будет заполнять полностью всё вместе с тапбаром
// и надо добавить/научиться обрабатывать ошибки и непредусмотренные вводы - L2.7

import UIKit

protocol ColorPickerViewControllerDelegate: AnyObject {
    func sendColor(color: UIColor)
}

class ColorPickerViewController: UIViewController {
    
    @IBOutlet var colorBoxView: UIView!
    
    @IBOutlet var redLabel: UILabel!
    @IBOutlet var greenLabel: UILabel!
    @IBOutlet var blueLabel: UILabel!
    
    @IBOutlet var redSlider: UISlider!
    @IBOutlet var greenSlider: UISlider!
    @IBOutlet var blueSlider: UISlider!
    
    @IBOutlet var redTextField: UITextField!
    @IBOutlet var greenTextField: UITextField!
    @IBOutlet var blueTextField: UITextField!
    
    weak var delegate: ColorPickerViewControllerDelegate?
    var mainViewColor: UIColor!
    // мы создали переменную для хранения текущего цвета
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorBoxView.layer.cornerRadius = 10
        
        redSlider.minimumTrackTintColor = .red
        greenSlider.minimumTrackTintColor = .green
        
        // возвращаем цвет из главного экрана или белый
        colorBoxView.backgroundColor = mainViewColor
        
        setSliders()
        setValue(for: redLabel, greenLabel, blueLabel)
        setValue(for: redTextField, greenTextField, blueTextField)
        addDoneButtonToKeyboard(for: redTextField, greenTextField, blueTextField)
    }
    
    // сам главный экшен для изменения цветов
    @IBAction func slidersActions(_ sender: UISlider) {
        setColor()
        
        switch sender.tag {
        case 0:
            setValue(for: redLabel)
            setValue(for: redTextField)
        case 1:
            setValue(for: greenLabel)
            setValue(for: greenTextField)
        case 2:
            setValue(for: blueLabel)
            setValue(for: blueTextField)
        default: break
        }
    }
    
    @IBAction func textFieldsActions(_ sender: UITextField) {
        switch sender.tag {
        case 0:
            redSlider.value = (sender.text! as NSString).floatValue
        case 1:
            greenSlider.value = (sender.text! as NSString).floatValue
        case 2:
            blueSlider.value = (sender.text! as NSString).floatValue
        default: break
        }
        
        setColor()
    }
    
    // цвет вью
    private func setColor() {
        colorBoxView.backgroundColor = UIColor(
            red: CGFloat(redSlider.value) / 255,
            green: CGFloat(greenSlider.value) / 255,
            blue: CGFloat(blueSlider.value) / 255,
            alpha: 1)
    }
    
    // для начального состояния лейблов
    // поменяю названия обеих функций на setValue просто, так можно, если названия параметров - разные
    private func setValue(for labels: UILabel...) {
        labels.forEach { label in
            switch label.tag {
            case 0: redLabel.text = string(from: redSlider)
            case 1: greenLabel.text = string(from: greenSlider)
            case 2: blueLabel.text = string(from: blueSlider)
            default: break
            }
        }
    }
    
    // для начального состояния текстфилдов
    private func setValue(for textFields: UITextField...) {
        textFields.forEach { textField in
            switch textField.tag {
            case 0: redTextField.text = string(from: redSlider)
            case 1: greenTextField.text = string(from: greenSlider)
            case 2: blueTextField.text = string(from: blueSlider)
            default: break
            }
        }
    }
    
    // теперь надо сделать чтобы слайдеры и лейблы отображали цвет (значения цвета) сохраненный в переменной цвета из первого экрана
    private func setSliders() {
        let ciColor = CIColor(color: mainViewColor)
        // CIColor разделяет цвет на 3 канала
        
        redSlider.value = Float(ciColor.red) * 255
        greenSlider.value = Float(ciColor.green) * 255
        blueSlider.value = Float(ciColor.blue) * 255
    }
    
    private func string(from slider: UISlider) -> String {
        String(Int(slider.value))
    }
    
    // надо ОБЯЗАТЕЛЬНО делать кнопку Done на цифровой клавиатуре
    private func addDoneButtonToKeyboard(for textFields: UITextField...) {
        
        // сначала логически создаем тулбар (какбы подложка)
        // затем кнопку дан
        // затем флекс область (кнопку)
        
        textFields.forEach { textField in
            let keyboardToolbar = UIToolbar()
            textField.inputAccessoryView = keyboardToolbar
            keyboardToolbar.sizeToFit()
            
            let doneButton = UIBarButtonItem(
                title: "Done",
                style: .done,
                target: self,
                action: #selector(didTapDone)
            )
            
            let flexBarButton = UIBarButtonItem(
                barButtonSystemItem: .flexibleSpace,
                target: nil,
                action: nil
            )
            
            // теоретически наши телефоны должны иметь все активные кнопки справа. Мир заточен под правшей. Считается хорошо когда кнопка справа
            keyboardToolbar.items = [flexBarButton, doneButton]
        }
        
    }
    
    @objc private func didTapDone() {
        view.endEditing(true)
    }
        
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        delegate?.sendColor(color: colorBoxView.backgroundColor!)
        dismiss(animated: true)
    }
    
}
