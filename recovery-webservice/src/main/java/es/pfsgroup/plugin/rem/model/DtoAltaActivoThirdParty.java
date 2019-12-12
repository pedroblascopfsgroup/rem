package es.pfsgroup.plugin.rem.model;

import java.util.Date;

public class DtoAltaActivoThirdParty {
	//llaves
	private Long numActivoHaya;
	private String codSubCartera;
	private String subtipoTituloCodigo;
	private Long numActivoExterno;
	private String tipoActivoCodigo;
	private String subtipoActivoCodigo;
	private String estadoFisicoCodigo;
	private String usoDominanteCodigo;
	private String descripcionActivo;
	
	//direccion
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
	
	//comercializacion
	private String destinoComercialCodigo;
	private String tipoAlquilerCodigo;
	private String tipoDeComercializacion;
	
	//inscripcion
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
	private String esIntegradoDivHorizontalRegistro;
	
	//titulo
	private String nifPropietario;
	private String gradoPropiedadCodigo;
	private Integer percentParticipacionPropiedad;
	
	//
	private String propiedadAnterior;
	private String referenciaCatastral;
	private String esVPO;
	private String calificacionCeeCodigo;
	private String cedudaHabitabilidad;
	
	
	//informacion_publicacion
	private String nifMediador;
	private Integer numPlantasVivienda;
	private Integer numBanyosVivienda;
	private Integer numAseosVivienda;
	private Integer numDormitoriosVivienda;
	private String trasteroAnejo;
	private String garajeAnejo;
	private String ascensor;
	
	//informacion_precios
	private Double precioMinimo;
	private Double precioVentaWeb;
	private Double valorTasacion;
	private Date fechaTasacion;
	
	//gestores del activo
	private String gestorComercial;
	private String supervisorGestorComercial;
	private String gestorFormalizacion;
	private String supervisorGestorFormalizacion;
	private String gestorAdmision;
	private String gestorActivos;
	private String gestoriaDeFormalizacion;
	
	//datos relevante admision
	private Date fechaInscripcion;
	private Date fechaObtencionTitulo;
	private Date fechaTomaPosesion;
	private Date fechaLanzamiento;
	private String ocupado;
	private String tieneTitulo;
	private String llave;
	private String cargas;

	//
	private String tipoActivo;
	private String formalizacion;
	
	//datos propietario
	private String nombrePropietario;
	private String apellidoPropietario1;
	private String apellidoPropietario2;
	private String tipoPropietario;
	private String NIFCIFPropietario;
	
	
	
	
	//getter y setters
	
