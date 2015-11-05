package es.pfsgroup.plugin.precontencioso.burofax.model;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.diccionarios.Dictionary;

@Entity
@Table(name = "DD_PCO_BFR_RESULTADO", schema = "${entity.schema}")
public class DDResultadoBurofaxPCO implements Dictionary, Auditable {

	private static final long serialVersionUID = 5519925945721182983L;
	
	public static final String ESTADO_PENDIENTE = "PENDIENTE";
	public static final String ESTADO_PREPARADO = "11";
	public static final String ESTADO_SOLICITADO = "12";
	public static final String ESTADO_ENVIADO = "13";
	

	@Id
	@Column(name = "DD_PCO_BFR_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDResultadoBurofaxPCOGenerator")
	@SequenceGenerator(name = "DDResultadoBurofaxPCOGenerator", sequenceName = "S_DD_PCO_BFR_RESULTADO")
	private Long id;

	@Column(name = "DD_PCO_BFR_CODIGO")
	private String codigo;

	@Column(name = "DD_PCO_BFR_DESCRIPCION")
	private String descripcion;

	@Column(name = "DD_PCO_BFR_DESCRIPCION_LARGA")
	private String descripcionLarga;
	
	@Column(name = "DD_PCO_BFR_NOTIFICADO")
	private Boolean implicaNotif;

	@Version
	private Integer version;

	@Embedded
	private Auditoria auditoria;

	/*
	 * GETTERS & SETTERS
	 */

	public Long getId() {
		return id;
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

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public Boolean getImplicaNotif() {
		return implicaNotif;
	}

	public void setImplicaNotif(Boolean implicaNotif) {
		this.implicaNotif = implicaNotif;
	}
	
}
