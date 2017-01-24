#if !NO_SWIFTPM
import cclang
#endif
import Foundation

/// Represents a file ID that's unique to each file in a translation unit.
public struct UniqueFileID: Equatable {
    let clang: CXFileUniqueID

    public static func ==(lhs: UniqueFileID, rhs: UniqueFileID) -> Bool {
        return lhs.clang.data == rhs.clang.data
    }
}

/// A particular source file that is part of a translation unit.
public struct File: Equatable {
    let clang: CXFile

    /// Retrieve the complete file and path name of the given file.
    public var name: String {
        return clang_getFileName(clang).asSwift()
    }

    /// Retrieve the last modification time of the given file.
    public var lastModified: Date {
        return Date(timeIntervalSince1970: TimeInterval(clang_getFileTime(clang)))
    }

    /// Retrieves the unique identifier for this file.
    /// If it failed, returns `nil`.
    public var uniqueID: UniqueFileID? {
        var id = CXFileUniqueID()
        guard clang_getFileUniqueID(clang, &id) != 0 else {
            return nil
        }
        return UniqueFileID(clang: id)
    }

    /// Determines if two files are equal.
    public static func ==(lhs: File, rhs: File) -> Bool {
        return clang_File_isEqual(lhs.clang, rhs.clang) != 0
    }
}
