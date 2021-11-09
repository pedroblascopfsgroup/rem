package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBValoracionesBien;
import es.pfsgroup.plugin.rem.model.dd.DDDesarrolloPlanteamiento;
import es.pfsgroup.plugin.rem.model.dd.DDFaseGestion;
import es.pfsgroup.plugin.rem.model.dd.DDMetodoValoracion;
import es.pfsgroup.plugin.rem.model.dd.DDProductoDesarrollar;
import es.pfsgroup.plugin.rem.model.dd.DDProximidadRespectoNucleoUrbano;
import es.pfsgroup.plugin.rem.model.dd.DDSistemaGestion;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDatoUtilizadoInmuebleComparable;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTasacion;


/**
 * Modelo que gestiona las tasaciones de los activos.
 * 
 * @author Anahuac de Vicente
 */
@Entity
@Table(name = "ACT_TAS_TASACION", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoTasacion implements Serializable, Auditable {

	private static final long serialVersionUID = 1L;


	@Id
    @Column(name = "TAS_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoTasacionGenerator")
    @SequenceGenerator(name = "ActivoTasacionGenerator", sequenceName = "S_ACT_TAS_TASACION")
    private Long id;
	
	@Column(name = "TAS_ID_EXTERNO")
	private Long idExterno;
	
    @ManyToOne
    @JoinColumn(name = "ACT_ID")
    private Activo activo;    
    
    @OneToOne
    @JoinColumn(name = "BIE_VAL_ID")
    private NMBValoracionesBien valoracionBien;  
    
    @ManyToOne
    @JoinColumn(name = "DD_TTS_ID")
    private DDTipoTasacion tipoTasacion; 
    
    @Column(name = "TAS_FECHA_INI_TASACION")
    private Date fechaInicioTasacion; 
    
    @Column(name = "TAS_FECHA_RECEPCION_TASACION")
    private Date fechaRecepcionTasacion;  
	
	@Column(name = "TAS_CODIGO_FIRMA")
    private Long codigoFirma;  
	
	@Column(name = "TAS_NOMBRE_TASADOR")
    private String nomTasador;  
	
	@Column(name = "TAS_IMPORTE_TAS_FIN")
    private Double importeTasacionFin;  
	
	@Column(name = "TAS_COSTE_REPO_NETO_ACTUAL")
    private Double costeRepoNetoActual;  
	
	@Column(name = "TAS_COSTE_REPO_NETO_FINALIZADO")
    private Double costeRepoNetoFinalizado;  
	
	@Column(name = "TAS_COEF_MERCADO_ESTADO")
    private Float coeficienteMercadoEstado;  
	
	@Column(name = "TAS_COEF_POND_VALOR_ANYADIDO")
    private Float coeficientePondValorAnanyadido;  
	
	@Column(name = "TAS_VALOR_REPER_SUELO_CONST")
    private Double valorReperSueloConst;  
	
	@Column(name = "TAS_COSTE_CONST_CONST")
    private Double costeConstConstruido;  
	
	@Column(name = "TAS_INDICE_DEPRE_FISICA")
    private Float indiceDepreFisica;  
	
	@Column(name = "TAS_INDICE_DEPRE_FUNCIONAL")
    private Float indiceDepreFuncional;  
	
	@Column(name = "TAS_INDICE_TOTAL_DEPRE")
    private Float indiceTotalDepre;  
	
	@Column(name = "TAS_COSTE_CONST_DEPRE")
    private Double costeConstDepreciada;  
	
	@Column(name = "TAS_COSTE_UNI_REPO_NETO")
    private Double costeUnitarioRepoNeto;  
	
	@Column(name = "TAS_COSTE_REPOSICION")
    private Double costeReposicion;  
	
	@Column(name = "TAS_PORCENTAJE_OBRA")
    private Float porcentajeObra;  
	
	@Column(name = "TAS_IMPORTE_VALOR_TER")
    private Double importeValorTerminado; 
	
	@Column(name = "TAS_ID_TEXTO_ASOCIADO")
    private Long idTextoAsociado; 
	
	@Column(name = "TAS_IMPORTE_VAL_LEGAL_FINCA")
    private Double importeValorLegalFinca; 
	
	@Column(name = "TAS_IMPORTE_VAL_SOLAR")
    private Double importeValorSolar; 
	
	@Column(name = "TAS_OBSERVACIONES")
    private String observaciones; 
	
	@Column(name = "TAS_ILOCALIZABLE")
	private Boolean ilocalizable;

	@OneToOne(mappedBy = "tasacion", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
	@JoinColumn(name = "TAS_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private GastoTasacionActivo gastoTasacionActivo;

	@Version   
	private Long version;

	@Embedded
	private Auditoria auditoria;

	@Column(name = "TAS_CODIGO_FIRMA_BBVA")
	private String codigoFirmaBbva;
	
	@Column(name = "TAS_ID_EXTERNO_BBVA")
	private String idExternoBbva;
	
	@Column(name = "GASTO_COM_TASACION")
    private Double gastosComercialesTasacion; 
	
	@Column(name = "REF_TASADORA")
    private String referenciaTasadora; 
	
	@Column(name = "PORC_COSTE_DEFECTO")
	private Boolean porcentajeCosteDefecto;
	
	@Column(name = "APROV_PARCELA_SUELO")
    private Double aprovechamientoParcelaSuelo; 
	
    @ManyToOne
    @JoinColumn(name = "DD_DSP_ID")
    private DDDesarrolloPlanteamiento desarrolloPlanteamiento; 
    
    @ManyToOne
    @JoinColumn(name = "DD_FSG_ID")
    private DDFaseGestion faseGestion; 
    
	@Column(name = "ACOGIDA_NORMATIVA")
	private Boolean acogidaNormativa;
	
	@Column(name = "NUM_VIVIENDAS")
    private Long numeroViviendas; 
	
	@Column(name = "PORC_AMBITO_VAL")
    private Double porcentajeAmbitoValorado; 
	
    @ManyToOne
    @JoinColumn(name = "DD_PRD_ID")
    private DDProductoDesarrollar productoDesarrollar; 
    
    @ManyToOne
    @JoinColumn(name = "DD_PNU_ID")
    private DDProximidadRespectoNucleoUrbano proximidadRespectoNucleoUrbano; 
    
    @ManyToOne
    @JoinColumn(name = "DD_SGT_ID")
    private DDSistemaGestion sistemaGestion; 
    
	@Column(name = "SUPERFICIE_ADOPTADA")
    private Double superficieAdoptada; 
	
    @ManyToOne
    @JoinColumn(name = "DD_SAC_ID")
    private DDSubtipoActivo tipoSuelo; 
    
	@Column(name = "VAL_HIPO_EDI_TERM_PROM")
    private Double valorHipotesisEdificioTerminadoPromocion; 
	
	@Column(name = "ADVERTENCIAS")
	private Boolean advertencias;
	
	@Column(name = "APROVECHAMIENTO")
    private Double aprovechamiento; 
	
	@Column(name = "COD_SOCIEDAD_TAS_VAL")
    private String codigoSociedadTasacionValoracion; 
	
	@Column(name = "CONDICIONANTES")
	private Boolean condicionantes;
	
	@Column(name = "COSTE_EST_TER_OBRA")
    private Double costeEstimadoTerminarObra; 
	
	@Column(name = "COSTE_DEST_PROPIO")
    private Double costeDestinaUsoPropio; 
	
    @Column(name = "FEC_ULT_AVANCE_EST")
    private Date fechaUltimoGradoAvanceEstimado;  
    
    @Column(name = "FEC_EST_TER_OBRA")
    private Date fechaEstimadaTerminarObra; 
    
	@Column(name = "FINCA_RUS_EXP_URB")
	private Boolean fincaRusticaExpectativasUrbanisticas;
	
    @ManyToOne
    @JoinColumn(name = "DD_MTV_ID")
    private DDMetodoValoracion metodoValoracion; 

	@Column(name = "MET_RES_DIN_MAX_COM")
    private Long mrdPlazoMaximoFinalizarComercializacion; 
	
	@Column(name = "MET_RES_DIN_MAX_CONS")
    private Long mrdPlazoMaximoFinalizarConstruccion; 
	
	@Column(name = "MET_RES_DIN_TAS_ANU")
    private Double mrdTasaAnualizadaHomogenea; 
	
	@Column(name = "MET_RES_DIN_TIPO_ACT")
    private Double mrdTasaActualizacion; 
	
	@Column(name = "MET_RES_EST_MAR_PROM")
    private Double mreMargenBeneficioPromotor; 
	
	@Column(name = "PARALIZACION_URB")
	private Boolean paralizacionUrbanizacion;
	
	@Column(name = "PORC_URB_EJECUTADO")
    private Double porcentajeUrbanizacionEjecutado;
	
	@Column(name = "PORC_AMBITO_VAL_ENT")
    private Double porcentajeAmbitoValoradoEntero;
	
    @ManyToOne
    @JoinColumn(name = "DD_PRD_ID_PREV")
    private DDProductoDesarrollar productoDesarrollarPrevisto;
    
	@Column(name = "PROYECTO_OBRA")
	private Boolean proyectoObra;
	
	@Column(name = "SUPERFICIE_TERRENO")
    private Double superficieTerreno;
	
	@Column(name = "TAS_ANU_VAR_MERCADO")
    private Double tasaAnualMedioVariacionPrecioMercado;
	
    @ManyToOne
    @JoinColumn(name = "DD_TDU_ID")
    private DDTipoDatoUtilizadoInmuebleComparable tipoDatoUtilizadoInmuebleComparable;
	
	@Column(name = "VALOR_TERRENO")
    private Double valorTerreno;
	
	@Column(name = "VALOR_TERRENO_AJUS")
    private Double valorTerrenoAjustado;
	
	@Column(name = "VAL_HIPO_EDI_TERM")
    private Double valorHipotesisEdificioTerminado;
	
	@Column(name = "VALOR_HIPOTECARIO")
    private Double valorHipotecario;
	
	@Column(name = "VISITA_ANT_INMUEBLE")
	private Boolean visitaAnteriorInmueble;
	
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getIdExterno() {
		return idExterno;
	}

	public void setIdExterno(Long idExterno) {
		this.idExterno = idExterno;
	}

	public Activo getActivo() {
		return activo;
	}

	public void setActivo(Activo activo) {
		this.activo = activo;
	}

	public NMBValoracionesBien getValoracionBien() {
		return valoracionBien;
	}

	public void setValoracionBien(NMBValoracionesBien valoracionBien) {
		this.valoracionBien = valoracionBien;
	}

	public DDTipoTasacion getTipoTasacion() {
		return tipoTasacion;
	}

	public void setTipoTasacion(DDTipoTasacion tipoTasacion) {
		this.tipoTasacion = tipoTasacion;
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

	public Long getCodigoFirma() {
		return codigoFirma;
	}

	public void setCodigoFirma(Long codigoFirma) {
		this.codigoFirma = codigoFirma;
	}

	public String getNomTasador() {
		return nomTasador;
	}

	public void setNomTasador(String nomTasador) {
		this.nomTasador = nomTasador;
	}

	public Double getImporteTasacionFin() {
		return importeTasacionFin;
	}

	public void setImporteTasacionFin(Double importeTasacionFin) {
		this.importeTasacionFin = importeTasacionFin;
	}

	public Double getCosteRepoNetoActual() {
		return costeRepoNetoActual;
	}

	public void setCosteRepoNetoActual(Double costeRepoNetoActual) {
		this.costeRepoNetoActual = costeRepoNetoActual;
	}

	public Double getCosteRepoNetoFinalizado() {
		return costeRepoNetoFinalizado;
	}

	public void setCosteRepoNetoFinalizado(Double costeRepoNetoFinalizado) {
		this.costeRepoNetoFinalizado = costeRepoNetoFinalizado;
	}

	public Float getCoeficienteMercadoEstado() {
		return coeficienteMercadoEstado;
	}

	public void setCoeficienteMercadoEstado(Float coeficienteMercadoEstado) {
		this.coeficienteMercadoEstado = coeficienteMercadoEstado;
	}

	public Float getCoeficientePondValorAnanyadido() {
		return coeficientePondValorAnanyadido;
	}

	public void setCoeficientePondValorAnanyadido(
			Float coeficientePondValorAnanyadido) {
		this.coeficientePondValorAnanyadido = coeficientePondValorAnanyadido;
	}

	public Double getValorReperSueloConst() {
		return valorReperSueloConst;
	}

	public void setValorReperSueloConst(Double valorReperSueloConst) {
		this.valorReperSueloConst = valorReperSueloConst;
	}

	public Double getCosteConstConstruido() {
		return costeConstConstruido;
	}

	public void setCosteConstConstruido(Double costeConstConstruido) {
		this.costeConstConstruido = costeConstConstruido;
	}

	public Float getIndiceDepreFisica() {
		return indiceDepreFisica;
	}

	public void setIndiceDepreFisica(Float indiceDepreFisica) {
		this.indiceDepreFisica = indiceDepreFisica;
	}

	public Float getIndiceDepreFuncional() {
		return indiceDepreFuncional;
	}

	public void setIndiceDepreFuncional(Float indiceDepreFuncional) {
		this.indiceDepreFuncional = indiceDepreFuncional;
	}

	public Float getIndiceTotalDepre() {
		return indiceTotalDepre;
	}

	public void setIndiceTotalDepre(Float indiceTotalDepre) {
		this.indiceTotalDepre = indiceTotalDepre;
	}

	public Double getCosteConstDepreciada() {
		return costeConstDepreciada;
	}

	public void setCosteConstDepreciada(Double costeConstDepreciada) {
		this.costeConstDepreciada = costeConstDepreciada;
	}

	public Double getCosteUnitarioRepoNeto() {
		return costeUnitarioRepoNeto;
	}

	public void setCosteUnitarioRepoNeto(Double costeUnitarioRepoNeto) {
		this.costeUnitarioRepoNeto = costeUnitarioRepoNeto;
	}

	public Double getCosteReposicion() {
		return costeReposicion;
	}

	public void setCosteReposicion(Double costeReposicion) {
		this.costeReposicion = costeReposicion;
	}

	public Float getPorcentajeObra() {
		return porcentajeObra;
	}

	public void setPorcentajeObra(Float porcentajeObra) {
		this.porcentajeObra = porcentajeObra;
	}

	public Double getImporteValorTerminado() {
		return importeValorTerminado;
	}

	public void setImporteValorTerminado(Double importeValorTerminado) {
		this.importeValorTerminado = importeValorTerminado;
	}

	public Long getIdTextoAsociado() {
		return idTextoAsociado;
	}

	public void setIdTextoAsociado(Long idTextoAsociado) {
		this.idTextoAsociado = idTextoAsociado;
	}

	public Double getImporteValorLegalFinca() {
		return importeValorLegalFinca;
	}

	public void setImporteValorLegalFinca(Double importeValorLegalFinca) {
		this.importeValorLegalFinca = importeValorLegalFinca;
	}

	public Double getImporteValorSolar() {
		return importeValorSolar;
	}

	public void setImporteValorSolar(Double importeValorSolar) {
		this.importeValorSolar = importeValorSolar;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}

	public Long getVersion() {
		return version;
	}

	public void setVersion(Long version) {
		this.version = version;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public String getCodigoFirmaBbva() {
		return codigoFirmaBbva;
	}

	public void setCodigoFirmaBbva(String codigoFirmaBbva) {
		this.codigoFirmaBbva = codigoFirmaBbva;
	}

	public String getIdExternoBbva() {
		return idExternoBbva;
	}

	public void setIdExternoBbva(String idExternoBbva) {
		this.idExternoBbva = idExternoBbva;
	}
	public Boolean isIlocalizable() {
		return ilocalizable;
	}

	public void setIlocalizable(Boolean ilocalizable) {
		this.ilocalizable = ilocalizable;
	}

	public GastoTasacionActivo getGastoTasacionActivo() {
		return gastoTasacionActivo;
	}

	public void setGastoTasacionActivo(GastoTasacionActivo gastoTasacionActivo) {
		this.gastoTasacionActivo = gastoTasacionActivo;
	}
	public Double getGastosComercialesTasacion() {
		return gastosComercialesTasacion;
	}

	public void setGastosComercialesTasacion(Double gastosComercialesTasacion) {
		this.gastosComercialesTasacion = gastosComercialesTasacion;
	}

	public String getReferenciaTasadora() {
		return referenciaTasadora;
	}

	public void setReferenciaTasadora(String referenciaTasadora) {
		this.referenciaTasadora = referenciaTasadora;
	}

	public Boolean getPorcentajeCosteDefecto() {
		return porcentajeCosteDefecto;
	}

	public void setPorcentajeCosteDefecto(Boolean porcentajeCosteDefecto) {
		this.porcentajeCosteDefecto = porcentajeCosteDefecto;
	}

	public Double getAprovechamientoParcelaSuelo() {
		return aprovechamientoParcelaSuelo;
	}

	public void setAprovechamientoParcelaSuelo(Double aprovechamientoParcelaSuelo) {
		this.aprovechamientoParcelaSuelo = aprovechamientoParcelaSuelo;
	}

	public DDDesarrolloPlanteamiento getDesarrolloPlanteamiento() {
		return desarrolloPlanteamiento;
	}

	public void setDesarrolloPlanteamiento(DDDesarrolloPlanteamiento desarrolloPlanteamiento) {
		this.desarrolloPlanteamiento = desarrolloPlanteamiento;
	}

	public DDFaseGestion getFaseGestion() {
		return faseGestion;
	}

	public void setFaseGestion(DDFaseGestion faseGestion) {
		this.faseGestion = faseGestion;
	}

	public Boolean getAcogidaNormativa() {
		return acogidaNormativa;
	}

	public void setAcogidaNormativa(Boolean acogidaNormativa) {
		this.acogidaNormativa = acogidaNormativa;
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

	public DDProductoDesarrollar getProductoDesarrollar() {
		return productoDesarrollar;
	}

	public void setProductoDesarrollar(DDProductoDesarrollar productoDesarrollar) {
		this.productoDesarrollar = productoDesarrollar;
	}

	public DDProximidadRespectoNucleoUrbano getProximidadRespectoNucleoUrbano() {
		return proximidadRespectoNucleoUrbano;
	}

	public void setProximidadRespectoNucleoUrbano(DDProximidadRespectoNucleoUrbano proximidadRespectoNucleoUrbano) {
		this.proximidadRespectoNucleoUrbano = proximidadRespectoNucleoUrbano;
	}

	public DDSistemaGestion getSistemaGestion() {
		return sistemaGestion;
	}

	public void setSistemaGestion(DDSistemaGestion sistemaGestion) {
		this.sistemaGestion = sistemaGestion;
	}

	public Double getSuperficieAdoptada() {
		return superficieAdoptada;
	}

	public void setSuperficieAdoptada(Double superficieAdoptada) {
		this.superficieAdoptada = superficieAdoptada;
	}

	public DDSubtipoActivo getTipoSuelo() {
		return tipoSuelo;
	}

	public void setTipoSuelo(DDSubtipoActivo tipoSuelo) {
		this.tipoSuelo = tipoSuelo;
	}

	public Double getValorHipotesisEdificioTerminadoPromocion() {
		return valorHipotesisEdificioTerminadoPromocion;
	}

	public void setValorHipotesisEdificioTerminadoPromocion(Double valorHipotesisEdificioTerminadoPromocion) {
		this.valorHipotesisEdificioTerminadoPromocion = valorHipotesisEdificioTerminadoPromocion;
	}

	public Boolean getAdvertencias() {
		return advertencias;
	}

	public void setAdvertencias(Boolean advertencias) {
		this.advertencias = advertencias;
	}

	public Double getAprovechamiento() {
		return aprovechamiento;
	}

	public void setAprovechamiento(Double aprovechamiento) {
		this.aprovechamiento = aprovechamiento;
	}

	public String getCodigoSociedadTasacionValoracion() {
		return codigoSociedadTasacionValoracion;
	}

	public void setCodigoSociedadTasacionValoracion(String codigoSociedadTasacionValoracion) {
		this.codigoSociedadTasacionValoracion = codigoSociedadTasacionValoracion;
	}

	public Boolean getCondicionantes() {
		return condicionantes;
	}

	public void setCondicionantes(Boolean condicionantes) {
		this.condicionantes = condicionantes;
	}

	public Double getCosteEstimadoTerminarObra() {
		return costeEstimadoTerminarObra;
	}

	public void setCosteEstimadoTerminarObra(Double costeEstimadoTerminarObra) {
		this.costeEstimadoTerminarObra = costeEstimadoTerminarObra;
	}

	public Double getCosteDestinaUsoPropio() {
		return costeDestinaUsoPropio;
	}

	public void setCosteDestinaUsoPropio(Double costeDestinaUsoPropio) {
		this.costeDestinaUsoPropio = costeDestinaUsoPropio;
	}

	public Date getFechaUltimoGradoAvanceEstimado() {
		return fechaUltimoGradoAvanceEstimado;
	}

	public void setFechaUltimoGradoAvanceEstimado(Date fechaUltimoGradoAvanceEstimado) {
		this.fechaUltimoGradoAvanceEstimado = fechaUltimoGradoAvanceEstimado;
	}

	public Date getFechaEstimadaTerminarObra() {
		return fechaEstimadaTerminarObra;
	}

	public void setFechaEstimadaTerminarObra(Date fechaEstimadaTerminarObra) {
		this.fechaEstimadaTerminarObra = fechaEstimadaTerminarObra;
	}

	public Boolean getFincaRusticaExpectativasUrbanisticas() {
		return fincaRusticaExpectativasUrbanisticas;
	}

	public void setFincaRusticaExpectativasUrbanisticas(Boolean fincaRusticaExpectativasUrbanisticas) {
		this.fincaRusticaExpectativasUrbanisticas = fincaRusticaExpectativasUrbanisticas;
	}

	public DDMetodoValoracion getMetodoValoracion() {
		return metodoValoracion;
	}

	public void setMetodoValoracion(DDMetodoValoracion metodoValoracion) {
		this.metodoValoracion = metodoValoracion;
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

	public Double getMrdTasaAnualizadaHomogenea() {
		return mrdTasaAnualizadaHomogenea;
	}

	public void setMrdTasaAnualizadaHomogenea(Double mrdTasaAnualizadaHomogenea) {
		this.mrdTasaAnualizadaHomogenea = mrdTasaAnualizadaHomogenea;
	}

	public Double getMrdTasaActualizacion() {
		return mrdTasaActualizacion;
	}

	public void setMrdTasaActualizacion(Double mrdTasaActualizacion) {
		this.mrdTasaActualizacion = mrdTasaActualizacion;
	}

	public Double getMreMargenBeneficioPromotor() {
		return mreMargenBeneficioPromotor;
	}

	public void setMreMargenBeneficioPromotor(Double mreMargenBeneficioPromotor) {
		this.mreMargenBeneficioPromotor = mreMargenBeneficioPromotor;
	}

	public Boolean getParalizacionUrbanizacion() {
		return paralizacionUrbanizacion;
	}

	public void setParalizacionUrbanizacion(Boolean paralizacionUrbanizacion) {
		this.paralizacionUrbanizacion = paralizacionUrbanizacion;
	}

	public Double getPorcentajeUrbanizacionEjecutado() {
		return porcentajeUrbanizacionEjecutado;
	}

	public void setPorcentajeUrbanizacionEjecutado(Double porcentajeUrbanizacionEjecutado) {
		this.porcentajeUrbanizacionEjecutado = porcentajeUrbanizacionEjecutado;
	}

	public Double getPorcentajeAmbitoValoradoEntero() {
		return porcentajeAmbitoValoradoEntero;
	}

	public void setPorcentajeAmbitoValoradoEntero(Double porcentajeAmbitoValoradoEntero) {
		this.porcentajeAmbitoValoradoEntero = porcentajeAmbitoValoradoEntero;
	}

	public DDProductoDesarrollar getProductoDesarrollarPrevisto() {
		return productoDesarrollarPrevisto;
	}

	public void setProductoDesarrollarPrevisto(DDProductoDesarrollar productoDesarrollarPrevisto) {
		this.productoDesarrollarPrevisto = productoDesarrollarPrevisto;
	}

	public Boolean getProyectoObra() {
		return proyectoObra;
	}

	public void setProyectoObra(Boolean proyectoObra) {
		this.proyectoObra = proyectoObra;
	}

	public Double getSuperficieTerreno() {
		return superficieTerreno;
	}

	public void setSuperficieTerreno(Double superficieTerreno) {
		this.superficieTerreno = superficieTerreno;
	}

	public Double getTasaAnualMedioVariacionPrecioMercado() {
		return tasaAnualMedioVariacionPrecioMercado;
	}

	public void setTasaAnualMedioVariacionPrecioMercado(Double tasaAnualMedioVariacionPrecioMercado) {
		this.tasaAnualMedioVariacionPrecioMercado = tasaAnualMedioVariacionPrecioMercado;
	}

	public DDTipoDatoUtilizadoInmuebleComparable getTipoDatoUtilizadoInmuebleComparable() {
		return tipoDatoUtilizadoInmuebleComparable;
	}

	public void setTipoDatoUtilizadoInmuebleComparable(
			DDTipoDatoUtilizadoInmuebleComparable tipoDatoUtilizadoInmuebleComparable) {
		this.tipoDatoUtilizadoInmuebleComparable = tipoDatoUtilizadoInmuebleComparable;
	}

	public Double getValorTerreno() {
		return valorTerreno;
	}

	public void setValorTerreno(Double valorTerreno) {
		this.valorTerreno = valorTerreno;
	}

	public Double getValorTerrenoAjustado() {
		return valorTerrenoAjustado;
	}

	public void setValorTerrenoAjustado(Double valorTerrenoAjustado) {
		this.valorTerrenoAjustado = valorTerrenoAjustado;
	}

	public Double getValorHipotesisEdificioTerminado() {
		return valorHipotesisEdificioTerminado;
	}

	public void setValorHipotesisEdificioTerminado(Double valorHipotesisEdificioTerminado) {
		this.valorHipotesisEdificioTerminado = valorHipotesisEdificioTerminado;
	}

	public Double getValorHipotecario() {
		return valorHipotecario;
	}

	public void setValorHipotecario(Double valorHipotecario) {
		this.valorHipotecario = valorHipotecario;
	}

	public Boolean getVisitaAnteriorInmueble() {
		return visitaAnteriorInmueble;
	}

	public void setVisitaAnteriorInmueble(Boolean visitaAnteriorInmueble) {
		this.visitaAnteriorInmueble = visitaAnteriorInmueble;
	}
	
	public Boolean getIlocalizable() {
		return ilocalizable;
	}

}
