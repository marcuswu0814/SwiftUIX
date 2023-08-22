//
// Copyright (c) Vatsal Manot
//

import Swift
import SwiftUI

/// An internal structure used to manage cell preferences for `CocoaList` and `CollectionView`.
@usableFromInline
struct _CollectionOrListCellPreferences: Hashable {
    var isFocusable: Bool?
    var isHighlightable: Bool?
    var isReorderable: Bool?
    var isSelectable: Bool?
}

extension _CollectionOrListCellPreferences {
    /// An internal preference key that defines a list row's preferences.
    struct PreferenceKey: SwiftUI.PreferenceKey {
        static let defaultValue = _CollectionOrListCellPreferences()
        
        static func reduce(value: inout _CollectionOrListCellPreferences, nextValue: () -> _CollectionOrListCellPreferences) {
            value = nextValue()
        }
    }
}

extension View {
    @available(*, deprecated)
    public func cellFocusable(_ focusable: Bool) -> some View {
        transformPreference(_CollectionOrListCellPreferences.PreferenceKey.self) { value in
            value.isFocusable = focusable
        }
    }
    
    @available(*, deprecated)
    public func cellHighlightable(_ highlightable: Bool) -> some View {
        transformPreference(_CollectionOrListCellPreferences.PreferenceKey.self) { value in
            value.isHighlightable = highlightable
        }
    }
    
    @available(*, deprecated, renamed: "_SwiftUIX_moveDisabled(_:)")
    public func cellReorderable(_ reorderable: Bool) -> some View {
        transformPreference(_CollectionOrListCellPreferences.PreferenceKey.self) { value in
            value.isReorderable = reorderable
        }
        .moveDisabled(!reorderable)
    }
    
    @available(*, deprecated, renamed: "_SwiftUIX_selectionDisabled(_:)")
    public func cellSelectable(_ selectable: Bool) -> some View {
        transformPreference(_CollectionOrListCellPreferences.PreferenceKey.self) { value in
            value.isSelectable = selectable
        }
    }
}

extension View {
    public func _SwiftUIX_focusable(
        _ focusable: Bool
    ) -> some View {
        transformPreference(_CollectionOrListCellPreferences.PreferenceKey.self) { value in
            value.isFocusable = focusable
        }
    }
    
    public func _SwiftUIX_moveDisabled(
        _ isDisabled: Bool
    ) -> some View {
        transformPreference(_CollectionOrListCellPreferences.PreferenceKey.self) { value in
            if isDisabled {
                value.isReorderable = false
            }
        }
        .moveDisabled(isDisabled)
    }
    
    public func _SwiftUIX_selectionDisabled(_ disabled: Bool) -> some View {
        transformPreference(_CollectionOrListCellPreferences.PreferenceKey.self) { value in
            if disabled {
                value.isSelectable = false
            }
        }
    }
}

// MARK: - Auxiliary

extension EnvironmentValues {
    private struct IsCellFocused: EnvironmentKey {
        static let defaultValue = false
    }
    
    private struct IsCellHighlighted: EnvironmentKey {
        static let defaultValue = false
    }
    
    private struct IsCellSelected: EnvironmentKey {
        static let defaultValue = false
    }
    
    /// Returns whether the nearest focusable cell has focus.
    public var isCellFocused: Bool {
        get {
            self[IsCellFocused.self]
        } set {
            self[IsCellFocused.self] = newValue
        }
    }
    
    /// A Boolean value that indicates whether the cell associated with this environment is highlighted.
    public var isCellHighlighted: Bool {
        get {
            self[IsCellHighlighted.self]
        } set {
            self[IsCellHighlighted.self] = newValue
        }
    }
    
    /// A Boolean value that indicates whether the cell associated with this environment is selected.
    public var isCellSelected: Bool {
        get {
            self[IsCellSelected.self]
        } set {
            self[IsCellSelected.self] = newValue
        }
    }
}
