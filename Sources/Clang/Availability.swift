#if !NO_SWIFTPM
import cclang
#endif

/// Describes the availability of a given declaration for each platform.
public struct Availability {
  /// Whether this declaration is unconditionally deprecated for all platforms.
  public let alwaysDeprecated: Bool

  /// The message to display when alerting someone of this deprecated
  /// declaration.
  public let deprecationMessage: String?

  /// Whether this declaration is unconditionally unavailable.
  public let alwaysUnavailable: Bool

  /// The message to display when alerting someone of this unavailable
  /// declaration.
  public let unavailableMessage: String?

  /// The specific availability for all platforms specified for this
  /// declaration.
  public let platforms: [PlatformAvailability]
}

/// Describes a version number of the form `<major>.<minor>.<subminor>`.
public struct Version {
  /// The major version number, e.g., the '10' in '10.7.3'.
  public let major: Int

  /// The minor version number, e.g., the '7' in '10.7.3'. This value will be
  /// 0 if no minor version number was provided, e.g., for version '10'.
  public let minor: Int

  /// The subminor version number, e.g., the '3' in '10.7.3'. This value will
  /// be 0 if no minor or subminor version number was provided, e.g.,
  /// in version '10' or '10.7'.
  public let subminor: Int

  /// Represents a version number for 0.0.0.
  public static let zero = Version(major: 0, minor: 0, subminor: 0)


  /// Creates a version with the specified major, minor, and subminor versions.
  ///
  /// - Parameters:
  ///   - major: The major version, e.g. "10" in "10.3.1"
  ///   - minor: The minor version, e.g. "3" in "10.3.1"
  ///   - subminor: The subminor version, e.g. "1" in "10.3.1"
  public init(major: Int, minor: Int, subminor: Int) {
    self.major = major
    self.minor = minor
    self.subminor = subminor
  }

  internal init?(clang: CXVersion) {
    guard clang.Major >= 0 else { return nil }
    self.major = Int(clang.Major)
    self.minor = max(Int(clang.Minor), 0)
    self.subminor = max(Int(clang.Subminor), 0)
  }
}

/// Describes the availability of a given entity on a particular
/// platform, e.g., a particular class might
/// only be available on Mac OS 10.7 or newer.
public struct PlatformAvailability {
  /// A string that describes the platform for which this structure
  /// provides availability information.
  public let platform: String

  /// The version number in which this entity was introduced.
  public let introduced: Version

  /// The version number in which this entity was deprecated (but is
  /// still available).
  public let deprecated: Version?

  /// The version number in which this entity was obsoleted, and therefore
  /// is no longer available.
  public let obsoleted: Version?

  /// Whether the entity is unconditionally unavailable on this platform.
  public let unavailable: Bool

  /// An optional message to provide to a user of this API, e.g., to
  /// suggest replacement APIs.
  public let message: String?

  internal init(clang: CXPlatformAvailability) {
    // We have to dispose this whole structure at once with a call to
    // clang_disposeCXPlatformAvailability, so we can't dispose the
    // individual strings inside.
    self.platform = clang.Platform.asSwiftNoDispose()
    self.introduced = Version(clang: clang.Introduced) ?? .zero
    self.deprecated = Version(clang: clang.Deprecated)
    self.obsoleted = Version(clang: clang.Obsoleted)
    self.unavailable = clang.Unavailable != 0
    self.message = clang.Message.asSwiftOptionalNoDispose()
  }
}
