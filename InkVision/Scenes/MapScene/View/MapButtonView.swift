//
//  MapButtonView.swift
//  InkVision
//
//  Created by Bruno Thuma on 28/11/21.
//  Credits to Vinicius Couto

import UIKit

final class MapButtonView: UIButton {
    // MARK: - Private variables

    private let iconName: String
    private var action: () -> Void

    // MARK: - Initialization

    init(isSmallButton: Bool, iconName: String, action: @escaping (() -> Void)) {
        self.iconName = iconName
        self.action = action

        super.init(frame: .zero)

        setupView(isSmallButton: isSmallButton)
        setupConstraints(isSmallButton: isSmallButton)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods

    private func setupView(isSmallButton: Bool) {
        let font = UIFont.systemFont(ofSize: isSmallButton ? CGFloat(20) : CGFloat(39),
                                     weight: LayoutMetrics.iconFontWeight)
        let configuration = UIImage.SymbolConfiguration(font: font)

        // TODO: Fix color
        let icon = UIImage(systemName: iconName, withConfiguration: configuration)?
            .imageWithColor(color: UIColor.white)

        // TODO: Fix color
        backgroundColor = UIColor(named: "pink")
        setImage(icon, for: .normal)
        layer.cornerRadius = isSmallButton ? CGFloat(38/2) : CGFloat(70/2)

        addTarget(self, action: #selector(tap), for: .touchUpInside)
    }

    private func setupConstraints(isSmallButton: Bool) {
        snp.makeConstraints { make in
            make.size.equalTo(isSmallButton ? CGFloat(38) : CGFloat(70))
        }
    }

    @objc private func tap() {
        action()
    }

    // MARK: - Layout Metrics

    private enum LayoutMetrics {
        private static let rectSize: Int = 38

        static let backgroundRectSize = CGSize(width: rectSize, height: rectSize)
        static let backgroundRectCornerRadius: CGFloat = CGFloat(rectSize/2)
        static let iconFontSize: CGFloat = 20
        static let iconFontWeight: UIFont.Weight = .bold
    }
}
