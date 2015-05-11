/**
 * 
 */
package es.capgemini.pfs.analisisExterna.dto;

import java.io.Serializable;

/**
 * @author marruiz
 *
 */
public class DtoAnalisisExternaTabla implements Serializable {

    private static final long serialVersionUID = 1351560150211213201L;

    private String salida;
    private Long numAsuntos;
    private Long numProcedimientos;
    private Double principal;
    private Double cobrosPagos;
    private Double importeRecuperado;
    private Double haceMas24Meses;
    private Double entre24y12;
    private Double entre12y6;
    private Double entre6y3;
    private Double entre3yFechaInforme;
    private Double menos3;
    private Double menos6;
    private Double menos12;
    private Double menos24;
    private Double mas24;

    /**
     * @return the salida
     */
    public String getSalida() {
        return salida;
    }

    /**
     * @param salida the salida to set
     */
    public void setSalida(String salida) {
        this.salida = salida;
    }

    /**
     * @return the numAsuntos
     */
    public Long getNumAsuntos() {
        return numAsuntos;
    }

    /**
     * @param numAsuntos the numAsuntos to set
     */
    public void setNumAsuntos(Long numAsuntos) {
        this.numAsuntos = numAsuntos;
    }

    /**
     * @return the numProcedimientos
     */
    public Long getNumProcedimientos() {
        return numProcedimientos;
    }

    /**
     * @param numProcedimientos the numProcedimientos to set
     */
    public void setNumProcedimientos(Long numProcedimientos) {
        this.numProcedimientos = numProcedimientos;
    }

    /**
     * @return the principal
     */
    public Double getPrincipal() {
        return principal;
    }

    /**
     * @param principal the principal to set
     */
    public void setPrincipal(Double principal) {
        this.principal = principal;
    }

    /**
     * @return the cobrosPagos
     */
    public Double getCobrosPagos() {
        return cobrosPagos;
    }

    /**
     * @param cobrosPagos the cobrosPagos to set
     */
    public void setCobrosPagos(Double cobrosPagos) {
        this.cobrosPagos = cobrosPagos;
    }

    /**
     * @return the importeRecuperado
     */
    public Double getImporteRecuperado() {
        return importeRecuperado;
    }

    /**
     * @param importeRecuperado the importeRecuperado to set
     */
    public void setImporteRecuperado(Double importeRecuperado) {
        this.importeRecuperado = importeRecuperado;
    }

    /**
     * @return the haceMas24Meses
     */
    public Double getHaceMas24Meses() {
        return haceMas24Meses;
    }

    /**
     * @param haceMas24Meses the haceMas24Meses to set
     */
    public void setHaceMas24Meses(Double haceMas24Meses) {
        this.haceMas24Meses = haceMas24Meses;
    }

    /**
     * @return the entre12y6
     */
    public Double getEntre12y6() {
        return entre12y6;
    }

    /**
     * @param entre12y6 the entre12y6 to set
     */
    public void setEntre12y6(Double entre12y6) {
        this.entre12y6 = entre12y6;
    }

    /**
     * @return the entre6y3
     */
    public Double getEntre6y3() {
        return entre6y3;
    }

    /**
     * @param entre6y3 the entre6y3 to set
     */
    public void setEntre6y3(Double entre6y3) {
        this.entre6y3 = entre6y3;
    }

    /**
     * @return the entre3yFechaInforme
     */
    public Double getEntre3yFechaInforme() {
        return entre3yFechaInforme;
    }

    /**
     * @param entre3yFechaInforme the entre3yFechaInforme to set
     */
    public void setEntre3yFechaInforme(Double entre3yFechaInforme) {
        this.entre3yFechaInforme = entre3yFechaInforme;
    }

    /**
     * @return the menos3
     */
    public Double getMenos3() {
        return menos3;
    }

    /**
     * @param menos3 the menos3 to set
     */
    public void setMenos3(Double menos3) {
        this.menos3 = menos3;
    }

    /**
     * @return the menos6
     */
    public Double getMenos6() {
        return menos6;
    }

    /**
     * @param menos6 the menos6 to set
     */
    public void setMenos6(Double menos6) {
        this.menos6 = menos6;
    }

    /**
     * @return the menos12
     */
    public Double getMenos12() {
        return menos12;
    }

    /**
     * @param menos12 the menos12 to set
     */
    public void setMenos12(Double menos12) {
        this.menos12 = menos12;
    }

    /**
     * @return the menos24
     */
    public Double getMenos24() {
        return menos24;
    }

    /**
     * @param menos24 the menos24 to set
     */
    public void setMenos24(Double menos24) {
        this.menos24 = menos24;
    }

    /**
     * @return the mas24
     */
    public Double getMas24() {
        return mas24;
    }

    /**
     * @param mas24 the mas24 to set
     */
    public void setMas24(Double mas24) {
        this.mas24 = mas24;
    }

    /**
     * @param entre24y12 the entre24y12 to set
     */
    public void setEntre24y12(Double entre24y12) {
        this.entre24y12 = entre24y12;
    }

    /**
     * @return the entre24y12
     */
    public Double getEntre24y12() {
        return entre24y12;
    }
}
