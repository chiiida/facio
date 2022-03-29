//
//  ParticleView.swift
//  Facio
//
//  Created by Sirikonss on 29/3/2565 BE.
//

import UIKit

protocol ParticleBarDelegate: AnyObject {
    
    func didSelectParticle(_ particle: String)
}

class ParticleBar: UIView {
    
    private let particlePicker = UIPickerView()
    private var currentParticle = Particle.none.title
    private var particleList = [
        Particle.none.title,
        Particle.bokeh.title,
        Particle.confetti.title,
        Particle.stars.title,
        Particle.rain.title,
        Particle.firework.title
    ]
    
    weak var delegate: ParticleBarDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setUpLayout()
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadLayoutSubviews() {
        particlePicker.snp.remakeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(20.0)
            $0.width.equalToSuperview()
            $0.height.equalTo(500)
        }
        particlePicker.subviews.forEach { $0.backgroundColor = .clear }
        
    }
    
    private func setUpLayout() {
        self.addSubViews(
            particlePicker
        )
        particlePicker.transform = CGAffineTransform(rotationAngle: -90 * (.pi / 180))
    }
    
    private func setUpViews() {
        self.backgroundColor = .white
        
        particlePicker.dataSource = self
        particlePicker.delegate = self
        particlePicker.backgroundColor = .clear
    }
}

extension ParticleBar {
    
    enum Particle {
        
        case none
        case bokeh
        case confetti
        case stars
        case rain
        case firework
        
        var title: String {
            switch self {
            case .none: return "None"
            case .bokeh: return "Bokeh"
            case .confetti: return "Confetti"
            case .stars: return "Stars"
            case .rain: return "Rain"
            case .firework: return "Firework"
            }
        }
    }
}

// MARK: - UIPickerViewDataSource, UIPickerViewDelegate

extension ParticleBar: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return particleList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let modeView = UIView()
        modeView.frame = CGRect(x: 0, y: 0, width: 100.0, height: 100.0)
        modeView.backgroundColor = .clear
        
        let modeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 75.0, height: 75.0))
        modeLabel.font = .regular(.comfortaa, ofSize: .xxSmall)
        modeLabel.textColor = .primaryGray
        modeLabel.text = particleList[row]
        modeLabel.textAlignment = .center
        modeLabel.layer.borderColor = UIColor.darkGray.cgColor
        modeLabel.layer.borderWidth = 3.0
        modeLabel.layer.cornerRadius = modeLabel.frame.width / 2
        
        modeView.addSubview(modeLabel)
        modeView.transform = CGAffineTransform(rotationAngle: 90 * (.pi / 180))
        
        return modeView
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 100.0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentParticle = particleList[row]
        delegate?.didSelectParticle(currentParticle)
    }
}
