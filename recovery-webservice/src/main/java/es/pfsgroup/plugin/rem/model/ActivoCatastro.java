package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDClaseUsoCatastral;
import es.pfsgroup.plugin.rem.model.dd.DDOrigenDatosCatastrales;
import es.pfsgroup.plugin.rem.model.dd.DDTipoMoneda;



/**
 * Modelo que gestiona la informacion de catastro de los activos
 * 
 * @author Anahuac de Vicente
 *
 */
@Entity
@Table(name = "ACT_CAT_CATASTRO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoCatastro implements Serializable, Auditable {


	/**
	 * 
	 */
	private static final long serialVersionUID = -495616918380275492L;

	@Id
    @Column(name = "CAT_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoCatastroGenerator")
    @SequenceGenerator(name = "ActivoCatastroGenerator", sequenceName = "S_ACT_CAT_CATASTRO")
    private Long id;

	@ManyToOne
    @JoinColumn(name = "ACT_ID")
    private Activo activo;   

	@Column(name = "CAT_REF_CATASTRAL")
	private String refCatastral;
	
	@Column(name = "CAT_POLIGONO")
	private String poligono;
	
	@Column(name = "CAT_PARCELA")
	private String parcela;
	
	@Column(name = "CAT_TITULAR_CATASTRAL")
	private String titularCatastral;
	
	@Column(name = "CAT_SUPERFICIE_CONSTRUIDA")
	private Float superficieConstruida;
	
	@Column(name = "CAT_SUPERFICIE_UTIL")
	private Float superficieUtil;
	
	@Column(name = "CAT_SUPERFICIE_REPER_COMUN")
	private Float superficieReperComun;
	
	@Column(name = "CAT_SUPERFICIE_PARCELA")
	private Float superficieParcela;
	
	@Column(name = "CAT_SUPERFICIE_SUELO")
	private Float superficieSuelo;
	
	@Column(name = "CAT_VALOR_CATASTRAL_CONST")
	private Double valorCatastralConst;
	
	@Column(name = "CAT_VALOR_CATASTRAL_SUELO")
	private Double valorCatastralSuelo;
	
	@Column(name = "CAT_FECHA_REV_VALOR_CATASTRAL")
	private Date fechaRevValorCatastral;
	
	@Column(name = "CAT_F_ALTA_CATASTRO")
	private Date fechaAltaCatastro;

	@Column(name = "CAT_F_BAJA_CATASTRO")
	private Date fechaBajaCatastro;
	
	@Column(name = "CAT_OBSERVACIONES")
	private String observaciones;
	
	@Column(name = "CAT_RESULTADO")
	private String resultadoSiNO;
	
	@Column(name = "CAT_FECHA_SOLICITUD_901")
	private Date fechaSolicitud901;
	
	@Column(name = "CAT_FECHA_ALTERACION")
	private Date fechaAlteracion;
	
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_ODC_ID")
	private DDOrigenDatosCatastrales origenDatosCatastrales;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_CUC_ID")
	private DDClaseUsoCatastral claseUsoCatastral;
	
	@Column(name = "CAT_VIGENTE")
	private Boolean catastroVigente;
	
	@Column(name = "CAT_VALOR_CATASTRAL")
	private Double valorCatastral;
	
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_MON_ID")
	private DDTipoMoneda tipoMoneda;
    
	@Column(name = "CAT_CORRECTO")
	private Boolean catastroCorrecto;
	
	@ManyToOne
    @JoinColumn(name = "CAT_CATASTRO")
    private Catastro catastro;   
	
	@Version   
	private Long version;
	
	@Embedded
	private Auditoria auditoria;
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Activo getActivo() {
		return activo;
	}

	public void setActivo(Activo activo) {
		this.activo = activo;
	}

	public String getRefCatastral() {
		return refCatastral;
	}

	public void setRefCatastral(String refCatastral) {
		this.refCatastral = refCatastral;
	}

	public String getPoligono() {
		return poligono;
	}

	public void setPoligono(String poligono) {
		this.poligono = poligono;
	}

	public String getParcela() {
		return parcela;
	}

	public void setParcela(String parcela) {
		this.parcela = parcela;
	}

	public String getTitularCatastral() {
		return titularCatastral;
	}

	public void setTitularCatastral(String titularCatastral) {
		this.titularCatastral = titularCatastral;
	}

	public Float getSuperficieConstruida() {
		return superficieConstruida;
	}

	public void setSuperficieConstruida(Float superficieConstruida) {
		this.superficieConstruida = superficieConstruida;
	}

	public Float getSuperficieUtil() {
		return superficieUtil;
	}

	public void setSuperficieUtil(Float superficieUtil) {
		this.superficieUtil = superficieUtil;
	}

	public Float getSuperficieReperComun() {
		return superficieReperComun;
	}

	public void setSuperficieReperComun(Float superficieReperComun) {
		this.superficieReperComun = superficieReperComun;
	}

	public Float getSuperficieParcela() {
		return superficieParcela;
	}

	public void setSuperficieParcela(Float superficieParcela) {
		this.superficieParcela = superficieParcela;
	}

	public Float getSuperficieSuelo() {
		return superficieSuelo;
	}

	public void setSuperficieSuelo(Float superficieSuelo) {
		this.superficieSuelo = superficieSuelo;
	}

	public Double getValorCatastralConst() {
		return valorCatastralConst;
	}

	public void setValorCatastralConst(Double valorCatastralConst) {
		this.valorCatastralConst = valorCatastralConst;
	}

	public Double getValorCatastralSuelo() {
		return valorCatastralSuelo;
	}

	public void setValorCatastralSuelo(Double valorCatastralSuelo) {
		this.valorCatastralSuelo = valorCatastralSuelo;
	}

	public Date getFechaRevValorCatastral() {
		return fechaRevValorCatastral;
	}

	public void setFechaRevValorCatastral(Date fechaRevValorCatastral) {
		this.fechaRevValorCatastral = fechaRevValorCatastral;
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

	public Date getFechaAltaCatastro() {
		return fechaAltaCatastro;
	}

	public void setFechaAltaCatastro(Date fechaAltaCatastro) {
		this.fechaAltaCatastro = fechaAltaCatastro;
	}

	public Date getFechaBajaCatastro() {
		return fechaBajaCatastro;
	}

	public void setFechaBajaCatastro(Date fechaBajaCatastro) {
		this.fechaBajaCatastro = fechaBajaCatastro;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}

	public String getResultado() {
		return resultadoSiNO;
	}

	public void setResultado(String resultadoSiNO) {
		this.resultadoSiNO = resultadoSiNO;
	}

	public Date getFechaSolicitud901() {
		return fechaSolicitud901;
	}

	public void setFechaSolicitud901(Date fechaSolicitud901) {
		this.fechaSolicitud901 = fechaSolicitud901;
	}

	public Date getFechaAlteracion() {
		return fechaAlteracion;
	}

	public void setFechaAlteracion(Date fechaAlteracion) {
		this.fechaAlteracion = fechaAlteracion;
	}

	public Boolean getCatastroVigente() {
		return catastroVigente;
	}

	public void setCatastroVigente(Boolean catastroVigente) {
		this.catastroVigente = catastroVigente;
	}

	public Double getValorCatastral() {
		return valorCatastral;
	}

	public void setValorCatastral(Double valorCatastral) {
		this.valorCatastral = valorCatastral;
	}

	public DDOrigenDatosCatastrales getOrigenDatosCatastrales() {
		return origenDatosCatastrales;
	}

	public void setOrigenDatosCatastrales(DDOrigenDatosCatastrales origenDatosCatastrales) {
		this.origenDatosCatastrales = origenDatosCatastrales;
	}

	public DDClaseUsoCatastral getClaseUsoCatastral() {
		return claseUsoCatastral;
	}

	public void setClaseUsoCatastral(DDClaseUsoCatastral claseUsoCatastral) {
		this.claseUsoCatastral = claseUsoCatastral;
	}

	public DDTipoMoneda getTipoMoneda() {
		return tipoMoneda;
	}

	public void setTipoMoneda(DDTipoMoneda tipoMoneda) {
		this.tipoMoneda = tipoMoneda;
	}

	public Boolean getCatastroCorrecto() {
		return catastroCorrecto;
	}

	public void setCatastroCorrecto(Boolean catastroCorrecto) {
		this.catastroCorrecto = catastroCorrecto;
	}

	public Catastro getCatastro() {
		return catastro;
	}

	public void setCatastro(Catastro catastro) {
		this.catastro = catastro;
	}
	
}