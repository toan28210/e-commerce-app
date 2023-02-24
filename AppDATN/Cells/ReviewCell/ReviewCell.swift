//
//  ReviewCell.swift
//  AppDATN
//
//  Created by Toan Tran on 24/12/2022.
//

import UIKit
import Cosmos

class ReviewCell: UICollectionViewCell {

    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var resTextView: UITextView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var rating: UILabel!
    static let identifier = "ReviewCell"
    static func nib() -> UINib {
        return UINib(nibName: ReviewCell.identifier, bundle: .main)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        lineView.addTopAndBottomBorders()
        resTextView.isEditable = false
        imageView.layer.cornerRadius = imageView.frame.width/2
    }
    func configure(with data: RatingModel) {
        rating.text = String(format: "%.1f", data.rating ?? 0)
        cosmosView.rating = data.rating ?? 0
        resTextView.text = data.response ?? ""
        fetchDataUser(userId: data.userId ?? "")
//        let dateCurrent = Date()
//        let calendar = Calendar.current
//        let components = calendar.dateComponents([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year, Calendar.Component.hour, Calendar.Component.minute], from: dateCurrent)
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
//         dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
//        let isoday = data.createdAt!
//        let date = dateFormatter.date(from: isoday)!
//        let componentsLaste = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
//        let date1 = DateComponents(calendar: .current, year: componentsLaste.year, month: componentsLaste.month, day: componentsLaste.day, hour: componentsLaste.hour, minute: componentsLaste.minute).date!
//        let date2 = DateComponents(calendar: .current, year: components.year, month: components.month, day: components.day, hour: components.hour, minute: components.minute).date!
//        let timeOffset = date2.offset(from: date1)
//        print("TIme offet \(timeOffset)")
//        time.text = "\(timeOffset)"
    }
    
    func fetchDataUser(userId: String) {
        let url = URL(string: "http://localhost:5000/api/users/find/\(userId)")!
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, res, error in
            if error != nil || data == nil {
                    print("Client error!")
                    return
                }
                guard let response = res as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    print("Server error!")
                    return
                }
                guard let mime = response.mimeType, mime == "application/json" else {
                    print("Wrong MIME type!")
                    return
                }
                do {
                    guard let data = data else {
                        return
                    }
                    let jsonDecoder = JSONDecoder()
                    let json = try jsonDecoder.decode(UserModel.self, from: data)
                    DispatchQueue.main.async {
                        let url = URL(string: json.avatar ?? "https://upload.wikimedia.org/wikipedia/commons/9/99/Sample_User_Icon.png")!
                        self.imageView.kf.setImage(with: url)
                        self.username.text = json.username ?? ""
                    }

                } catch {
                    print("JSON error: \(error.localizedDescription)")
                }
        }
        task.resume()
    }

}

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
}
