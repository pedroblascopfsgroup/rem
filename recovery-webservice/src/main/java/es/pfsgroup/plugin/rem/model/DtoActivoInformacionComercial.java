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
	private String anyoConstruccion;
	private String anyoRehabilitacion;
	private Integer aptoPublicidad;
	private String activosVinculados;
	private Date fechaEmisionInforme;
	private Date fechaAceptacion;
	private Date fechaRechazo;
	private Date fechaUltimaVisita;
	private Long codigoMediador;
	private String nombreMediador;
	private String emailMediador;
	private String telefonoMediador;
	private Long codigoMediadorEspejo;
	private String nombreMediadorEspejo;
	private String emailMediadorEspejo;
	private String telefonoMediadorEspejo;
	
	//Para la info de viviendas
	private String ultimaPlanta;
	private String numPlantasInter;
	private Boolean reformaCarpInt;
	private Boolean reformaCarpExt;
	private Boolean reformaCocina;
	private Boolean reformaBanyo;
	private Boolean reformaSuelo;
	private Boolean reformaPintura;
	private Boolean reformaIntegral;
	private Boolean reformaOtro;
	private String reformaOtroDesc;
	private String reformaPresupuesto;
	private String distribucionTxt;
	
	//Para la info de plazas de aparcamiento - Varios (Otros)
	private Boolean destinoCoche;
	private Boolean destinoMoto;
	private Boolean destinoDoble;
	private String anchura;
	private String profundidad;
	private Boolean formaIrregular;
	private String aparcamientoAltura;
	private Integer aparcamientoLicencia;
	private Integer aparcamientoSerbidumbre;
	private Integer aparcamientoMontacarga;
	private Integer aparcamientoColumnas;
	private Integer aparcamientoSeguridad;
	private String subtipoActivoCodigo;
	private String subtipoPlazagarajeCodigo;
	private String maniobrabilidadCodigo;
	
	//Para la info de locales comerciales
	private String mtsFachadaPpal;
	private String mtsFachadaLat;
	private String mtsLuzLibre;
	private String mtsAlturaLibre;
	private String mtsLinealesProf;
	private Integer diafano;
	private String usuIdoneo;
	private String usuAnterior;
	private String observaciones;
	private Boolean existeSalidaHumos; 
	private Boolean existeSalidaEmergencias;
	private Boolean existeAccesoMinusvalidos;
	private String otrosOtrasCaracteristicas; 
	
	//Para la info de edificio
	private Integer ascensor;
	private String anyoRehabilitacionEdificio;
	private String numPlantas;
	private String numAscensores;
	private Boolean reformaFachada;
	private Boolean reformaEscalera;
	private Boolean reformaPortal;
	private Boolean reformaAscensor;
	private Boolean reformaCubierta;
	private Boolean reformaOtrasZonasComunes;
	private String entornoComunicaciones;
	private String entornoInfraestructuras;
	private String ediDescripcion;
	private String reformaOtroDescEdificio;
	private Integer edificioDivisible;
	private String edificioOtrasCaracteristicas;
	private String edificioDescPlantas;
	
	//Para la info de suelo e industrial.
	private String infoDescripcion;
	private String infoDistribucionInterior;
	
	//Para la info de calidades
	private Integer ocio;
	private Integer hoteles;
	private String hotelesDesc;
	private Integer teatros;
	private String teatrosDesc;
	private Integer salasCine;
	private String salasCineDesc;
	private Integer instDeportivas;
	private String instDeportivasDesc;
	private Integer centrosComerciales;
	private String centrosComercialesDesc;
	private String ocioOtros;
	private Integer centrosEducativos;
	private Integer escuelasInfantiles;
	private String escuelasInfantilesDesc;
	private Integer colegios;
	private String colegiosDesc;
	private Integer institutos;
	private String institutosDesc;
	private Integer universidades;
	private String universidadesDesc;
	private String centrosEducativosOtros;
	private Integer centrosSanitarios;
	private Integer centrosSalud;
	private String centrosSaludDesc;
	private Integer clinicas;
	private String clinicasDesc;
	private Integer hospitales;
	private String hospitalesDesc;
	private String centrosSanitariosOtros;
	private Integer parkingSuperSufi;
	private Integer comunicaciones;
	private Integer facilAcceso;
	private String facilAccesoDesc;
	private Integer lineasBus;
	private String lineasBusDesc;
	private Integer metro;
	private String metroDesc;
	private Integer estacionTren;
	private String estacionTrenDesc;
	private String comunicacionesOtro;
	//--
    private String acabadoCarpinteriaCodigo;   
    private Integer puertaEntradaNormal;
	private Integer puertaEntradaBlindada;
	private Integer puertaEntradaAcorazada;
	private Integer puertaPasoMaciza;
	private Integer puertaPasoHueca;
	private Integer puertaPasoLacada;
	private Integer armariosEmpotrados;
	private String carpinteriaInteriorOtros;
	//--
    private Integer ventanasHierro;
	private Integer ventanasAluAnodizado;
	private Integer ventanasAluLacado;
	private Integer ventanasPVC;
	private Integer ventanasMadera;
	private Integer persianasPlastico;
	private Integer persianasAluminio;
	private Integer ventanasCorrederas;
	private Integer ventanasAbatibles;
	private Integer ventanasOscilobatientes;
	private Integer dobleCristal;
	private Integer dobleCristalEstado;
	private String carpinteriaExteriorOtros;
	//--
	private Integer humedadPared;   
	private Integer humedadTecho;
	private Integer grietaPared;
	private Integer grietaTecho;
	private Integer gotele;
	private Integer plasticaLisa;
	private Integer papelPintado;
	private Integer pinturaLisaTecho;
	private Integer pinturaLisaTechoEstado;
	private Integer molduraEscayola;
	private Integer molduraEscayolaEstado;
	private String paramentosOtros;
	//--
    private Integer tarimaFlotante;   
	private Integer parque;
	private Integer soladoMarmol;
	private Integer plaqueta;
	private String soladoOtros;
	//--
    private Integer amueblada; 
    private Integer estadoAmueblada; 
    private Integer encimera;   
	private Integer encimeraGranito;
	private Integer encimeraMarmol;
	private Integer encimeraOtroMaterial;	
	private Integer vitro;
    private Integer lavadora;   
	private Integer frigorifico;
	private Integer lavavajillas;
	private Integer microondas;
    private Integer horno;   
	private Integer suelosCocina;
	private Integer azulejos;
	private Integer estadoAzulejos;
	private Integer grifosMonomandos;
	private Integer estadoGrifosMonomandos;
	private String cocinaOtros;
	//--
	private Integer duchaBanyera;
    private Integer ducha;   
	private Integer banyera;
	private Integer banyeraHidromasaje;
	private Integer columnaHidromasaje;
    private Integer alicatadoMarmol;   
	private Integer alicatadoGranito;
	private Integer alicatadoAzulejo;
	private Integer encimeraBanyo;
    private Integer encimeraBanyoMarmol;   
	private Integer encimeraBanyoGranito;
	private Integer encimeraBanyoOtroMaterial;
	private Integer sanitarios;
	private Integer estadoSanitarios;
	private Integer suelosBanyo;
	private Integer grifoMonomando;
	private Integer estadoGrifoMonomando;
	private String banyoOtros;
	//--
	private Integer electricidadConContador;
	private Integer electricidadBuenEstado;
	private Integer electricidadDefectuosa;
	private Integer electricidad;
	private Integer aguaConContador;
	private Integer aguaBuenEstado;
	private Integer aguaDefectuosa;
    private Integer aguaCalienteCentral;
	private Integer aguaCalienteGasNat;
	private Integer agua;
	private Integer gasConContador;
	private Integer gasBuenEstado;
	private Integer gasDefectuosa;
	private Integer gas;
	private Integer calefaccionCentral;
	private Integer calefaccionGasNat;
	private Integer calefaccionRadiadorAlu;
	private Integer calefaccionPreinstalacion;
	private Integer airePreinstalacion;
	private Integer aireInstalacion;
	private Integer aireFrioCalor;
	private String instalacionOtros;
	//--
    private Integer jardines;   
	private Integer piscina;
	private Integer padel;
    private Integer tenis;   
	private Integer pistaPolideportiva;
	private String instalacionesDeportivasOtros;
	private Integer zonaInfantil;
    private Integer conserjeVigilancia;
	private Integer gimnasio;
	private String zonaComunOtros;
	
	// Mapeados a mano
	private String ubicacionActivoCodigo;
	private String ubicacionActivoDescripcion;
    private String estadoConstruccionCodigo;
    private String estadoConstruccionDescripcion;
    private String estadoConservacionCodigo;
    private String estadoConservacionDescripcion;
    private String estadoConservacionEdificioCodigo;
    private String estadoConservacionEdificioDescripcion;
    private String tipoFachadaCodigo; 
    private String tipoFachadaDescripcion;
    private String tipoViviendaCodigo;
    private String tipoViviendaDescripcion;
    private String tipoOrientacionCodigo; 
    private String tipoRentaCodigo; 
    private String tipoCalidadCodigo;
    private String ubicacionAparcamientoCodigo;
    private String tipoInfoComercialCodigo;
    private String tipoActivoCodigo;
	
	public String getInfoDescripcion() {
		return infoDescripcion;
	}
	public void setInfoDescripcion(String infoDescripcion) {
		this.infoDescripcion = infoDescripcion;
	}
	public String getInfoDistribucionInterior() {
		return infoDistribucionInterior;
	}
	public void setInfoDistribucionInterior(String infoDistribucionInterior) {
		this.infoDistribucionInterior = infoDistribucionInterior;
	}
	public String getEntornoComunicaciones() {
		return entornoComunicaciones;
	}
	public void setEntornoComunicaciones(String entornoComunicaciones) {
		this.entornoComunicaciones = entornoComunicaciones;
	}
	public String getEntornoInfraestructuras() {
		return entornoInfraestructuras;
	}
	public void setEntornoInfraestructuras(String entornoInfraestructuras) {
		this.entornoInfraestructuras = entornoInfraestructuras;
	}
	public Boolean getReformaOtrasZonasComunes() {
		return reformaOtrasZonasComunes;
	}
	public void setReformaOtrasZonasComunes(Boolean reformaOtrasZonasComunes) {
		this.reformaOtrasZonasComunes = reformaOtrasZonasComunes;
	}
	public String getNumeroActivo() {
		return numeroActivo;
	}
	public Long getCodigoMediador() {
		return codigoMediador;
	}
	public void setCodigoMediador(Long codigoMediador) {
		this.codigoMediador = codigoMediador;
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
	public String getAnyoConstruccion() {
		return anyoConstruccion;
	}
	public void setAnyoConstruccion(String anyoConstruccion) {
		this.anyoConstruccion = anyoConstruccion;
	}
	public String getAnyoRehabilitacion() {
		return anyoRehabilitacion;
	}
	public void setAnyoRehabilitacion(String anyoRehabilitacion) {
		this.anyoRehabilitacion = anyoRehabilitacion;
	}
	public Integer getAptoPublicidad() {
		return aptoPublicidad;
	}
	public void setAptoPublicidad(Integer aptoPublicidad) {
		this.aptoPublicidad = aptoPublicidad;
	}
	public Integer getAscensor() {
		return ascensor;
	}
	public void setAscensor(Integer ascensor) {
		this.ascensor = ascensor;
	}
	public String getReformaOtroDescEdificio() {
		return reformaOtroDescEdificio;
	}
	public void setReformaOtroDescEdificio(String reformaOtroDescEdificio) {
		this.reformaOtroDescEdificio = reformaOtroDescEdificio;
	}
	public String getNumPlantasInter() {
		return numPlantasInter;
	}
	public void setNumPlantasInter(String numPlantasInter) {
		this.numPlantasInter = numPlantasInter;
	}
	public String getAnyoRehabilitacionEdificio() {
		return anyoRehabilitacionEdificio;
	}
	public void setAnyoRehabilitacionEdificio(String anyoRehabilitacionEdificio) {
		this.anyoRehabilitacionEdificio = anyoRehabilitacionEdificio;
	}
	public String getMtsFachadaPpal() {
		return mtsFachadaPpal;
	}
	public void setMtsFachadaPpal(String mtsFachadaPpal) {
		this.mtsFachadaPpal = mtsFachadaPpal;
	}
	public String getMtsFachadaLat() {
		return mtsFachadaLat;
	}
	public void setMtsFachadaLat(String mtsFachadaLat) {
		this.mtsFachadaLat = mtsFachadaLat;
	}
	public String getMtsLuzLibre() {
		return mtsLuzLibre;
	}
	public void setMtsLuzLibre(String mtsLuzLibre) {
		this.mtsLuzLibre = mtsLuzLibre;
	}
	public String getMtsAlturaLibre() {
		return mtsAlturaLibre;
	}
	public void setMtsAlturaLibre(String mtsAlturaLibre) {
		this.mtsAlturaLibre = mtsAlturaLibre;
	}
	public String getMtsLinealesProf() {
		return mtsLinealesProf;
	}
	public void setMtsLinealesProf(String mtsLinealesProf) {
		this.mtsLinealesProf = mtsLinealesProf;
	}
	public Integer getDiafano() {
		return diafano;
	}
	public void setDiafano(Integer diafano) {
		this.diafano = diafano;
	}
	public String getUsuIdoneo() {
		return usuIdoneo;
	}
	public void setUsuIdoneo(String usuIdoneo) {
		this.usuIdoneo = usuIdoneo;
	}
	public String getUsuAnterior() {
		return usuAnterior;
	}
	public void setUsuAnterior(String usuAnterior) {
		this.usuAnterior = usuAnterior;
	}
/*	public Integer getNumPlazasGaraje() {
		return numPlazasGaraje;
	}
	public void setNumPlazasGaraje(Integer numPlazasGaraje) {
		this.numPlazasGaraje = numPlazasGaraje;
	}*/
	public Date getFechaEmisionInforme() {
		return fechaEmisionInforme;
	}
	public void setFechaEmisionInforme(Date fechaEmisionInforme) {
		this.fechaEmisionInforme = fechaEmisionInforme;
	}
	public Date getFechaUltimaVisita() {
		return fechaUltimaVisita;
	}
	public void setFechaUltimaVisita(Date fechaUltimaVisita) {
		this.fechaUltimaVisita = fechaUltimaVisita;
	}
	public String getUbicacionActivoCodigo() {
		return ubicacionActivoCodigo;
	}
	public void setUbicacionActivoCodigo(String ubicacionActivoCodigo) {
		this.ubicacionActivoCodigo = ubicacionActivoCodigo;
	}
	public String getEstadoConstruccionCodigo() {
		return estadoConstruccionCodigo;
	}
	public void setEstadoConstruccionCodigo(String estadoConstruccionCodigo) {
		this.estadoConstruccionCodigo = estadoConstruccionCodigo;
	}
	public String getEstadoConservacionCodigo() {
		return estadoConservacionCodigo;
	}
	public void setEstadoConservacionCodigo(String estadoConservacionCodigo) {
		this.estadoConservacionCodigo = estadoConservacionCodigo;
	}
	public String getEstadoConservacionEdificioCodigo() {
		return estadoConservacionEdificioCodigo;
	}
	public void setEstadoConservacionEdificioCodigo(
			String estadoConservacionEdificioCodigo) {
		this.estadoConservacionEdificioCodigo = estadoConservacionEdificioCodigo;
	}
	public String getTipoFachadaCodigo() {
		return tipoFachadaCodigo;
	}
	public void setTipoFachadaCodigo(String tipoFachadaCodigo) {
		this.tipoFachadaCodigo = tipoFachadaCodigo;
	}
	public String getTipoViviendaCodigo() {
		return tipoViviendaCodigo;
	}
	public void setTipoViviendaCodigo(String tipoViviendaCodigo) {
		this.tipoViviendaCodigo = tipoViviendaCodigo;
	}
	public String getTipoViviendaDescripcion() {
		return tipoViviendaDescripcion;
	}
	public void setTipoViviendaDescripcion(String tipoViviendaDescripcion) {
		this.tipoViviendaDescripcion = tipoViviendaDescripcion;
	}
	public String getTipoOrientacionCodigo() {
		return tipoOrientacionCodigo;
	}
	public void setTipoOrientacionCodigo(String tipoOrientacionCodigo) {
		this.tipoOrientacionCodigo = tipoOrientacionCodigo;
	}
	public String getTipoRentaCodigo() {
		return tipoRentaCodigo;
	}
	public void setTipoRentaCodigo(String tipoRentaCodigo) {
		this.tipoRentaCodigo = tipoRentaCodigo;
	}
	public String getActivosVinculados() {
		return activosVinculados;
	}
	public void setActivosVinculados(String activosVinculados) {
		this.activosVinculados = activosVinculados;
	}
	public String getObservaciones() {
		return observaciones;
	}
	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	public String getUltimaPlanta() {
		return ultimaPlanta;
	}
	public void setUltimaPlanta(String ultimaPlanta) {
		this.ultimaPlanta = ultimaPlanta;
	}
	public Boolean getReformaCarpInt() {
		return reformaCarpInt;
	}
	public void setReformaCarpInt(Boolean reformaCarpInt) {
		this.reformaCarpInt = reformaCarpInt;
	}
	public Boolean isReformaCarpInt() {
		return reformaCarpInt;
	}
	public Boolean getReformaCarpExt() {
		return reformaCarpExt;
	}
	public void setReformaCarpExt(Boolean reformaCarpExt) {
		this.reformaCarpExt = reformaCarpExt;
	}
	public Boolean isReformaCarpExt() {
		return reformaCarpExt;
	}
	public Boolean getReformaCocina() {
		return reformaCocina;
	}
	public void setReformaCocina(Boolean reformaCocina) {
		this.reformaCocina = reformaCocina;
	}
	public Boolean isReformaCocina() {
		return reformaCocina;
	}
	public Boolean getReformaBanyo() {
		return reformaBanyo;
	}
	public void setReformaBanyo(Boolean reformaBanyo) {
		this.reformaBanyo = reformaBanyo;
	}
	public Boolean isReformaBanyo() {
		return reformaBanyo;
	}
	public Boolean getReformaSuelo() {
		return reformaSuelo;
	}
	public void setReformaSuelo(Boolean reformaSuelo) {
		this.reformaSuelo = reformaSuelo;
	}
	public Boolean isReformaSuelo() {
		return reformaSuelo;
	}
	public Boolean getReformaPintura() {
		return reformaPintura;
	}
	public void setReformaPintura(Boolean reformaPintura) {
		this.reformaPintura = reformaPintura;
	}
	public Boolean isReformaPintura() {
		return reformaPintura;
	}
	public Boolean getReformaIntegral() {
		return reformaIntegral;
	}
	public void setReformaIntegral(Boolean reformaIntegral) {
		this.reformaIntegral = reformaIntegral;
	}
	public Boolean isReformaIntegral() {
		return reformaIntegral;
	}
	public Boolean getReformaOtro() {
		return reformaOtro;
	}
	public void setReformaOtro(Boolean reformaOtro) {
		this.reformaOtro = reformaOtro;
	}
	public Boolean isReformaOtro() {
		return reformaOtro;
	}
	public String getReformaPresupuesto() {
		return reformaPresupuesto;
	}
	public void setReformaPresupuesto(String reformaPresupuesto) {
		this.reformaPresupuesto = reformaPresupuesto;
	}
	public String getDistribucionTxt() {
		return distribucionTxt;
	}
	public void setDistribucionTxt(String distribucionTxt) {
		this.distribucionTxt = distribucionTxt;
	}
	public Boolean getDestinoCoche() {
		return destinoCoche;
	}
	public void setDestinoCoche(Boolean destinoCoche) {
		this.destinoCoche = destinoCoche;
	}
	public Boolean isDestinoCoche() {
		return destinoCoche;
	}
	public Boolean getDestinoMoto() {
		return destinoMoto;
	}
	public void setDestinoMoto(Boolean destinoMoto) {
		this.destinoMoto = destinoMoto;
	}
	public Boolean isDestinoMoto() {
		return destinoMoto;
	}
	public Boolean getDestinoDoble() {
		return destinoDoble;
	}
	public void setDestinoDoble(Boolean destinoDoble) {
		this.destinoDoble = destinoDoble;
	}
	public Boolean isDestinoDoble() {
		return destinoDoble;
	}
	public String getAnchura() {
		return anchura;
	}
	public void setAnchura(String anchura) {
		this.anchura = anchura;
	}
	public String getProfundidad() {
		return profundidad;
	}
	public void setProfundidad(String profundidad) {
		this.profundidad = profundidad;
	}
	public Boolean getFormaIrregular() {
		return formaIrregular;
	}
	public void setFormaIrregular(Boolean formaIrregular) {
		this.formaIrregular = formaIrregular;
	}
	public Boolean isFormaIrregular() {
		return formaIrregular;
	}
	public String getNumPlantas() {
		return numPlantas;
	}
	public void setNumPlantas(String numPlantas) {
		this.numPlantas = numPlantas;
	}
	public String getNumAscensores() {
		return numAscensores;
	}
	public void setNumAscensores(String numAscensores) {
		this.numAscensores = numAscensores;
	}
	public Boolean getReformaFachada() {
		return reformaFachada;
	}
	public void setReformaFachada(Boolean reformaFachada) {
		this.reformaFachada = reformaFachada;
	}
	public Boolean isReformaFachada() {
		return reformaFachada;
	}
	public Boolean getReformaEscalera() {
		return reformaEscalera;
	}
	public void setReformaEscalera(Boolean reformaEscalera) {
		this.reformaEscalera = reformaEscalera;
	}
	public Boolean isReformaEscalera() {
		return reformaEscalera;
	}
	public Boolean getReformaPortal() {
		return reformaPortal;
	}
	public void setReformaPortal(Boolean reformaPortal) {
		this.reformaPortal = reformaPortal;
	}
	public Boolean isReformaPortal() {
		return reformaPortal;
	}
	public Boolean getReformaAscensor() {
		return reformaAscensor;
	}
	public void setReformaAscensor(Boolean reformaAscensor) {
		this.reformaAscensor = reformaAscensor;
	}
	public Boolean isReformaAscensor() {
		return reformaAscensor;
	}
	public Boolean getReformaCubierta() {
		return reformaCubierta;
	}
	public void setReformaCubierta(Boolean reformaCubierta) {
		this.reformaCubierta = reformaCubierta;
	}
	public Boolean isReformaCubierta() {
		return reformaCubierta;
	}
	public String getReformaOtroDesc() {
		return reformaOtroDesc;
	}
	public void setReformaOtroDesc(String reformaOtroDesc) {
		this.reformaOtroDesc = reformaOtroDesc;
	}
	public Integer getOcio() {
		return ocio;
	}
	public void setOcio(Integer ocio) {
		this.ocio = ocio;
	}
	public Integer getHoteles() {
		return hoteles;
	}
	public void setHoteles(Integer hoteles) {
		this.hoteles = hoteles;
	}
	public String getHotelesDesc() {
		return hotelesDesc;
	}
	public void setHotelesDesc(String hotelesDesc) {
		this.hotelesDesc = hotelesDesc;
	}
	public Integer getTeatros() {
		return teatros;
	}
	public void setTeatros(Integer teatros) {
		this.teatros = teatros;
	}
	public String getTeatrosDesc() {
		return teatrosDesc;
	}
	public void setTeatrosDesc(String teatrosDesc) {
		this.teatrosDesc = teatrosDesc;
	}
	public Integer getSalasCine() {
		return salasCine;
	}
	public void setSalasCine(Integer salasCine) {
		this.salasCine = salasCine;
	}
	public String getSalasCineDesc() {
		return salasCineDesc;
	}
	public void setSalasCineDesc(String salasCineDesc) {
		this.salasCineDesc = salasCineDesc;
	}
	public Integer getInstDeportivas() {
		return instDeportivas;
	}
	public void setInstDeportivas(Integer instDeportivas) {
		this.instDeportivas = instDeportivas;
	}
	public String getInstDeportivasDesc() {
		return instDeportivasDesc;
	}
	public void setInstDeportivasDesc(String instDeportivasDesc) {
		this.instDeportivasDesc = instDeportivasDesc;
	}
	public Integer getCentrosComerciales() {
		return centrosComerciales;
	}
	public void setCentrosComerciales(Integer centrosComerciales) {
		this.centrosComerciales = centrosComerciales;
	}
	public String getCentrosComercialesDesc() {
		return centrosComercialesDesc;
	}
	public void setCentrosComercialesDesc(String centrosComercialesDesc) {
		this.centrosComercialesDesc = centrosComercialesDesc;
	}
	public String getOcioOtros() {
		return ocioOtros;
	}
	public void setOcioOtros(String ocioOtros) {
		this.ocioOtros = ocioOtros;
	}
	public Integer getCentrosEducativos() {
		return centrosEducativos;
	}
	public void setCentrosEducativos(Integer centrosEducativos) {
		this.centrosEducativos = centrosEducativos;
	}
	public Integer getEscuelasInfantiles() {
		return escuelasInfantiles;
	}
	public void setEscuelasInfantiles(Integer escuelasInfantiles) {
		this.escuelasInfantiles = escuelasInfantiles;
	}
	public String getEscuelasInfantilesDesc() {
		return escuelasInfantilesDesc;
	}
	public void setEscuelasInfantilesDesc(String escuelasInfantilesDesc) {
		this.escuelasInfantilesDesc = escuelasInfantilesDesc;
	}
	public Integer getColegios() {
		return colegios;
	}
	public void setColegios(Integer colegios) {
		this.colegios = colegios;
	}
	public String getColegiosDesc() {
		return colegiosDesc;
	}
	public void setColegiosDesc(String colegiosDesc) {
		this.colegiosDesc = colegiosDesc;
	}
	public Integer getInstitutos() {
		return institutos;
	}
	public void setInstitutos(Integer institutos) {
		this.institutos = institutos;
	}
	public String getInstitutosDesc() {
		return institutosDesc;
	}
	public void setInstitutosDesc(String institutosDesc) {
		this.institutosDesc = institutosDesc;
	}
	public Integer getUniversidades() {
		return universidades;
	}
	public void setUniversidades(Integer universidades) {
		this.universidades = universidades;
	}
	public String getUniversidadesDesc() {
		return universidadesDesc;
	}
	public void setUniversidadesDesc(String universidadesDesc) {
		this.universidadesDesc = universidadesDesc;
	}
	public String getCentrosEducativosOtros() {
		return centrosEducativosOtros;
	}
	public void setCentrosEducativosOtros(String centrosEducativosOtros) {
		this.centrosEducativosOtros = centrosEducativosOtros;
	}
	public Integer getCentrosSanitarios() {
		return centrosSanitarios;
	}
	public void setCentrosSanitarios(Integer centrosSanitarios) {
		this.centrosSanitarios = centrosSanitarios;
	}
	public Integer getCentrosSalud() {
		return centrosSalud;
	}
	public void setCentrosSalud(Integer centrosSalud) {
		this.centrosSalud = centrosSalud;
	}
	public String getCentrosSaludDesc() {
		return centrosSaludDesc;
	}
	public void setCentrosSaludDesc(String centrosSaludDesc) {
		this.centrosSaludDesc = centrosSaludDesc;
	}
	public Integer getClinicas() {
		return clinicas;
	}
	public void setClinicas(Integer clinicas) {
		this.clinicas = clinicas;
	}
	public String getClinicasDesc() {
		return clinicasDesc;
	}
	public void setClinicasDesc(String clinicasDesc) {
		this.clinicasDesc = clinicasDesc;
	}
	public Integer getHospitales() {
		return hospitales;
	}
	public void setHospitales(Integer hospitales) {
		this.hospitales = hospitales;
	}
	public String getHospitalesDesc() {
		return hospitalesDesc;
	}
	public void setHospitalesDesc(String hospitalesDesc) {
		this.hospitalesDesc = hospitalesDesc;
	}
	public String getCentrosSanitariosOtros() {
		return centrosSanitariosOtros;
	}
	public void setCentrosSanitariosOtros(String centrosSanitariosOtros) {
		this.centrosSanitariosOtros = centrosSanitariosOtros;
	}
	public Integer getParkingSuperSufi() {
		return parkingSuperSufi;
	}
	public void setParkingSuperSufi(Integer parkingSuperSufi) {
		this.parkingSuperSufi = parkingSuperSufi;
	}
	public Integer getComunicaciones() {
		return comunicaciones;
	}
	public void setComunicaciones(Integer comunicaciones) {
		this.comunicaciones = comunicaciones;
	}
	public Integer getFacilAcceso() {
		return facilAcceso;
	}
	public void setFacilAcceso(Integer facilAcceso) {
		this.facilAcceso = facilAcceso;
	}
	public String getFacilAccesoDesc() {
		return facilAccesoDesc;
	}
	public void setFacilAccesoDesc(String facilAccesoDesc) {
		this.facilAccesoDesc = facilAccesoDesc;
	}
	public Integer getLineasBus() {
		return lineasBus;
	}
	public void setLineasBus(Integer lineasBus) {
		this.lineasBus = lineasBus;
	}
	public String getLineasBusDesc() {
		return lineasBusDesc;
	}
	public void setLineasBusDesc(String lineasBusDesc) {
		this.lineasBusDesc = lineasBusDesc;
	}
	public Integer getMetro() {
		return metro;
	}
	public void setMetro(Integer metro) {
		this.metro = metro;
	}
	public String getMetroDesc() {
		return metroDesc;
	}
	public void setMetroDesc(String metroDesc) {
		this.metroDesc = metroDesc;
	}
	public Integer getEstacionTren() {
		return estacionTren;
	}
	public void setEstacionTren(Integer estacionTren) {
		this.estacionTren = estacionTren;
	}
	public String getEstacionTrenDesc() {
		return estacionTrenDesc;
	}
	public void setEstacionTrenDesc(String estacionTrenDesc) {
		this.estacionTrenDesc = estacionTrenDesc;
	}
	public String getComunicacionesOtro() {
		return comunicacionesOtro;
	}
	public void setComunicacionesOtro(String comunicacionesOtro) {
		this.comunicacionesOtro = comunicacionesOtro;
	}
	public String getAcabadoCarpinteriaCodigo() {
		return acabadoCarpinteriaCodigo;
	}
	public void setAcabadoCarpinteriaCodigo(String acabadoCarpinteriaCodigo) {
		this.acabadoCarpinteriaCodigo = acabadoCarpinteriaCodigo;
	}
	public Integer getPuertaEntradaNormal() {
		return puertaEntradaNormal;
	}
	public void setPuertaEntradaNormal(Integer puertaEntradaNormal) {
		this.puertaEntradaNormal = puertaEntradaNormal;
	}
	public Integer getPuertaEntradaBlindada() {
		return puertaEntradaBlindada;
	}
	public void setPuertaEntradaBlindada(Integer puertaEntradaBlindada) {
		this.puertaEntradaBlindada = puertaEntradaBlindada;
	}
	public Integer getPuertaEntradaAcorazada() {
		return puertaEntradaAcorazada;
	}
	public void setPuertaEntradaAcorazada(Integer puertaEntradaAcorazada) {
		this.puertaEntradaAcorazada = puertaEntradaAcorazada;
	}
	public Integer getPuertaPasoMaciza() {
		return puertaPasoMaciza;
	}
	public void setPuertaPasoMaciza(Integer puertaPasoMaciza) {
		this.puertaPasoMaciza = puertaPasoMaciza;
	}
	public Integer getPuertaPasoHueca() {
		return puertaPasoHueca;
	}
	public void setPuertaPasoHueca(Integer puertaPasoHueca) {
		this.puertaPasoHueca = puertaPasoHueca;
	}
	public Integer getPuertaPasoLacada() {
		return puertaPasoLacada;
	}
	public void setPuertaPasoLacada(Integer puertaPasoLacada) {
		this.puertaPasoLacada = puertaPasoLacada;
	}
	public Integer getArmariosEmpotrados() {
		return armariosEmpotrados;
	}
	public void setArmariosEmpotrados(Integer armariosEmpotrados) {
		this.armariosEmpotrados = armariosEmpotrados;
	}
	public String getCarpinteriaInteriorOtros() {
		return carpinteriaInteriorOtros;
	}
	public void setCarpinteriaInteriorOtros(String carpinteriaInteriorOtros) {
		this.carpinteriaInteriorOtros = carpinteriaInteriorOtros;
	}
	public Integer getVentanasHierro() {
		return ventanasHierro;
	}
	public void setVentanasHierro(Integer ventanasHierro) {
		this.ventanasHierro = ventanasHierro;
	}
	public Integer getVentanasAluAnodizado() {
		return ventanasAluAnodizado;
	}
	public void setVentanasAluAnodizado(Integer ventanasAluAnodizado) {
		this.ventanasAluAnodizado = ventanasAluAnodizado;
	}
	public Integer getVentanasAluLacado() {
		return ventanasAluLacado;
	}
	public void setVentanasAluLacado(Integer ventanasAluLacado) {
		this.ventanasAluLacado = ventanasAluLacado;
	}
	public Integer getVentanasPVC() {
		return ventanasPVC;
	}
	public void setVentanasPVC(Integer ventanasPVC) {
		this.ventanasPVC = ventanasPVC;
	}
	public Integer getVentanasMadera() {
		return ventanasMadera;
	}
	public void setVentanasMadera(Integer ventanasMadera) {
		this.ventanasMadera = ventanasMadera;
	}
	public Integer getPersianasPlastico() {
		return persianasPlastico;
	}
	public void setPersianasPlastico(Integer persianasPlastico) {
		this.persianasPlastico = persianasPlastico;
	}
	public Integer getPersianasAluminio() {
		return persianasAluminio;
	}
	public void setPersianasAluminio(Integer persianasAluminio) {
		this.persianasAluminio = persianasAluminio;
	}
	public Integer getVentanasCorrederas() {
		return ventanasCorrederas;
	}
	public void setVentanasCorrederas(Integer ventanasCorrederas) {
		this.ventanasCorrederas = ventanasCorrederas;
	}
	public Integer getVentanasAbatibles() {
		return ventanasAbatibles;
	}
	public void setVentanasAbatibles(Integer ventanasAbatibles) {
		this.ventanasAbatibles = ventanasAbatibles;
	}
	public Integer getVentanasOscilobatientes() {
		return ventanasOscilobatientes;
	}
	public void setVentanasOscilobatientes(Integer ventanasOscilobatientes) {
		this.ventanasOscilobatientes = ventanasOscilobatientes;
	}
	public Integer getDobleCristal() {
		return dobleCristal;
	}
	public void setDobleCristal(Integer dobleCristal) {
		this.dobleCristal = dobleCristal;
	}
	public Integer getDobleCristalEstado() {
		return dobleCristalEstado;
	}
	public void setDobleCristalEstado(Integer dobleCristalEstado) {
		this.dobleCristalEstado = dobleCristalEstado;
	}
	public String getCarpinteriaExteriorOtros() {
		return carpinteriaExteriorOtros;
	}
	public void setCarpinteriaExteriorOtros(String carpinteriaExteriorOtros) {
		this.carpinteriaExteriorOtros = carpinteriaExteriorOtros;
	}
	public Integer getHumedadPared() {
		return humedadPared;
	}
	public void setHumedadPared(Integer humedadPared) {
		this.humedadPared = humedadPared;
	}
	public Integer getHumedadTecho() {
		return humedadTecho;
	}
	public void setHumedadTecho(Integer humedadTecho) {
		this.humedadTecho = humedadTecho;
	}
	public Integer getGrietaPared() {
		return grietaPared;
	}
	public void setGrietaPared(Integer grietaPared) {
		this.grietaPared = grietaPared;
	}
	public Integer getGrietaTecho() {
		return grietaTecho;
	}
	public void setGrietaTecho(Integer grietaTecho) {
		this.grietaTecho = grietaTecho;
	}
	public Integer getGotele() {
		return gotele;
	}
	public void setGotele(Integer gotele) {
		this.gotele = gotele;
	}
	public Integer getPlasticaLisa() {
		return plasticaLisa;
	}
	public void setPlasticaLisa(Integer plasticaLisa) {
		this.plasticaLisa = plasticaLisa;
	}
	public Integer getPapelPintado() {
		return papelPintado;
	}
	public void setPapelPintado(Integer papelPintado) {
		this.papelPintado = papelPintado;
	}
	public Integer getPinturaLisaTecho() {
		return pinturaLisaTecho;
	}
	public void setPinturaLisaTecho(Integer pinturaLisaTecho) {
		this.pinturaLisaTecho = pinturaLisaTecho;
	}
	public Integer getPinturaLisaTechoEstado() {
		return pinturaLisaTechoEstado;
	}
	public void setPinturaLisaTechoEstado(Integer pinturaLisaTechoEstado) {
		this.pinturaLisaTechoEstado = pinturaLisaTechoEstado;
	}
	public Integer getMolduraEscayola() {
		return molduraEscayola;
	}
	public void setMolduraEscayola(Integer molduraEscayola) {
		this.molduraEscayola = molduraEscayola;
	}
	public Integer getMolduraEscayolaEstado() {
		return molduraEscayolaEstado;
	}
	public void setMolduraEscayolaEstado(Integer molduraEscayolaEstado) {
		this.molduraEscayolaEstado = molduraEscayolaEstado;
	}
	public String getParamentosOtros() {
		return paramentosOtros;
	}
	public void setParamentosOtros(String paramentosOtros) {
		this.paramentosOtros = paramentosOtros;
	}
	public Integer getTarimaFlotante() {
		return tarimaFlotante;
	}
	public void setTarimaFlotante(Integer tarimaFlotante) {
		this.tarimaFlotante = tarimaFlotante;
	}
	public Integer getParque() {
		return parque;
	}
	public void setParque(Integer parque) {
		this.parque = parque;
	}
	public Integer getSoladoMarmol() {
		return soladoMarmol;
	}
	public void setSoladoMarmol(Integer soladoMarmol) {
		this.soladoMarmol = soladoMarmol;
	}
	public Integer getPlaqueta() {
		return plaqueta;
	}
	public void setPlaqueta(Integer plaqueta) {
		this.plaqueta = plaqueta;
	}
	public String getSoladoOtros() {
		return soladoOtros;
	}
	public void setSoladoOtros(String soladoOtros) {
		this.soladoOtros = soladoOtros;
	}
	public Integer getAmueblada() {
		return amueblada;
	}
	public void setAmueblada(Integer amueblada) {
		this.amueblada = amueblada;
	}
	public Integer getEstadoAmueblada() {
		return estadoAmueblada;
	}
	public void setEstadoAmueblada(Integer estadoAmueblada) {
		this.estadoAmueblada = estadoAmueblada;
	}
	public Integer getEncimera() {
		return encimera;
	}
	public void setEncimera(Integer encimera) {
		this.encimera = encimera;
	}
	public Integer getEncimeraGranito() {
		return encimeraGranito;
	}
	public void setEncimeraGranito(Integer encimeraGranito) {
		this.encimeraGranito = encimeraGranito;
	}
	public Integer getEncimeraMarmol() {
		return encimeraMarmol;
	}
	public void setEncimeraMarmol(Integer encimeraMarmol) {
		this.encimeraMarmol = encimeraMarmol;
	}
	public Integer getEncimeraOtroMaterial() {
		return encimeraOtroMaterial;
	}
	public void setEncimeraOtroMaterial(Integer encimeraOtroMaterial) {
		this.encimeraOtroMaterial = encimeraOtroMaterial;
	}
	public Integer getVitro() {
		return vitro;
	}
	public void setVitro(Integer vitro) {
		this.vitro = vitro;
	}
	public Integer getLavadora() {
		return lavadora;
	}
	public void setLavadora(Integer lavadora) {
		this.lavadora = lavadora;
	}
	public Integer getFrigorifico() {
		return frigorifico;
	}
	public void setFrigorifico(Integer frigorifico) {
		this.frigorifico = frigorifico;
	}
	public Integer getLavavajillas() {
		return lavavajillas;
	}
	public void setLavavajillas(Integer lavavajillas) {
		this.lavavajillas = lavavajillas;
	}
	public Integer getMicroondas() {
		return microondas;
	}
	public void setMicroondas(Integer microondas) {
		this.microondas = microondas;
	}
	public Integer getHorno() {
		return horno;
	}
	public void setHorno(Integer horno) {
		this.horno = horno;
	}
	public Integer getSuelosCocina() {
		return suelosCocina;
	}
	public void setSuelosCocina(Integer suelosCocina) {
		this.suelosCocina = suelosCocina;
	}
	public Integer getAzulejos() {
		return azulejos;
	}
	public void setAzulejos(Integer azulejos) {
		this.azulejos = azulejos;
	}
	public Integer getEstadoAzulejos() {
		return estadoAzulejos;
	}
	public void setEstadoAzulejos(Integer estadoAzulejos) {
		this.estadoAzulejos = estadoAzulejos;
	}
	public Integer getGrifosMonomandos() {
		return grifosMonomandos;
	}
	public void setGrifosMonomandos(Integer grifosMonomandos) {
		this.grifosMonomandos = grifosMonomandos;
	}
	public Integer getEstadoGrifosMonomandos() {
		return estadoGrifosMonomandos;
	}
	public void setEstadoGrifosMonomandos(Integer estadoGrifosMonomandos) {
		this.estadoGrifosMonomandos = estadoGrifosMonomandos;
	}
	public String getCocinaOtros() {
		return cocinaOtros;
	}
	public void setCocinaOtros(String cocinaOtros) {
		this.cocinaOtros = cocinaOtros;
	}
	public Integer getDuchaBanyera() {
		return duchaBanyera;
	}
	public void setDuchaBanyera(Integer duchaBanyera) {
		this.duchaBanyera = duchaBanyera;
	}
	public Integer getDucha() {
		return ducha;
	}
	public void setDucha(Integer ducha) {
		this.ducha = ducha;
	}
	public Integer getBanyera() {
		return banyera;
	}
	public void setBanyera(Integer banyera) {
		this.banyera = banyera;
	}
	public Integer getBanyeraHidromasaje() {
		return banyeraHidromasaje;
	}
	public void setBanyeraHidromasaje(Integer banyeraHidromasaje) {
		this.banyeraHidromasaje = banyeraHidromasaje;
	}
	public Integer getColumnaHidromasaje() {
		return columnaHidromasaje;
	}
	public void setColumnaHidromasaje(Integer columnaHidromasaje) {
		this.columnaHidromasaje = columnaHidromasaje;
	}
	public Integer getAlicatadoMarmol() {
		return alicatadoMarmol;
	}
	public void setAlicatadoMarmol(Integer alicatadoMarmol) {
		this.alicatadoMarmol = alicatadoMarmol;
	}
	public Integer getalicatadoGranito() {
		return alicatadoGranito;
	}
	public void setalicatadoGranito(Integer alicatadoGranito) {
		this.alicatadoGranito = alicatadoGranito;
	}
	public Integer getAlicatadoAzulejo() {
		return alicatadoAzulejo;
	}
	public void setAlicatadoAzulejo(Integer alicatadoAzulejo) {
		this.alicatadoAzulejo = alicatadoAzulejo;
	}
	public Integer getEncimeraBanyo() {
		return encimeraBanyo;
	}
	public void setEncimeraBanyo(Integer encimeraBanyo) {
		this.encimeraBanyo = encimeraBanyo;
	}
	public Integer getEncimeraBanyoMarmol() {
		return encimeraBanyoMarmol;
	}
	public void setEncimeraBanyoMarmol(Integer encimeraBanyoMarmol) {
		this.encimeraBanyoMarmol = encimeraBanyoMarmol;
	}
	public Integer getEncimeraBanyoGranito() {
		return encimeraBanyoGranito;
	}
	public void setEncimeraBanyoGranito(Integer encimeraBanyoGranito) {
		this.encimeraBanyoGranito = encimeraBanyoGranito;
	}
	public Integer getEncimeraBanyoOtroMaterial() {
		return encimeraBanyoOtroMaterial;
	}
	public void setEncimeraBanyoOtroMaterial(Integer encimeraBanyoOtroMaterial) {
		this.encimeraBanyoOtroMaterial = encimeraBanyoOtroMaterial;
	}
	public Integer getSanitarios() {
		return sanitarios;
	}
	public void setSanitarios(Integer sanitarios) {
		this.sanitarios = sanitarios;
	}
	public Integer getEstadoSanitarios() {
		return estadoSanitarios;
	}
	public void setEstadoSanitarios(Integer estadoSanitarios) {
		this.estadoSanitarios = estadoSanitarios;
	}
	public Integer getSuelosBanyo() {
		return suelosBanyo;
	}
	public void setSuelosBanyo(Integer suelosBanyo) {
		this.suelosBanyo = suelosBanyo;
	}
	public Integer getGrifoMonomando() {
		return grifoMonomando;
	}
	public void setGrifoMonomando(Integer grifoMonomando) {
		this.grifoMonomando = grifoMonomando;
	}
	public Integer getEstadoGrifoMonomando() {
		return estadoGrifoMonomando;
	}
	public void setEstadoGrifoMonomando(Integer estadoGrifoMonomando) {
		this.estadoGrifoMonomando = estadoGrifoMonomando;
	}
	public String getBanyoOtros() {
		return banyoOtros;
	}
	public void setBanyoOtros(String banyoOtros) {
		this.banyoOtros = banyoOtros;
	}
	public Integer getElectricidadConContador() {
		return electricidadConContador;
	}
	public void setElectricidadConContador(Integer electricidadConContador) {
		this.electricidadConContador = electricidadConContador;
	}
	public Integer getElectricidadBuenEstado() {
		return electricidadBuenEstado;
	}
	public void setElectricidadBuenEstado(Integer electricidadBuenEstado) {
		this.electricidadBuenEstado = electricidadBuenEstado;
	}
	public Integer getElectricidadDefectuosa() {
		return electricidadDefectuosa;
	}
	public void setElectricidadDefectuosa(Integer electricidadDefectuosa) {
		this.electricidadDefectuosa = electricidadDefectuosa;
	}
	public Integer getAguaConContador() {
		return aguaConContador;
	}
	public void setAguaConContador(Integer aguaConContador) {
		this.aguaConContador = aguaConContador;
	}
	public Integer getAguaBuenEstado() {
		return aguaBuenEstado;
	}
	public void setAguaBuenEstado(Integer aguaBuenEstado) {
		this.aguaBuenEstado = aguaBuenEstado;
	}
	public Integer getAguaDefectuosa() {
		return aguaDefectuosa;
	}
	public void setAguaDefectuosa(Integer aguaDefectuosa) {
		this.aguaDefectuosa = aguaDefectuosa;
	}
	public Integer getAguaCalienteCentral() {
		return aguaCalienteCentral;
	}
	public void setAguaCalienteCentral(Integer aguaCalienteCentral) {
		this.aguaCalienteCentral = aguaCalienteCentral;
	}
	public Integer getAguaCalienteGasNat() {
		return aguaCalienteGasNat;
	}
	public void setAguaCalienteGasNat(Integer aguaCalienteGasNat) {
		this.aguaCalienteGasNat = aguaCalienteGasNat;
	}
	public Integer getGasConContador() {
		return gasConContador;
	}
	public void setGasConContador(Integer gasConContador) {
		this.gasConContador = gasConContador;
	}
	public Integer getGasBuenEstado() {
		return gasBuenEstado;
	}
	public void setGasBuenEstado(Integer gasBuenEstado) {
		this.gasBuenEstado = gasBuenEstado;
	}
	public Integer getGasDefectuosa() {
		return gasDefectuosa;
	}
	public void setGasDefectuosa(Integer gasDefectuosa) {
		this.gasDefectuosa = gasDefectuosa;
	}
	public Integer getCalefaccionCentral() {
		return calefaccionCentral;
	}
	public void setCalefaccionCentral(Integer calefaccionCentral) {
		this.calefaccionCentral = calefaccionCentral;
	}
	public Integer getCalefaccionGasNat() {
		return calefaccionGasNat;
	}
	public void setCalefaccionGasNat(Integer calefaccionGasNat) {
		this.calefaccionGasNat = calefaccionGasNat;
	}
	public Integer getCalefaccionRadiadorAlu() {
		return calefaccionRadiadorAlu;
	}
	public void setCalefaccionRadiadorAlu(Integer calefaccionRadiadorAlu) {
		this.calefaccionRadiadorAlu = calefaccionRadiadorAlu;
	}
	public Integer getCalefaccionPreinstalacion() {
		return calefaccionPreinstalacion;
	}
	public void setCalefaccionPreinstalacion(Integer calefaccionPreinstalacion) {
		this.calefaccionPreinstalacion = calefaccionPreinstalacion;
	}
	public Integer getAirePreinstalacion() {
		return airePreinstalacion;
	}
	public void setAirePreinstalacion(Integer airePreinstalacion) {
		this.airePreinstalacion = airePreinstalacion;
	}
	public Integer getAireInstalacion() {
		return aireInstalacion;
	}
	public void setAireInstalacion(Integer aireInstalacion) {
		this.aireInstalacion = aireInstalacion;
	}
	public Integer getAireFrioCalor() {
		return aireFrioCalor;
	}
	public void setAireFrioCalor(Integer aireFrioCalor) {
		this.aireFrioCalor = aireFrioCalor;
	}
	public String getInstalacionOtros() {
		return instalacionOtros;
	}
	public void setInstalacionOtros(String instalacionOtros) {
		this.instalacionOtros = instalacionOtros;
	}
	public Integer getJardines() {
		return jardines;
	}
	public void setJardines(Integer jardines) {
		this.jardines = jardines;
	}
	public Integer getPiscina() {
		return piscina;
	}
	public void setPiscina(Integer piscina) {
		this.piscina = piscina;
	}
	public Integer getPadel() {
		return padel;
	}
	public void setPadel(Integer padel) {
		this.padel = padel;
	}
	public Integer getTenis() {
		return tenis;
	}
	public void setTenis(Integer tenis) {
		this.tenis = tenis;
	}
	public Integer getPistaPolideportiva() {
		return pistaPolideportiva;
	}
	public void setPistaPolideportiva(Integer pistaPolideportiva) {
		this.pistaPolideportiva = pistaPolideportiva;
	}
	public String getInstalacionesDeportivasOtros() {
		return instalacionesDeportivasOtros;
	}
	public void setInstalacionesDeportivasOtros(String instalacionesDeportivasOtros) {
		this.instalacionesDeportivasOtros = instalacionesDeportivasOtros;
	}
	public Integer getZonaInfantil() {
		return zonaInfantil;
	}
	public void setZonaInfantil(Integer zonaInfantil) {
		this.zonaInfantil = zonaInfantil;
	}
	public Integer getConserjeVigilancia() {
		return conserjeVigilancia;
	}
	public void setConserjeVigilancia(Integer conserjeVigilancia) {
		this.conserjeVigilancia = conserjeVigilancia;
	}
	public Integer getGimnasio() {
		return gimnasio;
	}
	public void setGimnasio(Integer gimnasio) {
		this.gimnasio = gimnasio;
	}
	public String getZonaComunOtros() {
		return zonaComunOtros;
	}
	public void setZonaComunOtros(String zonaComunOtros) {
		this.zonaComunOtros = zonaComunOtros;
	}
	public String getEdiDescripcion() {
		return ediDescripcion;
	}
	public void setEdiDescripcion(String ediDescripcion) {
		this.ediDescripcion = ediDescripcion;
	}
	public String getTipoCalidadCodigo() {
		return tipoCalidadCodigo;
	}
	public void setTipoCalidadCodigo(String tipoCalidadCodigo) {
		this.tipoCalidadCodigo = tipoCalidadCodigo;
	}
	public String getUbicacionAparcamientoCodigo() {
		return ubicacionAparcamientoCodigo;
	}
	public void setUbicacionAparcamientoCodigo(String ubicacionAparcamientoCodigo) {
		this.ubicacionAparcamientoCodigo = ubicacionAparcamientoCodigo;
	}
	public String getTipoInfoComercialCodigo() {
		return tipoInfoComercialCodigo;
	}
	public void setTipoInfoComercialCodigo(String tipoInfoComercialCodigo) {
		this.tipoInfoComercialCodigo = tipoInfoComercialCodigo;
	}
	public Date getFechaAceptacion() {
		return fechaAceptacion;
	}
	public void setFechaAceptacion(Date fechaAceptacion) {
		this.fechaAceptacion = fechaAceptacion;
	}
	public Date getFechaRechazo() {
		return fechaRechazo;
	}
	public void setFechaRechazo(Date fechaRechazo) {
		this.fechaRechazo = fechaRechazo;
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
	public String getTipoActivoCodigo() {
		return tipoActivoCodigo;
	}
	public void setTipoActivoCodigo(String tipoActivoCodigo) {
		this.tipoActivoCodigo = tipoActivoCodigo;
	}
	public Boolean getExisteSalidaHumos() {
		return existeSalidaHumos;
	}
	public void setExisteSalidaHumos(Boolean existeSalidaHumos) {
		this.existeSalidaHumos = existeSalidaHumos;
	}
	public Boolean getExisteSalidaEmergencias() {
		return existeSalidaEmergencias;
	}
	public void setExisteSalidaEmergencias(Boolean existeSalidaEmergencias) {
		this.existeSalidaEmergencias = existeSalidaEmergencias;
	}
	public Boolean getExisteAccesoMinusvalidos() {
		return existeAccesoMinusvalidos;
	}
	public void setExisteAccesoMinusvalidos(Boolean existeAccesoMinusvalidos) {
		this.existeAccesoMinusvalidos = existeAccesoMinusvalidos;
	}
	public String getOtrosOtrasCaracteristicas() {
		return otrosOtrasCaracteristicas;
	}
	public void setOtrosOtrasCaracteristicas(String otrosOtrasCaracteristicas) {
		this.otrosOtrasCaracteristicas = otrosOtrasCaracteristicas;
	}
	public Integer getElectricidad() {
		return electricidad;
	}
	public void setElectricidad(Integer electricidad) {
		this.electricidad = electricidad;
	}
	public Integer getAgua() {
		return agua;
	}
	public void setAgua(Integer agua) {
		this.agua = agua;
	}
	public Integer getGas() {
		return gas;
	}
	public void setGas(Integer gas) {
		this.gas = gas;
	}
	public Integer getEdificioDivisible() {
		return edificioDivisible;
	}
	public void setEdificioDivisible(Integer edificioDivisible) {
		this.edificioDivisible = edificioDivisible;
	}
	public String getEdificioOtrasCaracteristicas() {
		return edificioOtrasCaracteristicas;
	}
	public void setEdificioOtrasCaracteristicas(String edificioOtrasCaracteristicas) {
		this.edificioOtrasCaracteristicas = edificioOtrasCaracteristicas;
	}
	public String getEdificioDescPlantas() {
		return edificioDescPlantas;
	}
	public void setEdificioDescPlantas(String edificioDescPlantas) {
		this.edificioDescPlantas = edificioDescPlantas;
	}
	public String getAparcamientoAltura() {
		return aparcamientoAltura;
	}
	public void setAparcamientoAltura(String aparcamientoAltura) {
		this.aparcamientoAltura = aparcamientoAltura;
	}
	public Integer getAparcamientoLicencia() {
		return aparcamientoLicencia;
	}
	public void setAparcamientoLicencia(Integer aparcamientoLicencia) {
		this.aparcamientoLicencia = aparcamientoLicencia;
	}
	public Integer getAparcamientoSerbidumbre() {
		return aparcamientoSerbidumbre;
	}
	public void setAparcamientoSerbidumbre(Integer aparcamientoSerbidumbre) {
		this.aparcamientoSerbidumbre = aparcamientoSerbidumbre;
	}
	public Integer getAparcamientoMontacarga() {
		return aparcamientoMontacarga;
	}
	public void setAparcamientoMontacarga(Integer aparcamientoMontacarga) {
		this.aparcamientoMontacarga = aparcamientoMontacarga;
	}
	public Integer getAparcamientoColumnas() {
		return aparcamientoColumnas;
	}
	public void setAparcamientoColumnas(Integer aparcamientoColumnas) {
		this.aparcamientoColumnas = aparcamientoColumnas;
	}
	public Integer getAparcamientoSeguridad() {
		return aparcamientoSeguridad;
	}
	public void setAparcamientoSeguridad(Integer aparcamientoSeguridad) {
		this.aparcamientoSeguridad = aparcamientoSeguridad;
	}
	public String getSubtipoActivoCodigo() {
		return subtipoActivoCodigo;
	}
	public void setSubtipoActivoCodigo(String subtipoActivoCodigo) {
		this.subtipoActivoCodigo = subtipoActivoCodigo;
	}
	public String getSubtipoPlazagarajeCodigo() {
		return subtipoPlazagarajeCodigo;
	}
	public void setSubtipoPlazagarajeCodigo(String subtipoPlazagarajeCodigo) {
		this.subtipoPlazagarajeCodigo = subtipoPlazagarajeCodigo;
	}
	public String getManiobrabilidadCodigo() {
		return maniobrabilidadCodigo;
	}
	public void setManiobrabilidadCodigo(String maniobrabilidadCodigo) {
		this.maniobrabilidadCodigo = maniobrabilidadCodigo;
	}
	public Long getCodigoMediadorEspejo() {
		return codigoMediadorEspejo;
	}
	public String getNombreMediadorEspejo() {
		return nombreMediadorEspejo;
	}
	public String getEmailMediadorEspejo() {
		return emailMediadorEspejo;
	}
	public String getTelefonoMediadorEspejo() {
		return telefonoMediadorEspejo;
	}
	public void setCodigoMediadorEspejo(Long codigoMediadorEspejo) {
		this.codigoMediadorEspejo = codigoMediadorEspejo;
	}
	public void setNombreMediadorEspejo(String nombreMediadorEspejo) {
		this.nombreMediadorEspejo = nombreMediadorEspejo;
	}
	public void setEmailMediadorEspejo(String emailMediadorEspejo) {
		this.emailMediadorEspejo = emailMediadorEspejo;
	}
	public void setTelefonoMediadorEspejo(String telefonoMediadorEspejo) {
		this.telefonoMediadorEspejo = telefonoMediadorEspejo;
	}
	public String getUbicacionActivoDescripcion() {
		return ubicacionActivoDescripcion;
	}
	public void setUbicacionActivoDescripcion(String ubicacionActivoDescripcion) {
		this.ubicacionActivoDescripcion = ubicacionActivoDescripcion;
	}
	public String getEstadoConstruccionDescripcion() {
		return estadoConstruccionDescripcion;
	}
	public void setEstadoConstruccionDescripcion(String estadoConstruccionDescripcion) {
		this.estadoConstruccionDescripcion = estadoConstruccionDescripcion;
	}
	public String getEstadoConservacionDescripcion() {
		return estadoConservacionDescripcion;
	}
	public void setEstadoConservacionDescripcion(String estadoConservacionDescripcion) {
		this.estadoConservacionDescripcion = estadoConservacionDescripcion;
	}
	public String getEstadoConservacionEdificioDescripcion() {
		return estadoConservacionEdificioDescripcion;
	}
	public void setEstadoConservacionEdificioDescripcion(String estadoConservacionEdificioDescripcion) {
		this.estadoConservacionEdificioDescripcion = estadoConservacionEdificioDescripcion;
	}
	public String getTipoFachadaDescripcion() {
		return tipoFachadaDescripcion;
	}
	public void setTipoFachadaDescripcion(String tipoFachadaDescripcion) {
		this.tipoFachadaDescripcion = tipoFachadaDescripcion;
	}
	
	
}