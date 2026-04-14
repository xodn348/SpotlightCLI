import Foundation

enum ANSIStripper {
    private static let csiPattern = "\u{1B}\\[[0-9;]*[A-Za-z]"
    private static let oscPattern = "\u{1B}\\][^\u{07}]*\u{07}"
    private static let crPattern = "\r"

    static func strip(_ input: String) -> String {
        var result = input
        let patterns = [csiPattern, oscPattern, crPattern]
        for pattern in patterns {
            if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
                result = regex.stringByReplacingMatches(
                    in: result,
                    options: [],
                    range: NSRange(result.startIndex..., in: result),
                    withTemplate: ""
                )
            }
        }
        return result
    }
}
