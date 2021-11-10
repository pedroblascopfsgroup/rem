package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;


/**
 * Dto para el grid de ofertas de la pestaña activos
 * @author Carlos Feliu
 *
 */
public class DtoOfertaActivo extends WebDto {

	private static final long serialVersionUID = 0L;


	private Long idOferta;
	private Long idActivo;
	private Long idAgrupacion;
	private String estadoOferta;
	private String codigoEstadoOferta;
	private String tipoRechazoCodigo;
	private String motivoRechazoCodigo;
	private Boolean esAnulacion;
	private Boolean gencat;
	private Date fechaEntradaCRMSF;
	private Boolean ventaCartera;
	private Boolean ofertaEspecial;
	private Boolean ventaSobrePlano;
	private String codRiesgoOperacion;
	
	
	public Long getIdOferta() {
		return idOferta;
	}
	public void setIdOferta(Long idOferta) {
		this.idOferta = idOferta;
	}
	
	public Long getIdActivo() {
		return idActivo;
	}
	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}
	public Long getIdAgrupacion() {
		return idAgrupacion;
	}
	public void setIdAgrupacion(Long idAgrupacion) {
		this.idAgrupacion = idAgrupacion;
	}
	public String getEstadoOferta() {
		return estadoOferta;
	}
	public void setEstadoOferta(String estadoOferta) {
		this.estadoOferta = estadoOferta;
	}
	public String getCodigoEstadoOferta() {
		return codigoEstadoOferta;
	}
	public void setCodigoEstadoOferta(String codigoEstadoOferta) {
		this.codigoEstadoOferta = codigoEstadoOferta;
	}
	public String getTipoRechazoCodigo() {
		return tipoRechazoCodigo;
	}
	public void setTipoRechazoCodigo(String tipoRechazoCodigo) {
		this.tipoRechazoCodigo = tipoRechazoCodigo;
	}
	public String getMotivoRechazoCodigo() {
		return motivoRechazoCodigo;
	}
	public void setMotivoRechazoCodigo(String motivoRechazoCodigo) {
		this.motivoRechazoCodigo = motivoRechazoCodigo;
	}
	public Boolean getEsAnulacion() {
		return esAnulacion;
	}
	public void setEsAnulacion(Boolean esAnulacion) {
		this.esAnulacion = esAnulacion;
	}
	public Boolean getGencat() {
		return gencat;
	}
	public void setGencat(Boolean gencat) {
		this.gencat = gencat;
	}
	public Date getFechaEntradaCRMSF() {
		return fechaEntradaCRMSF;
	}
	public void setFechaEntradaCRMSF(Date fechaEntradaCRMSF) {
		this.fechaEntradaCRMSF = fechaEntradaCRMSF;
	}
	public Boolean getVentaCartera() {
		return ventaCartera;
	}
	public void setVentaCartera(Boolean ventaCartera) {
		this.ventaCartera = ventaCartera;
	}
	public Boolean getOfertaEspecial() {
		return ofertaEspecial;
	}
	public void setOfertaEspecial(Boolean ofertaEspecial) {
		this.ofertaEspecial = ofertaEspecial;
	}
	public Boolean getVentaSobrePlano() {
		return ventaSobrePlano;
	}
	public void setVentaSobrePlano(Boolean ventaSobrePlano) {
		this.ventaSobrePlano = ventaSobrePlano;
	}
	public String getCodRiesgoOperacion() {
		return codRiesgoOperacion;
	}
	public void setCodRiesgoOperacion(String codRiesgoOperacion) {
		this.codRiesgoOperacion = codRiesgoOperacion;
	}
}