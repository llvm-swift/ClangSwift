#if SWIFT_PACKAGE
  import cclang
#endif
import Foundation

/// Represents a file ID that's unique to each file in a translation unit.
public struct UniqueFileID: Hashable {
  let clang: CXFileUniqueID

  /// Determines if two unique file IDs are equal.
  public static func ==(lhs: UniqueFileID, rhs: UniqueFileID) -> Bool {
    return lhs.clang.data == rhs.clang.data
  }

  /// A unique integer value representing this unique ID.
  public var hashValue: Int {
    return Int(Int64(bitPattern: clang.data.0 ^ clang.data.1 ^ clang.data.2)
      ^ 0x0a28bf1ac) // xor with a constant for extra mixing.
  }
}

/// A particular source file that is part of a translation unit.
public struct File: Hashable {
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

  /// A unique integer value representing this file.
  public var hashValue: Int {
    let mixin = 0xa24b1bc4
    guard let uniqueID = uniqueID else {
      return name.hashValue ^ mixin
    }
    return uniqueID.hashValue ^ mixin
  }
}
