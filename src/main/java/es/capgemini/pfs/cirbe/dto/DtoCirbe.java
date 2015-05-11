package es.capgemini.pfs.cirbe.dto;

import es.capgemini.pfs.cirbe.model.DDCodigoOperacionCirbe;
import es.capgemini.pfs.cirbe.model.DDTipoGarantiaCirbe;
import es.capgemini.pfs.cirbe.model.DDTipoSituacionCirbe;
import es.capgemini.pfs.cirbe.model.DDTipoVencimientoCirbe;

/**
 * Dto para enviar los datos de la pestaña CIRBE a la pantalla.
 * @author pamuller
 *
 */
public class DtoCirbe {

    private DDCodigoOperacionCirbe codigoOperacion;
    private DDTipoVencimientoCirbe tipoVencimiento;
    private DDTipoGarantiaCirbe tipoGarantia;
    private DDTipoSituacionCirbe tipoSituacion;

    private Double dispuestoFecha1;
    private Double dispuestoFecha2;
    private Double dispuestoFecha3;

    private Double disponibleFecha1;
    private Double disponibleFecha2;
    private Double disponibleFecha3;

    private boolean totalizador = false;
    private boolean subTotalizador = false;

    /**
     * @return the codigoOperacion
     */
    public DDCodigoOperacionCirbe getCodigoOperacion() {
        return codigoOperacion;
    }

    /**
     * @param codigoOperacion the codigoOperacion to set
     */
    public void setCodigoOperacion(DDCodigoOperacionCirbe codigoOperacion) {
        this.codigoOperacion = codigoOperacion;
    }

    /**
     * @return the tipoVencimiento
     */
    public DDTipoVencimientoCirbe getTipoVencimiento() {
        return tipoVencimiento;
    }

    /**
     * @param tipoVencimiento the tipoVencimiento to set
     */
    public void setTipoVencimiento(DDTipoVencimientoCirbe tipoVencimiento) {
        this.tipoVencimiento = tipoVencimiento;
    }

    /**
     * @return the tipoGarantia
     */
    public DDTipoGarantiaCirbe getTipoGarantia() {
        return tipoGarantia;
    }

    /**
     * @param tipoGarantia the tipoGarantia to set
     */
    public void setTipoGarantia(DDTipoGarantiaCirbe tipoGarantia) {
        this.tipoGarantia = tipoGarantia;
    }

    /**
     * @return the tipoSituacion
     */
    public DDTipoSituacionCirbe getTipoSituacion() {
        return tipoSituacion;
    }

    /**
     * @param tipoSituacion the tipoSituacion to set
     */
    public void setTipoSituacion(DDTipoSituacionCirbe tipoSituacion) {
        this.tipoSituacion = tipoSituacion;
    }

    /**
     * @return the dispuestoFecha1
     */
    public Double getDispuestoFecha1() {
        return dispuestoFecha1;
    }

    /**
     * @param dispuestoFecha1 the dispuestoFecha1 to set
     */
    public void setDispuestoFecha1(Double dispuestoFecha1) {
        this.dispuestoFecha1 = dispuestoFecha1;
    }

    /**
     * @return the dispuestoFecha2
     */
    public Double getDispuestoFecha2() {
        return dispuestoFecha2;
    }

    /**
     * @param dispuestoFecha2 the dispuestoFecha2 to set
     */
    public void setDispuestoFecha2(Double dispuestoFecha2) {
        this.dispuestoFecha2 = dispuestoFecha2;
    }

    /**
     * @return the dispuestoFecha3
     */
    public Double getDispuestoFecha3() {
        return dispuestoFecha3;
    }

    /**
     * @param dispuestoFecha3 the dispuestoFecha3 to set
     */
    public void setDispuestoFecha3(Double dispuestoFecha3) {
        this.dispuestoFecha3 = dispuestoFecha3;
    }

    /**
     * @return the disponibleFecha1
     */
    public Double getDisponibleFecha1() {
        return disponibleFecha1;
    }

    /**
     * @param disponibleFecha1 the disponibleFecha1 to set
     */
    public void setDisponibleFecha1(Double disponibleFecha1) {
        this.disponibleFecha1 = disponibleFecha1;
    }

    /**
     * @return the disponibleFecha2
     */
    public Double getDisponibleFecha2() {
        return disponibleFecha2;
    }

    /**
     * @param disponibleFecha2 the disponibleFecha2 to set
     */
    public void setDisponibleFecha2(Double disponibleFecha2) {
        this.disponibleFecha2 = disponibleFecha2;
    }

    /**
     * @return the disponibleFecha3
     */
    public Double getDisponibleFecha3() {
        return disponibleFecha3;
    }

    /**
     * @param disponibleFecha3 the disponibleFecha3 to set
     */
    public void setDisponibleFecha3(Double disponibleFecha3) {
        this.disponibleFecha3 = disponibleFecha3;
    }

    /**
     * @return the totalizador
     */
    public boolean isTotalizador() {
        return totalizador;
    }

    /**
     * @param totalizador the totalizador to set
     */
    public void setTotalizador(boolean totalizador) {
        this.totalizador = totalizador;
    }

    /**
     * @return the subTotalizador
     */
    public boolean isSubTotalizador() {
        return subTotalizador;
    }

    /**
     * @param subTotalizador the subTotalizador to set
     */
    public void setSubTotalizador(boolean subTotalizador) {
        this.subTotalizador = subTotalizador;
    }

    /**
     * {@inheritDoc}
     */
    @Override
    public String toString() {
        return codigoOperacion.getDescripcion() + "\n" + tipoGarantia.getDescripcion() + "\n" + tipoVencimiento.getDescripcion() + "\n"
                + tipoSituacion.getDescripcion() + "\n" + disponibleFecha1 + "\n" + dispuestoFecha1 + "\n" + disponibleFecha2 + "\n"
                + dispuestoFecha2 + "\n" + disponibleFecha3 + "\n" + dispuestoFecha3 + "\n";
    }
}
