package es.pfsgroup.plugin.rem.model.dd;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;

/**
 * Modelo que gestiona el diccionario de entrada de activos bankia (COENAE).
 */
@Entity
@Table(name = "DD_ENA_ENTRADA_ACTIVO_BNK", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class DDEntradaActivoBankia implements Auditable, Dictionary {

	private static final long serialVersionUID = -7630209416003763597L;

	public static final String CODIGO_ADJUDICACION = "01";
	public static final String CODIGO_DACION = "02";
	public static final String CODIGO_COMPRA_VENTA = "03";
	public static final String CODIGO_DISOLUCION_PROINDIVISO = "04";
	public static final String CODIGO_ABSORCION = "05";
	public static final String CODIGO_CESION_EN_PAGO = "06";
	public static final String CODIGO_COMPRA_VENTA_JUDICIAL = "07";
	public static final String CODIGO_OTROS = "08";
	public static final String CODIGO_INTERMEDIACION = "09";
	public static final String CODIGO_TRASPASO = "10";
	public static final String CODIGO_ACTIVOS_PROPIOS_DE_NEGOCIO = "12";
	public static final String CODIGO_INMOVILIZADO_DE_USO_PROPIO = "13";
	public static final String CODIGO_INMOVILIZADO_DESAFECTADO_A_LA_ACTIVIDAD = "14";
	public static final String CODIGO_LEASING = "16";
	public static final String CODIGO_PROMOCIONES_EXTERNAS = "21";
	public static final String CODIGO_SALE_AND_LEASE_BACK = "22";
	public static final String CODIGO_CARTERA_TERCEROS = "23";


	@Id
	@Column(name = "DD_ENA_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDEntradaActivoBankiaGenerator")
	@SequenceGenerator(name = "DDEntradaActivoBankiaGenerator", sequenceName = "S_DD_ENA_ENTRADA_ACTIVO_BNK")
	private Long id;

	@Column(name = "DD_ENA_CODIGO")
	private String codigo;

	@Column(name = "DD_ENA_DESCRIPCION")
	private String descripcion;

	@Column(name = "DD_ENA_DESCRIPCION_LARGA")
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