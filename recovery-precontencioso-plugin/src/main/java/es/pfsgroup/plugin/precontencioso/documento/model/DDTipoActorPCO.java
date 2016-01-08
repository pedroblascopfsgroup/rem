package es.pfsgroup.plugin.precontencioso.documento.model;

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
@Table(name = "DD_PCO_DOC_SOLICIT_TIPOACTOR", schema = "${entity.schema}")
public class DDTipoActorPCO implements Dictionary, Auditable {

	public static final String GESTORIA = "GESTORIA_PREDOC";
	public static final String NOTARIA = "NOTARI";
	
	private static final long serialVersionUID = 3136933085857841623L;

	@Id
	@Column(name = "DD_PCO_DSA_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "DDTipoActorPCOGenerator")
	@SequenceGenerator(name = "DDTipoActorPCOGenerator", sequenceName = "S_DD_PCO_DOC_SOLICIT_ACTOR")
	private Long id;

	@Column(name = "DD_PCO_DSA_CODIGO")
	private String codigo;

	@Column(name = "DD_PCO_DSA_DESCRIPCION")
	private String descripcion;

	@Column(name = "DD_PCO_DSA_DESCRIPCION_LARGA")
	private String descripcionLarga;
	
	@Column(name = "DD_PCO_DSA_TRAT_EXP")
	private Boolean tratamientoExpediente;	
	
	@Column(name = "DD_PCO_DSA_ACCESO_RECOVERY")
	private Boolean accesoRecovery;	

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

	public Boolean getTratamientoExpediente() {
		return tratamientoExpediente;
	}

	public void setTratamientoExpediente(Boolean tratamientoExpediente) {
		this.tratamientoExpediente = tratamientoExpediente;
	}

	public Boolean getAccesoRecovery() {
		return accesoRecovery;
	}

	public void setAccesoRecovery(Boolean accesoRecovery) {
		this.accesoRecovery = accesoRecovery;
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
}
