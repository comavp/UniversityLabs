package utils;

public class Comparators {
    public static Boolean isValueInBoundedInterval(final Integer left, final Integer right, final Integer value) {
        if (left < right) {
            return left <= value && value <= right;
        } else if (left == right) {
            return true;
        } else {
            return left <= value || value <= right;
        }
    }

    public static Boolean isValueInUnboundedInterval(final Integer left, final Integer right, final Integer value) {
        if (left < right) {
            return left < value && value < right;
        } else if (left == right) {
            return false;
        } else {
            return left < value || value < right;
        }
    }

    public static Boolean isValueInLeftBoundedInterval(final Integer left, final Integer right, final Integer value) {
        if (left < right) {
            return left <= value && value < right;
        } else if (left == right) {
            return false;
        } else {
            return left <= value || value < right;
        }
    }

    public static Boolean isValueInRightBoundedInterval(final Integer left, final Integer right, final Integer value) {
        if (left < right) {
            return left < value && value <= right;
        } else if (left == right) {
            return true;
        } else {
            return left < value || value <= right;
        }
    }
}
