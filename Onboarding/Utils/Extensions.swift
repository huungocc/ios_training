import UIKit

extension UIColor {
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if hexSanitized.hasPrefix("#") {
            hexSanitized.remove(at: hexSanitized.startIndex)
        }

        var rgb: UInt64 = 0
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        switch hexSanitized.count {
        case 6:
            self.init(
                red: CGFloat((rgb & 0xFF0000) >> 16) / 255,
                green: CGFloat((rgb & 0x00FF00) >> 8) / 255,
                blue: CGFloat(rgb & 0x0000FF) / 255,
                alpha: 1.0
            )
        case 8:
            self.init(
                red: CGFloat((rgb & 0xFF000000) >> 24) / 255,
                green: CGFloat((rgb & 0x00FF0000) >> 16) / 255,
                blue: CGFloat((rgb & 0x0000FF00) >> 8) / 255,
                alpha: CGFloat(rgb & 0x000000FF) / 255
            )
        default:
            return nil
        }
    }
}
