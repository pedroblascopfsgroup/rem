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
import es.capgemini.pfs.users.domain.Usuario;

/**
 * Modelo que relaciona el el prescriptor de cajamar con su usuario.
 * 
 * @author Julian Dolz
 */
@Entity
@Table(name = "PGC_PROVE_GES_CAJAMAR", schema = "${entity.schema}")
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ProveedorGestorCajamar implements Serializable, Auditable {

	private static final long serialVersionUID = -3664785355514894637L;
	
	@Id
    @Column(name = "PGC_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ProveedorGestorCajamarGenerator")
    @SequenceGenerator(name = "ProveedorGestorCajamarGenerator", sequenceName = "S_PGC_PROVE_GES_CAJAMAR")
    private Long id;
	
	@OneToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "USU_ID")
	private Usuario usuario;

	@OneToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "PVE_ID")
	private ActivoProveedor activoProveedor;
    
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

	public Usuario getUsuario() {
		return usuario;
	}

	public void setUsuario(Usuario usuario) {
		this.usuario = usuario;
	}

	public ActivoProveedor getActivoProveedor() {
		return activoProveedor;
	}

	public void setActivoProveedor(ActivoProveedor activoProveedor) {
		this.activoProveedor = activoProveedor;
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
