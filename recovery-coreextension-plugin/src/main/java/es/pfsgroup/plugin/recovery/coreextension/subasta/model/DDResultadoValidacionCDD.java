package es.pfsgroup.plugin.recovery.coreextension.subasta.model;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;

@Entity
@Table(name = "DD_RVC_RES_VALIDACION_CDD", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class DDResultadoValidacionCDD implements Auditable, Dictionary {
	
	public static String VALIDACION_CAMPO_SIN_INFORMAR = "REQUIRED";
	public static String VALIDACION_INFORMAR_PROPIEDAD_ASUNTO = "PRASREQ";
	public static String VALIDACION_PROPIEDAD_ASUNTO_BANKIA = "PRASBNK";
	public static String VALIDACION_PROPIEDAD_ASUNTO_SAREB = "PRASSAB";
	public static String VALIDACION_TAREA_CONTABILIZAR = "CONTTAR";
	public static String VALIDACION_PRC_SIN_OPERACION_ACTIVA = "PRCNOACT";
	public static String VALIDACION_BIEN_SIN_CONTRATO = "BIENCNT";
	public static String VALIDACION_SIN_LOTES_PRC = "LOTEPRC";
	public static String VALIDACION_SIN_BIEN_LOTES = "LOTEBIE";
	public static String VALIDACION_BIEN_VARIOS_LOTES = "BIENLOTES";

	/**
	 * 
	 */
	private static final long serialVersionUID = 8241676492195229282L;

	@Id
	@Column(name = "DD_RVC_ID")
	private Long id;

	@Column(name = "DD_RVC_CODIGO")
	private String codigo;

	@Column(name = "DD_RVC_DESCRIPCION")
	private String descripcion;

	@Column(name = "DD_RVC_DESCRIPCION_LARGA")
	private String descripcionLarga;

	@Embedded
	private Auditoria auditoria;

	@Version
	private Integer version;

	/**
	 * @return the id
	 */
	public Long getId() {
		return id;
	}

	/**
	 * @param id
	 *            the id to set
	 */
	public void setId(Long id) {
		this.id = id;
	}

	/**
	 * @return the codigo
	 */
	public String getCodigo() {
		return codigo;
	}

	/**
	 * @param codigo
	 *            the codigo to set
	 */
	public void setCodigo(String codigo) {
		this.codigo = codigo;
	}

	/**
	 * @return the descripcion
	 */
	public String getDescripcion() {
		return descripcion;
	}

	/**
	 * @param descripcion
	 *            the descripcion to set
	 */
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}

	/**
	 * @return the descripcionLarga
	 */
	public String getDescripcionLarga() {
		return descripcionLarga;
	}

	/**
	 * @param descripcionLarga
	 *            the descripcionLarga to set
	 */
	public void setDescripcionLarga(String descripcionLarga) {
		this.descripcionLarga = descripcionLarga;
	}

	/**
	 * @return the auditoria
	 */
	public Auditoria getAuditoria() {
		return auditoria;
	}

	/**
	 * @param auditoria
	 *            the auditoria to set
	 */
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	/**
	 * @return the version
	 */
	public Integer getVersion() {
		return version;
	}

	/**
	 * @param version
	 *            the version to set
	 */
	public void setVersion(Integer version) {
		this.version = version;
	}

}
