package es.capgemini.pfs.cirbe.dto;

import java.util.Date;
import java.util.List;

/**
 * @author marruiz
 */
public class DtoResumenCirbe {

    /**
     * Rows con los diccionarios y valores, y también subtotales.
     */
    private List<DtoCirbe> rows;

    /**
     * Fechas en el resumen.
     */
    private Date fecha1;
    private Date fecha2;
    private Date fecha3;


    /**
     * @return the rows
     */
    public List<DtoCirbe> getRows() {
        return rows;
    }

    /**
     * @param rows the rows to set
     */
    public void setRows(List<DtoCirbe> rows) {
        this.rows = rows;
    }

    /**
     * @return the fecha1
     */
    public Date getFecha1() {
        return fecha1;
    }

    /**
     * @param fecha1 the fecha1 to set
     */
    public void setFecha1(Date fecha1) {
        this.fecha1 = fecha1;
    }

    /**
     * @return the fecha2
     */
    public Date getFecha2() {
        return fecha2;
    }

    /**
     * @param fecha2 the fecha2 to set
     */
    public void setFecha2(Date fecha2) {
        this.fecha2 = fecha2;
    }

    /**
     * @return the fecha3
     */
    public Date getFecha3() {
        return fecha3;
    }

    /**
     * @param fecha3 the fecha3 to set
     */
    public void setFecha3(Date fecha3) {
        this.fecha3 = fecha3;
    }
}
