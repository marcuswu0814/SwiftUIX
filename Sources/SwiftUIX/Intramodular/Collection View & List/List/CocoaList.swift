//
// Copyright (c) Vatsal Manot
//

#if os(iOS) || os(macOS) || os(tvOS) || os(visionOS)

import Swift
import SwiftUI

#if os(macOS)
public struct CocoaList<Content: View>: View {
    private let _content: AnyView
    
    public init(_content: AnyView) {
        self._content = _content
    }
    
    public var body: some View {
        _content
    }
    
    public init(
        @ViewBuilder content: () -> Content
    ) {
        let content = _VariadicViewAdapter(content) { content in
            _CocoaList(configuration: _CocoaListVariadicViewContent(content.children))
        }
        
        self.init(_content: content.eraseToAnyView())
    }
}
#else
extension CocoaList {
    public init<Content: View>(
        @ViewBuilder content: () -> Content
    ) where SectionType == Never, SectionHeader == Never, SectionFooter == Never, ItemType == Never, RowContent == Never, Data == AnyRandomAccessCollection<ListSection<SectionType, ItemType>> {
        fatalError()
    }
}
#endif

#endif

extension View {
    public func cocoaListItem<ID: Hashable>(
        id: ID
    ) -> some View {
        _trait(_CocoaListItemID.self, _CocoaListItemID(id: id))
    }
}

// MARK: - Auxiliary

struct _CocoaListItemID: Hashable {
    let id: AnyHashable
}
