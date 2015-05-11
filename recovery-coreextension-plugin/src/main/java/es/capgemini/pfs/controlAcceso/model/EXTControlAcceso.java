package es.capgemini.pfs.controlAcceso.model;

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

import es.capgemini.pfs.api.controlAcceso.EXTControlAccesoInfo;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.users.domain.Usuario;

@Entity
@Table(name = "CAU_CONTROL_ACCESO_USUARIOS", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
public class EXTControlAcceso implements EXTControlAccesoInfo, Serializable, Auditable{

	/**
	 * 
	 */
	private static final long serialVersionUID = -3062559647280164146L;

	@Id
    @Column(name = "CAU_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ControlAccesoGenerator")
    @SequenceGenerator(name = "ControlAccesoGenerator", sequenceName = "S_CAU_CONTROL_ACCESO_USUARIOS")
	private Long id;
	
	@ManyToOne
    @JoinColumn(name = "USU_ID")
	private Usuario usuario;
	
	@Embedded
	private Auditoria auditoria;
	
	@Version
	private Integer version;
	
	@Override
	public Long getId() {
		return id;
	}
	
	public void setId(Long id){
		this.id=id;
	}

	@Override
	public Usuario getUsuario() {
		return usuario;
	}
	
	
	
	public void setUsuario(Usuario usuario){
		this.usuario=usuario;
	}

	@Override
	public Auditoria getAuditoria() {
		return auditoria;
	}

	@Override
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria=auditoria;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public Integer getVersion() {
		return version;
	}

}
