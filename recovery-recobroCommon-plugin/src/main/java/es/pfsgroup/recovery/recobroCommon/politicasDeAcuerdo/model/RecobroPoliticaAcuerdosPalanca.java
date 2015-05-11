package es.pfsgroup.recovery.recobroCommon.politicasDeAcuerdo.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
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

import es.capgemini.pfs.acuerdo.model.RecobroDDSubtipoPalanca;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;

@Entity
@Table(name = "RCF_PAA_POL_ACUERDOS_PALANCAS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class RecobroPoliticaAcuerdosPalanca implements Auditable, Serializable{
	
	private static final long serialVersionUID = -1934773194960249533L;
	
	@Id
    @Column(name = "RCF_PAA_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "PoliticaAcuerdosPalancaGenerator")
	@SequenceGenerator(name = "PoliticaAcuerdosPalancaGenerator", sequenceName = "S_RCF_PAA_POL_ACUER_PALANCAS")
    private Long id;

	 
	@ManyToOne
	@JoinColumn(name = "RCF_POA_ID", nullable = false)
	private RecobroPoliticaDeAcuerdos politicaAcuerdos;
	
	@ManyToOne
	@JoinColumn(name = "RCF_STP_ID", nullable = true)
	private RecobroDDSubtipoPalanca subtipoPalanca;
	 
	@ManyToOne
	@JoinColumn(name = "DD_SIN_ID", nullable = true)
	private DDSiNo delegada;	
	
	@Column(name = "RCF_PAA_PRIORIDAD")
	private Integer prioridad;	
	
	@Column(name = "RCF_PAA_TIEMPO_INMUNIDAD1")
	private Integer tiempoInmunidad1;
	
	@Column(name = "RCF_PAA_TIEMPO_INMUNIDAD2")
	private Integer tiempoInmunidad2;
	
	@Embedded
	private Auditoria auditoria;

	@Version
	private Integer version;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}
    
	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public RecobroPoliticaDeAcuerdos getPoliticaAcuerdos() {
		return politicaAcuerdos;
	}

	public void setPoliticaAcuerdos(RecobroPoliticaDeAcuerdos politicaAcuerdos) {
		this.politicaAcuerdos = politicaAcuerdos;
	}

	public RecobroDDSubtipoPalanca getSubtipoPalanca() {
		return subtipoPalanca;
	}

	public void setSubtipoPalanca(RecobroDDSubtipoPalanca subtipoPalanca) {
		this.subtipoPalanca = subtipoPalanca;
	}

	public Integer getPrioridad() {
		return prioridad;
	}

	public void setPrioridad(Integer prioridad) {
		this.prioridad = prioridad;
	}
	
	public Integer getTiempoInmunidad1() {
		return tiempoInmunidad1;
	}

	public void setTiempoInmunidad1(Integer tiempoInmunidad1) {
		this.tiempoInmunidad1 = tiempoInmunidad1;
	}

	public Integer getTiempoInmunidad2() {
		return tiempoInmunidad2;
	}

	public void setTiempoInmunidad2(Integer tiempoInmunidad2) {
		this.tiempoInmunidad2 = tiempoInmunidad2;
	}

	public DDSiNo getDelegada() {
		return delegada;
	}

	public void setDelegada(DDSiNo delegada) {
		this.delegada = delegada;
	}
}
