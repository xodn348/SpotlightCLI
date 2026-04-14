import Foundation
import SwiftUI

struct MarkdownRenderer {
    static func render(_ markdown: String) -> AttributedString {
        guard !markdown.isEmpty else {
            return AttributedString()
        }

        do {
            var result = try AttributedString(markdown: markdown, options: AttributedString.MarkdownParsingOptions())
            
            for run in result.runs {
                if let inlineIntent = run.inlinePresentationIntent,
                   inlineIntent.contains(.code) {
                    result[run.range].font = .system(.body, design: .monospaced)
                    result[run.range].backgroundColor = Color(nsColor: .quaternaryLabelColor)
                }
                
                if let blockIntent = run.presentationIntent {
                    for component in blockIntent.components {
                        if case .codeBlock(_) = component.kind {
                            result[run.range].font = .system(.body, design: .monospaced)
                        }
                    }
                }
            }
            
            return result
        } catch {
            return AttributedString(markdown)
        }
    }
}
