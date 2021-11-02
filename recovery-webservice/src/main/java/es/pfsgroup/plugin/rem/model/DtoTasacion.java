package es.pfsgroup.plugin.rem.model;

import java.util.Date;

/**
 * Dto para el listado de propietarios de los activos
 * @author Anahuac de Vicente
 */
public class DtoTasacion {

	private Long id;
	private Long externoID; // Solicitud tasación Bankia.
	private Long idActivo; // Solicitud tasación Bankia.
    private String tipoTasacionCodigo; 
    private String tipoTasacionDescripcion; 
    private Date fechaInicioTasacion; 
    private Date fechaValorTasacion; //fechaFinTasacion a nivel visual
    private Date fechaRecepcionTasacion;  
    private Date fechaSolicitudTasacion; // Solicitud tasación Bankia.
    private String gestorSolicitud; // Solicitud tasación Bankia.
    private String codigoFirma;  
    private String nomTasador;  
    private String importeValorTasacion;  
    private String importeTasacionFin;  
    private String costeRepoNetoActual;  
    private String costeRepoNetoFinalizado;  
    private String coeficienteMercadoEstado;  
    private String coeficientePondValorAnanyadido;  
    private String valorReperSueloConst;  
    private String costeConstConstruido;  
    private String indiceDepreFisica;  
    private String indiceDepreFuncional;  
    private String indiceTotalDepre;  
    private String costeConstDepreciada;  
    private String costeUnitarioRepoNeto;  
    private String costeReposicion;  
    private String porcentajeObra;  
    private String importeValorTerminado; 
    private String idTextoAsociado; 
    private String importeValorLegalFinca; 
    private String importeValorSolar; 
    private String observaciones;
    private Boolean ilocalizable;
    private String externoBbva;
    private Long numGastoHaya;
    private Long idGasto;
    private Double superficieParcela;
    private Double superficie;
    private String referenciaTasadora;
    private String acogidaNormativa;
    private Double valorHipotesisEdificioTerminadoPromocion;
    private String advertencias;
    private String codigoSociedadTasacionValoracion;
    private String condicionantes;
    private String metodoValoracionCodigo;
    private Long valorTerreno;
    private Long valorTerrenoAjustado;
    private Long valorHipotesisEdificioTerminado;
    private Long valorHipotecario;
    private String visitaAnteriorInmueble;
    private Long superficieAdoptada;
    private Long costeEstimadoTerminarObra;
    private Long costeDestinaUsoPropio;
    private Date fechaEstimadaTerminarObra;
    private Long mrdPlazoMaximoFinalizarComercializacion;
    private Long mrdPlazoMaximoFinalizarConstruccion;
    private Long mrdTasaAnualizadaHomogenea;
    private Long mrdTasaActualizacion;
    private Long mreMargenBeneficioPromotor;
    private Long superficieTerreno;
    private Long tasaAnualMedioVariacionPrecioMercado;
    private Long aprovechamientoParcelaSuelo;
    private String desarrolloPlanteamientoCodigo;
    private String faseGestionCodigo;
    private Long numeroViviendas;
    private Double porcentajeAmbitoValorado;
    private String productoDesarrollarCodigo;
    private String proximidadRespectoNucleoUrbanoCodigo;
    private String sistemaGestionCodigo;
    private String tipoSueloCodigo;
    private Long aprovechamiento;
    private Date fechaUltimoGradoAvanceEstimado;
    private Long porcentajeUrbanizacionEjecutado;
    private Long porcentajeAmbitoValoradoEntero;
    private String productoDesarrollarPrevistoCodigo;
    private String proyectoObra;
    private Double gastosComercialesTasacion;
    private String porcentajeCosteDefecto;
    private String fincaRusticaExpectativasUrbanisticas;
    private String paralizacionUrbanizacion;
    private String tipoDatoUtilizadoInmuebleComparableCodigo;

	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public String getTipoTasacionCodigo() {
		return tipoTasacionCodigo;
	}
	public void setTipoTasacionCodigo(String tipoTasacionCodigo) {
		this.tipoTasacionCodigo = tipoTasacionCodigo;
	}
	public String getTipoTasacionDescripcion() {
		return tipoTasacionDescripcion;
	}
	public void setTipoTasacionDescripcion(String tipoTasacionDescripcion) {
		this.tipoTasacionDescripcion = tipoTasacionDescripcion;
	}
	public Date getFechaInicioTasacion() {
		return fechaInicioTasacion;
	}
	public void setFechaInicioTasacion(Date fechaInicioTasacion) {
		this.fechaInicioTasacion = fechaInicioTasacion;
	}
	public Date getFechaRecepcionTasacion() {
		return fechaRecepcionTasacion;
	}
	public void setFechaRecepcionTasacion(Date fechaRecepcionTasacion) {
		this.fechaRecepcionTasacion = fechaRecepcionTasacion;
	}
	public Date getFechaSolicitudTasacion() {
		return fechaSolicitudTasacion;
	}
	public void setFechaSolicitudTasacion(Date fechaSolicitudTasacion) {
		this.fechaSolicitudTasacion = fechaSolicitudTasacion;
	}
	public String getCodigoFirma() {
		return codigoFirma;
	}
	public void setCodigoFirma(String codigoFirma) {
		this.codigoFirma = codigoFirma;
	}
	public String getNomTasador() {
		return nomTasador;
	}
	public void setNomTasador(String nomTasador) {
		this.nomTasador = nomTasador;
	}
	public String getImporteTasacionFin() {
		return importeTasacionFin;
	}
	public void setImporteTasacionFin(String importeTasacionFin) {
		this.importeTasacionFin = importeTasacionFin;
	}
	public String getCosteRepoNetoActual() {
		return costeRepoNetoActual;
	}
	public void setCosteRepoNetoActual(String costeRepoNetoActual) {
		this.costeRepoNetoActual = costeRepoNetoActual;
	}
	public String getCosteRepoNetoFinalizado() {
		return costeRepoNetoFinalizado;
	}
	public void setCosteRepoNetoFinalizado(String costeRepoNetoFinalizado) {
		this.costeRepoNetoFinalizado = costeRepoNetoFinalizado;
	}
	public String getCoeficienteMercadoEstado() {
		return coeficienteMercadoEstado;
	}
	public void setCoeficienteMercadoEstado(String coeficienteMercadoEstado) {
		this.coeficienteMercadoEstado = coeficienteMercadoEstado;
	}
	public String getCoeficientePondValorAnanyadido() {
		return coeficientePondValorAnanyadido;
	}
	public void setCoeficientePondValorAnanyadido(
			String coeficientePondValorAnanyadido) {
		this.coeficientePondValorAnanyadido = coeficientePondValorAnanyadido;
	}
	public String getValorReperSueloConst() {
		return valorReperSueloConst;
	}
	public void setValorReperSueloConst(String valorReperSueloConst) {
		this.valorReperSueloConst = valorReperSueloConst;
	}
	public String getCosteConstConstruido() {
		return costeConstConstruido;
	}
	public void setCosteConstConstruido(String costeConstConstruido) {
		this.costeConstConstruido = costeConstConstruido;
	}
	public String getIndiceDepreFisica() {
		return indiceDepreFisica;
	}
	public void setIndiceDepreFisica(String indiceDepreFisica) {
		this.indiceDepreFisica = indiceDepreFisica;
	}
	public String getIndiceDepreFuncional() {
		return indiceDepreFuncional;
	}
	public void setIndiceDepreFuncional(String indiceDepreFuncional) {
		this.indiceDepreFuncional = indiceDepreFuncional;
	}
	public String getIndiceTotalDepre() {
		return indiceTotalDepre;
	}
	public void setIndiceTotalDepre(String indiceTotalDepre) {
		this.indiceTotalDepre = indiceTotalDepre;
	}
	public String getCosteConstDepreciada() {
		return costeConstDepreciada;
	}
	public void setCosteConstDepreciada(String costeConstDepreciada) {
		this.costeConstDepreciada = costeConstDepreciada;
	}
	public String getCosteUnitarioRepoNeto() {
		return costeUnitarioRepoNeto;
	}
	public void setCosteUnitarioRepoNeto(String costeUnitarioRepoNeto) {
		this.costeUnitarioRepoNeto = costeUnitarioRepoNeto;
	}
	public String getCosteReposicion() {
		return costeReposicion;
	}
	public void setCosteReposicion(String costeReposicion) {
		this.costeReposicion = costeReposicion;
	}
	public String getPorcentajeObra() {
		return porcentajeObra;
	}
	public void setPorcentajeObra(String porcentajeObra) {
		this.porcentajeObra = porcentajeObra;
	}
	public String getImporteValorTerminado() {
		return importeValorTerminado;
	}
	public void setImporteValorTerminado(String importeValorTerminado) {
		this.importeValorTerminado = importeValorTerminado;
	}
	public String getIdTextoAsociado() {
		return idTextoAsociado;
	}
	public void setIdTextoAsociado(String idTextoAsociado) {
		this.idTextoAsociado = idTextoAsociado;
	}
	public String getImporteValorLegalFinca() {
		return importeValorLegalFinca;
	}
	public void setImporteValorLegalFinca(String importeValorLegalFinca) {
		this.importeValorLegalFinca = importeValorLegalFinca;
	}
	public String getImporteValorSolar() {
		return importeValorSolar;
	}
	public void setImporteValorSolar(String importeValorSolar) {
		this.importeValorSolar = importeValorSolar;
	}
	public String getObservaciones() {
		return observaciones;
	}
	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	public Date getFechaValorTasacion() {
		return fechaValorTasacion;
	}
	public void setFechaValorTasacion(Date fechaValorTasacion) {
		this.fechaValorTasacion = fechaValorTasacion;
	}
	public String getImporteValorTasacion() {
		return importeValorTasacion;
	}
	public void setImporteValorTasacion(String importeValorTasacion) {
		this.importeValorTasacion = importeValorTasacion;
	}
	public Long getExternoID() {
		return externoID;
	}
	public void setExternoID(Long externoID) {
		this.externoID = externoID;
	}
	public String getGestorSolicitud() {
		return gestorSolicitud;
	}
	public void setGestorSolicitud(String gestorSolicitud) {
		this.gestorSolicitud = gestorSolicitud;
	}
	public Long getIdActivo() {
		return idActivo;
	}
	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}
	
	public String getExternoBbva() {
		return externoBbva;
	}
	public void setExternoBbva(String externoBbva) {
		this.externoBbva = externoBbva;
	}
	public Boolean getIlocalizable() {
		return ilocalizable;
	}
	public void setIlocalizable(Boolean ilocalizable) {
		this.ilocalizable = ilocalizable;
	}

	public Long getNumGastoHaya() {
		return numGastoHaya;
	}

	public void setNumGastoHaya(Long numGastoHaya) {
		this.numGastoHaya = numGastoHaya;
	}

	public Long getIdGasto() {
		return idGasto;
	}

	public void setIdGasto(Long idGasto) {
		this.idGasto = idGasto;
	}
	public Double getSuperficieParcela() {
		return superficieParcela;
	}
	public void setSuperficieParcela(Double superficieParcela) {
		this.superficieParcela = superficieParcela;
	}
	public Double getSuperficie() {
		return superficie;
	}
	public void setSuperficie(Double superficie) {
		this.superficie = superficie;
	}
	public String getReferenciaTasadora() {
		return referenciaTasadora;
	}
	public void setReferenciaTasadora(String referenciaTasadora) {
		this.referenciaTasadora = referenciaTasadora;
	}
	public String getAcogidaNormativa() {
		return acogidaNormativa;
	}
	public void setAcogidaNormativa(String acogidaNormativa) {
		this.acogidaNormativa = acogidaNormativa;
	}
	public Double getValorHipotesisEdificioTerminadoPromocion() {
		return valorHipotesisEdificioTerminadoPromocion;
	}
	public void setValorHipotesisEdificioTerminadoPromocion(Double valorHipotesisEdificioTerminadoPromocion) {
		this.valorHipotesisEdificioTerminadoPromocion = valorHipotesisEdificioTerminadoPromocion;
	}
	public String getAdvertencias() {
		return advertencias;
	}
	public void setAdvertencias(String advertencias) {
		this.advertencias = advertencias;
	}
	public String getCodigoSociedadTasacionValoracion() {
		return codigoSociedadTasacionValoracion;
	}
	public void setCodigoSociedadTasacionValoracion(String codigoSociedadTasacionValoracion) {
		this.codigoSociedadTasacionValoracion = codigoSociedadTasacionValoracion;
	}
	public String getCondicionantes() {
		return condicionantes;
	}
	public void setCondicionantes(String condicionantes) {
		this.condicionantes = condicionantes;
	}
	public String getMetodoValoracionCodigo() {
		return metodoValoracionCodigo;
	}
	public void setMetodoValoracionCodigo(String metodoValoracionCodigo) {
		this.metodoValoracionCodigo = metodoValoracionCodigo;
	}
	public Long getValorTerreno() {
		return valorTerreno;
	}
	public void setValorTerreno(Long valorTerreno) {
		this.valorTerreno = valorTerreno;
	}
	public Long getValorTerrenoAjustado() {
		return valorTerrenoAjustado;
	}
	public void setValorTerrenoAjustado(Long valorTerrenoAjustado) {
		this.valorTerrenoAjustado = valorTerrenoAjustado;
	}
	public Long getValorHipotesisEdificioTerminado() {
		return valorHipotesisEdificioTerminado;
	}
	public void setValorHipotesisEdificioTerminado(Long valorHipotesisEdificioTerminado) {
		this.valorHipotesisEdificioTerminado = valorHipotesisEdificioTerminado;
	}
	public Long getValorHipotecario() {
		return valorHipotecario;
	}
	public void setValorHipotecario(Long valorHipotecario) {
		this.valorHipotecario = valorHipotecario;
	}
	public String getVisitaAnteriorInmueble() {
		return visitaAnteriorInmueble;
	}
	public void setVisitaAnteriorInmueble(String visitaAnteriorInmueble) {
		this.visitaAnteriorInmueble = visitaAnteriorInmueble;
	}
	public Long getSuperficieAdoptada() {
		return superficieAdoptada;
	}
	public void setSuperficieAdoptada(Long superficieAdoptada) {
		this.superficieAdoptada = superficieAdoptada;
	}
	public Long getCosteEstimadoTerminarObra() {
		return costeEstimadoTerminarObra;
	}
	public void setCosteEstimadoTerminarObra(Long costeEstimadoTerminarObra) {
		this.costeEstimadoTerminarObra = costeEstimadoTerminarObra;
	}
	public Long getCosteDestinaUsoPropio() {
		return costeDestinaUsoPropio;
	}
	public void setCosteDestinaUsoPropio(Long costeDestinaUsoPropio) {
		this.costeDestinaUsoPropio = costeDestinaUsoPropio;
	}
	public Date getFechaEstimadaTerminarObra() {
		return fechaEstimadaTerminarObra;
	}
	public void setFechaEstimadaTerminarObra(Date fechaEstimadaTerminarObra) {
		this.fechaEstimadaTerminarObra = fechaEstimadaTerminarObra;
	}
	public Long getMrdPlazoMaximoFinalizarComercializacion() {
		return mrdPlazoMaximoFinalizarComercializacion;
	}
	public void setMrdPlazoMaximoFinalizarComercializacion(Long mrdPlazoMaximoFinalizarComercializacion) {
		this.mrdPlazoMaximoFinalizarComercializacion = mrdPlazoMaximoFinalizarComercializacion;
	}
	public Long getMrdPlazoMaximoFinalizarConstruccion() {
		return mrdPlazoMaximoFinalizarConstruccion;
	}
	public void setMrdPlazoMaximoFinalizarConstruccion(Long mrdPlazoMaximoFinalizarConstruccion) {
		this.mrdPlazoMaximoFinalizarConstruccion = mrdPlazoMaximoFinalizarConstruccion;
	}
	public Long getMrdTasaAnualizadaHomogenea() {
		return mrdTasaAnualizadaHomogenea;
	}
	public void setMrdTasaAnualizadaHomogenea(Long mrdTasaAnualizadaHomogenea) {
		this.mrdTasaAnualizadaHomogenea = mrdTasaAnualizadaHomogenea;
	}
	public Long getMrdTasaActualizacion() {
		return mrdTasaActualizacion;
	}
	public void setMrdTasaActualizacion(Long mrdTasaActualizacion) {
		this.mrdTasaActualizacion = mrdTasaActualizacion;
	}
	public Long getMreMargenBeneficioPromotor() {
		return mreMargenBeneficioPromotor;
	}
	public void setMreMargenBeneficioPromotor(Long mreMargenBeneficioPromotor) {
		this.mreMargenBeneficioPromotor = mreMargenBeneficioPromotor;
	}
	public Long getSuperficieTerreno() {
		return superficieTerreno;
	}
	public void setSuperficieTerreno(Long superficieTerreno) {
		this.superficieTerreno = superficieTerreno;
	}
	public Long getTasaAnualMedioVariacionPrecioMercado() {
		return tasaAnualMedioVariacionPrecioMercado;
	}
	public void setTasaAnualMedioVariacionPrecioMercado(Long tasaAnualMedioVariacionPrecioMercado) {
		this.tasaAnualMedioVariacionPrecioMercado = tasaAnualMedioVariacionPrecioMercado;
	}
	public Long getAprovechamientoParcelaSuelo() {
		return aprovechamientoParcelaSuelo;
	}
	public void setAprovechamientoParcelaSuelo(Long aprovechamientoParcelaSuelo) {
		this.aprovechamientoParcelaSuelo = aprovechamientoParcelaSuelo;
	}
	public String getDesarrolloPlanteamientoCodigo() {
		return desarrolloPlanteamientoCodigo;
	}
	public void setDesarrolloPlanteamientoCodigo(String desarrolloPlanteamientoCodigo) {
		this.desarrolloPlanteamientoCodigo = desarrolloPlanteamientoCodigo;
	}
	public String getFaseGestionCodigo() {
		return faseGestionCodigo;
	}
	public void setFaseGestionCodigo(String faseGestionCodigo) {
		this.faseGestionCodigo = faseGestionCodigo;
	}
	public Long getNumeroViviendas() {
		return numeroViviendas;
	}
	public void setNumeroViviendas(Long numeroViviendas) {
		this.numeroViviendas = numeroViviendas;
	}
	public Double getPorcentajeAmbitoValorado() {
		return porcentajeAmbitoValorado;
	}
	public void setPorcentajeAmbitoValorado(Double porcentajeAmbitoValorado) {
		this.porcentajeAmbitoValorado = porcentajeAmbitoValorado;
	}
	public String getProductoDesarrollarCodigo() {
		return productoDesarrollarCodigo;
	}
	public void setProductoDesarrollarCodigo(String productoDesarrollarCodigo) {
		this.productoDesarrollarCodigo = productoDesarrollarCodigo;
	}
	public String getProximidadRespectoNucleoUrbanoCodigo() {
		return proximidadRespectoNucleoUrbanoCodigo;
	}
	public void setProximidadRespectoNucleoUrbanoCodigo(String proximidadRespectoNucleoUrbanoCodigo) {
		this.proximidadRespectoNucleoUrbanoCodigo = proximidadRespectoNucleoUrbanoCodigo;
	}
	public String getSistemaGestionCodigo() {
		return sistemaGestionCodigo;
	}
	public void setSistemaGestionCodigo(String sistemaGestionCodigo) {
		this.sistemaGestionCodigo = sistemaGestionCodigo;
	}
	public String getTipoSueloCodigo() {
		return tipoSueloCodigo;
	}
	public void setTipoSueloCodigo(String tipoSueloCodigo) {
		this.tipoSueloCodigo = tipoSueloCodigo;
	}
	public Long getAprovechamiento() {
		return aprovechamiento;
	}
	public void setAprovechamiento(Long aprovechamiento) {
		this.aprovechamiento = aprovechamiento;
	}
	public Date getFechaUltimoGradoAvanceEstimado() {
		return fechaUltimoGradoAvanceEstimado;
	}
	public void setFechaUltimoGradoAvanceEstimado(Date fechaUltimoGradoAvanceEstimado) {
		this.fechaUltimoGradoAvanceEstimado = fechaUltimoGradoAvanceEstimado;
	}
	public Long getPorcentajeUrbanizacionEjecutado() {
		return porcentajeUrbanizacionEjecutado;
	}
	public void setPorcentajeUrbanizacionEjecutado(Long porcentajeUrbanizacionEjecutado) {
		this.porcentajeUrbanizacionEjecutado = porcentajeUrbanizacionEjecutado;
	}
	public Long getPorcentajeAmbitoValoradoEntero() {
		return porcentajeAmbitoValoradoEntero;
	}
	public void setPorcentajeAmbitoValoradoEntero(Long porcentajeAmbitoValoradoEntero) {
		this.porcentajeAmbitoValoradoEntero = porcentajeAmbitoValoradoEntero;
	}
	public String getProductoDesarrollarPrevistoCodigo() {
		return productoDesarrollarPrevistoCodigo;
	}
	public void setProductoDesarrollarPrevistoCodigo(String productoDesarrollarPrevistoCodigo) {
		this.productoDesarrollarPrevistoCodigo = productoDesarrollarPrevistoCodigo;
	}
	public String getProyectoObra() {
		return proyectoObra;
	}
	public void setProyectoObra(String proyectoObra) {
		this.proyectoObra = proyectoObra;
	}
	public Double getGastosComercialesTasacion() {
		return gastosComercialesTasacion;
	}
	public void setGastosComercialesTasacion(Double gastosComercialesTasacion) {
		this.gastosComercialesTasacion = gastosComercialesTasacion;
	}
	public String getPorcentajeCosteDefecto() {
		return porcentajeCosteDefecto;
	}
	public void setPorcentajeCosteDefecto(String porcentajeCosteDefecto) {
		this.porcentajeCosteDefecto = porcentajeCosteDefecto;
	}
	public String getFincaRusticaExpectativasUrbanisticas() {
		return fincaRusticaExpectativasUrbanisticas;
	}
	public void setFincaRusticaExpectativasUrbanisticas(String fincaRusticaExpectativasUrbanisticas) {
		this.fincaRusticaExpectativasUrbanisticas = fincaRusticaExpectativasUrbanisticas;
	}
	public String getParalizacionUrbanizacion() {
		return paralizacionUrbanizacion;
	}
	public void setParalizacionUrbanizacion(String paralizacionUrbanizacion) {
		this.paralizacionUrbanizacion = paralizacionUrbanizacion;
	}
	public String getTipoDatoUtilizadoInmuebleComparableCodigo() {
		return tipoDatoUtilizadoInmuebleComparableCodigo;
	}
	public void setTipoDatoUtilizadoInmuebleComparableCodigo(String tipoDatoUtilizadoInmuebleComparableCodigo) {
		this.tipoDatoUtilizadoInmuebleComparableCodigo = tipoDatoUtilizadoInmuebleComparableCodigo;
	}
}