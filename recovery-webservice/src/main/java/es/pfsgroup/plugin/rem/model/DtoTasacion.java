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
}