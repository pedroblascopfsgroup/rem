package es.pfsgroup.recovery.ext.impl.acuerdo.model;

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

import es.capgemini.pfs.acuerdo.model.DDResultadoAcuerdoActuacion;
import es.capgemini.pfs.acuerdo.model.DDTipoActuacionAcuerdo;
import es.capgemini.pfs.acuerdo.model.DDTipoAyudaAcuerdo;
import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.expediente.model.Expediente;

/**
 * Clase que representa a un ActuacionesRealizadasAcuerdo.
 * @author pamuller
 *
 */
@Entity
@Table(name = "ARE_ACT_REALIZADAS_EXP", schema = "${entity.schema}")
@Cache(usage=CacheConcurrencyStrategy.READ_WRITE)
public class EXTActuacionesRealizadasExpediente implements Serializable, Auditable {

    private static final long serialVersionUID = 0L;

    @Id
    @Column(name = "ARE_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "EXTActuacionesRealizadasExpedienteGenerator")
    @SequenceGenerator(name = "EXTActuacionesRealizadasExpedienteGenerator", sequenceName = "S_ARE_ACT_REALIZADAS_EXP")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "EXP_ID")
    private Expediente expediente;

    @ManyToOne
    @JoinColumn(name = "DD_ATA_ID")
    private DDTipoActuacionAcuerdo ddTipoActuacionAcuerdo;

    @ManyToOne
    @JoinColumn(name = "DD_RAA_ID")
    private DDResultadoAcuerdoActuacion ddResultadoAcuerdoActuacion;

    @ManyToOne
    @JoinColumn(name = "DD_TAY_ID")
    private DDTipoAyudaAcuerdo tipoAyudaActuacion;

    @Column(name = "ARE_FECHA_ACTUACION")
    private Date fechaActuacion;

    @Column(name = "ARE_OBSERVACIONES")
    private String observaciones;

    @Version
    private Integer version;

    @Embedded
    private Auditoria auditoria;

	@Column(name = "SYS_GUID")
	private String guid;
    
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

    public Expediente getExpediente() {
		return expediente;
	}
    
    public void setExpediente(Expediente expediente) {
		this.expediente = expediente;
	}

    /**
     * @return the ddTipoActuacionAcuerdo
     */
    public DDTipoActuacionAcuerdo getDdTipoActuacionAcuerdo() {
        return ddTipoActuacionAcuerdo;
    }

    /**
     * @param ddTipoActuacionAcuerdo the ddTipoActuacionAcuerdo to set
     */
    public void setDdTipoActuacionAcuerdo(DDTipoActuacionAcuerdo ddTipoActuacionAcuerdo) {
        this.ddTipoActuacionAcuerdo = ddTipoActuacionAcuerdo;
    }

    /**
     * @return the ddResultadoAcuerdoActuacion
     */
    public DDResultadoAcuerdoActuacion getDdResultadoAcuerdoActuacion() {
        return ddResultadoAcuerdoActuacion;
    }

    /**
     * @param ddResultadoAcuerdoActuacion the ddResultadoAcuerdoActuacion to set
     */
    public void setDdResultadoAcuerdoActuacion(DDResultadoAcuerdoActuacion ddResultadoAcuerdoActuacion) {
        this.ddResultadoAcuerdoActuacion = ddResultadoAcuerdoActuacion;
    }

    /**
     * @return the tipoAyudaActuacion
     */
    public DDTipoAyudaAcuerdo getTipoAyudaActuacion() {
        return tipoAyudaActuacion;
    }

    /**
     * @param tipoAyudaActuacion the tipoAyudaActuacion to set
     */
    public void setTipoAyudaActuacion(DDTipoAyudaAcuerdo tipoAyudaActuacion) {
        this.tipoAyudaActuacion = tipoAyudaActuacion;
    }

    /**
     * @return the fechaActuacion
     */
    public Date getFechaActuacion() {
        return fechaActuacion;
    }

    /**
     * @param fechaActuacion the fechaActuacion to set
     */
    public void setFechaActuacion(Date fechaActuacion) {
        this.fechaActuacion = fechaActuacion;
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
    
	public String getGuid() {
		return guid;
	}

	public void setGuid(String guid) {
		this.guid = guid;
	}
	
    
}
