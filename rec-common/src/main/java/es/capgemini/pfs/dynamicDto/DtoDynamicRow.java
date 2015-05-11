package es.capgemini.pfs.dynamicDto;

import java.util.ArrayList;
import java.util.List;

/**
 * Row de un DTO dinámico.
 * @author marruiz
 */
public class DtoDynamicRow {

    private List<DtoCell> cells;
    private List<DtoDynamicRow> subdata;

    /**
     * Recupera de su información directa, el valor de un parámetro llamado igual que el 'name' de entrada.
     * @param name
     * @return
     */
    public String getValueForName(String name) {
        DtoCell cell = getCell(name);
        if (cell == null)
            return "";
        else
            return cell.getValue();
    }

    /**
     * Recupera la celda
     * @param name
     * @return
     */
    public DtoCell getCell(String name) {
        for (DtoCell cell : cells) {
            if (name.equals(cell.getName())) return cell;
        }
        return null;
    }

    /**
     * Constructor default.
     * Crea las listas de la clase.
     */
    public DtoDynamicRow() {
        cells = new ArrayList<DtoCell>();
        subdata = new ArrayList<DtoDynamicRow>();
    }

    /**
     * Agrega una celda a la fila.
     * @param cell la celda que hay que agregar.
     */
    public void addCell(DtoCell cell) {
        cells.add(cell);
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public String toString() {
        String s = "";
        for (DtoCell cell : cells) {
            s += cell.toString() + "\n";
        }
        return s;
    }

    /**
     * @return the scoringFechas
     */
    public List<DtoCell> getCells() {
        return cells;
    }

    /**
     * @param arrayList the scoringFechas to set
     */
    public void setCells(List<DtoCell> arrayList) {
        this.cells = arrayList;
    }

    /**
     * Subdatos anidados al row.
     * @return the subdatos
     */
    public List<DtoDynamicRow> getSubdata() {
        return subdata;
    }

    /**
     * @param subdata the subdatos to set
     */
    public void setSubdata(List<DtoDynamicRow> subdata) {
        this.subdata = subdata;
    }
}
