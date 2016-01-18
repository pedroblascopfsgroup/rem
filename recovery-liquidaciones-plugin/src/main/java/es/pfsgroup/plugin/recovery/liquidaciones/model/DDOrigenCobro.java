package es.pfsgroup.plugin.recovery.liquidaciones.model;

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
@Table(name = "DD_OC_ORIGEN_COBRO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
public class DDOrigenCobro implements Auditable, Dictionary {
	public static final String PAGO_CONTRA_LA_MASA = "PM";
	public static final String PAGO_FIADOR_HIPOTECANTE = "PF";
	public static final String PAGO_ORGANISMOS_PUBLICOS = "PO";
	public static final String PAGO_CONVENIOS = "PC";
	public static final String PAGO_LIQUIDACION = "PL";
	public static final String EJECUCION_FIADORES = "EF";
	public static final String EJECUCION_PRENDAS ="EP";
	public static final String ADJUDICACION_SUBASTA_CONCURSAL ="ASC";
	public static final String ADJUDICACION_SUBASTA_EJECUTIVA = "ASE";
	public static final String COMPRA_GRUPO = "CG";
	public static final String COMPRA_TERCEROS = "CT";
	public static final String OTROS = "OT";
	/**
	 * 
	 */
	private static final long serialVersionUID = 3818321200247223321L;

	@Id
	@Column(name = "DD_OC_ID")
	private Long id;

	@Column(name = "DD_OC_CODIGO")
	private String codigo;

	@Column(name = "DD_OC_DESCRIPCION")
	private String descripcion;

	@Column(name = "DD_OC_DESCRIPCION_LARGA")
	private String descripcionLarga;

	@Embedded
	private Auditoria auditoria;

	@Version
	private Integer version;

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
}
