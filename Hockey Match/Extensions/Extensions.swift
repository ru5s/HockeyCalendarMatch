//
//  Extensions.swift
//  Hockey Match
//
//  Created by DF on 05/06/24.
//

import Foundation
import UIKit
import SwiftUI
import Combine

//Date extensions -------->

//format date
extension Date {
    func dateFormatHHmm() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let formattedDate = formatter.string(from: self)
        return formattedDate
    }
    
    func dateFormatddMMM() -> String {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd MMMM"
        let formattedDate = formatter.string(from: self)
        return formattedDate
    }
    
    func dateFormatddMMMMHHmm() -> String {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd MMMM HH:mm"
        let formattedDate = formatter.string(from: self)
        return formattedDate
    }
}

//String extensions -------->

//convert string date to unixTime
extension String {
    func convertToIntStringDate() -> Int {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"

            if let date = dateFormatter.date(from: self) {
                let unixTime = date.timeIntervalSince1970
                return Int(unixTime)
            } else {
                return 0
            }
        }
}

//UIApplication extensions -------->

//hide keyboard
extension UIApplication {
    func endEditing(_ force: Bool) {
        self.windows
            .filter { $0.isKeyWindow }
            .first?
            .endEditing(force)
    }
}

//View extensions -------->

//add border to shape
fileprivate struct BorderedCornerRadius: ViewModifier {
    var radius: CGFloat
    var borderLineWidth: CGFloat = 1
    var borderColor: Color = .gray
    var antialiased: Bool = true
    
    func body(content: Content) -> some View {
        content
            .cornerRadius(self.radius, antialiased: self.antialiased)
            .overlay(
                RoundedRectangle(cornerRadius: self.radius)
                    .strokeBorder(self.borderColor, lineWidth: self.borderLineWidth, antialiased: self.antialiased)
            )
    }
}

extension View {
    func cornerRadiusWithBorder(radius: CGFloat, borderLineWidth: CGFloat = 1, borderColor: Color = .gray, antialiased: Bool = true) -> some View {
        modifier(BorderedCornerRadius(radius: radius, borderLineWidth: borderLineWidth, borderColor: borderColor, antialiased: antialiased))
    }
    
    func textEditorBackground(_ content: Color) -> some View {
        if #available(iOS 16.0, *) {
            return self.scrollContentBackground(.hidden)
                .background(content)
        } else {
            UITextView.appearance().backgroundColor = .clear
            return self.background(content)
        }
    }
    
    @available(iOS 14, *)
    func navigationBarTitleTextColor(_ color: Color) -> some View {
        let uiColor = UIColor(color)
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.black ]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: uiColor ]
        return self
    }
}
