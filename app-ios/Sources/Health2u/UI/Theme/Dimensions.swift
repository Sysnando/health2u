import CoreGraphics

public enum Dimensions {
    public enum Space {
        public static let xxs: CGFloat = 2
        public static let xs: CGFloat = 4
        public static let s: CGFloat = 8
        public static let m: CGFloat = 16
        public static let l: CGFloat = 24
        public static let xl: CGFloat = 32
        public static let xxl: CGFloat = 48
    }

    public enum CornerRadius {
        public static let xs: CGFloat = 2
        public static let s: CGFloat = 4
        public static let m: CGFloat = 8
        public static let l: CGFloat = 12
        public static let xl: CGFloat = 16
        public static let xxl: CGFloat = 24
        public static let full: CGFloat = 999
    }

    public enum Elevation {
        public static let none: CGFloat = 0
        public static let xs: CGFloat = 1
        public static let s: CGFloat = 2
        public static let m: CGFloat = 4
        public static let l: CGFloat = 8
        public static let xl: CGFloat = 16
        public static let xxl: CGFloat = 24
    }

    public enum Size {
        public static let button: CGFloat = 48
        public static let buttonSmall: CGFloat = 36
        public static let buttonLarge: CGFloat = 56
        public static let icon: CGFloat = 24
        public static let iconSmall: CGFloat = 20
        public static let iconLarge: CGFloat = 32
        public static let touchTarget: CGFloat = 44
        public static let avatarSmall: CGFloat = 40
        public static let avatarMedium: CGFloat = 48
        public static let avatarLarge: CGFloat = 56
    }
}
