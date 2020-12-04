package chord;

import fingertable.FingerEntry;
import fingertable.FingerTable;
import sun.reflect.annotation.ExceptionProxy;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

import static utils.Calculators.calculatePredecessorIndex;
import static utils.Calculators.calculateSuccessorIndex;
import static utils.Comparators.isValueInLeftBoundedInterval;

public class ChordNet {
    private final Integer m;
    private final Integer n;
    private List<ChordNode> nodes;
    private List<ChordNode> activeNodes;

    public ChordNet(final Integer n) throws Exception {
        if (n < 1) {
            throw new Exception("Cannot create ChordNet. Illegal argument");
        }
        this.n = n;
        this.m = (int) (Math.log(n) / Math.log(2));
        this.nodes = new ArrayList<>();
        this.activeNodes = new ArrayList<>();

        for (int i = 0; i < n; i++) {
            this.nodes.add(new ChordNode(i));
        }
    }

    // Find successor and predecessor

    public ChordNode findSuccessor(int id) throws Exception {
        if (!activeNodes.isEmpty()) {
            ChordNode chordNode = this.nodes.get(id);
            if (chordNode.isActive()) {
                return chordNode;
            } else {
                return findSuccessorForId(this.activeNodes.get(0).getId(), id);
            }
        }
        throw new Exception("ChordNet has not any active nodes");
    }

    public ChordNode findPredecessor(int id) throws Exception {
        if (!activeNodes.isEmpty()) {
            return findPredecessorForId(this.activeNodes.get(0).getId(), id);
        }
        throw new Exception("ChordNet has not any active nodes");
    }

    private ChordNode findPredecessorForId(int startChordNodeId, int id) throws Exception {
        return this.nodes.get(startChordNodeId).findPredecessor(id);
    }

    private ChordNode findSuccessorForId(int startChordNodeId, int id) throws Exception {
        return this.nodes.get(startChordNodeId).findSuccessor(id);
    }

    // Add new node

    public void add(final Integer index) throws Exception {
        ChordNode node = this.nodes.get(index);
        if (node.isActive()) {
            return;
        }
        if (activeNodes.isEmpty()) {
            initializeFirstChordNode(node);
        } else {
            initializeAnyChordNode(node);
            updateActiveChordNodesFingerTable(node);
        }
        this.activeNodes.add(node);
        this.activeNodes.sort(Comparator.comparingInt(ChordNode::getId));
    }

    private void initializeFirstChordNode(final ChordNode firstNode) throws Exception {
        int firstNodeId = firstNode.getId();
        List<FingerEntry> records = new ArrayList<>();

        for (int i = 0; i < this.m; i++) {
            Integer startId = calculateSuccessorIndex(firstNodeId, i, this.n);
            Integer endId = calculateSuccessorIndex(firstNodeId, i + 1, this.n);
            records.add(new FingerEntry(this.nodes.get(startId), this.nodes.get(endId), firstNode));
        }
        firstNode.setActive();
        firstNode.setSuccessor(firstNode);
        firstNode.setPredecessor(firstNode);
        firstNode.setFingerTable(records);
    }

    private void initializeAnyChordNode(final ChordNode anyNode) throws Exception {

        int anyNodeId = anyNode.getId();
        List<FingerEntry> records = new ArrayList<>();

        int startId = calculateSuccessorIndex(anyNodeId, 0, n);
        int endId = calculateSuccessorIndex(anyNodeId, 1, n);
        ChordNode nodeSuccessor = findSuccessor(startId);
        records.add(new FingerEntry(this.nodes.get(startId), this.nodes.get(endId), nodeSuccessor));

        ChordNode successor = findSuccessor(anyNodeId);
        ChordNode predecessor = successor.getPredecessor();

        anyNode.setActive();

        anyNode.setSuccessor(successor);
        anyNode.setPredecessor(predecessor);
        successor.setPredecessor(anyNode);
        predecessor.setSuccessor(anyNode);


        for (int i = 1; i < this.m; i++) {
            startId = calculateSuccessorIndex(anyNodeId, i, this.n);
            endId = calculateSuccessorIndex(anyNodeId, i + 1, this.n);
            if (!isValueInLeftBoundedInterval(anyNodeId, nodeSuccessor.getId(), startId)) {
                nodeSuccessor = findSuccessor(startId);
            }
            records.add(new FingerEntry(nodes.get(startId), nodes.get(endId), nodeSuccessor));
        }
        anyNode.setFingerTable(records);
    }

    private void updateActiveChordNodesFingerTable(ChordNode node) {
        try {
            for (int i = 0; i < m; i++) {
                int id = calculatePredecessorIndex(node.getId(), i, n);
                ChordNode predecessor;
                if (this.nodes.get(id).isActive()) {
                    predecessor = this.nodes.get(id);
                } else {
                    predecessor = findPredecessor(id);
                }
                updateFingers(node, predecessor, i);
            }
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void updateFingers(ChordNode node, ChordNode predecessor, int fingerIndex) throws Exception {
        if (node.getId() == predecessor.getId()) {
            return;
        }
        FingerEntry record = predecessor.getFingerTable().getFinger(fingerIndex);
        if (isValueInLeftBoundedInterval(record.getStart().getId(), record.getNode().getId(), node.getId())) {
            record.setNode(node);
            updateFingers(node, predecessor.getPredecessor(), fingerIndex);
        }
    }

    // Remove node

    public void remove(int index) throws Exception {
        if (index < 0 || index >= this.nodes.size()) {
            throw new Exception("Can not remove node. Invalid index.");
        }
        if (this.activeNodes.stream().map(ChordNode::getId).noneMatch(id -> id == index)) {
            return;
        }
        ChordNode nodeToRemove = this.nodes.get(index);
        ChordNode successor = nodeToRemove.getSuccessor();
        ChordNode predecessor = nodeToRemove.getPredecessor();

        for (int i = 0; i < this.m; i++) {
            updateActiveChordNodesFingerTable(nodeToRemove, predecessor, i);
        }

        predecessor.setSuccessor(successor);
        successor.setPredecessor(predecessor);

        this.nodes.set(index, new ChordNode(index));
        this.activeNodes.remove(nodeToRemove);
        if (!activeNodes.isEmpty()) {
            this.activeNodes.sort(Comparator.comparingInt(ChordNode::getId));
        }
    }

    private void updateActiveChordNodesFingerTable(ChordNode deleted, ChordNode predecessor, int recordIndex) {
        if (deleted.equals(predecessor)) {
            return;
        }
        try {
            FingerTable table = predecessor.getFingerTable();
            FingerEntry record = table.getFinger(recordIndex);
            ChordNode node = record.getNode();
            if (node.equals(deleted)) {
                ChordNode successor = deleted.getSuccessor();
                record.setNode(successor);
                table.setRecord(record, recordIndex);
            }
            updateActiveChordNodesFingerTable(deleted, predecessor.getPredecessor(), recordIndex);
        }
        catch (Exception e) {
            e.printStackTrace();
        }

    }

    @Override
    public String toString() {
        return "ChordNet{" + "n=" + this.n + ", m=" + this.m + ", nodes=" + this.nodes + '}';
    }
}
