package es.capgemini.pfs.acuerdo.model;

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

import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.contrato.model.AdjuntoContrato;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.despachoExterno.model.DDTipoDespachoExterno;
import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;

/**
 * Clase que representa la configuración de usuarios de un Acuerdo de un Asunto.
 * @author pamuller
 *
 */
@Entity
@Table(name = "ACU_CONFIG_ACUERDO_ASUNTO", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class AcuerdoConfigAsuntoUsers implements Serializable, Auditable {

    private static final long serialVersionUID = 0L;

    @Id
    @Column(name = "ACU_DGE_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "AcuerdoConfigAsuntoUserGenerator")
    @SequenceGenerator(name = "AcuerdoConfigAsuntoUserGenerator", sequenceName = "S_ACU_CONFIG_ACUERDO_ASUNTO")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "DD_TDE_ID_PROPONENTE")
    private DDTipoDespachoExterno proponente;
    
    @ManyToOne
    @JoinColumn(name = "DD_TDE_ID_VALIDADOR")
    private DDTipoDespachoExterno validador;
    
    @ManyToOne
    @JoinColumn(name = "DD_TDE_ID_DECISOR")
    private DDTipoDespachoExterno decisor;


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

 
    /**
     * @return the version
     */
    public Integer getVersion() {
        return version;
    }
    
	
    public DDTipoDespachoExterno getProponente() {
		return proponente;
	}

	public void setProponente(DDTipoDespachoExterno proponente) {
		this.proponente = proponente;
	}

	
	public DDTipoDespachoExterno getValidador() {
		return validador;
	}

	public void setValidador(DDTipoDespachoExterno validador) {
		this.validador = validador;
	}

	
	public DDTipoDespachoExterno getDecisor() {
		return decisor;
	}

	public void setDecisor(DDTipoDespachoExterno decisor) {
		this.decisor = decisor;
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
