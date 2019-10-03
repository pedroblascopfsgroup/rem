package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

@Entity
@Table(name = "CONF_ACCESO_GESTORIA", schema = "${entity.schema}")
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ConfiguracionAccesoGestoria implements Serializable, Auditable {

	private static final long serialVersionUID = 4477763412715784465L;

	@Id
    @Column(name = "CAG_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ConfAccesoGestoriaGenerator")
    @SequenceGenerator(name = "ConfAccesoGestoriaGenerator", sequenceName = "S_CONF_ACCESO_GESTORIA")
    private Long id;
	
    @Column(name = "CAG_DESCRIPCION")
    private String descripcion;
    
    @Column(name = "CAG_DESCRIPCION_LARGA")
    private String descripcionLarga;
    
	@Column(name = "USUARIO_GES_ADMISION")
	private String gestoriaAdmision;

	@Column(name = "USUARIO_GES_ADMINISTRACION")
	private String gestoriaAdministracion;

	@Column(name = "USUARIO_GES_FORMALIZACION")
	private String gestoriaFormalizacion;

	@Version   
	private Long version;

	@Embedded
	private Auditoria auditoria;

	
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

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	public String getDescripcionLarga() {
		return descripcionLarga;
	}

	public void setDescripcionLarga(String descripcionLarga) {
		this.descripcionLarga = descripcionLarga;
	}

	public String getGestoriaAdmision() {
		return gestoriaAdmision;
	}

	public void setGestoriaAdmision(String gestoriaAdmision) {
		this.gestoriaAdmision = gestoriaAdmision;
	}

	public String getGestoriaAdministracion() {
		return gestoriaAdministracion;
	}

	public void setGestoriaAdministracion(String gestoriaAdministracion) {
		this.gestoriaAdministracion = gestoriaAdministracion;
	}

	public String getGestoriaFormalizacion() {
		return gestoriaFormalizacion;
	}

	public void setGestoriaFormalizacion(String gestoriaFormalizacion) {
		this.gestoriaFormalizacion = gestoriaFormalizacion;
	}
	
}
