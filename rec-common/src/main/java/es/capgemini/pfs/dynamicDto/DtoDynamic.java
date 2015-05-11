package es.capgemini.pfs.dynamicDto;

import java.io.Serializable;
import java.util.List;


/**
 * DTO dinámico, puede tener x columnas con diferentes formatos cada una.
 * @author marruiz
 */
public class DtoDynamic implements Serializable {

    private static final long serialVersionUID = 7542070158363699193L;

    /**
     * Información acerca de como está compuesto la información del DTO.
     */
    private List<DtoMetadata> metadata;

    /**
     * Filas del DTO.
     */
    private List<DtoDynamicRow> rows;

    /**
     * <code>true</code> si el DTO contiene sub-datos en cada row.
     */
    private boolean tieneSubdata = false;


    /**
     * Información acerca de como está compuesto la información del DTO.
     * @return the metadata
     */
    public List<DtoMetadata> getMetadata() {
        return metadata;
    }
    /**
     * @param metadata the metadata to set
     */
    public void setMetadata(List<DtoMetadata> metadata) {
        this.metadata = metadata;
    }
    /**
     * Filas del DTO.
     * @return the rows
     */
    public List<DtoDynamicRow> getRows() {
        return rows;
    }
    /**
     * @param rows the rows to set
     */
    public void setRows(List<DtoDynamicRow> rows) {
        this.rows = rows;
    }
    /**
     * @return <code>true</code> si el DTO contiene sub-datos en cada row.
     */
    public boolean isTieneSubdata() {
        return tieneSubdata;
    }
    /**
     * @param tieneSubdata the tieneSubdata to set
     */
    public void setTieneSubdata(boolean tieneSubdata) {
        this.tieneSubdata = tieneSubdata;
    }
}
