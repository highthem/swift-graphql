import Foundation
import GraphQLAST

/*
 We represent enumerator values as strings. There's nothing
 special in here, just the generated code.
 */

// MARK: - Enum

extension EnumType {
    /// Represents the enum structure.
    var declaration: String {
        """
        extension Enums {
            \(docs)
            enum \(name.pascalCase): String, CaseIterable, Codable {
            \(values)
            }
        }
        """
    }

    private var docs: String {
        "/* \(description ?? name) */"
    }

    /// Represents possible enum cases.
    private var values: String {
        enumValues.map { $0.declaration }.joined(separator: "\n")
    }
}

// MARK: - EnumValue

extension EnumValue {
    /// Returns an enum case definition.
    fileprivate var declaration: String {
        """
        \(docs)
        \(availability)
        case \(name.camelCase.normalize) = "\(name)"
        """
    }

    private var docs: String {
        description.map { "/* \($0) */" } ?? ""
    }

    private var availability: String {
        if isDeprecated {
            let message = deprecationReason ?? ""
            return "@available(*, deprecated, message: \"\(message)\")"
        }
        return ""
    }
}
