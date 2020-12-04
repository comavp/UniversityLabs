package fingertable;

import java.util.ArrayList;
import java.util.List;

public class FingerTable {

    private List<FingerEntry> fingerTable;

    public FingerTable(final List<FingerEntry> records) {
        this.fingerTable = records;
    }

    public List<FingerEntry> getFingerTable() {
        return fingerTable;
    }

    public void setFingerTable(final List<FingerEntry> fingerTable) {
        this.fingerTable = fingerTable;
    }

    public Integer getSize() {
        return fingerTable.size();
    }

    public FingerEntry getFinger(final Integer index) {
        return fingerTable.get(index);
    }

    public void setRecord(final FingerEntry record, final Integer recordIndex){
        fingerTable.set(recordIndex, record);
    }

    @Override
    public String toString() {
        return "\n\tFingerTable{" + fingerTable + '}' + '\n';
    }
}
