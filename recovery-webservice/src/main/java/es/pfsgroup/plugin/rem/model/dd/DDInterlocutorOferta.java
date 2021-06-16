package es.pfsgroup.plugin.rem.model.dd;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;
import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import javax.persistence.*;

/**
 * Modelo que gestiona el diccionario de InterlocutorOferta
 *
 * 
 * @author Jesus Jativa
 *
 */
@Entity
@Table(name = "DD_FIO_FUN_INTERLOCUTOR_OFERTA", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDInterlocutorOferta implements Auditable, Dictionary {
	
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "DD_FIO_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDInterlocutorOferta")
	@SequenceGenerator(name = "DDInterlocutorOferta", sequenceName = "S_DD_FIO_FUN_INTERLOCUTOR_OFERTA")
	private Long id;

	@Column(name = "DD_FIO_CODIGO")
	private String codigo;

	@Column(name = "DD_FIO_CODIGO_C4C")
	private String codigoC4C;

	@Column(name = "DD_FIO_DESCRIPCION")
	private String descripcion;

	@Column(name = "DD_FIO_DESCRIPCION_LARGA")
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

	public String getCodigoC4C() {
		return codigoC4C;
	}

	public void setCodigoC4C(String codigoC4C) {
		this.codigoC4C = codigoC4C;
	}

}