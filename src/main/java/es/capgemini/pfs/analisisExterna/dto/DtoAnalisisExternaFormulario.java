package es.capgemini.pfs.analisisExterna.dto;

import java.io.Serializable;

/**
 * DTO con los datos cargados en el formulario web para el reporte de Analisis Externa.
 * @author marruiz
 *
 */
public class DtoAnalisisExternaFormulario implements Serializable {

    private static final long serialVersionUID = -8321231039017940156L;

    private String fecha;
    private String idTipoProcedimientos;
    private String codigoDespachos;
    private String idUsuariosGestor;
    private String idUsuariosSupervisor;
    private String codigosFase;
    private String codigoPlazo;
    private String bProcedimientoActivo;
    private String tipoSalida;
    private String tipo;

    /**
     * @return the tipoSalida
     */
    public String getTipoSalida() {
        return tipoSalida;
    }

    /**
     * @param tipoSalida the tipoSalida to set
     */
    public void setTipoSalida(String tipoSalida) {
        this.tipoSalida = tipoSalida;
    }

    /**
     * @param fecha the fecha to set
     */
    public void setFecha(String fecha) {
        this.fecha = fecha;
    }

    /**
     * @return the fecha
     */
    public String getFecha() {
        return fecha;
    }

    /**
     * @param idTipoProcedimientos the idTipoProcedimientos to set
     */
    public void setIdTipoProcedimientos(String idTipoProcedimientos) {
        this.idTipoProcedimientos = idTipoProcedimientos;
    }

    /**
     * @return the idTipoProcedimientos
     */
    public String getIdTipoProcedimientos() {
        return idTipoProcedimientos;
    }

    /**
     * @param idUsuariosGestor the idUsuariosGestor to set
     */
    public void setIdUsuariosGestor(String idUsuariosGestor) {
        this.idUsuariosGestor = idUsuariosGestor;
    }

    /**
     * @return the idUsuariosGestor
     */
    public String getIdUsuariosGestor() {
        return idUsuariosGestor;
    }

    /**
     * @param idUsuariosSupervisor the idUsuariosSupervisor to set
     */
    public void setIdUsuariosSupervisor(String idUsuariosSupervisor) {
        this.idUsuariosSupervisor = idUsuariosSupervisor;
    }

    /**
     * @return the idUsuariosSupervisor
     */
    public String getIdUsuariosSupervisor() {
        return idUsuariosSupervisor;
    }

    /**
     * @param codigosFase the codigosFase to set
     */
    public void setCodigosFase(String codigosFase) {
        this.codigosFase = codigosFase;
    }

    /**
     * @return the codigosFase
     */
    public String getCodigosFase() {
        return codigosFase;
    }

    /**
     * @param codigoPlazo the codigoPlazo to set
     */
    public void setCodigoPlazo(String codigoPlazo) {
        this.codigoPlazo = codigoPlazo;
    }

    /**
     * @return the codigoPlazo
     */
    public String getCodigoPlazo() {
        return codigoPlazo;
    }

    /**
     * @param bProcedimientoActivo the bProcedimientoActivo to set
     */
    public void setbProcedimientoActivo(String bProcedimientoActivo) {
        this.bProcedimientoActivo = bProcedimientoActivo;
    }

    /**
     * @return the bProcedimientoActivo
     */
    public String getbProcedimientoActivo() {
        return bProcedimientoActivo;
    }

    /**
     * @param tipo the tipo to set
     */
    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    /**
     * @return the tipo
     */
    public String getTipo() {
        return tipo;
    }

    /**
     * @param codigoDespachos the codigoDespachos to set
     */
    public void setCodigoDespachos(String codigoDespachos) {
        this.codigoDespachos = codigoDespachos;
    }

    /**
     * @return the codigoDespachos
     */
    public String getCodigoDespachos() {
        return codigoDespachos;
    }
}
