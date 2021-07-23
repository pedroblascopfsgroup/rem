package es.pfsgroup.plugin.rem.model.dd;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;
import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import javax.persistence.*;

/**
 * Modelo que gestiona el diccionario de EstadoComunicacionC4C
 *
 * 
 * @author Jesus Jativa
 *
 */
@Entity
@Table(name = "DD_ECC_ESTADO_COMUNICACION_C4C", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause=Auditoria.UNDELETED_RESTICTION)
public class DDEstadoComunicacionC4C implements Auditable, Dictionary {
	
	private static final long serialVersionUID = 1L;
	
	public static final String C4C_VALIDADO = "05";
	public static final String C4C_NO_ENVIADO = "01";

	@Id
	@Column(name = "DD_ECC_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDEstadoComunicacionC4C")
	@SequenceGenerator(name = "DDEstadoComunicacionC4C", sequenceName = "S_DD_ECC_ESTADO_COMUNICACION_C4C")
	private Long id;

	@Column(name = "DD_ECC_CODIGO")
	private String codigo;

	@Column(name = "DD_ECC_DESCRIPCION")
	private String descripcion;

	@Column(name = "DD_ECC_DESCRIPCION_LARGA")
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