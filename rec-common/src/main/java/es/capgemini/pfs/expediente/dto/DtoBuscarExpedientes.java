package es.capgemini.pfs.expediente.dto;

import java.util.Set;

import org.springframework.binding.message.MessageBuilder;
import org.springframework.binding.message.MessageContext;

import es.capgemini.devon.pagination.PaginationParamsImpl;
import es.capgemini.devon.validation.ErrorMessageUtils;
import es.capgemini.devon.validation.ValidationException;

/**
 * Clase que contiene los parámetros utilizados para realizar una Búsqueda de expedientes.
 * @author mtorrado
 *
 */
public class DtoBuscarExpedientes extends PaginationParamsImpl {

    private static final long serialVersionUID = -5044783974206550753L;

    private Long idCnt;

    private Long codigo;

    private String descripcion;

    private String codigoEntidad;

    private String codigoZona;

    private String codigoSituacion;

    private String idEstado;

    private String minRiesgoTotal;

    private String maxRiesgoTotal;

    private String minSaldoVencido;

    private String maxSaldoVencido;

    private boolean busqueda;
    private Set<String> codigoZonas;

    private String nroContrato;

    private String segmentos;

    private String tipoPersona;

    private Long idComite;

    private Long idSesion;

    private Long comiteBusqueda;

    private String codigoGestion;
    
    private String params;
    
    private String fechaCreacion;

    /**
     * valida que al menos se selecciono un criterio.
     * @param messageContext mesanje
     * @return boolean
     */
    public boolean validateListado(MessageContext messageContext) {
        if (busqueda && codigo == null && (idEstado == null || "".equals(idEstado.trim())) && (codigoZona == null || "".equals(codigoZona.trim()))
                && (codigoEntidad == null || "".equals(codigoEntidad.trim())) && (codigoSituacion == null || "".equals(codigoSituacion.trim()))
                && (minRiesgoTotal == null || "".equals(minRiesgoTotal.trim())) && (maxRiesgoTotal == null || "".equals(maxRiesgoTotal.trim()))
                && (minSaldoVencido == null || "".equals(minSaldoVencido.trim())) && (maxSaldoVencido == null || "".equals(maxSaldoVencido.trim()))
                && (descripcion == null || "".equals(descripcion.trim())) && (nroContrato == null || "".equals(nroContrato.trim()))
                && (segmentos == null || "".equals(segmentos.trim())) && (tipoPersona == null || "".equals(tipoPersona.trim())) && (idComite == null)
                && (comiteBusqueda == null) && (codigoGestion == null || "".equals(codigoGestion.trim())) && (params == null || "".equals(params.trim()))) {
            messageContext.addMessage(new MessageBuilder().code("busquedaExpediente.noHayParametros").error().source("").defaultText(
                    "**Debe Compleatarse por lo menos un parámetro").build());
            throw new ValidationException(ErrorMessageUtils.convertMessages(messageContext.getAllMessages()));
        }
        return true;
    }

    /**
     * @return the idCnt
     */
    public Long getIdCnt() {
        return idCnt;
    }

    /**
     * @param idCnt the idCnt to set
     */
    public void setIdCnt(Long idCnt) {
        this.idCnt = idCnt;
    }

    /**
     * @return the codigo
     */
    public Long getCodigo() {
        return codigo;
    }

    /**
     * @param codigo the codigo to set
     */
    public void setCodigo(Long codigo) {
        this.codigo = codigo;
    }

    /**
     * @return the descripcion
     */
    public String getDescripcion() {
        return descripcion;
    }

    /**
     * @param descripcion the descripcion to set
     */
    public void setDescripcion(String descripcion) {
        this.descripcion = descripcion;
    }

    /**
     * @return the codigoEntidad
     */
    public String getCodigoEntidad() {
        return codigoEntidad;
    }

    /**
     * @param codigoEntidad the codigoEntidad to set
     */
    public void setCodigoEntidad(String codigoEntidad) {
        this.codigoEntidad = codigoEntidad;
    }

    /**
     * @return the codigoSituacion
     */
    public String getCodigoSituacion() {
        return codigoSituacion;
    }

    /**
     * @param codigoSituacion the codigoSituacion to set
     */
    public void setCodigoSituacion(String codigoSituacion) {
        this.codigoSituacion = codigoSituacion;
    }

    /**
     * @return the idEstado
     */
    public String getIdEstado() {
        return idEstado;
    }

    /**
     * @param idEstado the idEstado to set
     */
    public void setIdEstado(String idEstado) {
        this.idEstado = idEstado;
    }

