package es.pfsgroup.plugin.rem.model;

import java.util.Date;

public final class DtoAltaActivoFinanciero {
// DATOS BÁSICOS ACTIVO

	// IDENTIFICACIÓN
	private Long numActivoHaya;
	private String carteraCodigo;
	private String subcarteraCodigo;
	private String tipoTituloCodigo;
	private String subtipoTituloCodigo;
	private Long numActivoCartera; // número activo según cartera.
	private Long numBienRecovery; // (NMBBIEN - sarebId)'BIE_ENTIDAD_ID'
	private Long idAsuntoRecovery;
	private String tipoActivoCodigo;
	private String subtipoActivoCodigo;
	private String estadoFisicoCodigo;
	private String usoDominanteCodigo;
	private String descripcionActivo;

	// DIRECCION
	private String tipoViaCodigo;
	private String nombreVia;
	private String numVia;
	private String escalera;
	private String planta;
	private String puerta;
	private String provinciaCodigo;
	private String municipioCodigo;
	private String unidadMunicipioCodigo;
	private String codigoPostal;

	// COMERCIALIZACION
	private String destinoComercialCodigo;
	private String tipoAlquilerCodigo;

	// DATOS PRESTAMO QUE GRAVA EL ACTIVO
	private String numPrestamo;
	private String estadoExpedienteRiesgoCodigo;
	private String nifSociedadAcreedora;
	private Long codigoSociedadAcreedora;
	private String nombreSociedadAcreedora;
	private String direccionSociedadAcreedora;
	private Double importeDeuda;
	private Long idGarantia;

// TITULO E INFORMACION REGISTRAL

	// INSCRIPCION
	private String poblacionRegistroCodigo;
	private String numRegistro;
	private Integer tomoRegistro;
	private Integer libroRegistro;
	private Integer folioRegistro;
	private String fincaRegistro;
	private String idufirCruRegistro;
	private Float superficieConstruidaRegistro;
	private Float superficieUtilRegistro;
	private Float superficieRepercusionEECCRegistro;
	private Float parcelaRegistro;
	private Boolean esIntegradoDivHorizontalRegistro;

