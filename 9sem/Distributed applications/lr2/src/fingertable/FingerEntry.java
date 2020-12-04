package fingertable;

import chord.ChordNode;

public class FingerEntry {

    private ChordNode start;
    private ChordNode end;
    private ChordNode node;

    public FingerEntry(ChordNode start, ChordNode end, ChordNode node) {
        this.start = start;
        this.end = end;
        this.node = node;
    }

    public ChordNode getStart() {
        return start;
    }

    public void setStart(ChordNode start) {
        this.start = start;
    }

    public ChordNode getEnd() {
        return end;
    }

    public void setEnd(ChordNode end) {
        this.end = end;
    }

    public ChordNode getNode() {
        return node;
    }

    public void setNode(ChordNode node) {
        this.node = node;
    }

    @Override
    public String toString() {
        return "\n\t\tFingerEntry{" + "start=" + start.getId() + ", end=" + end.getId() + ", node=" + node.getId() + '}';
    }
}
