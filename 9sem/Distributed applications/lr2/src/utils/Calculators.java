package utils;

public class Calculators {
    public static Integer calculateSuccessorIndex(final Integer n, final Integer i, final Integer m) {
        return (int) ((n + Math.pow(2, i)) % m);
    }

    public static Integer calculatePredecessorIndex(final Integer n, final Integer i, final Integer m) {
        return (int) ((n - Math.pow(2, i) + m) % m);
    }
}
