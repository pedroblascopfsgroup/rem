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
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

@Entity
@Table(name = "MGP_MAPEO_GESTOR_DOC_PRO", schema = "${entity.schema}")
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class MapeoPropietarioGestorDocumental implements Serializable, Auditable {

	private static final long serialVersionUID = 1L;
		
	@Id
    @Column(name = "MGP_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "MapeoPropietarioGestorDocumentalGenerator")
    @SequenceGenerator(name = "MapeoPropietarioGestorDocumentalGenerator", sequenceName = "S_MGP_MAPEO_GESTOR_DOC_PRO")
    private Long id;

    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "PRO_ID")
	private ActivoPropietario propietario;
    
    @Column(name = "CLIENTE_GD")
    private String clienteGestorDocumental;

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

	public ActivoPropietario getPropietario() {
		return propietario;
	}

	public void setPropietario(ActivoPropietario propietario) {
		this.propietario = propietario;
	}

	public String getClienteGestorDocumental() {
		return clienteGestorDocumental;
	}

	public void setClienteGestorDocumental(String clienteGestorDocumental) {
		this.clienteGestorDocumental = clienteGestorDocumental;
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