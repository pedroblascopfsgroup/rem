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
 * Modelo que gestiona el diccionario de motivos de anulacion de una reserva.
 */
@Entity
@Table(name = "DD_MAR_MOTIVO_ANULACION_RES", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_ONLY)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class DDMotivoAnulacionReserva implements Auditable, Dictionary {

	private static final long serialVersionUID = 5329218176019126036L;

	public static final String CODIGO_COMPRADOR_NO_INTERESADO_OPERACION = "1";
	public static final String CODIGO_DECISION_DEL_AREA = "2";
	public static final String CODIGO_NO_DISPONE_DINERO_FINANCIACION = "3";
	public static final String CODIGO_CIRCUNSTANCIAS_DISTINTAS_A_LAS_PACTADAS = "4";
	public static final String CODIGO_NO_SE_CUMPLEN_CONDICIONANTES = "5";
	public static final String CODIGO_NO_DESEAN_ESCRITURAR = "6";
	public static final String CODIGO_DECISION_HAYA = "9";

	@Id
	@Column(name = "DD_MAR_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDMotivoAnulacionReservaGenerator")
	@SequenceGenerator(name = "DDMotivoAnulacionReservaGenerator", sequenceName = "S_DD_MAR_MOTIVO_ANULACION_RES")
	private Long id;

	@Column(name = "DD_MAR_CODIGO")
	private String codigo;

	@Column(name = "DD_MAR_DESCRIPCION")
	private String descripcion;

	@Column(name = "DD_MAR_DESCRIPCION_LARGA")
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