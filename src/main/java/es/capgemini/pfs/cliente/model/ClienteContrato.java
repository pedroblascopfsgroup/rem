package es.capgemini.pfs.cliente.model;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Embedded;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Version;

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;
import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.contrato.model.Contrato;

/**
 * Entidad CCL_CONTRATOS_CLIENTE.
 *
 * @author Andrés Esteban
 *
 */
@Entity
@Table(name = "CCL_CONTRATOS_CLIENTE", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class ClienteContrato implements Serializable, Auditable {

    private static final long serialVersionUID = 1L;

    @Id
    @Column(name = "CCL_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ClienteContratoGenerator")
    @SequenceGenerator(name = "ClienteContratoGenerator", sequenceName = "S_CCL_CONTRATOS_CLIENTE")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "CNT_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private Contrato contrato;

    @OneToOne
    @JoinColumn(name = "CLI_ID")
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    private Cliente cliente;

    @Column(name = "CCL_PASE")
    private Integer pase;

    @Embedded
    private Auditoria auditoria;

    @Version
    private Integer version;

    /**
     * @return the id
     */
    public Long getId() {
        return id;
    }

    /**
     * @param id
     *            the id to set
     */
    public void setId(Long id) {
        this.id = id;
    }

    /**
     * @return the contrato
     */
    public Contrato getContrato() {
        return contrato;
    }

    /**
     * @param contrato
     *            the contrato to set
     */
    public void setContrato(Contrato contrato) {
        this.contrato = contrato;
    }

    /**
     * @return the cliente
     */
    public Cliente getCliente() {
        return cliente;
    }

    /**
     * @param cliente
     *            the cliente to set
     */
    public void setCliente(Cliente cliente) {
        this.cliente = cliente;
    }

    /**
     * @return the pase
     */
    public Integer getPase() {
        return pase;
    }

    /**
     * @param pase
     *            the pase to set
     */
    public void setPase(Integer pase) {
        this.pase = pase;
    }

    /**
     * @return the auditoria
     */
    public Auditoria getAuditoria() {
        return auditoria;
    }

    /**
     * @param auditoria
     *            the auditoria to set
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

    /**
     * @param version
     *            the version to set
     */
    public void setVersion(Integer version) {
        this.version = version;
    }
}