	public Long getNumActivoHaya() {
		return numActivoHaya;
	}
	public void setNumActivoHaya(Long numActivoHaya) {
		this.numActivoHaya = numActivoHaya;
	}
	public String getCodSubCartera() {
		return codSubCartera;
	}
	public void setCodSubCartera(String codCartera) {
		this.codSubCartera = codCartera;
	}
	public String getSubtipoTituloCodigo() {
		return subtipoTituloCodigo;
	}
	public void setSubtipoTituloCodigo(String subtipoTituloCodigo) {
		this.subtipoTituloCodigo = subtipoTituloCodigo;
	}
	public Long getNumActivoExterno() {
		return numActivoExterno;
	}
	public void setNumActivoExterno(Long numActivoExterno) {
		this.numActivoExterno = numActivoExterno;
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
	public String getTipoDeComercializacion() {
		return tipoDeComercializacion;
	}
	public void setTipoDeComercializacion(String tipoDeComercializacion) {
		this.tipoDeComercializacion = tipoDeComercializacion;
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
	public String getEsIntegradoDivHorizontalRegistro() {
		return esIntegradoDivHorizontalRegistro;
	}
	public void setEsIntegradoDivHorizontalRegistro(String esIntegradoDivHorizontalRegistro) {
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
	public String getPropiedadAnterior() {
		return propiedadAnterior;
	}
	public void setPropiedadAnterior(String propiedadAnterior) {
		this.propiedadAnterior = propiedadAnterior;
	}
	public String getReferenciaCatastral() {
		return referenciaCatastral;
	}
	public void setReferenciaCatastral(String referenciaCatastral) {
		this.referenciaCatastral = referenciaCatastral;
	}
	public String getEsVPO() {
		return esVPO;
	}
	public void setEsVPO(String esVPO) {
		this.esVPO = esVPO;
	}
	public String getCalificacionCeeCodigo() {
		return calificacionCeeCodigo;
	}
	public void setCalificacionCeeCodigo(String calificacionCeeCodigo) {
		this.calificacionCeeCodigo = calificacionCeeCodigo;
	}
	public String getCedudaHabitabilidad() {
		return cedudaHabitabilidad;
	}
	public void setCedudaHabitabilidad(String cedudaHabitabilidad) {
		this.cedudaHabitabilidad = cedudaHabitabilidad;
	}
	public String getNifMediador() {
		return nifMediador;
	}
	public void setNifMediador(String nifMediador) {
		this.nifMediador = nifMediador;
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
	public String getTrasteroAnejo() {
		return trasteroAnejo;
	}
	public void setTrasteroAnejo(String trasteroAnejo) {
		this.trasteroAnejo = trasteroAnejo;
	}
	public String getGarajeAnejo() {
		return garajeAnejo;
	}
	public void setGarajeAnejo(String garajeAnejo) {
		this.garajeAnejo = garajeAnejo;
	}
	public String getAscensor() {
		return ascensor;
	}
	public void setAscensor(String ascensor) {
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
	public String getGestorComercial() {
		return gestorComercial;
	}
	public void setGestorComercial(String gestorComercial) {
		this.gestorComercial = gestorComercial;
	}
	public String getSupervisorGestorComercial() {
		return supervisorGestorComercial;
	}
	public void setSupervisorGestorComercial(String supervisorGestorComercial) {
		this.supervisorGestorComercial = supervisorGestorComercial;
	}
	public String getGestorFormalizacion() {
		return gestorFormalizacion;
	}
	public void setGestorFormalizacion(String gestorFormalizacion) {
		this.gestorFormalizacion = gestorFormalizacion;
	}
	public String getSupervisorGestorFormalizacion() {
		return supervisorGestorFormalizacion;
	}
	public void setSupervisorGestorFormalizacion(String supervisorGestorFormalizacion) {
		this.supervisorGestorFormalizacion = supervisorGestorFormalizacion;
	}
	public String getGestorAdmision() {
		return gestorAdmision;
	}
	public void setGestorAdmision(String gestorAdmision) {
		this.gestorAdmision = gestorAdmision;
	}
	public String getGestorActivos() {
		return gestorActivos;
	}
	public void setGestorActivos(String gestorActivos) {
		this.gestorActivos = gestorActivos;
	}
	public String getGestoriaDeFormalizacion() {
		return gestoriaDeFormalizacion;
	}
	public void setGestoriaDeFormalizacion(String gestoriaDeFormalizacion) {
		this.gestoriaDeFormalizacion = gestoriaDeFormalizacion;
	}
	public Date getFechaInscripcion() {
		return fechaInscripcion;
	}
	public void setFechaInscripcion(Date fechaInscripcion) {
		this.fechaInscripcion = fechaInscripcion;
	}
	public Date getFechaObtencionTitulo() {
		return fechaObtencionTitulo;
	}
	public void setFechaObtencionTitulo(Date fechaObtencionTitulo) {
		this.fechaObtencionTitulo = fechaObtencionTitulo;
	}
	public Date getFechaTomaPosesion() {
		return fechaTomaPosesion;
	}
	public void setFechaTomaPosesion(Date fechaTomaPosesion) {
		this.fechaTomaPosesion = fechaTomaPosesion;
	}
	public Date getFechaLanzamiento() {
		return fechaLanzamiento;
	}
	public void setFechaLanzamiento(Date fechaLanzamiento) {
		this.fechaLanzamiento = fechaLanzamiento;
	}
	public String getOcupado() {
		return ocupado;
	}
	public void setOcupado(String ocupado) {
		this.ocupado = ocupado;
	}
	public String getTieneTitulo() {
		return tieneTitulo;
	}
	public void setTieneTitulo(String tieneTitulo) {
		this.tieneTitulo = tieneTitulo;
	}
	public String getLlave() {
		return llave;
	}
	public void setLlave(String llave) {
		this.llave = llave;
	}
	public String getCargas() {
		return cargas;
	}
	public void setCargas(String cargas) {
		this.cargas = cargas;
	}
	public String getTipoActivo() {
		return tipoActivo;
	}
	public void setTipoActivo(String tipoActivo) {
		this.tipoActivo = tipoActivo;
	}
	public String getFormalizacion() {
		return formalizacion;
	}
	public void setFormalizacion(String formalizacion) {
		this.formalizacion = formalizacion;
	}
	public String getNombrePropietario() {
		return nombrePropietario;
	}
	public void setNombrePropietario(String nombrePropietario) {
		this.nombrePropietario = nombrePropietario;
	}
	public String getApellidoPropietario1() {
		return apellidoPropietario1;
	}
	public void setApellidoPropietario1(String apellidoPropietario1) {
		this.apellidoPropietario1 = apellidoPropietario1;
	}
	public String getApellidoPropietario2() {
		return apellidoPropietario2;
	}
	public void setApellidoPropietario2(String apellidoPropietario2) {
		this.apellidoPropietario2 = apellidoPropietario2;
	}
	public String getTipoPropietario() {
		return tipoPropietario;
	}
	public void setTipoPropietario(String tipoPropietario) {
		this.tipoPropietario = tipoPropietario;
	}
	public String getNIFCIFPropietario() {
		return NIFCIFPropietario;
	}
	public void setNIFCIFPropietario(String nIFCIFPropietario) {
		NIFCIFPropietario = nIFCIFPropietario;
	}	
	
}
