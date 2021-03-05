package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para el filtro de Visitas
 * @author Javier Esbrí
 *
 */
public class DtoOfertaGridFilter extends WebDto {

	private static final long serialVersionUID = 0L;

	private Long id;
    private String numOferta;
    private String numExpediente;
    private String numActivo;
    private String numAgrupacion;
    private String numActivoAgrupacion;
    private String numActivoUvem;
    private String numActivoSareb;
    private String numPrinex;
    private String codigoPromocionPrinex;
    private String numVisita;
    private Boolean agrupacionesVinculadas;
    private String codigoTipoOferta;
    private String descripcionTipoOferta;    
    private String estadoExpedienteAlquiler;
    private String estadoExpedienteVenta;
    private String codigoEstadoExpediente;
    private String descripcionEstadoExpediente;
    private String tipoComercializacionCodigo;
    private String tipoGestor;
    private String tipoFecha;
    private String fechaDesde;
    private String fechaHasta;
    private String fechaCreacion;
    private String codigoEstadoOferta;
    private String descripcionEstadoOferta;    
    private String claseActivoBancarioCodigo;
    private String importeOferta;
    private String nombreCanal;
    private String canalCodigo;
    private String canalDescripcion;
    private String usuarioGestor;
    private String carteraCodigo;
    private String subcarteraCodigo;
    private String gestoria;
    private String ofertante;
    private String documentoOfertante;
    private String telefonoOfertante;
    private String emailOfertante;
    private Integer ofertaExpress;
    private Long gestoriaBag;
    
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getNumOferta() {
		return numOferta;
	}
	public void setNumOferta(String numOferta) {
		this.numOferta = numOferta;
	}
	public String getNumExpediente() {
		return numExpediente;
	}
	public void setNumExpediente(String numExpediente) {
		this.numExpediente = numExpediente;
	}
	public String getNumActivo() {
		return numActivo;
	}
	public void setNumActivo(String numActivo) {
		this.numActivo = numActivo;
	}
	public String getNumAgrupacion() {
		return numAgrupacion;
	}
	public void setNumAgrupacion(String numAgrupacion) {
		this.numAgrupacion = numAgrupacion;
	}
	public String getNumActivoAgrupacion() {
		return numActivoAgrupacion;
	}
	public void setNumActivoAgrupacion(String numActivoAgrupacion) {
		this.numActivoAgrupacion = numActivoAgrupacion;
	}
	public String getNumActivoUvem() {
		return numActivoUvem;
	}
	public void setNumActivoUvem(String numActivoUvem) {
		this.numActivoUvem = numActivoUvem;
	}
	public String getNumActivoSareb() {
		return numActivoSareb;
	}
	public void setNumActivoSareb(String numActivoSareb) {
		this.numActivoSareb = numActivoSareb;
	}
	public String getNumPrinex() {
		return numPrinex;
	}
	public void setNumPrinex(String numPrinex) {
		this.numPrinex = numPrinex;
	}
	public String getCodigoPromocionPrinex() {
		return codigoPromocionPrinex;
	}
	public void setCodigoPromocionPrinex(String codigoPromocionPrinex) {
		this.codigoPromocionPrinex = codigoPromocionPrinex;
	}
	public String getNumVisita() {
		return numVisita;
	}
	public void setNumVisita(String numVisita) {
		this.numVisita = numVisita;
	}
	public Boolean getAgrupacionesVinculadas() {
		return agrupacionesVinculadas;
	}
	public void setAgrupacionesVinculadas(Boolean agrupacionesVinculadas) {
		this.agrupacionesVinculadas = agrupacionesVinculadas;
	}
	public String getCodigoTipoOferta() {
		return codigoTipoOferta;
	}
	public void setCodigoTipoOferta(String codigoTipoOferta) {
		this.codigoTipoOferta = codigoTipoOferta;
	}
	public String getDescripcionTipoOferta() {
		return descripcionTipoOferta;
	}
	public void setDescripcionTipoOferta(String descripcionTipoOferta) {
		this.descripcionTipoOferta = descripcionTipoOferta;
	}
	public String getEstadoExpedienteAlquiler() {
		return estadoExpedienteAlquiler;
	}
	public void setEstadoExpedienteAlquiler(String estadoExpedienteAlquiler) {
		this.estadoExpedienteAlquiler = estadoExpedienteAlquiler;
	}
	public String getEstadoExpedienteVenta() {
		return estadoExpedienteVenta;
	}
	public void setEstadoExpedienteVenta(String estadoExpedienteVenta) {
		this.estadoExpedienteVenta = estadoExpedienteVenta;
	}
	public String getCodigoEstadoExpediente() {
		return codigoEstadoExpediente;
	}
	public void setCodigoEstadoExpediente(String codigoEstadoExpediente) {
		this.codigoEstadoExpediente = codigoEstadoExpediente;
	}
	public String getDescripcionEstadoExpediente() {
		return descripcionEstadoExpediente;
	}
	public void setDescripcionEstadoExpediente(String descripcionEstadoExpediente) {
		this.descripcionEstadoExpediente = descripcionEstadoExpediente;
	}
	public String getTipoComercializacionCodigo() {
		return tipoComercializacionCodigo;
	}
	public void setTipoComercializacionCodigo(String tipoComercializacionCodigo) {
		this.tipoComercializacionCodigo = tipoComercializacionCodigo;
	}
	public String getTipoGestor() {
		return tipoGestor;
	}
	public void setTipoGestor(String tipoGestor) {
		this.tipoGestor = tipoGestor;
	}
	public String getTipoFecha() {
		return tipoFecha;
	}
	public void setTipoFecha(String tipoFecha) {
		this.tipoFecha = tipoFecha;
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
	public String getFechaCreacion() {
		return fechaCreacion;
	}
	public void setFechaCreacion(String fechaCreacion) {
		this.fechaCreacion = fechaCreacion;
	}
	public String getCodigoEstadoOferta() {
		return codigoEstadoOferta;
	}
	public void setCodigoEstadoOferta(String codigoEstadoOferta) {
		this.codigoEstadoOferta = codigoEstadoOferta;
	}
	public String getDescripcionEstadoOferta() {
		return descripcionEstadoOferta;
	}
	public void setDescripcionEstadoOferta(String descripcionEstadoOferta) {
		this.descripcionEstadoOferta = descripcionEstadoOferta;
	}
	public String getClaseActivoBancarioCodigo() {
		return claseActivoBancarioCodigo;
	}
	public void setClaseActivoBancarioCodigo(String claseActivoBancarioCodigo) {
		this.claseActivoBancarioCodigo = claseActivoBancarioCodigo;
	}
	public String getImporteOferta() {
		return importeOferta;
	}
	public void setImporteOferta(String importeOferta) {
		this.importeOferta = importeOferta;
	}
	public String getNombreCanal() {
		return nombreCanal;
	}
	public void setNombreCanal(String nombreCanal) {
		this.nombreCanal = nombreCanal;
	}
	public String getCanalCodigo() {
		return canalCodigo;
	}
	public void setCanalCodigo(String canalCodigo) {
		this.canalCodigo = canalCodigo;
	}
	public String getCanalDescripcion() {
		return canalDescripcion;
	}
	public void setCanalDescripcion(String canalDescripcion) {
		this.canalDescripcion = canalDescripcion;
	}
	public String getUsuarioGestor() {
		return usuarioGestor;
	}
	public void setUsuarioGestor(String usuarioGestor) {
		this.usuarioGestor = usuarioGestor;
	}
	public String getCarteraCodigo() {
		return carteraCodigo;
	}
	public void setCarteraCodigo(String carteraCodigo) {
		this.carteraCodigo = carteraCodigo;
	}
	public String getSubcarteraCodigo() {
		return subcarteraCodigo;
	}
	public void setSubcarteraCodigo(String subcarteraCodigo) {
		this.subcarteraCodigo = subcarteraCodigo;
	}
	public String getGestoria() {
		return gestoria;
	}
	public void setGestoria(String gestoria) {
		this.gestoria = gestoria;
	}
	public String getOfertante() {
		return ofertante;
	}
	public void setOfertante(String ofertante) {
		this.ofertante = ofertante;
	}
	public String getDocumentoOfertante() {
		return documentoOfertante;
	}
	public void setDocumentoOfertante(String documentoOfertante) {
		this.documentoOfertante = documentoOfertante;
	}
	public String getTelefonoOfertante() {
		return telefonoOfertante;
	}
	public void setTelefonoOfertante(String telefonoOfertante) {
		this.telefonoOfertante = telefonoOfertante;
	}
	public String getEmailOfertante() {
		return emailOfertante;
	}
	public void setEmailOfertante(String emailOfertante) {
		this.emailOfertante = emailOfertante;
	}
	public Integer getOfertaExpress() {
		return ofertaExpress;
	}
	public void setOfertaExpress(Integer ofertaExpress) {
		this.ofertaExpress = ofertaExpress;
	}
	public Long getGestoriaBag() {
		return gestoriaBag;
	}
	public void setGestoriaBag(Long gestoriaBag) {
		this.gestoriaBag = gestoriaBag;
	}
	
	
}