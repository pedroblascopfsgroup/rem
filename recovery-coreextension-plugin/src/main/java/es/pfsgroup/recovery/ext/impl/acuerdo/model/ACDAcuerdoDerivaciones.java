package es.pfsgroup.recovery.ext.impl.acuerdo.model;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Transient;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.acuerdo.model.DDTipoAcuerdo;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.contrato.model.AdjuntoContrato;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.despachoExterno.model.DDTipoDespachoExterno;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;

/**
 * Clase que representa la configuración de las derivaciones del Acuerdo de un Asunto.
 * @author Carlos Gil
 *
 */
@Entity
@Table(name = "ACU_CDE_DERIVACIONES", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class ACDAcuerdoDerivaciones implements Serializable, Auditable {

    private static final long serialVersionUID = 0L;

    @Id
    @Column(name = "ACU_CDE_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ACDAcuerdoDerivacionesGenerator")
    @SequenceGenerator(name = "ACDAcuerdoDerivacionesGenerator", sequenceName = "S_ACU_CDE_DERIVACIONES")
    private Long id;
    
	@ManyToOne
	@JoinColumn(name = "DD_TPA_ID")
	private DDTipoAcuerdo tipoAcuerdo;
    
    @ManyToOne
    @JoinColumn(name = "DD_TPO_ID")
    private TipoProcedimiento tipoProcedimiento;
    
    @Column(name = "ACU_CDE_RESTRICTIVO")
    private Boolean restrictivo;
    
    @Column(name = "ACU_CDE_RESTRICTIVO_TEXTO")
    private String restrictivoTexto;

    @Version
    private Integer version;

    @Embedded
    private Auditoria auditoria;
    

    /**
     * @return the id
     */
    public Long getId() {
        return id;
    }

    /**
     * @param id the id to set
     */
    public void setId(Long id) {
        this.id = id;
    }
    
    
    public DDTipoAcuerdo getTipoAcuerdo() {
		return tipoAcuerdo;
	}

	public void setTipoAcuerdo(DDTipoAcuerdo tipoAcuerdo) {
		this.tipoAcuerdo = tipoAcuerdo;
	}
	

	public TipoProcedimiento getTipoProcedimiento() {
		return tipoProcedimiento;
	}

	public void setTipoProcedimiento(TipoProcedimiento tipoProcedimiento) {
		this.tipoProcedimiento = tipoProcedimiento;
	}
	

	public Boolean getRestrictivo() {
		return restrictivo;
	}

	public void setRestrictivo(Boolean restrictivo) {
		this.restrictivo = restrictivo;
	}
	

	public String getRestrictivoTexto() {
		return restrictivoTexto;
	}

	public void setRestrictivoTexto(String restrictivoTexto) {
		this.restrictivoTexto = restrictivoTexto;
	}

 
    /**
     * @return the version
     */
    public Integer getVersion() {
        return version;
    }

    /**
     * @param version the version to set
     */
    public void setVersion(Integer version) {
        this.version = version;
    }

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


    
}
