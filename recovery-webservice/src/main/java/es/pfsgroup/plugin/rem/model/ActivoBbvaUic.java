package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

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
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;

/**
 * Modelo que gestiona los activos de BBVA
 * 
 * @author Javier Esbrí
 */
@Entity
@Table(name = "ACT_BBVA_UIC", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoBbvaUic implements Serializable, Auditable {


	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "UIC_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoBbvaUicGenerator")
    @SequenceGenerator(name = "ActivoBbvaUicGenerator", sequenceName = "S_ACT_BBVA_UIC")
    private Long id;

	@OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ACT_ID")
    private Activo activo;

	@Column(name = "BBVA_UIC")
  	private String uicBbva;
	
    @ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "BBVA_ACTIVO_EPA")
  	private DDSinSiNo activoEpa;
	
	@Column(name = "BBVA_CEXPER")
  	private String cexperBbva;
    
	@Column(name = "BBVA_CONTRAPARTIDA")
  	private String contrapartida;
	
	@Column(name = "BBVA_FOLIO")
  	private String folio;
	
	@Column(name = "BBVA_CDPEN")
  	private String cdpen;
	
	@Column(name = "BBVA_OFICINA")
  	private String oficina;
    
	@Column(name = "BBVA_EMPRESA")
  	private String empresa;
    
	@Version   
	private Long version;
	
	@Embedded
	private Auditoria auditoria;	
	
	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
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

	public String getUicBbva() {
		return uicBbva;
	}

	public void setUicBbva(String uicBbva) {
		this.uicBbva = uicBbva;
	}

	public DDSinSiNo getActivoEpa() {
		return activoEpa;
	}

	public void setActivoEpa(DDSinSiNo activoEpa) {
		this.activoEpa = activoEpa;
	}

	public String getCexperBbva() {
		return cexperBbva;
	}

	public void setCexperBbva(String cexperBbva) {
		this.cexperBbva = cexperBbva;
	}

	public String getContrapartida() {
		return contrapartida;
	}

	public void setContrapartida(String contrapartida) {
		this.contrapartida = contrapartida;
	}

	public String getFolio() {
		return folio;
	}

	public void setFolio(String folio) {
		this.folio = folio;
	}

	public String getCdpen() {
		return cdpen;
	}

	public void setCdpen(String cdpen) {
		this.cdpen = cdpen;
	}

	public String getOficina() {
		return oficina;
	}

	public void setOficina(String oficina) {
		this.oficina = oficina;
	}

	public String getEmpresa() {
		return empresa;
	}

	public void setEmpresa(String empresa) {
		this.empresa = empresa;
	}

	public Long getVersion() {
		return version;
	}

	public void setVersion(Long version) {
		this.version = version;
	}
	
}
