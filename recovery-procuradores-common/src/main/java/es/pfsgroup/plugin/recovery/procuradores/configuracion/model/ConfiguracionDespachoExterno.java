package es.pfsgroup.plugin.recovery.procuradores.configuracion.model;

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

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.pfsgroup.plugin.recovery.procuradores.categorias.model.Categorizacion;

/**
 * Clase que modela la configuración de los Despachos externos.
 * @author manuel
 *
 */
@Entity
@Table(name = "DEC_DESPACHO_EXT_CONFIG", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause= Auditoria.UNDELETED_RESTICTION)
public class ConfiguracionDespachoExterno implements Serializable, Auditable{

	private static final long serialVersionUID = -7858786980863452308L;

	@Id
	@Column(name = "DEC_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "ConfiguracionDespachoExternoGenerator")
	@SequenceGenerator(name = "ConfiguracionDespachoExternoGenerator", sequenceName = "S_DEC_DESPACHO_EXT_CONFIG")
	private Long id;
	
	@ManyToOne
	@JoinColumn(name = "DES_ID")
	private DespachoExterno despachoExterno;
	
	@ManyToOne
	@JoinColumn(name = "DEC_CTG_TAREAS")	
	private Categorizacion categorizacionTareas; 
	
	@ManyToOne
	@JoinColumn(name = "DEC_CTG_RESOLUCIONES")
	private Categorizacion categorizacionResoluciones;
	
	@Column(name = " DEC_DESPACHO_INTEGRAL")
	private Boolean despachoIntegal;
	
	@Column(name = " DEC_AVISOS")
	private Boolean avisos;
	
	@Column(name = " DEC_PAUSADOS")
	private Boolean pausados;

	@Embedded
	private Auditoria auditoria;
	
	@Version
	private Integer version;
	
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}
	
	public DespachoExterno getDespachoExterno() {
		return despachoExterno;
	}

	public void setDespachoExterno(DespachoExterno despachoExterno) {
		this.despachoExterno = despachoExterno;
	}

	public Categorizacion getCategorizacionTareas() {
		return categorizacionTareas;
	}

	public void setCategorizacionTareas(Categorizacion categorizacionTareas) {
		this.categorizacionTareas = categorizacionTareas;
	}

	public Categorizacion getCategorizacionResoluciones() {
		return categorizacionResoluciones;
	}

	public void setCategorizacionResoluciones(
			Categorizacion categorizacionResoluciones) {
		this.categorizacionResoluciones = categorizacionResoluciones;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public Boolean getDespachoIntegal() {
		return despachoIntegal;
	}

	public void setDespachoIntegal(Boolean despachoIntegal) {
		this.despachoIntegal = despachoIntegal;
	}
	
	public Boolean getAvisos() {
		return avisos;
	}

	public void setAvisos(Boolean avisos) {
		this.avisos = avisos;
	}
	
	public Boolean getPausados() {
		return pausados;
	}

	public void setPausados(Boolean pausados) {
		this.pausados = pausados;
	}
}
