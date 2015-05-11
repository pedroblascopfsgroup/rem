package es.pfsgroup.plugin.recovery.instruccionesExterna.instruccionesTareasExterna.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;




@Entity
@Table(name = "TFI_TAREAS_FORM_ITEMS", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class INSInstruccionesTareasExterna implements Serializable, Auditable{

	/**
	 * 
	 */
	private static final long serialVersionUID = -2609285013211857615L;
	
	@Id
    @Column(name = "TFI_ID")
    private Long id;

	@Column(name = "TFI_TIPO")
    private String type;
	
    @Column(name = "TFI_LABEL")
    private String label;

    @Column(name = "TFI_NOMBRE")
    private String nombre;
    
    @Column(name = "TFI_ORDEN")
    private int order;
    
    @ManyToOne
    @JoinColumn(name = "TAP_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private TareaProcedimiento tareaProcedimiento;
    
    @Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;

	@Override
	public Auditoria getAuditoria() {
		return auditoria;
	}

	@Override
	public void setAuditoria(Auditoria auditoria) {
		this.auditoria=auditoria;
		
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getId() {
		return id;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getType() {
		return type;
	}

	public void setLabel(String label) {
		this.label = label;
	}

	public String getLabel() {
		return label;
	}

	public void setNombre(String nombre) {
		this.nombre = nombre;
	}

	public String getNombre() {
		return nombre;
	}

	public void setOrder(int order) {
		this.order = order;
	}

	public int getOrder() {
		return order;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	public Integer getVersion() {
		return version;
	}

	public void setTareaProcedimiento(TareaProcedimiento tareaProcedimiento) {
		this.tareaProcedimiento = tareaProcedimiento;
	}

	public TareaProcedimiento getTareaProcedimiento() {
		return tareaProcedimiento;
	}

    
}
