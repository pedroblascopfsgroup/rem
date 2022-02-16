package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;
/**
 * Dto para la pestaña de información comercial de la ficha de Activo
 * @author Benjamín Guerrero
 *
 */
public class DtoActivoInformacionComercial extends DtoTabActivo {

	private static final long serialVersionUID = 0L;

	private String numeroActivo;
	private String descripcionComercial;
	private Date fechaVisita;
	private Date envioLlavesApi;
	private Date recepcionLlavesApi;
	private Long codigoMediador;
	private String nombreMediador;
	private String emailMediador;
	private String telefonoMediador;
	private Boolean autorizacionWeb;
	private Date fechaAutorizacionHasta;
	private Long codigoMediadorEspejo;
	private String nombreMediadorEspejo;
	private String emailMediadorEspejo;
	private String telefonoMediadorEspejo;
	private Date recepcionLlavesEspejo;
	private Boolean autorizacionWebEspejo;
	private String codigoProveedor;
	private String nombreProveedor;
	private String tipoActivoCodigo;
	private String tipoActivoDescripcion;
	private String subtipoActivoCodigo;
	private String subtipoActivoDescripcion;
	private String tipoViaCodigo;
	private String tipoViaDescripcion;
	private String nombreVia;
	private String numeroDomicilio;
	private String escalera;
	private String piso;
	private String puerta;
	private String provinciaCodigo;
	private String provinciaDescripcion;
	private String municipioCodigo;
	private String municipioDescripcion;
	private String inferiorMunicipioCodigo;
	private String inferiorMunicipioDescripcion;
	private String codPostal;
	private String latitud;
	private String longitud;
	private Integer posibleInforme;
	private String motivoNoPosibleInforme;
	private String ubicacionActivoCodigo;
	private String ubicacionActivoDescripcion;
	private String distrito;
	
	//Informacion general
	private String regimenInmuebleCod;
	private String regimenInmuebleDesc;
	private String estadoOcupacionalCod;
	private String estadoOcupacionalDesc;
	private Integer anyoConstruccion;

	//Caracteristicas del activo
	private String visitableCod;
	private String visitableDesc;
	private String ocupadoCod;
	private String ocupadoDesc;
	private Integer dormitorios;
	private Integer banyos;
	private Integer aseos;
	private Integer salones;
	private Integer estancias;
	private Integer plantas;
	private Integer planta;
	private String ascensorCod;
	private String ascensorDesc;
	private Integer plazasGaraje;
	private String terrazaCod;
	private String terrazaDesc;
	private Double superficieUtil;
	private Double superficieTerraza;
	private String patioCod;
	private String patioDesc;
	private Double superficiePatio;
	private String rehabilitadoCod;
	private String rehabilitadoDesc;
	private Integer anyoRehabilitacion;
	private String licenciaObraCod;
	private String licenciaObraDesc;
	private String estadoConservacionCod;
	private String estadoConservacionDesc;
	private String anejoGarajeCod;
	private String anejoGarajeDesc;
	private String anejoTrasteroCod;
	private String anejoTrasteroDesc;
	
	//Caracteristicas ppales del activo
	private String orientacion;
	private String extIntCod;
	private String extIntDesc;
	private String cocRatingCod;
	private String cocRatingDesc;
	private String cocAmuebladaCod;
	private String cocAmuebladaDesc;
	private String armEmpotradosCod;
	private String armEmpotradosDesc;
	private String calefaccion;
	private String tipoCalefaccionCod;
	private String tipoCalefaccionDesc;
	private String aireAcondCod;
	private String aireAcondDesc;
	
	//Otras caracteristicas del activo (vivienda)
	private String estadoConservacionEdiCod;
	private String estadoConservacionEdiDesc;
	private Integer plantasEdificio;
	private String puertaAccesoCod;
	private String puertaAccesoDesc;
	private String estadoPuertasIntCod;
	private String estadoPuertasIntDesc;
	private String estadoPersianasCod;
	private String estadoPersianasDesc;
	private String estadoVentanasCod;
	private String estadoVentanasDesc;
	private String estadoPinturaCod;
	private String estadoPinturaDesc;
	private String estadoSoladosCod;
	private String estadoSoladosDesc;
	private String estadoBanyosCod;
	private String estadoBanyosDesc;
	private String admiteMascotaCod;
	private String admiteMascotaDesc;
	
	//Otras caracteristicas del activo (!vivienda)
	private String licenciaAperturaCod;
	private String licenciaAperturaDesc;
	private String salidaHumoCod;
	private String salidaHumoDesc;
	private String aptoUsoCod;
	private String aptoUsoDesc;
	private String accesibilidadCod;
	private String accesibilidadDesc;
	private Double edificabilidadTecho;
	private Double superficieSuelo;
	private Double porcUrbEjecutada;
	private String clasificacionCod;
	private String clasificacionDesc;
	private String usoCod;
	private String usoDesc;
	private Double metrosFachada;
	private String almacenCod;
	private String almacenDesc;
	private Double metrosAlmacen;
	private String supVentaExpoCod;
	private String supVentaExpoDesc;
	private Double metrosSupVentaExpo;
	private String entreplantaCod;
	private String entreplantaDesc;
	private Double alturaLibre;
	private Double porcEdiEjecutada;
	
