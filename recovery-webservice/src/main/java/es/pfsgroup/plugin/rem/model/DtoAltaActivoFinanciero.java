package es.pfsgroup.plugin.rem.model;

public final class DtoAltaActivoFinanciero {
// DATOS BÁSICOS ACTIVO

	// IDENTIFICACIÓN
	private Long numActivoHaya;
	private String carteraCodigo;
	private Long numActivoCartera;
	private Long numBienRecovery;
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
	private String tipoComercializacionCodigo;
	private String destinoComercialCodigo;
	private String tipoAlquilerCodigo;

	// DATOS PRESTAMO QUE GRAVA EL ACTIVO
	private String numExpedienteRiesgoAsociado;
	private String estadoExpedienteRiesgoCodigo;
	private String tipoProducto;
	private String nifSociedadAcreedora;
	private String nombreSociedadAcreedora;
	private String numSociedadAcreedora;
	private Double importeDeuda;


// TITULO E INFORMACION REGISTRAL

	// INSCRIPCION
	private String provinciaRegistroCodigo;
	private String poblacionRegistroCodigo;
	private String numRegistro;
	private int tomoRegistro;
	private int libroRegistro;
	private int folioRegistro;
	private String fincaRegistro;
	private String idufirCruRegistro;
	private int superficieConstruidaRegistro;
	private int superficieUtilRegistro;
	private int superficieRepercusionEECCRegistro;
	private String parcelaRegistro;
	private Boolean esIntegradoDivHorizontalRegistro;

	// TITULO
	private String nifPropietario;
	private String nombrePropietario;
	private String gradoPropiedadCodigo;
	private int percentParticipacionPropiedad;


// INFORMACION ADMINISTRATIVA
	private String referenciaCatastral;
	private Boolean esVPO;


// INFORMACION COMERCIAL
	private int numPlantasVivienda;
	private int numBanyosVivienda;
	private int numAseosVivienda;
	private int numDormitoriosVivienda;
	private Boolean esLocalConGarageTrastero;
	
	
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
	public String getTipoComercializacionCodigo() {
		return tipoComercializacionCodigo;
	}
	public void setTipoComercializacionCodigo(String tipoComercializacionCodigo) {
		this.tipoComercializacionCodigo = tipoComercializacionCodigo;
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
	public String getNumExpedienteRiesgoAsociado() {
		return numExpedienteRiesgoAsociado;
	}
	public void setNumExpedienteRiesgoAsociado(String numExpedienteRiesgoAsociado) {
		this.numExpedienteRiesgoAsociado = numExpedienteRiesgoAsociado;
	}
	public String getEstadoExpedienteRiesgoCodigo() {
		return estadoExpedienteRiesgoCodigo;
	}
	public void setEstadoExpedienteRiesgoCodigo(String estadoExpedienteRiesgoCodigo) {
		this.estadoExpedienteRiesgoCodigo = estadoExpedienteRiesgoCodigo;
	}
	public String getTipoProducto() {
		return tipoProducto;
	}
	public void setTipoProducto(String tipoProducto) {
		this.tipoProducto = tipoProducto;
	}
	public String getNifSociedadAcreedora() {
		return nifSociedadAcreedora;
	}
	public void setNifSociedadAcreedora(String nifSociedadAcreedora) {
		this.nifSociedadAcreedora = nifSociedadAcreedora;
	}
	public String getNombreSociedadAcreedora() {
		return nombreSociedadAcreedora;
	}
	public void setNombreSociedadAcreedora(String nombreSociedadAcreedora) {
		this.nombreSociedadAcreedora = nombreSociedadAcreedora;
	}
	public String getNumSociedadAcreedora() {
		return numSociedadAcreedora;
	}
	public void setNumSociedadAcreedora(String numSociedadAcreedora) {
		this.numSociedadAcreedora = numSociedadAcreedora;
	}
	public Double getImporteDeuda() {
		return importeDeuda;
	}
	public void setImporteDeuda(Double importeDeuda) {
		this.importeDeuda = importeDeuda;
	}
	public String getProvinciaRegistroCodigo() {
		return provinciaRegistroCodigo;
	}
	public void setProvinciaRegistroCodigo(String provinciaRegistroCodigo) {
		this.provinciaRegistroCodigo = provinciaRegistroCodigo;
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
	public int getTomoRegistro() {
		return tomoRegistro;
	}
	public void setTomoRegistro(int tomoRegistro) {
		this.tomoRegistro = tomoRegistro;
	}
	public int getLibroRegistro() {
		return libroRegistro;
	}
	public void setLibroRegistro(int libroRegistro) {
		this.libroRegistro = libroRegistro;
	}
	public int getFolioRegistro() {
		return folioRegistro;
	}
	public void setFolioRegistro(int folioRegistro) {
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
	public int getSuperficieConstruidaRegistro() {
		return superficieConstruidaRegistro;
	}
	public void setSuperficieConstruidaRegistro(int superficieConstruidaRegistro) {
		this.superficieConstruidaRegistro = superficieConstruidaRegistro;
	}
	public int getSuperficieUtilRegistro() {
		return superficieUtilRegistro;
	}
	public void setSuperficieUtilRegistro(int superficieUtilRegistro) {
		this.superficieUtilRegistro = superficieUtilRegistro;
	}
	public int getSuperficieRepercusionEECCRegistro() {
		return superficieRepercusionEECCRegistro;
	}
	public void setSuperficieRepercusionEECCRegistro(int superficieRepercusionEECCRegistro) {
		this.superficieRepercusionEECCRegistro = superficieRepercusionEECCRegistro;
	}
	public String getParcelaRegistro() {
		return parcelaRegistro;
	}
	public void setParcelaRegistro(String parcelaRegistro) {
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
	public String getNombrePropietario() {
		return nombrePropietario;
	}
	public void setNombrePropietario(String nombrePropietario) {
		this.nombrePropietario = nombrePropietario;
	}
	public String getGradoPropiedadCodigo() {
		return gradoPropiedadCodigo;
	}
	public void setGradoPropiedadCodigo(String gradoPropiedadCodigo) {
		this.gradoPropiedadCodigo = gradoPropiedadCodigo;
	}
	public int getPercentParticipacionPropiedad() {
		return percentParticipacionPropiedad;
	}
	public void setPercentParticipacionPropiedad(int percentParticipacionPropiedad) {
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
	public int getNumPlantasVivienda() {
		return numPlantasVivienda;
	}
	public void setNumPlantasVivienda(int numPlantasVivienda) {
		this.numPlantasVivienda = numPlantasVivienda;
	}
	public int getNumBanyosVivienda() {
		return numBanyosVivienda;
	}
	public void setNumBanyosVivienda(int numBanyosVivienda) {
		this.numBanyosVivienda = numBanyosVivienda;
	}
	public int getNumAseosVivienda() {
		return numAseosVivienda;
	}
	public void setNumAseosVivienda(int numAseosVivienda) {
		this.numAseosVivienda = numAseosVivienda;
	}
	public int getNumDormitoriosVivienda() {
		return numDormitoriosVivienda;
	}
	public void setNumDormitoriosVivienda(int numDormitoriosVivienda) {
		this.numDormitoriosVivienda = numDormitoriosVivienda;
	}
	public Boolean getEsLocalConGarageTrastero() {
		return esLocalConGarageTrastero;
	}
	public void setEsLocalConGarageTrastero(Boolean esLocalConGarageTrastero) {
		this.esLocalConGarageTrastero = esLocalConGarageTrastero;
	}

}
