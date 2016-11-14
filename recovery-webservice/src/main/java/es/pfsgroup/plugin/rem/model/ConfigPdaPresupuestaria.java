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
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoGasto;


/**
 * Modelo que gestiona la informacion de la configuración las cuentas contables y partidas presupuestarias
 *  
 * @author Jose Villel
 *
 */
@Entity
@Table(name = "CPP_CONFIG_PTDAS_PREP", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ConfigPdaPresupuestaria implements Serializable, Auditable {
	
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
    @Column(name = "CPP_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ConfiguracionCCPPGenerator")
    @SequenceGenerator(name = "ConfiguracionCCPPGenerator", sequenceName = "S_CPP_CONFIG_PTDAS_PREP")
    private Long id;
	
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "EJE_ID")
    private Ejercicio ejercicio;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_STG_ID")
    private DDSubtipoGasto subtipoGasto;    
	 
    @ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name="DD_CRA_ID")
	private DDCartera cartera;
    
    @Column(name = "CPP_PARTIDA_PRESUPUESTARIA")
	private String partidaPresupuestaria;

    
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

	public Ejercicio getEjercicio() {
		return ejercicio;
	}

	public void setEjercicio(Ejercicio ejercicio) {
		this.ejercicio = ejercicio;
	}

	public DDSubtipoGasto getSubtipoGasto() {
		return subtipoGasto;
	}

	public void setSubtipoGasto(DDSubtipoGasto subtipoGasto) {
		this.subtipoGasto = subtipoGasto;
	}

	public DDCartera getCartera() {
		return cartera;
	}

	public void setCartera(DDCartera cartera) {
		this.cartera = cartera;
	}

	public String getPartidaPresupuestaria() {
		return partidaPresupuestaria;
	}

	public void setPartidaPresupuestaria(String partidaPresupuestaria) {
		this.partidaPresupuestaria = partidaPresupuestaria;
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
