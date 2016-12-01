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
@Table(name = "CCC_CONFIG_CTAS_CONTABLES", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ConfigCuentaContable implements Serializable, Auditable {
	
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
    @Column(name = "CCC_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ConfigCuentasContablesGenerator")
    @SequenceGenerator(name = "ConfigCuentasContablesGenerator", sequenceName = "S_CCC_CONFIG_CTAS_CONTABLES")
    private Long id;
	    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_STG_ID")
    private DDSubtipoGasto subtipoGasto;    
	 
    @ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name="DD_CRA_ID")
	private DDCartera cartera;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "PRO_ID")
    private ActivoPropietario propietario;    
    
	@Column(name="CCC_CUENTA_ACTIVABLE")
    private String cuentaContableActivable;

	@Column(name="CCC_CUENTA_ANYO_CURSO")
    private String cuentaContableAnyoCurso;
    
    @Column(name = "CCC_CUENTA_ANYOS_ANTERIORES")
	private String cuentaContableAnyosAnteriores;

    
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

	public String getCuentaContableActivable() {
		return cuentaContableActivable;
	}

	public void setCuentaContableActivable(String cuentaContableActivable) {
		this.cuentaContableActivable = cuentaContableActivable;
	}

	public String getCuentaContableAnyoCurso() {
		return cuentaContableAnyoCurso;
	}

	public void setCuentaContableAnyoCurso(String cuentaContableAnyoCurso) {
		this.cuentaContableAnyoCurso = cuentaContableAnyoCurso;
	}

	public String getCuentaContableAnyosAnteriores() {
		return cuentaContableAnyosAnteriores;
	}

	public void setCuentaContableAnyosAnteriores(
			String cuentaContableAnyosAnteriores) {
		this.cuentaContableAnyosAnteriores = cuentaContableAnyosAnteriores;
	}
	
    public ActivoPropietario getPropietario() {
		return propietario;
	}

	public void setPropietario(ActivoPropietario propietario) {
		this.propietario = propietario;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
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
