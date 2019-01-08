package es.pfsgroup.plugin.rem.rest.model;

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

import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;

/**
 * 
 * @author jarbona
 *
 */
@Entity
@Table(name = "RST_DESTINATARIOS", schema = "${entity.schema}")
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class DestinatariosRest implements Serializable, Auditable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -2607201785044647557L;

	@Id
	@Column(name = "RST_DEST_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "destinatariosRstGenerator")
	@SequenceGenerator(name = "destinatariosRstGenerator", sequenceName = "S_RST_DESTINATARIOS")
	private Long destinatarioId;

	@Column(name = "RST_DEST_CORREO")
	private String correo;

	@Column(name = "RST_DEST_NOMBRE")
	private String nombre;

	@Version   
	private Long version;
	
	@Embedded
	private Auditoria auditoria;

	public Long getDestinatarioId() {
		return destinatarioId;
	}

	public void setDestinatarioId(Long destinatarioId) {
		this.destinatarioId = destinatarioId;
	}

	public String getCorreo() {
		return correo;
	}

	public void setCorreo(String correo) {
		this.correo = correo;
	}

	public String getNombre() {
		return nombre;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
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
