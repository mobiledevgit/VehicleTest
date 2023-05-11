//
//  Data+JsonString.swift
//  Exercise
//

import Foundation

extension Data {
    func jsonString() -> String {
        do {
            let json = try JSONSerialization.jsonObject(with: self, options: [])
            let data = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            guard let jsonString = String(data: data, encoding: .utf8) else {
                return ""
            }
            return jsonString
        } catch {
            print("Error: \(error.localizedDescription)")
        }
        return ""
    }
}
