package es.capgemini.pfs.asunto.model;

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

import org.hibernate.annotations.Cache;
import org.hibernate.annotations.CacheConcurrencyStrategy;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.despachoExterno.model.GestorDespacho;

/**
 * Clase para la auditoria de cambios de supervisor / gestor de un asunto 
 * @author Lisandro Medrano
 *
 */
@Entity
@Table(name = "HCA_HISTORICO_CAMBIOS_ASUNTO", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class HistoricoCambiosAsunto implements Serializable, Auditable {

    /**
     * 
     */
    private static final long serialVersionUID = 1L;
    @Id
    @Column(name = "HCA_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "HistoricoAsuntoGenerator")
    @SequenceGenerator(name = "HistoricoAsuntoGenerator", sequenceName = "S_HCA_HISTORICO_CAMBIOS_ASUNTO")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "HCA_SUP_ORIGEN")
    private GestorDespacho supervisorOrigen;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "HCA_SUP_DESTINO")
    private GestorDespacho supervisorDestino;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ASU_ID")
    private Asunto asunto;

    /**
     * Flag para reconocer si el cambio de supervisor se hizo por vacaciones del supervisor de origen
     * Valores:
     *  true: por vacaciones
     *  false: se realizó un cambio arbitrario de supervisor
     */
    @Column(name = "HCA_TEMPORAL")
    private boolean temporal;

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

    public GestorDespacho getSupervisorOrigen() {
        return supervisorOrigen;
    }

    public void setSupervisorOrigen(GestorDespacho supervisorOrigen) {
        this.supervisorOrigen = supervisorOrigen;
    }

    public GestorDespacho getSupervisorDestino() {
        return supervisorDestino;
    }

    public void setSupervisorDestino(GestorDespacho supervisorDestino) {
        this.supervisorDestino = supervisorDestino;
    }

    public Asunto getAsunto() {
        return asunto;
    }

    public void setAsunto(Asunto asunto) {
        this.asunto = asunto;
    }

    public boolean getTemporal() {
        return temporal;
    }

    public void setTemporal(boolean temporal) {
        this.temporal = temporal;
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