    /**
     * @return the minRiesgoTotal
     */
    public String getMinRiesgoTotal() {
        return minRiesgoTotal;
    }

    /**
     * @param minRiesgoTotal the minRiesgoTotal to set
     */
    public void setMinRiesgoTotal(String minRiesgoTotal) {
        this.minRiesgoTotal = minRiesgoTotal;
    }

    /**
     * @return the maxRiesgoTotal
     */
    public String getMaxRiesgoTotal() {
        return maxRiesgoTotal;
    }

    /**
     * @param maxRiesgoTotal the maxRiesgoTotal to set
     */
    public void setMaxRiesgoTotal(String maxRiesgoTotal) {
        this.maxRiesgoTotal = maxRiesgoTotal;
    }

    /**
     * @return the minSaldoVencido
     */
    public String getMinSaldoVencido() {
        return minSaldoVencido;
    }

    /**
     * @param minSaldoVencido the minSaldoVencido to set
     */
    public void setMinSaldoVencido(String minSaldoVencido) {
        this.minSaldoVencido = minSaldoVencido;
    }

    /**
     * @return the maxSaldoVencido
     */
    public String getMaxSaldoVencido() {
        return maxSaldoVencido;
    }

    /**
     * @param maxSaldoVencido the maxSaldoVencido to set
     */
    public void setMaxSaldoVencido(String maxSaldoVencido) {
        this.maxSaldoVencido = maxSaldoVencido;
    }

    /**
     * @return the busqueda
     */
    public boolean isBusqueda() {
        return busqueda;
    }

    /**
     * @param busqueda the busqueda to set
     */
    public void setBusqueda(boolean busqueda) {
        this.busqueda = busqueda;
    }

    /**
     * @return the codigoZona
     */
    public String getCodigoZona() {
        return codigoZona;
    }

    /**
     * @param codigoZona the codigoZona to set
     */
    public void setCodigoZona(String codigoZona) {
        this.codigoZona = codigoZona;
    }

    /**
     * @param codigoZonas the codigoZonas to set
     */
    public void setCodigoZonas(Set<String> codigoZonas) {
        this.codigoZonas = codigoZonas;
    }

    /**
     * @return the codigoZonas
     */
    public Set<String> getCodigoZonas() {
        return codigoZonas;
    }

    /**
     * @return the nroContrato
     */
    public String getNroContrato() {
        return nroContrato;
    }

    /**
     * @param nroContrato the nroContrato to set
     */
    public void setNroContrato(String nroContrato) {
        this.nroContrato = nroContrato;
    }

    /**
     * @return the segmentos
     */
    public String getSegmentos() {
        return segmentos;
    }

    /**
     * @param segmentos the segmentos to set
     */
    public void setSegmentos(String segmentos) {
        this.segmentos = segmentos;
    }

    /**
     * @return the tipoPersona
     */
    public String getTipoPersona() {
        return tipoPersona;
    }

    /**
     * @param tipoPersona the tipoPersona to set
     */
    public void setTipoPersona(String tipoPersona) {
        this.tipoPersona = tipoPersona;
    }

    /**
     * @return the idSesion
     */
    public Long getIdSesion() {
        return idSesion;
    }

    /**
     * @param idSesion the idSesion to set
     */
    public void setIdSesion(Long idSesion) {
        this.idSesion = idSesion;
    }

    /**
     * @return the idComite
     */
    public Long getIdComite() {
        return idComite;
    }

    /**
     * @param idComite the comite to set
     */
    public void setIdComite(Long idComite) {
        this.idComite = idComite;
    }

    /**
     * @param comiteBusqueda the comiteBusqueda to set
     */
    public void setComiteBusqueda(Long comiteBusqueda) {
        this.comiteBusqueda = comiteBusqueda;
    }

    /**
     * @return the comiteBusqueda
     */
    public Long getComiteBusqueda() {
        return comiteBusqueda;
    }

    /**
     * @param codigoGestion the codigoGestion to set
     */
    public void setCodigoGestion(String codigoGestion) {
        this.codigoGestion = codigoGestion;
    }

    /**
     * @return the codigoGestion
     */
    public String getCodigoGestion() {
        return codigoGestion;
    }

	public String getParams() {
		return params;
	}

	public void setParams(String params) {
		this.params = params;
	}

	public String getFechaCreacion() {
		return fechaCreacion;
	}

	public void setFechaCreacion(String fechaCreacion) {
		this.fechaCreacion = fechaCreacion;
	}
}
