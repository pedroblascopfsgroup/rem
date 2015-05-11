package es.capgemini.pfs.itinerario.model;

import java.io.Serializable;
import java.util.Date;

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

import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.cliente.model.Cliente;
import es.capgemini.pfs.expediente.model.Expediente;
import es.capgemini.pfs.tareaNotificacion.model.DDTipoEntidad;

/**
 * modelo de la tabla EPR_ESTADOS_PROCESOS.
 * @author JPB
 */
@Entity
@Table(name = "EPR_ESTADOS_PROCESOS", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class EstadoProceso implements Serializable, Auditable {

    private static final long serialVersionUID = 1L;

    @Id
    @Column(name = "EPR_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "EstadoProcesoGenerator")
    @SequenceGenerator(name = "EstadoProcesoGenerator", sequenceName = "S_EPR_ESTADOS_PROCESOS")
    private Long id;

    @ManyToOne
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    @JoinColumn(name = "DD_EIN_ID")
    private DDTipoEntidad tipoEntidad;

    @Column(name = "EPR_PROCESS_BPM")
    private Long procesoBPM;

    @ManyToOne
    @JoinColumn(name = "DD_EST_ID")
    private DDEstadoItinerario estadoItinerario;

    @Column(name = "EPR_FECHA_EST_ID")
    private Date fechaCambioEstado;

    @ManyToOne
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    @JoinColumn(name = "EXP_ID")
    private Expediente expediente;

    @ManyToOne
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    @JoinColumn(name = "CLI_ID")
    private Cliente cliente;

    @ManyToOne
    @Where(clause = Auditoria.UNDELETED_RESTICTION)
    @JoinColumn(name = "ASU_ID")
    private Asunto asunto;

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
     * @param id the id to set
     */
    public void setId(Long id) {
        this.id = id;
    }

    /**
     * @return the tipoEntidad
     */
    public DDTipoEntidad getTipoEntidad() {
        return tipoEntidad;
    }

    /**
     * @param tipoEntidad the tipoEntidad to set
     */
    public void setTipoEntidad(DDTipoEntidad tipoEntidad) {
        this.tipoEntidad = tipoEntidad;
    }

    /**
     * @return the estadoItinerario
     */
    public DDEstadoItinerario getEstadoItinerario() {
        return estadoItinerario;
    }

    /**
     * @param estadoItinerario the estadoItinerario to set
     */
    public void setEstadoItinerario(DDEstadoItinerario estadoItinerario) {
        this.estadoItinerario = estadoItinerario;
    }

    /**
     * @return the fechaCambioEstado
     */
    public Date getFechaCambioEstado() {
        return fechaCambioEstado;
    }

    /**
     * @param fechaCambioEstado the fechaCambioEstado to set
     */
    public void setFechaCambioEstado(Date fechaCambioEstado) {
        this.fechaCambioEstado = fechaCambioEstado;
    }

    /**
     * @return the expediente
     */
    public Expediente getExpediente() {
        return expediente;
    }

    /**
     * @param expediente the expediente to set
     */
    public void setExpediente(Expediente expediente) {
        this.expediente = expediente;
    }

    /**
     * @return the cliente
     */
    public Cliente getCliente() {
        return cliente;
    }

    /**
     * @param cliente the cliente to set
     */
    public void setCliente(Cliente cliente) {
        this.cliente = cliente;
    }

    /**
     * @return the asunto
     */
    public Asunto getAsunto() {
        return asunto;
    }

    /**
     * @param asunto the asunto to set
     */
    public void setAsunto(Asunto asunto) {
        this.asunto = asunto;
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
     * @return the procesoBPM
     */
    public Long getProcesoBPM() {
        return procesoBPM;
    }

    /**
     * @param procesoBPM the procesoBPM to set
     */
    public void setProcesoBPM(Long procesoBPM) {
        this.procesoBPM = procesoBPM;
    }

}
