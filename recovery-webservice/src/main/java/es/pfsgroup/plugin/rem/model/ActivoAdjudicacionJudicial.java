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
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.procesosJudiciales.model.TipoJuzgado;
import es.capgemini.pfs.procesosJudiciales.model.TipoPlaza;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBAdjudicacionBien;
import es.pfsgroup.plugin.rem.model.dd.DDEntidadEjecutante;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoAdjudicacion;



/**
 * Modelo que gestiona la información de las adjudicaciones judiciales.
 * 
 * @author Anahuac de Vicente
 */
@Entity
@Table(name = "ACT_AJD_ADJJUDICIAL", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoAdjudicacionJudicial implements Serializable, Auditable {


	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "AJD_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoAdjudicacionJudicialGenerator")
    @SequenceGenerator(name = "ActivoAdjudicacionJudicialGenerator", sequenceName = "S_ACT_AJD_ADJJUDICIAL")
    private Long id;
	
	@OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    private Activo activo;
	   
    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "BIE_ADJ_ID")
    private NMBAdjudicacionBien adjudicacionBien;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_JUZ_ID")
    private TipoJuzgado juzgado;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_PLA_ID")
    private TipoPlaza plazaJuzgado;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_EDJ_ID")
    private DDEstadoAdjudicacion estadoAdjudicacion;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_EEJ_ID")
    private DDEntidadEjecutante entidadEjecutante;
	
	@Column(name = "AJD_FECHA_ADJUDICACION")
	private Date fechaAdjudicacion;
	
	@Column(name = "AJD_NUM_AUTO")
	private String numAuto;
	
	@Column(name = "AJD_PROCURADOR")
	private String procurador;
	
	@Column(name = "AJD_LETRADO")
	private String letrado;
	
	@Column(name = "AJD_ID_ASUNTO")
	private Long idAsunto;
	
	@Column(name = "AJD_EXP_DEF_TESTI")
	private String defectosTestimonio;

	@Version   
	private Long version;
	
	@Embedded
	private Auditoria auditoria;

	
	public ActivoAdjudicacionJudicial() {		
		Auditoria.save(this);
	}
	
	
	
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

	public NMBAdjudicacionBien getAdjudicacionBien() {
		return adjudicacionBien;
	}

	public void setAdjudicacionBien(NMBAdjudicacionBien adjudicacionBien) {
		this.adjudicacionBien = adjudicacionBien;
	}

	public TipoJuzgado getJuzgado() {
		return juzgado;
	}

	public void setJuzgado(TipoJuzgado juzgado) {
		this.juzgado = juzgado;
	}

	public TipoPlaza getPlazaJuzgado() {
		return plazaJuzgado;
	}

	public void setPlazaJuzgado(TipoPlaza plazaJuzgado) {
		this.plazaJuzgado = plazaJuzgado;
	}

	public DDEstadoAdjudicacion getEstadoAdjudicacion() {
		return estadoAdjudicacion;
	}

	public void setEstadoAdjudicacion(DDEstadoAdjudicacion estadoAdjudicacion) {
		this.estadoAdjudicacion = estadoAdjudicacion;
	}

	public DDEntidadEjecutante getEntidadEjecutante() {
		return entidadEjecutante;
	}

	public void setEntidadEjecutante(DDEntidadEjecutante entidadEjecutante) {
		this.entidadEjecutante = entidadEjecutante;
	}

	public Date getFechaAdjudicacion() {
		return fechaAdjudicacion;
	}

	public void setFechaAdjudicacion(Date fechaAdjudicacion) {
		this.fechaAdjudicacion = fechaAdjudicacion;
	}

	public String getNumAuto() {
		return numAuto;
	}

	public void setNumAuto(String numAuto) {
		this.numAuto = numAuto;
	}

	public String getProcurador() {
		return procurador;
	}

	public void setProcurador(String procurador) {
		this.procurador = procurador;
	}

	public String getLetrado() {
		return letrado;
	}

	public void setLetrado(String letrado) {
		this.letrado = letrado;
	}

	public Long getIdAsunto() {
		return idAsunto;
	}

	public void setIdAsunto(Long idAsunto) {
		this.idAsunto = idAsunto;
	}

/*	public Integer getNumExpRiesgoAdj() {
		return numExpRiesgoAdj;
	}

	public void setNumExpRiesgoAdj(Integer numExpRiesgoAdj) {
		this.numExpRiesgoAdj = numExpRiesgoAdj;
	}*/

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

	public String getDefectosTestimonio() {
		return defectosTestimonio;
	}

	public void setDefectosTestimonio(String defectosTestimonio) {
		this.defectosTestimonio = defectosTestimonio;
	}
	
	
}
