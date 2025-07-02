import UIKit

class TimeCell: UITableViewCell {
    static let identifier = "TimeCell"
    
    private let timeLabel = CustomView.makeLabel(fontSize: 20, weight: .medium, color: .black)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(timeLabel)

        NSLayoutConstraint.activate([
            timeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            timeLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            timeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
        ])
    }
    
    func configure(time: String, colorTime: UIColor? = .black) {
        timeLabel.text = time
        timeLabel.textColor = colorTime
    }
}
