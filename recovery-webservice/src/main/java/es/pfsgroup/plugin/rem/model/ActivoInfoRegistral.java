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
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.direccion.model.Localidad;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBInformacionRegistralBien;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoDivHorizontal;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoObraNueva;



/**
 * Modelo que gestiona la informacion registral de un activo
 * 
 * @author Jose Villel
 */
@Entity
@Table(name = "ACT_REG_INFO_REGISTRAL", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoInfoRegistral implements Serializable, Auditable {


	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "REG_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoInfoRegistralGenerator")
    @SequenceGenerator(name = "ActivoInfoRegistralGenerator", sequenceName = "S_ACT_REG_INFO_REGISTRAL")
    private Long id;

	@OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    private Activo activo;
	
    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "BIE_DREG_ID")
    private NMBInformacionRegistralBien infoRegistralBien;
    
    @Column(name = "REG_NUM_DEPARTAMENTO")
	private Integer numDepartamento;
    
    @Column(name = "REG_IDUFIR")
	private String idufir;
	
	@Column(name = "REG_HAN_CAMBIADO")
	private Integer hanCambiado;
	
	@OneToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_LOC_ID_ANTERIOR")
	private Localidad  localidadAnterior;
	
	@Column(name = "REG_NUM_ANTERIOR")
	private String numAnterior;
	
	@Column(name = "REG_NUM_FINCA_ANTERIOR")
	private String numFincaAnterior;
	
	@Column(name = "REG_SUPERFICIE_UTIL")
	private Float superficieUtil;
	
	@Column(name = "REG_SUPERFICIE_ELEM_COMUN")
	private Float superficieElementosComunes;
	
	@Column(name = "REG_SUPERFICIE_PARCELA")
	private Float superficieParcela;
	
	@Column(name = "REG_SUPERFICIE_BAJO_RASANTE")
	private Float superficieBajoRasante;
	
	@Column(name = "REG_SUPERFICIE_SOBRE_RASANTE")
	private Float superficieSobreRasante;
	
	@Column(name = "REG_DIV_HOR_INSCRITO")
	private Integer divHorInscrito;
    
	@OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_EDH_ID")
	private DDEstadoDivHorizontal estadoDivHorizontal;
	
    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_EON_ID")
	private DDEstadoObraNueva estadoObraNueva;

	@Column(name = "REG_FECHA_CFO")
	private Date fechaCfo;




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

	public NMBInformacionRegistralBien getInfoRegistralBien() {
		return infoRegistralBien;
	}

	public void setInfoRegistralBien(NMBInformacionRegistralBien infoRegistralBien) {
		this.infoRegistralBien = infoRegistralBien;
	}

	public Integer getNumDepartamento() {
		return numDepartamento;
	}

	public void setNumDepartamento(Integer numDepartamento) {
		this.numDepartamento = numDepartamento;
	}

	public String getIdufir() {
		return idufir;
	}

	public void setIdufir(String idufir) {
		this.idufir = idufir;
	}

	public Integer getHanCambiado() {
		return hanCambiado;
	}

	public void setHanCambiado(Integer hanCambiado) {
		this.hanCambiado = hanCambiado;
	}

	public Localidad getLocalidadAnterior() {
		return localidadAnterior;
	}

	public void setLocalidadAnterior(Localidad localidadAnterior) {
		this.localidadAnterior = localidadAnterior;
	}

	public String getNumAnterior() {
		return numAnterior;
	}

	public void setNumAnterior(String numAnterior) {
		this.numAnterior = numAnterior;
	}

	public String getNumFincaAnterior() {
		return numFincaAnterior;
	}

	public void setNumFincaAnterior(String numFincaAnterior) {
		this.numFincaAnterior = numFincaAnterior;
	}

	public Float getSuperficieUtil() {
		return superficieUtil;
	}

	public void setSuperficieUtil(Float superficieUtil) {
		this.superficieUtil = superficieUtil;
	}

	public Float getSuperficieElementosComunes() {
		return superficieElementosComunes;
	}

	public void setSuperficieElementosComunes(Float superficieElementosComunes) {
		this.superficieElementosComunes = superficieElementosComunes;
	}

	public Float getSuperficieParcela() {
		return superficieParcela;
	}

	public void setSuperficieParcela(Float superficieParcela) {
		this.superficieParcela = superficieParcela;
	}

	public Float getSuperficieBajoRasante() {
		return superficieBajoRasante;
	}

	public void setSuperficieBajoRasante(Float superficieBajoRasante) {
		this.superficieBajoRasante = superficieBajoRasante;
	}

	public Float getSuperficieSobreRasante() {
		return superficieSobreRasante;
	}

	public void setSuperficieSobreRasante(Float superficieSobreRasante) {
		this.superficieSobreRasante = superficieSobreRasante;
	}

	public Integer getDivHorInscrito() {
		// null
		// 0 - NO INSCRITA
		// 1 - INSCRITA
		return divHorInscrito;
	}

	public void setDivHorInscrito(Integer divHorInscrito) {
		this.divHorInscrito = divHorInscrito;
	}

	public DDEstadoDivHorizontal getEstadoDivHorizontal() {
		return estadoDivHorizontal;
	}

	public void setEstadoDivHorizontal(DDEstadoDivHorizontal estadoDivHorizontal) {
		this.estadoDivHorizontal = estadoDivHorizontal;
	}

	public DDEstadoObraNueva getEstadoObraNueva() {
		return estadoObraNueva;
	}

	public void setEstadoObraNueva(DDEstadoObraNueva estadoObraNueva) {
		this.estadoObraNueva = estadoObraNueva;
	}

	public Date getFechaCfo() {
		return fechaCfo;
	}

	public void setFechaCfo(Date fechaCfo) {
		this.fechaCfo = fechaCfo;
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
	
	
	
	
}
