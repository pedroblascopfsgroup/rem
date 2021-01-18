package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
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
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoTrabajo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTrabajo;

@Entity
@Table(name = "CFG_VISUALIZAR_LLAVES", schema = "${entity.schema}")
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class CFGVisualizarLlaves implements Serializable, Auditable {

	private static final long serialVersionUID = 4477763412715784465L;

	@Id
    @Column(name = "CVL_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "VisualizarLlavesGenerator")
    @SequenceGenerator(name = "VisualizarLlavesGenerator", sequenceName = "S_CFG_VISUALIZAR_LLAVES")
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_TTR_ID")
    private DDTipoTrabajo tipoTrabajo;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_STR_ID")
    private DDSubtipoTrabajo subtipoTrabajo;

    @Column(name = "VISUALIZACION_LLAVES")
    private Integer visualizacionLlaves;

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

	public DDTipoTrabajo getTipoTrabajo() {
		return tipoTrabajo;
	}

	public void setTipoTrabajo(DDTipoTrabajo tipoTrabajo) {
		this.tipoTrabajo = tipoTrabajo;
	}

	public DDSubtipoTrabajo getSubtipoTrabajo() {
		return subtipoTrabajo;
	}

	public void setSubtipoTrabajo(DDSubtipoTrabajo subtipoTrabajo) {
		this.subtipoTrabajo = subtipoTrabajo;
	}

	public Integer getVisualizacionLlaves() {
		return visualizacionLlaves;
	}

	public void setVisualizacionLlaves(Integer visualizacionLlaves) {
		this.visualizacionLlaves = visualizacionLlaves;
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