	//Equipamientos
	private String zonaVerdeCod;
	private String zonaVerdeDesc;
	private String jardinCod;
	private String jardinDesc;
	private String zonaDeportivaCod;
	private String zonaDeportivaDesc;
	private String gimnasioCod;
	private String gimnasioDesc;
	private String piscinaCod;
	private String piscinaDesc;
	private String conserjeCod;
	private String conserjeDesc;
	private String accesoMovReducidaCod;
	private String accesoMovReducidaDesc;
	
	//Comunicaciones y servicios
	private String ubicacionCod;
	private String ubicacionDesc;
	private String valUbicacionCod;
	private String valUbicacionDesc;

	//Otra info de interes
	private String modificadoInforme;
	private String completadoInforme;
	private Date fechaModificadoInforme;
	private Date fechaCompletadoInforme;
	private Date fechaRecepcionInforme;
	
	
	public String getNumeroActivo() {
		return numeroActivo;
	}
	public void setNumeroActivo(String numeroActivo) {
		this.numeroActivo = numeroActivo;
	}
	public String getDescripcionComercial() {
		return descripcionComercial;
	}
	public void setDescripcionComercial(String descripcionComercial) {
		this.descripcionComercial = descripcionComercial;
	}
	public Long getCodigoMediador() {
		return codigoMediador;
	}
	public void setCodigoMediador(Long codigoMediador) {
		this.codigoMediador = codigoMediador;
	}
	public String getNombreMediador() {
		return nombreMediador;
	}
	public void setNombreMediador(String nombreMediador) {
		this.nombreMediador = nombreMediador;
	}
	public String getEmailMediador() {
		return emailMediador;
	}
	public void setEmailMediador(String emailMediador) {
		this.emailMediador = emailMediador;
	}
	public String getTelefonoMediador() {
		return telefonoMediador;
	}
	public void setTelefonoMediador(String telefonoMediador) {
		this.telefonoMediador = telefonoMediador;
	}
	public Long getCodigoMediadorEspejo() {
		return codigoMediadorEspejo;
	}
	public void setCodigoMediadorEspejo(Long codigoMediadorEspejo) {
		this.codigoMediadorEspejo = codigoMediadorEspejo;
	}
	public String getNombreMediadorEspejo() {
		return nombreMediadorEspejo;
	}
	public void setNombreMediadorEspejo(String nombreMediadorEspejo) {
		this.nombreMediadorEspejo = nombreMediadorEspejo;
	}
	public String getEmailMediadorEspejo() {
		return emailMediadorEspejo;
	}
	public void setEmailMediadorEspejo(String emailMediadorEspejo) {
		this.emailMediadorEspejo = emailMediadorEspejo;
	}
	public String getTelefonoMediadorEspejo() {
		return telefonoMediadorEspejo;
	}
	public void setTelefonoMediadorEspejo(String telefonoMediadorEspejo) {
		this.telefonoMediadorEspejo = telefonoMediadorEspejo;
	}
	public String getRegimenInmuebleCod() {
		return regimenInmuebleCod;
	}
	public void setRegimenInmuebleCod(String regimenInmuebleCod) {
		this.regimenInmuebleCod = regimenInmuebleCod;
	}
	public String getRegimenInmuebleDesc() {
		return regimenInmuebleDesc;
	}
	public void setRegimenInmuebleDesc(String regimenInmuebleDesc) {
		this.regimenInmuebleDesc = regimenInmuebleDesc;
	}
	public String getEstadoOcupacionalCod() {
		return estadoOcupacionalCod;
	}
	public void setEstadoOcupacionalCod(String estadoOcupacionalCod) {
		this.estadoOcupacionalCod = estadoOcupacionalCod;
	}
	public String getEstadoOcupacionalDesc() {
		return estadoOcupacionalDesc;
	}
	public void setEstadoOcupacionalDesc(String estadoOcupacionalDesc) {
		this.estadoOcupacionalDesc = estadoOcupacionalDesc;
	}
	public Date getFechaVisita() {
		return fechaVisita;
	}
	public void setFechaVisita(Date fechaVisita) {
		this.fechaVisita = fechaVisita;
	}
	public Date getEnvioLlavesApi() {
		return envioLlavesApi;
	}
	public void setEnvioLlavesApi(Date envioLlavesApi) {
		this.envioLlavesApi = envioLlavesApi;
	}
	public Date getRecepcionLlavesApi() {
		return recepcionLlavesApi;
	}
	public void setRecepcionLlavesApi(Date recepcionLlavesApi) {
		this.recepcionLlavesApi = recepcionLlavesApi;
	}
	public Integer getAnyoConstruccion() {
		return anyoConstruccion;
	}
	public void setAnyoConstruccion(Integer anyoConstruccion) {
		this.anyoConstruccion = anyoConstruccion;
	}
	public String getVisitableCod() {
		return visitableCod;
	}
	public void setVisitableCod(String visitableCod) {
		this.visitableCod = visitableCod;
	}
	public String getVisitableDesc() {
		return visitableDesc;
	}
	public void setVisitableDesc(String visitableDesc) {
		this.visitableDesc = visitableDesc;
	}
	public String getOcupadoCod() {
		return ocupadoCod;
	}
	public void setOcupadoCod(String ocupadoCod) {
		this.ocupadoCod = ocupadoCod;
	}
	public String getOcupadoDesc() {
		return ocupadoDesc;
	}
	public void setOcupadoDesc(String ocupadoDesc) {
		this.ocupadoDesc = ocupadoDesc;
	}
	public Integer getDormitorios() {
		return dormitorios;
	}
	public void setDormitorios(Integer dormitorios) {
		this.dormitorios = dormitorios;
	}
	public Integer getBanyos() {
		return banyos;
	}
	public void setBanyos(Integer banyos) {
		this.banyos = banyos;
	}
	public Integer getAseos() {
		return aseos;
	}
	public void setAseos(Integer aseos) {
		this.aseos = aseos;
	}
	public Integer getSalones() {
		return salones;
	}
	public void setSalones(Integer salones) {
		this.salones = salones;
	}
	public Integer getEstancias() {
		return estancias;
	}
	public void setEstancias(Integer estancias) {
		this.estancias = estancias;
	}
	public Integer getPlantas() {
		return plantas;
	}
	public void setPlantas(Integer plantas) {
		this.plantas = plantas;
	}
	public Integer getPlanta() {
		return planta;
	}
	public void setPlanta(Integer planta) {
		this.planta = planta;
	}
	public String getAscensorCod() {
		return ascensorCod;
	}
	public void setAscensorCod(String ascensorCod) {
		this.ascensorCod = ascensorCod;
	}
	public String getAscensorDesc() {
		return ascensorDesc;
	}
	public void setAscensorDesc(String ascensorDesc) {
		this.ascensorDesc = ascensorDesc;
	}
	public Integer getPlazasGaraje() {
		return plazasGaraje;
	}
	public void setPlazasGaraje(Integer plazasGaraje) {
		this.plazasGaraje = plazasGaraje;
	}
	public String getTerrazaCod() {
		return terrazaCod;
	}
	public void setTerrazaCod(String terrazaCod) {
		this.terrazaCod = terrazaCod;
	}
	public String getTerrazaDesc() {
		return terrazaDesc;
	}
	public void setTerrazaDesc(String terrazaDesc) {
		this.terrazaDesc = terrazaDesc;
	}
	public Double getSuperficieUtil() {
		return superficieUtil;
	}
	public void setSuperficieUtil(Double superficieUtil) {
		this.superficieUtil = superficieUtil;
	}
	public Double getSuperficieTerraza() {
		return superficieTerraza;
	}
	public void setSuperficieTerraza(Double superficieTerraza) {
		this.superficieTerraza = superficieTerraza;
	}
	public String getPatioCod() {
		return patioCod;
	}
	public void setPatioCod(String patioCod) {
		this.patioCod = patioCod;
	}
	public String getPatioDesc() {
		return patioDesc;
	}
	public void setPatioDesc(String patioDesc) {
		this.patioDesc = patioDesc;
	}
	public Double getSuperficiePatio() {
		return superficiePatio;
	}
	public void setSuperficiePatio(Double superficiePatio) {
		this.superficiePatio = superficiePatio;
	}
	public String getRehabilitadoCod() {
		return rehabilitadoCod;
	}
	public void setRehabilitadoCod(String rehabilitadoCod) {
		this.rehabilitadoCod = rehabilitadoCod;
	}
	public String getRehabilitadoDesc() {
		return rehabilitadoDesc;
	}
	public void setRehabilitadoDesc(String rehabilitadoDesc) {
		this.rehabilitadoDesc = rehabilitadoDesc;
	}
	public Integer getAnyoRehabilitacion() {
		return anyoRehabilitacion;
	}
	public void setAnyoRehabilitacion(Integer anyoRehabilitacion) {
		this.anyoRehabilitacion = anyoRehabilitacion;
	}
	public String getLicenciaObraCod() {
		return licenciaObraCod;
	}
	public void setLicenciaObraCod(String licenciaObraCod) {
		this.licenciaObraCod = licenciaObraCod;
	}
	public String getLicenciaObraDesc() {
		return licenciaObraDesc;
	}
	public void setLicenciaObraDesc(String licenciaObraDesc) {
		this.licenciaObraDesc = licenciaObraDesc;
	}
	public String getEstadoConservacionCod() {
		return estadoConservacionCod;
	}
	public void setEstadoConservacionCod(String estadoConservacionCod) {
		this.estadoConservacionCod = estadoConservacionCod;
	}
	public String getEstadoConservacionDesc() {
		return estadoConservacionDesc;
	}
	public void setEstadoConservacionDesc(String estadoConservacionDesc) {
		this.estadoConservacionDesc = estadoConservacionDesc;
	}
	public String getAnejoGarajeCod() {
		return anejoGarajeCod;
	}
	public void setAnejoGarajeCod(String anejoGarajeCod) {
		this.anejoGarajeCod = anejoGarajeCod;
	}
	public String getAnejoGarajeDesc() {
		return anejoGarajeDesc;
	}
	public void setAnejoGarajeDesc(String anejoGarajeDesc) {
		this.anejoGarajeDesc = anejoGarajeDesc;
	}
	public String getAnejoTrasteroCod() {
		return anejoTrasteroCod;
	}
	public void setAnejoTrasteroCod(String anejoTrasteroCod) {
		this.anejoTrasteroCod = anejoTrasteroCod;
	}
	public String getAnejoTrasteroDesc() {
		return anejoTrasteroDesc;
	}
	public void setAnejoTrasteroDesc(String anejoTrasteroDesc) {
		this.anejoTrasteroDesc = anejoTrasteroDesc;
	}
	public String getOrientacion() {
		return orientacion;
	}
	public void setOrientacion(String orientacion) {
		this.orientacion = orientacion;
	}
	public String getExtIntCod() {
		return extIntCod;
	}
	public void setExtIntCod(String extIntCod) {
		this.extIntCod = extIntCod;
	}
	public String getExtIntDesc() {
		return extIntDesc;
	}
	public void setExtIntDesc(String extIntDesc) {
		this.extIntDesc = extIntDesc;
	}
	public String getCocRatingCod() {
		return cocRatingCod;
	}
	public void setCocRatingCod(String cocRatingCod) {
		this.cocRatingCod = cocRatingCod;
	}
	public String getCocRatingDesc() {
		return cocRatingDesc;
	}
	public void setCocRatingDesc(String cocRatingDesc) {
		this.cocRatingDesc = cocRatingDesc;
	}
	public String getCocAmuebladaCod() {
		return cocAmuebladaCod;
	}
	public void setCocAmuebladaCod(String cocAmuebladaCod) {
		this.cocAmuebladaCod = cocAmuebladaCod;
	}
	public String getCocAmuebladaDesc() {
		return cocAmuebladaDesc;
	}
	public void setCocAmuebladaDesc(String cocAmuebladaDesc) {
		this.cocAmuebladaDesc = cocAmuebladaDesc;
	}
	public String getArmEmpotradosCod() {
		return armEmpotradosCod;
	}
	public void setArmEmpotradosCod(String armEmpotradosCod) {
		this.armEmpotradosCod = armEmpotradosCod;
	}
	public String getArmEmpotradosDesc() {
		return armEmpotradosDesc;
	}
	public void setArmEmpotradosDesc(String armEmpotradosDesc) {
		this.armEmpotradosDesc = armEmpotradosDesc;
	}
	public String getCalefaccion() {
		return calefaccion;
	}
	public void setCalefaccion(String calefaccion) {
		this.calefaccion = calefaccion;
	}
	public String getTipoCalefaccionCod() {
		return tipoCalefaccionCod;
	}
	public void setTipoCalefaccionCod(String tipoCalefaccionCod) {
		this.tipoCalefaccionCod = tipoCalefaccionCod;
	}
	public String getTipoCalefaccionDesc() {
		return tipoCalefaccionDesc;
	}
	public void setTipoCalefaccionDesc(String tipoCalefaccionDesc) {
		this.tipoCalefaccionDesc = tipoCalefaccionDesc;
	}
	public String getAireAcondCod() {
		return aireAcondCod;
	}
	public void setAireAcondCod(String aireAcondCod) {
		this.aireAcondCod = aireAcondCod;
	}
	public String getAireAcondDesc() {
		return aireAcondDesc;
	}
	public void setAireAcondDesc(String aireAcondDesc) {
		this.aireAcondDesc = aireAcondDesc;
	}
	public String getEstadoConservacionEdiCod() {
		return estadoConservacionEdiCod;
	}
	public void setEstadoConservacionEdiCod(String estadoConservacionEdiCod) {
		this.estadoConservacionEdiCod = estadoConservacionEdiCod;
	}
	public String getEstadoConservacionEdiDesc() {
		return estadoConservacionEdiDesc;
	}
	public void setEstadoConservacionEdiDesc(String estadoConservacionEdiDesc) {
		this.estadoConservacionEdiDesc = estadoConservacionEdiDesc;
	}
	public Integer getPlantasEdificio() {
		return plantasEdificio;
	}
	public void setPlantasEdificio(Integer plantasEdificio) {
		this.plantasEdificio = plantasEdificio;
	}
	public String getPuertaAccesoCod() {
		return puertaAccesoCod;
	}
	public void setPuertaAccesoCod(String puertaAccesoCod) {
		this.puertaAccesoCod = puertaAccesoCod;
	}
	public String getPuertaAccesoDesc() {
		return puertaAccesoDesc;
	}
	public void setPuertaAccesoDesc(String puertaAccesoDesc) {
		this.puertaAccesoDesc = puertaAccesoDesc;
	}
	public String getEstadoPuertasIntCod() {
		return estadoPuertasIntCod;
	}
	public void setEstadoPuertasIntCod(String estadoPuertasIntCod) {
		this.estadoPuertasIntCod = estadoPuertasIntCod;
	}
	public String getEstadoPuertasIntDesc() {
		return estadoPuertasIntDesc;
	}
	public void setEstadoPuertasIntDesc(String estadoPuertasIntDesc) {
		this.estadoPuertasIntDesc = estadoPuertasIntDesc;
	}
	public String getEstadoPersianasCod() {
		return estadoPersianasCod;
	}
	public void setEstadoPersianasCod(String estadoPersianasCod) {
		this.estadoPersianasCod = estadoPersianasCod;
	}
	public String getEstadoPersianasDesc() {
		return estadoPersianasDesc;
	}
	public void setEstadoPersianasDesc(String estadoPersianasDesc) {
		this.estadoPersianasDesc = estadoPersianasDesc;
	}
	public String getEstadoVentanasCod() {
		return estadoVentanasCod;
	}
	public void setEstadoVentanasCod(String estadoVentanasCod) {
		this.estadoVentanasCod = estadoVentanasCod;
	}
	public String getEstadoVentanasDesc() {
		return estadoVentanasDesc;
	}
	public void setEstadoVentanasDesc(String estadoVentanasDesc) {
		this.estadoVentanasDesc = estadoVentanasDesc;
	}
	public String getEstadoPinturaCod() {
		return estadoPinturaCod;
	}
	public void setEstadoPinturaCod(String estadoPinturaCod) {
		this.estadoPinturaCod = estadoPinturaCod;
	}
	public String getEstadoPinturaDesc() {
		return estadoPinturaDesc;
	}
	public void setEstadoPinturaDesc(String estadoPinturaDesc) {
		this.estadoPinturaDesc = estadoPinturaDesc;
	}
	public String getEstadoSoladosCod() {
		return estadoSoladosCod;
	}
	public void setEstadoSoladosCod(String estadoSoladosCod) {
		this.estadoSoladosCod = estadoSoladosCod;
	}
	public String getEstadoSoladosDesc() {
		return estadoSoladosDesc;
	}
	public void setEstadoSoladosDesc(String estadoSoladosDesc) {
		this.estadoSoladosDesc = estadoSoladosDesc;
	}
	public String getEstadoBanyosCod() {
		return estadoBanyosCod;
	}
	public void setEstadoBanyosCod(String estadoBanyosCod) {
		this.estadoBanyosCod = estadoBanyosCod;
	}
	public String getEstadoBanyosDesc() {
		return estadoBanyosDesc;
	}
	public void setEstadoBanyosDesc(String estadoBanyosDesc) {
		this.estadoBanyosDesc = estadoBanyosDesc;
	}
	public String getAdmiteMascotaCod() {
		return admiteMascotaCod;
	}
	public void setAdmiteMascotaCod(String admiteMascotaCod) {
		this.admiteMascotaCod = admiteMascotaCod;
	}
	public String getAdmiteMascotaDesc() {
		return admiteMascotaDesc;
	}
	public void setAdmiteMascotaDesc(String admiteMascotaDesc) {
		this.admiteMascotaDesc = admiteMascotaDesc;
	}
	public String getLicenciaAperturaCod() {
		return licenciaAperturaCod;
	}
	public void setLicenciaAperturaCod(String licenciaAperturaCod) {
		this.licenciaAperturaCod = licenciaAperturaCod;
	}
	public String getLicenciaAperturaDesc() {
		return licenciaAperturaDesc;
	}
	public void setLicenciaAperturaDesc(String licenciaAperturaDesc) {
		this.licenciaAperturaDesc = licenciaAperturaDesc;
	}
	public String getSalidaHumoCod() {
		return salidaHumoCod;
	}
	public void setSalidaHumoCod(String salidaHumoCod) {
		this.salidaHumoCod = salidaHumoCod;
	}
	public String getSalidaHumoDesc() {
		return salidaHumoDesc;
	}
	public void setSalidaHumoDesc(String salidaHumoDesc) {
		this.salidaHumoDesc = salidaHumoDesc;
	}
	public String getAptoUsoCod() {
		return aptoUsoCod;
	}
	public void setAptoUsoCod(String aptoUsoCod) {
		this.aptoUsoCod = aptoUsoCod;
	}
	public String getAptoUsoDesc() {
		return aptoUsoDesc;
	}
	public void setAptoUsoDesc(String aptoUsoDesc) {
		this.aptoUsoDesc = aptoUsoDesc;
	}
	public String getAccesibilidadCod() {
		return accesibilidadCod;
	}
	public void setAccesibilidadCod(String accesibilidadCod) {
		this.accesibilidadCod = accesibilidadCod;
	}
	public String getAccesibilidadDesc() {
		return accesibilidadDesc;
	}
	public void setAccesibilidadDesc(String accesibilidadDesc) {
		this.accesibilidadDesc = accesibilidadDesc;
	}
	public Double getEdificabilidadTecho() {
		return edificabilidadTecho;
	}
	public void setEdificabilidadTecho(Double edificabilidadTecho) {
		this.edificabilidadTecho = edificabilidadTecho;
	}
	public Double getSuperficieSuelo() {
		return superficieSuelo;
	}
	public void setSuperficieSuelo(Double superficieSuelo) {
		this.superficieSuelo = superficieSuelo;
	}
	public Double getPorcUrbEjecutada() {
		return porcUrbEjecutada;
	}
	public void setPorcUrbEjecutada(Double porcUrbEjecutada) {
		this.porcUrbEjecutada = porcUrbEjecutada;
	}
	public String getClasificacionCod() {
		return clasificacionCod;
	}
	public void setClasificacionCod(String clasificacionCod) {
		this.clasificacionCod = clasificacionCod;
	}
	public String getClasificacionDesc() {
		return clasificacionDesc;
	}
	public void setClasificacionDesc(String clasificacionDesc) {
		this.clasificacionDesc = clasificacionDesc;
	}
	public String getUsoCod() {
		return usoCod;
	}
	public void setUsoCod(String usoCod) {
		this.usoCod = usoCod;
	}
	public String getUsoDesc() {
		return usoDesc;
	}
	public void setUsoDesc(String usoDesc) {
		this.usoDesc = usoDesc;
	}
	public Double getMetrosFachada() {
		return metrosFachada;
	}
	public void setMetrosFachada(Double metrosFachada) {
		this.metrosFachada = metrosFachada;
	}
	public String getAlmacenCod() {
		return almacenCod;
	}
	public void setAlmacenCod(String almacenCod) {
		this.almacenCod = almacenCod;
	}
	public String getAlmacenDesc() {
		return almacenDesc;
	}
	public void setAlmacenDesc(String almacenDesc) {
		this.almacenDesc = almacenDesc;
	}
	public Double getMetrosAlmacen() {
		return metrosAlmacen;
	}
	public void setMetrosAlmacen(Double metrosAlmacen) {
		this.metrosAlmacen = metrosAlmacen;
	}
	public String getSupVentaExpoCod() {
		return supVentaExpoCod;
	}
	public void setSupVentaExpoCod(String supVentaExpoCod) {
		this.supVentaExpoCod = supVentaExpoCod;
	}
	public String getSupVentaExpoDesc() {
		return supVentaExpoDesc;
	}
	public void setSupVentaExpoDesc(String supVentaExpoDesc) {
		this.supVentaExpoDesc = supVentaExpoDesc;
	}
	public Double getMetrosSupVentaExpo() {
		return metrosSupVentaExpo;
	}
	public void setMetrosSupVentaExpo(Double metrosSupVentaExpo) {
		this.metrosSupVentaExpo = metrosSupVentaExpo;
	}
	public String getEntreplantaCod() {
		return entreplantaCod;
	}
	public void setEntreplantaCod(String entreplantaCod) {
		this.entreplantaCod = entreplantaCod;
	}
	public String getEntreplantaDesc() {
		return entreplantaDesc;
	}
	public void setEntreplantaDesc(String entreplantaDesc) {
		this.entreplantaDesc = entreplantaDesc;
	}
	public Double getAlturaLibre() {
		return alturaLibre;
	}
	public void setAlturaLibre(Double alturaLibre) {
		this.alturaLibre = alturaLibre;
	}
	public Double getPorcEdiEjecutada() {
		return porcEdiEjecutada;
	}
	public void setPorcEdiEjecutada(Double porcEdiEjecutada) {
		this.porcEdiEjecutada = porcEdiEjecutada;
	}
	public String getZonaVerdeCod() {
		return zonaVerdeCod;
	}
	public void setZonaVerdeCod(String zonaVerdeCod) {
		this.zonaVerdeCod = zonaVerdeCod;
	}
	public String getZonaVerdeDesc() {
		return zonaVerdeDesc;
	}
	public void setZonaVerdeDesc(String zonaVerdeDesc) {
		this.zonaVerdeDesc = zonaVerdeDesc;
	}
	public String getJardinCod() {
		return jardinCod;
	}
	public void setJardinCod(String jardinCod) {
		this.jardinCod = jardinCod;
	}
	public String getJardinDesc() {
		return jardinDesc;
	}
	public void setJardinDesc(String jardinDesc) {
		this.jardinDesc = jardinDesc;
	}
	public String getZonaDeportivaCod() {
		return zonaDeportivaCod;
	}
	public void setZonaDeportivaCod(String zonaDeportivaCod) {
		this.zonaDeportivaCod = zonaDeportivaCod;
	}
	public String getZonaDeportivaDesc() {
		return zonaDeportivaDesc;
	}
	public void setZonaDeportivaDesc(String zonaDeportivaDesc) {
		this.zonaDeportivaDesc = zonaDeportivaDesc;
	}
	public String getGimnasioCod() {
		return gimnasioCod;
	}
	public void setGimnasioCod(String gimnasioCod) {
		this.gimnasioCod = gimnasioCod;
	}
	public String getGimnasioDesc() {
		return gimnasioDesc;
	}
	public void setGimnasioDesc(String gimnasioDesc) {
		this.gimnasioDesc = gimnasioDesc;
	}
	public String getPiscinaCod() {
		return piscinaCod;
	}
	public void setPiscinaCod(String piscinaCod) {
		this.piscinaCod = piscinaCod;
	}
	public String getPiscinaDesc() {
		return piscinaDesc;
	}
	public void setPiscinaDesc(String piscinaDesc) {
		this.piscinaDesc = piscinaDesc;
	}
	public String getConserjeCod() {
		return conserjeCod;
	}
	public void setConserjeCod(String conserjeCod) {
		this.conserjeCod = conserjeCod;
	}
	public String getConserjeDesc() {
		return conserjeDesc;
	}
	public void setConserjeDesc(String conserjeDesc) {
		this.conserjeDesc = conserjeDesc;
	}
	public String getAccesoMovReducidaCod() {
		return accesoMovReducidaCod;
	}
	public void setAccesoMovReducidaCod(String accesoMovReducidaCod) {
		this.accesoMovReducidaCod = accesoMovReducidaCod;
	}
	public String getAccesoMovReducidaDesc() {
		return accesoMovReducidaDesc;
	}
	public void setAccesoMovReducidaDesc(String accesoMovReducidaDesc) {
		this.accesoMovReducidaDesc = accesoMovReducidaDesc;
	}
	public String getUbicacionCod() {
		return ubicacionCod;
	}
	public void setUbicacionCod(String ubicacionCod) {
		this.ubicacionCod = ubicacionCod;
	}
	public String getUbicacionDesc() {
		return ubicacionDesc;
	}
	public void setUbicacionDesc(String ubicacionDesc) {
		this.ubicacionDesc = ubicacionDesc;
	}
	public String getValUbicacionCod() {
		return valUbicacionCod;
	}
	public void setValUbicacionCod(String valUbicacionCod) {
		this.valUbicacionCod = valUbicacionCod;
	}
	public String getValUbicacionDesc() {
		return valUbicacionDesc;
	}
	public void setValUbicacionDesc(String valUbicacionDesc) {
		this.valUbicacionDesc = valUbicacionDesc;
	}
	public String getModificadoInforme() {
		return modificadoInforme;
	}
	public void setModificadoInforme(String modificadoInforme) {
		this.modificadoInforme = modificadoInforme;
	}
	public String getCompletadoInforme() {
		return completadoInforme;
	}
	public void setCompletadoInforme(String completadoInforme) {
		this.completadoInforme = completadoInforme;
	}
	public Date getFechaModificadoInforme() {
		return fechaModificadoInforme;
	}
	public void setFechaModificadoInforme(Date fechaModificadoInforme) {
		this.fechaModificadoInforme = fechaModificadoInforme;
	}
	public Date getFechaCompletadoInforme() {
		return fechaCompletadoInforme;
	}
	public void setFechaCompletadoInforme(Date fechaCompletadoInforme) {
		this.fechaCompletadoInforme = fechaCompletadoInforme;
	}
	public Date getFechaRecepcionInforme() {
		return fechaRecepcionInforme;
	}
	public void setFechaRecepcionInforme(Date fechaRecepcionInforme) {
		this.fechaRecepcionInforme = fechaRecepcionInforme;
	}
	public Boolean getAutorizacionWeb() {
		return autorizacionWeb;
	}
	public void setAutorizacionWeb(Boolean autorizacionWeb) {
		this.autorizacionWeb = autorizacionWeb;
	}
	public Date getFechaAutorizacionHasta() {
		return fechaAutorizacionHasta;
	}
	public void setFechaAutorizacionHasta(Date fechaAutorizacionHasta) {
		this.fechaAutorizacionHasta = fechaAutorizacionHasta;
	}
	public Date getRecepcionLlavesEspejo() {
		return recepcionLlavesEspejo;
	}
	public void setRecepcionLlavesEspejo(Date recepcionLlavesEspejo) {
		this.recepcionLlavesEspejo = recepcionLlavesEspejo;
	}
	public Boolean getAutorizacionWebEspejo() {
		return autorizacionWebEspejo;
	}
	public void setAutorizacionWebEspejo(Boolean autorizacionWebEspejo) {
		this.autorizacionWebEspejo = autorizacionWebEspejo;
	}
	public String getCodigoProveedor() {
		return codigoProveedor;
	}
	public void setCodigoProveedor(String codigoProveedor) {
		this.codigoProveedor = codigoProveedor;
	}
	public String getNombreProveedor() {
		return nombreProveedor;
	}
	public void setNombreProveedor(String nombreProveedor) {
		this.nombreProveedor = nombreProveedor;
	}
	public String getTipoActivoCodigo() {
		return tipoActivoCodigo;
	}
	public void setTipoActivoCodigo(String tipoActivoCodigo) {
		this.tipoActivoCodigo = tipoActivoCodigo;
	}
	public String getTipoActivoDescripcion() {
		return tipoActivoDescripcion;
	}
	public void setTipoActivoDescripcion(String tipoActivoDescripcion) {
		this.tipoActivoDescripcion = tipoActivoDescripcion;
	}
	public String getSubtipoActivoCodigo() {
		return subtipoActivoCodigo;
	}
	public void setSubtipoActivoCodigo(String subtipoActivoCodigo) {
		this.subtipoActivoCodigo = subtipoActivoCodigo;
	}
	public String getSubtipoActivoDescripcion() {
		return subtipoActivoDescripcion;
	}
	public void setSubtipoActivoDescripcion(String subtipoActivoDescripcion) {
		this.subtipoActivoDescripcion = subtipoActivoDescripcion;
	}
	public String getTipoViaCodigo() {
		return tipoViaCodigo;
	}
	public void setTipoViaCodigo(String tipoViaCodigo) {
		this.tipoViaCodigo = tipoViaCodigo;
	}
	public String getTipoViaDescripcion() {
		return tipoViaDescripcion;
	}
	public void setTipoViaDescripcion(String tipoViaDescripcion) {
		this.tipoViaDescripcion = tipoViaDescripcion;
	}
	public String getNombreVia() {
		return nombreVia;
	}
	public void setNombreVia(String nombreVia) {
		this.nombreVia = nombreVia;
	}
	public String getNumeroDomicilio() {
		return numeroDomicilio;
	}
	public void setNumeroDomicilio(String numeroDomicilio) {
		this.numeroDomicilio = numeroDomicilio;
	}
	public String getEscalera() {
		return escalera;
	}
	public void setEscalera(String escalera) {
		this.escalera = escalera;
	}
	public String getPiso() {
		return piso;
	}
	public void setPiso(String piso) {
		this.piso = piso;
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
	public String getProvinciaDescripcion() {
		return provinciaDescripcion;
	}
	public void setProvinciaDescripcion(String provinciaDescripcion) {
		this.provinciaDescripcion = provinciaDescripcion;
	}
	public String getMunicipioCodigo() {
		return municipioCodigo;
	}
	public void setMunicipioCodigo(String municipioCodigo) {
		this.municipioCodigo = municipioCodigo;
	}
	public String getMunicipioDescripcion() {
		return municipioDescripcion;
	}
	public void setMunicipioDescripcion(String municipioDescripcion) {
		this.municipioDescripcion = municipioDescripcion;
	}
	public String getInferiorMunicipioCodigo() {
		return inferiorMunicipioCodigo;
	}
	public void setInferiorMunicipioCodigo(String inferiorMunicipioCodigo) {
		this.inferiorMunicipioCodigo = inferiorMunicipioCodigo;
	}
	public String getInferiorMunicipioDescripcion() {
		return inferiorMunicipioDescripcion;
	}
	public void setInferiorMunicipioDescripcion(String inferiorMunicipioDescripcion) {
		this.inferiorMunicipioDescripcion = inferiorMunicipioDescripcion;
	}
	public String getCodPostal() {
		return codPostal;
	}
	public void setCodPostal(String codPostal) {
		this.codPostal = codPostal;
	}
	public String getLatitud() {
		return latitud;
	}
	public void setLatitud(String latitud) {
		this.latitud = latitud;
	}
	public String getLongitud() {
		return longitud;
	}
	public void setLongitud(String longitud) {
		this.longitud = longitud;
	}
	public Integer getPosibleInforme() {
		return posibleInforme;
	}
	public void setPosibleInforme(Integer posibleInforme) {
		this.posibleInforme = posibleInforme;
	}
	public String getMotivoNoPosibleInforme() {
		return motivoNoPosibleInforme;
	}
	public void setMotivoNoPosibleInforme(String motivoNoPosibleInforme) {
		this.motivoNoPosibleInforme = motivoNoPosibleInforme;
	}
	public String getUbicacionActivoCodigo() {
		return ubicacionActivoCodigo;
	}
	public void setUbicacionActivoCodigo(String ubicacionActivoCodigo) {
		this.ubicacionActivoCodigo = ubicacionActivoCodigo;
	}
	public String getUbicacionActivoDescripcion() {
		return ubicacionActivoDescripcion;
	}
	public void setUbicacionActivoDescripcion(String ubicacionActivoDescripcion) {
		this.ubicacionActivoDescripcion = ubicacionActivoDescripcion;
	}
	public String getDistrito() {
		return distrito;
	}
	public void setDistrito(String distrito) {
		this.distrito = distrito;
	}
	
}