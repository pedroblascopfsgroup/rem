package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embeddable;
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

import es.capgemini.pfs.auditoria.model.Auditoria;



/**
 * clase modelo de CPF_CONFIG_PVE_FORMALIZACION.
 *
 */
@Entity
@Table(name = "CPF_CONFIG_PVE_FORMALIZACION", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class CPFProveedor implements Serializable {
    private static final long serialVersionUID = 1L;

    @Id
    @Column(name = "CPF_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "OfertaGenerator")
    @SequenceGenerator(name = "OfertaGenerator", sequenceName = "S_CPF_CONFIG_PVE_FORMALIZACION")
    private Long id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "PVE_ID")
    private ActivoProveedor proveedor;
	
    @Column(name = "CPF_FORMALIZACION_CAJAMAR")
    private Boolean cpfFormalizacionCajamar;
    
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

	public ActivoProveedor getProveedor() {
		return proveedor;
	}

	public void setProveedor(ActivoProveedor proveedor) {
		this.proveedor = proveedor;
	}

	public Boolean getCpfFormalizacionCajamar() {
		return cpfFormalizacionCajamar;
	}

	public void setCpfFormalizacionCajamar(Boolean cpfFormalizacionCajamar) {
		this.cpfFormalizacionCajamar = cpfFormalizacionCajamar;
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
