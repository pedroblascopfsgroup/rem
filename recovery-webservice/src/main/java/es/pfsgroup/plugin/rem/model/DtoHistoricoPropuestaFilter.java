package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

/**
 * HR-641
 * Dto para el filtro de Historico Propuestas de Precios
 * @author jros
 *
 */
public class DtoHistoricoPropuestaFilter extends WebDto {

	private static final long serialVersionUID = 0L;

	private String numPropuesta;
	private String nombrePropuesta;
	private String entidadPropietariaCodigo;
	private String tipoPropuesta;
	private String numTramite;
	private String numTrabajo;
	private String tipoDeFecha;
	private String fechaDesde;
	private String fechaHasta;
	private String estadoPropuesta;
	private String gestorPrecios;
	private Long idAdjunto;
	
	public String getNumPropuesta() {
		return numPropuesta;
	}
	public void setNumPropuesta(String numPropuesta) {
		this.numPropuesta = numPropuesta;
	}
	public String getNombrePropuesta() {
		return nombrePropuesta;
	}
	public void setNombrePropuesta(String nombrePropuesta) {
		this.nombrePropuesta = nombrePropuesta;
	}
	public String getEntidadPropietariaCodigo() {
		return entidadPropietariaCodigo;
	}
	public void setEntidadPropietariaCodigo(String entidadPropietariaCodigo) {
		this.entidadPropietariaCodigo = entidadPropietariaCodigo;
	}
	public String getTipoPropuesta() {
		return tipoPropuesta;
	}
	public void setTipoPropuesta(String tipoPropuesta) {
		this.tipoPropuesta = tipoPropuesta;
	}
	public String getNumTramite() {
		return numTramite;
	}
	public void setNumTramite(String numTramite) {
		this.numTramite = numTramite;
	}
	public String getNumTrabajo() {
		return numTrabajo;
	}
	public void setNumTrabajo(String numTrabajo) {
		this.numTrabajo = numTrabajo;
	}
	public String getTipoDeFecha() {
		return tipoDeFecha;
	}
	public void setTipoDeFecha(String tipoDeFecha) {
		this.tipoDeFecha = tipoDeFecha;
	}
	public String getFechaDesde() {
		return fechaDesde;
	}
	public void setFechaDesde(String fechaDesde) {
		this.fechaDesde = fechaDesde;
	}
	public String getFechaHasta() {
		return fechaHasta;
	}
	public void setFechaHasta(String fechaHasta) {
		this.fechaHasta = fechaHasta;
	}
	public String getEstadoPropuesta() {
		return estadoPropuesta;
	}
	public void setEstadoPropuesta(String estadoPropuesta) {
		this.estadoPropuesta = estadoPropuesta;
	}
	public String getGestorPrecios() {
		return gestorPrecios;
	}
	public void setGestorPrecios(String gestorPrecios) {
		this.gestorPrecios = gestorPrecios;
	}
	public Long getIdAdjunto() {
		return idAdjunto;
	}
	public void setIdAdjunto(Long idAdjunto) {
		this.idAdjunto = idAdjunto;
	}

	
}
