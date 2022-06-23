package es.pfsgroup.plugin.rem.model;

import java.util.Date;

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
	private Long idCliente;
	private Boolean excluirGencat;
	private Long numOferPrincipal;
	private String direccionComercial;
	private Date fechaAlta;
	private Boolean checkSubasta;
	
	//HREOS-6905
	private String claseOferta;
	
	//HREOS-4937
	private Boolean cesionDatos;
	private Boolean comunicacionTerceros;
	private Boolean transferenciasInternacionales;
	private Long idDocAdjunto;
	
	//REMVIP-4116
	private String subcarteraCodigo;
	
	//REMVIP-8377
	private Long idOfertaOrigen;
	
	//REMVIP-8524
	private Boolean ofrDocRespPrescriptor;
	
	private String vinculoCaixaCodigo;
	
	private String fechaNacimientoConstitucion;
	private String paisNacimientoCompradorCodigo;
    private String localidadNacimientoCompradorCodigo;
    private String codigoPais;
    private String provinciaCodigo;
    private String municipioCodigo;
    private String direccion;
    private Boolean prp;
    private String localidadNacimientoCompradorDescripcion;
    private String tipologivaVentaCod;
    private String provinciaNacimiento;
    private String provinciaNacimientoDescripcion;
    private String codigoPostalNacimiento;
    private String emailNacimiento;
    private String telefonoNacimiento1;
    private String telefonoNacimiento2;
    
    private String codTipoDocumentoRte;
    private String numDocumentoRte;
    private String nombreRazonSocialRte;
    private String apellidosRte;
    private String paisNacimientoRepresentanteCodigo;
    private String provinciaNacimientoRepresentanteCodigo;
    private String localidadNacimientoRepresentanteCodigo;
    private String fechaNacimientoRepresentante ;
    private String codigoPaisRte;
    private String provinciaRteCodigo;
    private String municipioRteCodigo;
    private String codigoPostalRte;
    private String direccionRte;
    private String emailRte;
    private String telefono1Rte;
    private String telefono2Rte;
    private Boolean representantePrp;
    private String sociedadEmpleadoCaixa;
    private String oficinaEmpleadoCaixa;
    private Boolean antiguoDeudor;
    private String nacionalidadCodigo;
    private String nacionalidadRprCodigo;
    private String ibanDevolucion;
		
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
	public void setGestoria(Long codGestoria) {
		this.gestoria = codGestoria;
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
	
	//HREOS-4937
	public Boolean getCesionDatos() {
		return cesionDatos;
	}
	public void setCesionDatos(Boolean cesionDatos) {
		this.cesionDatos = cesionDatos;
	}
	public Boolean getComunicacionTerceros() {
		return comunicacionTerceros;
	}
	public void setComunicacionTerceros(Boolean comunicacionTerceros) {
		this.comunicacionTerceros = comunicacionTerceros;
	}
	public Boolean getTransferenciasInternacionales() {
		return transferenciasInternacionales;
	}
	public void setTransferenciasInternacionales(Boolean transferenciasInternacionales) {
		this.transferenciasInternacionales = transferenciasInternacionales;
	}
	public Long getIdDocAdjunto() {
		return idDocAdjunto;
	}
	public void setIdDocAdjunto(Long idDocAdjunto) {
		this.idDocAdjunto = idDocAdjunto;
	}
	public Long getIdCliente() {
		return idCliente;
	}
	public void setIdCliente(Long idCliente) {
		this.idCliente = idCliente;
	}
	public Long getNumOferPrincipal() {
		return numOferPrincipal;
	}
	public void setNumOferPrincipal(Long numOferPrincipal) {
		this.numOferPrincipal = numOferPrincipal;
	}
	
	
	
	//REMVIP-4116
	public String getSubcarteraCodigo() {
		return subcarteraCodigo;
	}
	public void setSubcarteraCodigo(String subcarteraCodigo) {
		this.subcarteraCodigo = subcarteraCodigo;
	}
	public Boolean getExcluirGencat() {
		return excluirGencat;
	}
	public void setExcluirGencat(Boolean excluirGencat) {
		this.excluirGencat = excluirGencat;
	}
	
	
	
		
	//HREOS-6905 
	public String getClaseOferta() {
		return claseOferta;
	}
	public void setClaseOferta(String claseOferta) {
		this.claseOferta = claseOferta;
	}
	public String getDireccionComercial() {
		return direccionComercial;
	}
	public void setDireccionComercial(String direccionComercial) {
		this.direccionComercial = direccionComercial;
	}
	public Date getFechaAlta() {
		return fechaAlta;
	}
	public void setFechaAlta(Date fechaAlta) {
		this.fechaAlta = fechaAlta;
	}
	
	
	
	
	//REMVIP-8377
	public Long getIdOfertaOrigen() {
		return idOfertaOrigen;
	}
	public void setIdOfertaOrigen(Long idOfertaOrigen) {
		this.idOfertaOrigen = idOfertaOrigen;
	}
	
	
	
	
	//REMVIP-8524
	public Boolean getOfrDocRespPrescriptor() {
		return ofrDocRespPrescriptor;
	}

	public void setOfrDocRespPrescriptor(Boolean ofrDocRespPrescriptor) {
		this.ofrDocRespPrescriptor = ofrDocRespPrescriptor;
	}
	public String getFechaNacimientoConstitucion() {
		return fechaNacimientoConstitucion;
	}
	public void setFechaNacimientoConstitucion(String fechaNacimientoConstitucion) {
		this.fechaNacimientoConstitucion = fechaNacimientoConstitucion;
	}
	public String getPaisNacimientoCompradorCodigo() {
		return paisNacimientoCompradorCodigo;
	}
	public void setPaisNacimientoCompradorCodigo(String paisNacimientoCompradorCodigo) {
		this.paisNacimientoCompradorCodigo = paisNacimientoCompradorCodigo;
	}
	public String getLocalidadNacimientoCompradorCodigo() {
		return localidadNacimientoCompradorCodigo;
	}
	public void setLocalidadNacimientoCompradorCodigo(String localidadNacimientoCompradorCodigo) {
		this.localidadNacimientoCompradorCodigo = localidadNacimientoCompradorCodigo;
	}
	public String getCodigoPais() {
		return codigoPais;
	}
	public void setCodigoPais(String codigoPais) {
		this.codigoPais = codigoPais;
	}
	public String getProvinciaCodigo() {
		return provinciaCodigo;
	}
	public void setProvinciaCodigo(String provinciaCodigo) {
		this.provinciaCodigo = provinciaCodigo;
	}
	public String getMunicipioCodigo() {
		return municipioCodigo;
	}
	public void setMunicipioCodigo(String municipioCodigo) {
		this.municipioCodigo = municipioCodigo;
	}
	public String getDireccion() {
		return direccion;
	}
	public void setDireccion(String direccion) {
		this.direccion = direccion;
	}
	public Boolean getPrp() {
		return prp;
	}
	public void setPrp(Boolean prp) {
		this.prp = prp;
	}
	public String getLocalidadNacimientoCompradorDescripcion() {
		return localidadNacimientoCompradorDescripcion;
	}
	public void setLocalidadNacimientoCompradorDescripcion(String localidadNacimientoCompradorDescripcion) {
		this.localidadNacimientoCompradorDescripcion = localidadNacimientoCompradorDescripcion;
	}
	public String getVinculoCaixaCodigo() {
		return vinculoCaixaCodigo;
	}
	public void setVinculoCaixaCodigo(String vinculoCaixaCodigo) {
		this.vinculoCaixaCodigo = vinculoCaixaCodigo;
	}
	public String getTipologivaVentaCod() {
		return tipologivaVentaCod;
	}
	public void setTipologivaVentaCod(String tipologivaVentaCod) {
		this.tipologivaVentaCod = tipologivaVentaCod;
	}
	public String getProvinciaNacimiento() {
		return provinciaNacimiento;
	}
	public void setProvinciaNacimiento(String provinciaNacimiento) {
		this.provinciaNacimiento = provinciaNacimiento;
	}
	public String getProvinciaNacimientoDescripcion() {
		return provinciaNacimientoDescripcion;
	}
	public void setProvinciaNacimientoDescripcion(String provinciaNacimientoDescripcion) {
		this.provinciaNacimientoDescripcion = provinciaNacimientoDescripcion;
	}
	public String getCodigoPostalNacimiento() {
		return codigoPostalNacimiento;
	}
	public void setCodigoPostalNacimiento(String codigoPostalNacimiento) {
		this.codigoPostalNacimiento = codigoPostalNacimiento;
	}
	public String getEmailNacimiento() {
		return emailNacimiento;
	}
	public void setEmailNacimiento(String emailNacimiento) {
		this.emailNacimiento = emailNacimiento;
	}
	public String getTelefonoNacimiento1() {
		return telefonoNacimiento1;
	}
	public void setTelefonoNacimiento1(String telefonoNacimiento1) {
		this.telefonoNacimiento1 = telefonoNacimiento1;
	}
	public String getTelefonoNacimiento2() {
		return telefonoNacimiento2;
	}
	public void setTelefonoNacimiento2(String telefonoNacimiento2) {
		this.telefonoNacimiento2 = telefonoNacimiento2;
	}
	public Boolean getCheckSubasta() {
		return checkSubasta;
	}
	public void setCheckSubasta(Boolean checkSubasta) {
		this.checkSubasta = checkSubasta;
	}
	public String getCodTipoDocumentoRte() {
		return codTipoDocumentoRte;
	}
	public void setCodTipoDocumentoRte(String codTipoDocumentoRte) {
		this.codTipoDocumentoRte = codTipoDocumentoRte;
	}
	public String getNumDocumentoRte() {
		return numDocumentoRte;
	}
	public void setNumDocumentoRte(String numDocumentoRte) {
		this.numDocumentoRte = numDocumentoRte;
	}
	public String getNombreRazonSocialRte() {
		return nombreRazonSocialRte;
	}
	public void setNombreRazonSocialRte(String nombreRazonSocialRte) {
		this.nombreRazonSocialRte = nombreRazonSocialRte;
	}
	public String getApellidosRte() {
		return apellidosRte;
	}
	public void setApellidosRte(String apellidosRte) {
		this.apellidosRte = apellidosRte;
	}
	public String getPaisNacimientoRepresentanteCodigo() {
		return paisNacimientoRepresentanteCodigo;
	}
	public void setPaisNacimientoRepresentanteCodigo(String paisNacimientoRepresentanteCodigo) {
		this.paisNacimientoRepresentanteCodigo = paisNacimientoRepresentanteCodigo;
	}
	public String getProvinciaNacimientoRepresentanteCodigo() {
		return provinciaNacimientoRepresentanteCodigo;
	}
	public void setProvinciaNacimientoRepresentanteCodigo(String provinciaNacimientoRepresentanteCodigo) {
		this.provinciaNacimientoRepresentanteCodigo = provinciaNacimientoRepresentanteCodigo;
	}
	public String getLocalidadNacimientoRepresentanteCodigo() {
		return localidadNacimientoRepresentanteCodigo;
	}
	public void setLocalidadNacimientoRepresentanteCodigo(String localidadNacimientoRepresentanteCodigo) {
		this.localidadNacimientoRepresentanteCodigo = localidadNacimientoRepresentanteCodigo;
	}
	public String getFechaNacimientoRepresentante() {
		return fechaNacimientoRepresentante;
	}
	public void setFechaNacimientoRepresentante(String fechaNacimientoRepresentante) {
		this.fechaNacimientoRepresentante = fechaNacimientoRepresentante;
	}
	public String getCodigoPaisRte() {
		return codigoPaisRte;
	}
	public void setCodigoPaisRte(String codigoPaisRte) {
		this.codigoPaisRte = codigoPaisRte;
	}
	public String getProvinciaRteCodigo() {
		return provinciaRteCodigo;
	}
	public void setProvinciaRteCodigo(String provinciaRteCodigo) {
		this.provinciaRteCodigo = provinciaRteCodigo;
	}
	public String getMunicipioRteCodigo() {
		return municipioRteCodigo;
	}
	public void setMunicipioRteCodigo(String municipioRteCodigo) {
		this.municipioRteCodigo = municipioRteCodigo;
	}
	public String getCodigoPostalRte() {
		return codigoPostalRte;
	}
	public void setCodigoPostalRte(String codigoPostalRte) {
		this.codigoPostalRte = codigoPostalRte;
	}
	public String getDireccionRte() {
		return direccionRte;
	}
	public void setDireccionRte(String direccionRte) {
		this.direccionRte = direccionRte;
	}
	public String getEmailRte() {
		return emailRte;
	}
	public void setEmailRte(String emailRte) {
		this.emailRte = emailRte;
	}
	public String getTelefono1Rte() {
		return telefono1Rte;
	}
	public void setTelefono1Rte(String telefono1Rte) {
		this.telefono1Rte = telefono1Rte;
	}
	public String getTelefono2Rte() {
		return telefono2Rte;
	}
	public void setTelefono2Rte(String telefono2Rte) {
		this.telefono2Rte = telefono2Rte;
	}
	public Boolean getRepresentantePrp() {
		return representantePrp;
	}
	public void setRepresentantePrp(Boolean representantePrp) {
		this.representantePrp = representantePrp;
	}
	public String getSociedadEmpleadoCaixa() {
		return sociedadEmpleadoCaixa;
	}
	public void setSociedadEmpleadoCaixa(String sociedadEmpleadoCaixa) {
		this.sociedadEmpleadoCaixa = sociedadEmpleadoCaixa;
	}
	public String getOficinaEmpleadoCaixa() {
		return oficinaEmpleadoCaixa;
	}
	public void setOficinaEmpleadoCaixa(String oficinaEmpleadoCaixa) {
		this.oficinaEmpleadoCaixa = oficinaEmpleadoCaixa;
	}
	public Boolean getAntiguoDeudor() {
		return antiguoDeudor;
	}
	public void setAntiguoDeudor(Boolean antiguoDeudor) {
		this.antiguoDeudor = antiguoDeudor;
	}
	public String getNacionalidadCodigo() {
		return nacionalidadCodigo;
	}
	public void setNacionalidadCodigo(String nacionalidadCodigo) {
		this.nacionalidadCodigo = nacionalidadCodigo;
	}
	public String getNacionalidadRprCodigo() {
		return nacionalidadRprCodigo;
	}
	public void setNacionalidadRprCodigo(String nacionalidadRprCodigo) {
		this.nacionalidadRprCodigo = nacionalidadRprCodigo;
	}
	public String getIbanDevolucion() {
		return ibanDevolucion;
	}
	public void setIbanDevolucion(String ibanDevolucion) {
		this.ibanDevolucion = ibanDevolucion;
	}
	
}