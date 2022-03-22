package es.pfsgroup.plugin.rem.model.dd;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;
import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import javax.persistence.*;

/**
 * Modelo que gestiona el diccionario de RolInterlocutor
 *
 * 
 * @author Jesus Jativa
 *
 */
@Entity
@Table(name = "DD_TRI_TIPO_ROL_INTERLOCUTOR", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDRolInterlocutor implements Auditable, Dictionary {
	
	private static final long serialVersionUID = 1L;

	public static final String COD_CLIENTE_FINAL = "CRM000";
	public static final String COD_SOCIO_COMERCIAL = "CRM011";


	@Id
	@Column(name = "DD_TRI_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDRolInterlocutor")
	@SequenceGenerator(name = "DDRolInterlocutor", sequenceName = "S_DD_TRI_TIPO_ROL_INTERLOCUTOR")
	private Long id;

	@Column(name = "DD_TRI_CODIGO")
	private String codigo;

	@Column(name = "DD_TRI_DESCRIPCION")
	private String descripcion;

	@Column(name = "DD_TRI_DESCRIPCION_LARGA")
	private String descripcionLarga;

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

	public String getCodigo() {
		return codigo;
	}

	public void setCodigo(String codigo) {
		this.codigo = codigo;
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