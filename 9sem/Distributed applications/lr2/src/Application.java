import chord.ChordNet;

import java.util.*;

public class Application {

    final static int M_intM = 16;
    //final static List<Integer> m_arPos = new ArrayList<Integer>(Arrays.asList(1, 2, 3, 4, 5));

    public static void main(String[] args) throws Exception {
        ChordNet chordNet = new ChordNet(16);
        chordNet.add(0);
        chordNet.add(5);
        chordNet.add(9);
        chordNet.add(12);
        System.out.println(chordNet);

        System.out.println("-------------------------------");
        chordNet.remove(5);
        System.out.println(chordNet);
    }
}
