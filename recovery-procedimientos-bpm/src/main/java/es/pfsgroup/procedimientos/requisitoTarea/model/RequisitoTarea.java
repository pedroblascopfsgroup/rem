package es.pfsgroup.procedimientos.requisitoTarea.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.Table;
import javax.persistence.Version;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.procesosJudiciales.model.GenericFormItem;
import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;

@Entity
@Table(name = "RET_REQUISITO_TAREA", schema = "${entity.schema}")
public class RequisitoTarea implements Serializable, Auditable{


    /**
	 * 
	 */
	private static final long serialVersionUID = 3059810319085582210L;
	
	@Id
	@Column(name ="RET_ID")
	private Long id;
	
	
	@OneToOne
    @JoinColumn(name = "TAP_ID")
	private TareaProcedimiento tareaProcedimiento;
	
	@OneToOne
    @JoinColumn(name = "TAP_REQ")
	private TareaProcedimiento tareaProcedimientoRequerida;
	
	@OneToOne
    @JoinColumn(name = "TFI_REQ")
	private GenericFormItem campoRequerido;

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
     * @param auditoria the auditoria to set
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

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public TareaProcedimiento getTareaProcedimiento() {
		return tareaProcedimiento;
	}

	public void setTareaProcedimiento(TareaProcedimiento tareaProcedimiento) {
		this.tareaProcedimiento = tareaProcedimiento;
	}

	public TareaProcedimiento getTareaProcedimientoRequerida() {
		return tareaProcedimientoRequerida;
	}

	public void setTareaProcedimientoRequerida(
			TareaProcedimiento tareaProcedimientoRequerida) {
		this.tareaProcedimientoRequerida = tareaProcedimientoRequerida;
	}

	public GenericFormItem getCampoRequerido() {
		return campoRequerido;
	}

	public void setCampoRequerido(GenericFormItem campoRequerido) {
		this.campoRequerido = campoRequerido;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}
}
