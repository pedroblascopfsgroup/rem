package es.pfsgroup.plugin.rem.model;

import es.capgemini.devon.dto.WebDto;

/**
 * Dto para el filtro de Visitas
 * @author Luis Caballero
 *
 */
public class DtoOfertasFilter extends WebDto {

	private static final long serialVersionUID = 0L;

	private Long numOferta;
	private Long numActivo;
	private Long numAgrupacion;
	private String estadoOferta;
	private String tipoOferta;
	private Long idAgrupacion;
	private Long idActivo;
	private String fechaAltaDesde;
	private String fechaAltaHasta;
	private Long numExpediente;
	private String estadoExpediente;
	private String subtipoActivo;
	private String importeOferta;
	private String ofertante;
	private String comite;
	private Boolean derechoTanteo;
	private String fechaAccion;
	private Long idOferta;
	private String numAgrupacionRem;
	private String nombreCliente;
	private String apellidosCliente;
	private String razonSocialCliente;
	private String numDocumentoCliente;
	private String tipoDocumento;
	private Boolean deDerechoTanteo;
	
	public Long getNumOferta() {
		return numOferta;
	}
	public void setNumOferta(Long numOferta) {
		this.numOferta = numOferta;
	}
	public Long getNumActivo() {
		return numActivo;
	}
	public void setNumActivo(Long numActivo) {
		this.numActivo = numActivo;
	}
	public Long getNumAgrupacion() {
		return numAgrupacion;
	}
	public void setNumAgrupacion(Long numAgrupacion) {
		this.numAgrupacion = numAgrupacion;
	}
	public String getEstadoOferta() {
		return estadoOferta;
	}
	public void setEstadoOferta(String estadoOferta) {
		this.estadoOferta = estadoOferta;
	}
	public String getTipoOferta() {
		return tipoOferta;
	}
	public void setTipoOferta(String tipoOferta) {
		this.tipoOferta = tipoOferta;
	}
	public Long getIdAgrupacion() {
		return idAgrupacion;
	}
	public void setIdAgrupacion(Long idAgrupacion) {
		this.idAgrupacion = idAgrupacion;
	}
	public String getFechaAltaDesde() {
		return fechaAltaDesde;
	}
	public void setFechaAltaDesde(String fechaAltaDesde) {
		this.fechaAltaDesde = fechaAltaDesde;
	}
	public String getFechaAltaHasta() {
		return fechaAltaHasta;
	}
	public void setFechaAltaHasta(String fechaAltaHasta) {
		this.fechaAltaHasta = fechaAltaHasta;
	}
	public Long getNumExpediente() {
		return numExpediente;
	}
	public void setNumExpediente(Long numExpediente) {
		this.numExpediente = numExpediente;
	}
	public String getEstadoExpediente() {
		return estadoExpediente;
	}
	public void setEstadoExpediente(String estadoExpediente) {
		this.estadoExpediente = estadoExpediente;
	}
	public String getSubtipoActivo() {
		return subtipoActivo;
	}
	public void setSubtipoActivo(String subtipoActivo) {
		this.subtipoActivo = subtipoActivo;
	}
	public String getImporteOferta() {
		return importeOferta;
	}
	public void setImporteOferta(String importeOferta) {
		this.importeOferta = importeOferta;
	}
	public String getOfertante() {
		return ofertante;
	}
	public void setOfertante(String ofertante) {
		this.ofertante = ofertante;
	}
	public String getComite() {
		return comite;
	}
	public void setComite(String comite) {
		this.comite = comite;
	}
	public Boolean getDerechoTanteo() {
		return derechoTanteo;
	}
	public void setDerechoTanteo(Boolean derechoTanteo) {
		this.derechoTanteo = derechoTanteo;
	}
	public String getFechaAccion() {
		return fechaAccion;
	}
	public void setFechaAccion(String fechaAccion) {
		this.fechaAccion = fechaAccion;
	}
	public Long getIdOferta() {
		return idOferta;
	}
	public void setIdOferta(Long idOferta) {
		this.idOferta = idOferta;
	}
	public String getNumAgrupacionRem() {
		return numAgrupacionRem;
	}
	public void setNumAgrupacionRem(String numAgrupacionRem) {
		this.numAgrupacionRem = numAgrupacionRem;
	}
	public Long getIdActivo() {
		return idActivo;
	}
	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}
	public String getNombreCliente() {
		return nombreCliente;
	}
	public void setNombreCliente(String nombreCliente) {
		this.nombreCliente = nombreCliente;
	}
	public String getApellidosCliente() {
		return apellidosCliente;
	}
	public void setApellidosCliente(String apellidosCliente) {
		this.apellidosCliente = apellidosCliente;
	}
	public String getRazonSocialCliente() {
		return razonSocialCliente;
	}
	public void setRazonSocialCliente(String razonSocialCliente) {
		this.razonSocialCliente = razonSocialCliente;
	}
	public String getNumDocumentoCliente() {
		return numDocumentoCliente;
	}
	public void setNumDocumentoCliente(String numDocumentoCliente) {
		this.numDocumentoCliente = numDocumentoCliente;
	}
	public String getTipoDocumento() {
		return tipoDocumento;
	}
	public void setTipoDocumento(String tipoDocumento) {
		this.tipoDocumento = tipoDocumento;
	}
	
	public Boolean getDeDerechoTanteo() {
		return deDerechoTanteo;
	}
	public void setDeDerechoTanteo(Boolean deDerechoTanteo) {
		this.deDerechoTanteo = deDerechoTanteo;
	}
	
	
	
}