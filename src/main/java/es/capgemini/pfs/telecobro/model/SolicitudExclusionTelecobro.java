package es.capgemini.pfs.telecobro.model;

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

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.cliente.model.Cliente;

/**
 * Estados de telecobro.
 */
@Entity
@Table(name = "SET_SOL_EXCL_TELECOBRO", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class SolicitudExclusionTelecobro implements Serializable, Auditable {

	/**
	 * serial.
	 */
	private static final long serialVersionUID = -1637787816506547314L;

    @Id
    @Column(name = "SET_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ExclusionTelecobroGenerator")
    @SequenceGenerator(name = "ExclusionTelecobroGenerator", sequenceName = "S_SET_SOL_EXCL_TELECOBRO")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "CLI_ID")
    private Cliente cliente;

    @ManyToOne
    @JoinColumn(name = "DD_MET_ID")
    private DDMotivosExclusionTelecobro motivoExclusion;

    @Column(name = "SET_OBSERVACIONES")
    private String observaciones;

    @Column(name = "SET_ACEPTADA")
    private boolean aceptada;

    @Column(name = "SET_RESPUESTA")
    private String respuesta;

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
     * @return the motivoExclusion
     */
    public DDMotivosExclusionTelecobro getMotivoExclusion() {
        return motivoExclusion;
    }

    /**
     * @param motivoExclusion the motivoExclusion to set
     */
    public void setMotivoExclusion(DDMotivosExclusionTelecobro motivoExclusion) {
        this.motivoExclusion = motivoExclusion;
    }

    /**
     * @return the observaciones
     */
    public String getObservaciones() {
        return observaciones;
    }

    /**
     * @param observaciones the observaciones to set
     */
    public void setObservaciones(String observaciones) {
        this.observaciones = observaciones;
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
     * @return the aceptada
     */
    public boolean isAceptada() {
        return aceptada;
    }

    /**
     * @param aceptada the aceptada to set
     */
    public void setAceptada(boolean aceptada) {
        this.aceptada = aceptada;
    }

    /**
     * @return the respuesta
     */
    public String getRespuesta() {
        return respuesta;
    }

    /**
     * @param respuesta the respuesta to set
     */
    public void setRespuesta(String respuesta) {
        this.respuesta = respuesta;
    }

}