	// TITULO
	private String nifPropietario;
	private String gradoPropiedadCodigo;
	private Integer percentParticipacionPropiedad;


// INFORMACION ADMINISTRATIVA 
	private String referenciaCatastral;
	private Boolean esVPO;
	private String calificacionCeeCodigo;

// INFORMACION COMERCIAL
	private String nifMediador;
	private Integer numPlantasVivienda;
	private Integer numBanyosVivienda;
	private Integer numAseosVivienda;
	private Integer numDormitoriosVivienda;
	private Boolean trasteroAnejo;
	private Boolean garajeAnejo;
	private Boolean ascensor;
	
// PRECIOS
	private Double precioMinimo;
	private Double precioVentaWeb;
	private Double valorTasacion;
	private Date fechaTasacion;
	
	
// Getters Setters
	public Long getNumActivoHaya() {
		return numActivoHaya;
	}
	public void setNumActivoHaya(Long numActivoHaya) {
		this.numActivoHaya = numActivoHaya;
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
	public Long getNumActivoCartera() {
		return numActivoCartera;
	}
	public void setNumActivoCartera(Long numActivoCartera) {
		this.numActivoCartera = numActivoCartera;
	}
	public Long getNumBienRecovery() {
		return numBienRecovery;
	}
	public void setNumBienRecovery(Long numBienRecovery) {
		this.numBienRecovery = numBienRecovery;
	}
	public Long getIdAsuntoRecovery() {
		return idAsuntoRecovery;
	}
	public void setIdAsuntoRecovery(Long idAsuntoRecovery) {
		this.idAsuntoRecovery = idAsuntoRecovery;
	}
	public String getTipoActivoCodigo() {
		return tipoActivoCodigo;
	}
	public void setTipoActivoCodigo(String tipoActivoCodigo) {
		this.tipoActivoCodigo = tipoActivoCodigo;
	}
	public String getSubtipoActivoCodigo() {
		return subtipoActivoCodigo;
	}
	public void setSubtipoActivoCodigo(String subtipoActivoCodigo) {
		this.subtipoActivoCodigo = subtipoActivoCodigo;
	}
	public String getEstadoFisicoCodigo() {
		return estadoFisicoCodigo;
	}
	public void setEstadoFisicoCodigo(String estadoFisicoCodigo) {
		this.estadoFisicoCodigo = estadoFisicoCodigo;
	}
	public String getUsoDominanteCodigo() {
		return usoDominanteCodigo;
	}
	public void setUsoDominanteCodigo(String usoDominanteCodigo) {
		this.usoDominanteCodigo = usoDominanteCodigo;
	}
	public String getDescripcionActivo() {
		return descripcionActivo;
	}
	public void setDescripcionActivo(String descripcionActivo) {
		this.descripcionActivo = descripcionActivo;
	}
	public String getTipoViaCodigo() {
		return tipoViaCodigo;
	}
	public void setTipoViaCodigo(String tipoViaCodigo) {
		this.tipoViaCodigo = tipoViaCodigo;
	}
	public String getNombreVia() {
		return nombreVia;
	}
	public void setNombreVia(String nombreVia) {
		this.nombreVia = nombreVia;
	}
	public String getNumVia() {
		return numVia;
	}
	public void setNumVia(String numVia) {
		this.numVia = numVia;
	}
	public String getEscalera() {
		return escalera;
	}
	public void setEscalera(String escalera) {
		this.escalera = escalera;
	}
	public String getPlanta() {
		return planta;
	}
	public void setPlanta(String planta) {
		this.planta = planta;
	}
	public String getPuerta() {
		return puerta;
	}
	public void setPuerta(String puerta) {
		this.puerta = puerta;
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
	public String getUnidadMunicipioCodigo() {
		return unidadMunicipioCodigo;
	}
	public void setUnidadMunicipioCodigo(String unidadMunicipioCodigo) {
		this.unidadMunicipioCodigo = unidadMunicipioCodigo;
	}
	public String getCodigoPostal() {
		return codigoPostal;
	}
	public void setCodigoPostal(String codigoPostal) {
		this.codigoPostal = codigoPostal;
	}
	public String getDestinoComercialCodigo() {
		return destinoComercialCodigo;
	}
	public void setDestinoComercialCodigo(String destinoComercialCodigo) {
		this.destinoComercialCodigo = destinoComercialCodigo;
	}
	public String getTipoAlquilerCodigo() {
		return tipoAlquilerCodigo;
	}
	public void setTipoAlquilerCodigo(String tipoAlquilerCodigo) {
		this.tipoAlquilerCodigo = tipoAlquilerCodigo;
	}
	public String getEstadoExpedienteRiesgoCodigo() {
		return estadoExpedienteRiesgoCodigo;
	}
	public void setEstadoExpedienteRiesgoCodigo(String estadoExpedienteRiesgoCodigo) {
		this.estadoExpedienteRiesgoCodigo = estadoExpedienteRiesgoCodigo;
	}
	public String getNifSociedadAcreedora() {
		return nifSociedadAcreedora;
	}
	public void setNifSociedadAcreedora(String nifSociedadAcreedora) {
		this.nifSociedadAcreedora = nifSociedadAcreedora;
	}
	public Long getCodigoSociedadAcreedora() {
		return codigoSociedadAcreedora;
	}
	public void setCodigoSociedadAcreedora(Long codigoSociedadAcreedora) {
		this.codigoSociedadAcreedora = codigoSociedadAcreedora;
	}
	public String getNombreSociedadAcreedora() {
		return nombreSociedadAcreedora;
	}
	public void setNombreSociedadAcreedora(String nombreSociedadAcreedora) {
		this.nombreSociedadAcreedora = nombreSociedadAcreedora;
	}
	public String getDireccionSociedadAcreedora() {
		return direccionSociedadAcreedora;
	}
	public void setDireccionSociedadAcreedora(String direccionSociedadAcreedora) {
		this.direccionSociedadAcreedora = direccionSociedadAcreedora;
	}
	public Double getImporteDeuda() {
		return importeDeuda;
	}
	public void setImporteDeuda(Double importeDeuda) {
		this.importeDeuda = importeDeuda;
	}
	public String getPoblacionRegistroCodigo() {
		return poblacionRegistroCodigo;
	}
	public void setPoblacionRegistroCodigo(String poblacionRegistroCodigo) {
		this.poblacionRegistroCodigo = poblacionRegistroCodigo;
	}
	public String getNumRegistro() {
		return numRegistro;
	}
	public void setNumRegistro(String numRegistro) {
		this.numRegistro = numRegistro;
	}
	public Integer getTomoRegistro() {
		return tomoRegistro;
	}
	public void setTomoRegistro(Integer tomoRegistro) {
		this.tomoRegistro = tomoRegistro;
	}
	public Integer getLibroRegistro() {
		return libroRegistro;
	}
	public void setLibroRegistro(Integer libroRegistro) {
		this.libroRegistro = libroRegistro;
	}
	public Integer getFolioRegistro() {
		return folioRegistro;
	}
	public void setFolioRegistro(Integer folioRegistro) {
		this.folioRegistro = folioRegistro;
	}
	public String getFincaRegistro() {
		return fincaRegistro;
	}
	public void setFincaRegistro(String fincaRegistro) {
		this.fincaRegistro = fincaRegistro;
	}
	public String getIdufirCruRegistro() {
		return idufirCruRegistro;
	}
	public void setIdufirCruRegistro(String idufirCruRegistro) {
		this.idufirCruRegistro = idufirCruRegistro;
	}
	public Float getSuperficieConstruidaRegistro() {
		return superficieConstruidaRegistro;
	}
	public void setSuperficieConstruidaRegistro(Float superficieConstruidaRegistro) {
		this.superficieConstruidaRegistro = superficieConstruidaRegistro;
	}
	public Float getSuperficieUtilRegistro() {
		return superficieUtilRegistro;
	}
	public void setSuperficieUtilRegistro(Float superficieUtilRegistro) {
		this.superficieUtilRegistro = superficieUtilRegistro;
	}
	public Float getSuperficieRepercusionEECCRegistro() {
		return superficieRepercusionEECCRegistro;
	}
	public void setSuperficieRepercusionEECCRegistro(Float superficieRepercusionEECCRegistro) {
		this.superficieRepercusionEECCRegistro = superficieRepercusionEECCRegistro;
	}
	public Float getParcelaRegistro() {
		return parcelaRegistro;
	}
	public void setParcelaRegistro(Float parcelaRegistro) {
		this.parcelaRegistro = parcelaRegistro;
	}
	public Boolean getEsIntegradoDivHorizontalRegistro() {
		return esIntegradoDivHorizontalRegistro;
	}
	public void setEsIntegradoDivHorizontalRegistro(Boolean esIntegradoDivHorizontalRegistro) {
		this.esIntegradoDivHorizontalRegistro = esIntegradoDivHorizontalRegistro;
	}
	public String getNifPropietario() {
		return nifPropietario;
	}
	public void setNifPropietario(String nifPropietario) {
		this.nifPropietario = nifPropietario;
	}
	public String getGradoPropiedadCodigo() {
		return gradoPropiedadCodigo;
	}
	public void setGradoPropiedadCodigo(String gradoPropiedadCodigo) {
		this.gradoPropiedadCodigo = gradoPropiedadCodigo;
	}
	public Integer getPercentParticipacionPropiedad() {
		return percentParticipacionPropiedad;
	}
	public void setPercentParticipacionPropiedad(Integer percentParticipacionPropiedad) {
		this.percentParticipacionPropiedad = percentParticipacionPropiedad;
	}
	public String getReferenciaCatastral() {
		return referenciaCatastral;
	}
	public void setReferenciaCatastral(String referenciaCatastral) {
		this.referenciaCatastral = referenciaCatastral;
	}
	public Boolean getEsVPO() {
		return esVPO;
	}
	public void setEsVPO(Boolean esVPO) {
		this.esVPO = esVPO;
	}
	public Integer getNumPlantasVivienda() {
		return numPlantasVivienda;
	}
	public void setNumPlantasVivienda(Integer numPlantasVivienda) {
		this.numPlantasVivienda = numPlantasVivienda;
	}
	public Integer getNumBanyosVivienda() {
		return numBanyosVivienda;
	}
	public void setNumBanyosVivienda(Integer numBanyosVivienda) {
		this.numBanyosVivienda = numBanyosVivienda;
	}
	public Integer getNumAseosVivienda() {
		return numAseosVivienda;
	}
	public void setNumAseosVivienda(Integer numAseosVivienda) {
		this.numAseosVivienda = numAseosVivienda;
	}
	public Integer getNumDormitoriosVivienda() {
		return numDormitoriosVivienda;
	}
	public void setNumDormitoriosVivienda(Integer numDormitoriosVivienda) {
		this.numDormitoriosVivienda = numDormitoriosVivienda;
	}
	public String getTipoTituloCodigo() {
		return tipoTituloCodigo;
	}
	public void setTipoTituloCodigo(String tipoTituloCodigo) {
		this.tipoTituloCodigo = tipoTituloCodigo;
	}
	public String getSubtipoTituloCodigo() {
		return subtipoTituloCodigo;
	}
	public void setSubtipoTituloCodigo(String subtipoTituloCodigo) {
		this.subtipoTituloCodigo = subtipoTituloCodigo;
	}
	public String getNumPrestamo() {
		return numPrestamo;
	}
	public void setNumPrestamo(String numPrestamo) {
		this.numPrestamo = numPrestamo;
	}
	public Long getIdGarantia() {
		return idGarantia;
	}
	public void setIdGarantia(Long idGarantia) {
		this.idGarantia = idGarantia;
	}
	public String getCalificacionCeeCodigo() {
		return calificacionCeeCodigo;
	}
	public void setCalificacionCeeCodigo(String calificacionCeeCodigo) {
		this.calificacionCeeCodigo = calificacionCeeCodigo;
	}
	public String getNifMediador() {
		return nifMediador;
	}
	public void setNifMediador(String nifMediador) {
		this.nifMediador = nifMediador;
	}
	public Boolean getTrasteroAnejo() {
		return trasteroAnejo;
	}
	public void setTrasteroAnejo(Boolean trasteroAnejo) {
		this.trasteroAnejo = trasteroAnejo;
	}
	public Boolean getGarajeAnejo() {
		return garajeAnejo;
	}
	public void setGarajeAnejo(Boolean garajeAnejo) {
		this.garajeAnejo = garajeAnejo;
	}
	public Boolean getAscensor() {
		return ascensor;
	}
	public void setAscensor(Boolean ascensor) {
		this.ascensor = ascensor;
	}
	public Double getPrecioMinimo() {
		return precioMinimo;
	}
	public void setPrecioMinimo(Double precioMinimo) {
		this.precioMinimo = precioMinimo;
	}
	public Double getPrecioVentaWeb() {
		return precioVentaWeb;
	}
	public void setPrecioVentaWeb(Double precioVentaWeb) {
		this.precioVentaWeb = precioVentaWeb;
	}
	public Double getValorTasacion() {
		return valorTasacion;
	}
	public void setValorTasacion(Double valorTasacion) {
		this.valorTasacion = valorTasacion;
	}
	public Date getFechaTasacion() {
		return fechaTasacion;
	}
	public void setFechaTasacion(Date fechaTasacion) {
		this.fechaTasacion = fechaTasacion;
	}

}
