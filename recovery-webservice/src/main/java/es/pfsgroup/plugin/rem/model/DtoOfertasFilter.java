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
	private String[] estadosOferta;
	private String tipoOferta;
	private Long idAgrupacion;
	private Long idActivo;
	private String fechaAltaDesde;
	private String fechaAltaHasta;
	private Long numExpediente;
	private String estadoExpediente;
	private String[] estadosExpedienteAlquiler;
	private String[] estadosExpediente;
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
	private String codigoPrescriptor;
	private String tipoGestor;
	private Long usuarioGestor;
	private String tipoFecha;
	private String fechaDesde;
	private String fechaHasta;
	private String canal;
	private String nombreCanal;
	private String telefonoOfertante;
	private String emailOfertante;
	private String documentoOfertante;
	private String codigoPromocionPrinex;
	private Boolean intencionFinanciar;
	private String codigoSucursal;
	private String tipoSucursal;
	private String carteraCodigo;
	private Long gestoria;
	private String tipoPersona;
	private String estadoCivil;
	private String regimenMatrimonial;
	private String tipoComercializacion;
	private String claseActivoBancario;
	private Long numActivoUvem;
	private Long numActivoSareb;
	private Long numPrinex;
	private Boolean agrupacionesVinculadas;	
	private Boolean ventaDirecta;
	private Long idUvem;
		
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
	public String[] getEstadosOferta() {
		return estadosOferta;
	}
	public void setEstadosOferta(String[] estadosOferta) {
		this.estadosOferta = estadosOferta;
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
	public String[] getEstadosExpediente() {
		return estadosExpediente;
	}
	public void setEstadosExpediente(String[] estadosExpediente) {
		this.estadosExpediente = estadosExpediente;
	}
	public String[] getEstadosExpedienteAlquiler() {
		return estadosExpedienteAlquiler;
	}
	public void setEstadosExpedienteAlquiler(String[] estadosExpedienteAlquiler) {
		this.estadosExpedienteAlquiler = estadosExpedienteAlquiler;
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
	public String getCodigoPrescriptor() {
		return codigoPrescriptor;
	}
	public void setCodigoPrescriptor(String codigoPrescriptor) {
		this.codigoPrescriptor = codigoPrescriptor;
	}
	public Long getUsuarioGestor() {
		return usuarioGestor;
	}
	public void setUsuarioGestor(Long usuarioGestor) {
		this.usuarioGestor = usuarioGestor;
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
	public String getCanal() {
		return canal;
	}
	public void setCanal(String canal) {
		this.canal = canal;
	}
	public String getNombreCanal() {
		return nombreCanal;
	}
	public void setNombreCanal(String nombreCanal) {
		this.nombreCanal = nombreCanal;
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
	public String getDocumentoOfertante() {
		return documentoOfertante;
	}
	public void setDocumentoOfertante(String documentoOfertante) {
		this.documentoOfertante = documentoOfertante;
	}
	public Long getGestoria() {
		return gestoria;
	}
	public void setGestoria(Long gestoria) {
		this.gestoria = gestoria;
	}
	public String getCodigoPromocionPrinex() {
		return codigoPromocionPrinex;
	}
	public void setCodigoPromocionPrinex(String codigoPromocionPrinex) {
		this.codigoPromocionPrinex = codigoPromocionPrinex;
	}
	public Boolean getIntencionFinanciar() {
		return intencionFinanciar;
	}
	public void setIntencionFinanciar(Boolean intencionFinanciar) {
		this.intencionFinanciar = intencionFinanciar;
	}
	public String getCodigoSucursal() {
		return codigoSucursal;
	}
	public void setCodigoSucursal(String codigoSucursal) {
		this.codigoSucursal = codigoSucursal;
	}
	public String getTipoSucursal() {
		return tipoSucursal;
	}
	public void setTipoSucursal(String tipoSucursal) {
		this.tipoSucursal = tipoSucursal;
	}
	public String getCarteraCodigo() {
		return carteraCodigo;
	}
	public void setCarteraCodigo(String carteraCodigo) {
		this.carteraCodigo = carteraCodigo;
	}
	public String getTipoPersona() {
		return tipoPersona;
	}
	public void setTipoPersona(String tipoPersona) {
		this.tipoPersona = tipoPersona;
	}
	public String getEstadoCivil() {
		return estadoCivil;
	}
	public void setEstadoCivil(String estadoCivil) {
		this.estadoCivil = estadoCivil;
	}
	public String getRegimenMatrimonial() {
		return regimenMatrimonial;
	}
	public void setRegimenMatrimonial(String regimenMatrimonial) {
		this.regimenMatrimonial = regimenMatrimonial;
	}
	public String getTipoComercializacion() {
		return tipoComercializacion;
	}
	public void setTipoComercializacion(String tipoComercializacion) {
		this.tipoComercializacion = tipoComercializacion;
	}
	public String getClaseActivoBancario() {
		return claseActivoBancario;
	}
	public void setClaseActivoBancario(String claseActivoBancario) {
		this.claseActivoBancario = claseActivoBancario;
	}	
	public Long getNumActivoUvem() {
		return numActivoUvem;
	}
	public void setNumActivoUvem(Long numActivoUvem) {
		this.numActivoUvem = numActivoUvem;
	}
	public Long getNumActivoSareb() {
		return numActivoSareb;
	}
	public void setNumActivoSareb(Long numActivoSareb) {
		this.numActivoSareb = numActivoSareb;
	}
	public Long getNumPrinex() {
		return numPrinex;
	}
	public void setNumPrinex(Long numPrinex) {
		this.numPrinex = numPrinex;
	}
	public Boolean getAgrupacionesVinculadas() {
		return agrupacionesVinculadas;
	}
	public void setAgrupacionesVinculadas(Boolean agrupacionesVinculadas) {
		this.agrupacionesVinculadas = agrupacionesVinculadas;
	}
	public Boolean getVentaDirecta() {
		return ventaDirecta;
	}
	public void setVentaDirecta(Boolean ventaDirecta) {
		this.ventaDirecta = ventaDirecta;
	}
	public Long getIdUvem() {
		return idUvem;
	}
	public void setIdUvem(Long idUvem) {
		this.idUvem = idUvem;
	}
	public String getTipoGestor() {
		return tipoGestor;
	}
	public void setTipoGestor(String tipoGestor) {
		this.tipoGestor = tipoGestor;
	}
		
}