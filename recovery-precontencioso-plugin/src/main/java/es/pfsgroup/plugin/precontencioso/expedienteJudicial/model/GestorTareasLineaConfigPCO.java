package es.pfsgroup.plugin.precontencioso.expedienteJudicial.model;

import java.io.Serializable;

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

@Entity
@Table(name = "PCO_LCT_LINEA_CONFIG_TAREA", schema = "${entity.schema}")
public class GestorTareasLineaConfigPCO  implements Auditable, Serializable {

	private static final long serialVersionUID = -5937725614873248157L;

	public static final String ACCION_CREAR = "CREAR";
	public static final String ACCION_CANCELAR = "CANCELAR";

	@Id
	@Column(name = "PCO_LCT_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "GestorTareasLineaConfigPCOGenerator")
	@SequenceGenerator(name = "GestorTareasLineaConfigPCOGenerator", sequenceName = "S_PCO_LCT_LINEA_CONFIG_TAREA")
	private Long id;
	
	@Column(name = "PCO_LCT_CODIGO_TAREA")
	private String codigoTarea;

	@Column(name = "PCO_LCT_CODIGO_ACCION")
	private String codigoAccion;

	@Column(name = "PCO_LCT_HQL")
	private String condicionHQL;

	@Version
	private Integer version;

	@Embedded
	private Auditoria auditoria;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getCodigoTarea() {
		return codigoTarea;
	}

	public void setCodigoTarea(String codigoTarea) {
		this.codigoTarea = codigoTarea;
	}

	public String getCodigoAccion() {
		return codigoAccion;
	}

	public void setCodigoAccion(String codigoAccion) {
		this.codigoAccion = codigoAccion;
	}

	public String getCondicionHQL() {
		return condicionHQL;
	}

	public void setCondicionHQL(String condicionHQL) {
		this.condicionHQL = condicionHQL;
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
