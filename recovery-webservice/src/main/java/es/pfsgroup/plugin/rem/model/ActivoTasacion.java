package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import javax.persistence.*;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBValoracionesBien;
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
}
