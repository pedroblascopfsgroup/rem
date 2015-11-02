package es.pfsgroup.plugin.precontencioso.documento.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;
import es.pfsgroup.recovery.ext.impl.tipoFicheroAdjunto.DDTipoFicheroAdjunto;


@Entity
@Table(name = "PCO_CDE_CONF_TFA_TIPOENTIDAD", schema = "${entity.schema}")
public class ConfigEntidadProcTipoFicheroPCO implements Auditable, Serializable {

	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name = "PCO_CDE_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "ConfigEntidadProcTipoFicheroGenerator")
	@SequenceGenerator(name = "ConfigEntidadProcTipoFicheroGenerator", sequenceName = "S_PCO_CDE_CONF_TFA_TIPOENTIDAD")
	private Long id;

	@ManyToOne
	@JoinColumn(name = "DD_PCO_DTD_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private DDUnidadGestionPCO tipoEntidad;
	
	@ManyToOne
	@JoinColumn(name = "DD_TPO_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private TipoProcedimiento tipoProcedimiento;
	
	@ManyToOne
	@JoinColumn(name = "DD_TFA_ID")
	@Where(clause = Auditoria.UNDELETED_RESTICTION)
	private DDTipoFicheroAdjunto tipoFichero;
	
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

	public DDUnidadGestionPCO getTipoEntidad() {
		return tipoEntidad;
	}

	public void setTipoEntidad(DDUnidadGestionPCO tipoEntidad) {
		this.tipoEntidad = tipoEntidad;
	}

	public TipoProcedimiento getTipoProcedimiento() {
		return tipoProcedimiento;
	}

	public void setTipoProcedimiento(TipoProcedimiento tipoProcedimiento) {
		this.tipoProcedimiento = tipoProcedimiento;
	}

	public DDTipoFicheroAdjunto getTipoFichero() {
		return tipoFichero;
	}

	public void setTipoFichero(DDTipoFicheroAdjunto tipoFichero) {
		this.tipoFichero = tipoFichero;
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
