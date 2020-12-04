package chord;

import fingertable.FingerEntry;
import fingertable.FingerTable;

import java.util.ArrayList;
import java.util.List;

import static utils.Comparators.*;

public class ChordNode {

    private Integer id;
    private ChordNode successor;
    private ChordNode predecessor;
    private FingerTable fingerTable;
    private Boolean active;

    public ChordNode (Integer id) {
        this.id = id;
        this.active = false;
    }

    // Search by identifier

    public ChordNode findSuccessor(Integer id) throws Exception {
        if (this.id.equals(id)) {
            return this;
        }
        return findPredecessor(id).getSuccessor();

    }

    public ChordNode findPredecessor(Integer id) throws Exception {
        ChordNode node = this;
        while (!isValueInRightBoundedInterval(node.id, node.successor.id, id)) {
            node = this.getClosestPrecedingFinger(id);
        }
        return node;
    }

    private ChordNode getClosestPrecedingFinger(int id) throws Exception {
        if (isActive()) {
            for (int i = fingerTable.getSize() - 1; i >= 0; i--) {
                ChordNode node = fingerTable.getFinger(i).getNode();
                if (isValueInUnboundedInterval(this.id, id, node.getId())) {
                    return node;
                }
            }
            return this;
        } else {
            throw new Exception("Node with id = " + this.id.toString() + "doesn't exist");
        }
    }

    // Getters and setters

    public Boolean isActive() {
        return active;
    }

    public void setActive() {
        active = true;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public ChordNode getSuccessor() {
        return successor;
    }

    public void setSuccessor(ChordNode successor) {
        this.successor = successor;
    }

    public ChordNode getPredecessor() {
        return predecessor;
    }

    public void setPredecessor(ChordNode predecessor) {
        this.predecessor = predecessor;
    }

    public FingerTable getFingerTable() {
        return fingerTable;
    }

    public void setFingerTable(FingerTable fingerTable) {
        this.fingerTable = fingerTable;
    }

    public void setFingerTable(List<FingerEntry> records) {
        this.fingerTable = new FingerTable(records);
    }

    @Override
    public String toString() {
        StringBuilder builder = new StringBuilder("\nChordNode{id = ");
        builder.append(this.id);
        builder.append(", isActive = ").append(isActive());
        if (isActive()) {
            builder.append(", successor = ").append(successor.id);
            builder.append(", predecessor = ").append(predecessor.id);
            builder.append(", finger table = ").append(fingerTable.toString());
        }
        builder.append('}');
        return builder.toString();
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (o == null || getClass() != o.getClass()) {
            return false;
        }
        final ChordNode chordNode = (ChordNode) o;
        return this.id.equals(chordNode.id);
    }
}
