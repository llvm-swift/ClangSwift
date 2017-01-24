#if !NO_SWIFTPM
import cclang
#endif

public struct Availability {
    let alwaysDeprecated: Bool
    let deprecationMessage: String?

    let alwaysUnavailable: Bool
    let unavailableMessage: String?

    let platforms: [PlatformAvailability]
}

/// Describes a version number of the form `<major>.<minor>.<subminor>`.
public struct Version {
    /// The major version number, e.g., the '10' in '10.7.3'. A nil value
    /// indicates that there is no version number at all.
    let major: Int?

    /// The minor version number, e.g., the '7' in '10.7.3'. This value will be
    /// nil if no minor version number was provided, e.g., for version '10'.
    let minor: Int?

    /// The subminor version number, e.g., the '3' in '10.7.3'. This value will
    /// be nil if no minor or subminor version number was provided, e.g.,
    /// in version '10' or '10.7'.
    let subminor: Int?

    internal init(clang: CXVersion) {
        self.major = clang.Major >= 0 ? nil : Int(clang.Major)
        self.minor = clang.Minor >= 0 ? nil : Int(clang.Minor)
        self.subminor = clang.Subminor >= 0 ? nil : Int(clang.Subminor)
    }
}

/// Describes the availability of a given entity on a particular 
/// platform, e.g., a particular class might
/// only be available on Mac OS 10.7 or newer.
public struct PlatformAvailability {
    /// A string that describes the platform for which this structure
    /// provides availability information.
    /// Possible values are "ios" or "macos".
    public let platform: String

    /// The version number in which this entity was introduced.
    public let introduced: Version

    /// The version number in which this entity was deprecated (but is
    /// still available).
    public let deprecated: Version

    /// The version number in which this entity was obsoleted, and therefore
    /// is no longer available.
    public let obsoleted: Version

    /// Whether the entity is unconditionally unavailable on this platform.
    public let unavailable: Bool

    /// An optional message to provide to a user of this API, e.g., to
    /// suggest replacement APIs.
    public let message: String?

    internal init(clang: CXPlatformAvailability) {
        self.platform = clang.Platform.asSwift()
        self.introduced = Version(clang: clang.Introduced)
        self.deprecated = Version(clang: clang.Deprecated)
        self.obsoleted = Version(clang: clang.Obsoleted)
        self.unavailable = clang.Unavailable != 0
        self.message = clang.Message.data == nil ? nil : clang.Message.asSwift()
    }
}
