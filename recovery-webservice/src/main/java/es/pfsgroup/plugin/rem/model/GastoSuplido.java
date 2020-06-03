package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
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


/**
 * Modelo que gestiona la informacion de gastos suplidos
 *  
 * @author Daniel Algaba
 *
 */
@Entity
@Table(name = "GSS_GASTOS_SUPLIDOS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Inheritance(strategy=InheritanceType.JOINED)
public class GastoSuplido implements Serializable, Auditable {
	
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
		
	@Id
    @Column(name = "GSS_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "GastoSuplidoGenerator")
    @SequenceGenerator(name = "GastoSuplidoGenerator", sequenceName = "S_GSS_GASTOS_SUPLIDOS")
    private Long id;
	
	@OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "GPV_ID_PADRE")
    private GastoProveedor gastoProveedorPadre;
	
	@OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "GPV_ID_SUPLIDO")
    private GastoProveedor gastoProveedorSuplido;
    
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

	public GastoProveedor getGastoProveedorPadre() {
		return gastoProveedorPadre;
	}

	public void setGastoProveedorPadre(GastoProveedor gastoProveedorPadre) {
		this.gastoProveedorPadre = gastoProveedorPadre;
	}

	public GastoProveedor getGastoProveedorSuplido() {
		return gastoProveedorSuplido;
	}

	public void setGastoProveedorSuplido(GastoProveedor gastoProveedorSuplido) {
		this.gastoProveedorSuplido = gastoProveedorSuplido;
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
