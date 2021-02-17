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
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivoTPA;

@Entity
@Table(name = "CFM_CONFIGURACION_REAM", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ConfiguracionReam implements Serializable,Auditable{

	
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "CFM_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ConfiguracionReamGenerator")
    @SequenceGenerator(name = "ConfiguracionReamGenerator", sequenceName = "S_CFM_CONFIGURACION_REAM")
    private Long id;
	
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "DD_CRA_ID")
	private DDCartera cartera;
	
	 @ManyToOne(fetch = FetchType.LAZY)
	 @JoinColumn(name = "DD_SCR_ID")
	 private DDSubcartera subcartera;
	 
	 @ManyToOne(fetch = FetchType.LAZY)
	 @JoinColumn(name = "PRO_ID")
	 private ActivoPropietario propietario;
	 
	 @Column(name = "CFM_CARTERA_MAC")
	 private Integer carteraMac;
	 

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

	public DDCartera getCartera() {
		return cartera;
	}

	public void setCartera(DDCartera cartera) {
		this.cartera = cartera;
	}

	public DDSubcartera getSubcartera() {
		return subcartera;
	}

	public void setSubcartera(DDSubcartera subcartera) {
		this.subcartera = subcartera;
	}

	public ActivoPropietario getPropietario() {
		return propietario;
	}

	public void setPropietario(ActivoPropietario propietario) {
		this.propietario = propietario;
	}

	public Integer getCarteraMac() {
		return carteraMac;
	}

	public void setCarteraMac(Integer carteraMac) {
		this.carteraMac = carteraMac;
	}


}
