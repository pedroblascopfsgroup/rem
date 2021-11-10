package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

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

import org.hibernate.annotations.Where;

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.plugin.rem.model.dd.DDApruebaDeniega;
import es.pfsgroup.plugin.rem.model.dd.DDMotivosEstadoBC;

/**
 * Modelo que gestiona los activos.
 */
@Entity
@Table(name = "FAE_FECHA_ARRAS_EXPEDIENTE", schema = "${entity.schema}")
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class FechaArrasExpediente implements Serializable, Auditable {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
    @Column(name = "FAE_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "FechaArrasExpedienteGenerator")
    @SequenceGenerator(name = "FechaArrasExpedienteGenerator", sequenceName = "S_FAE_FECHA_ARRAS_EXPEDIENTE")
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ECO_ID")
    private ExpedienteComercial expedienteComercial;
    
    @Column(name = "FAE_FECHA_ENVIO")
    private Date fechaEnvio;
    
    @Column(name = "FAE_FECHA_PROPUESTA")
    private Date fechaPropuesta;
    
    @Column(name = "FAE_FECHA_RESPUESTA_BC")
    private Date fechaRespuestaBC;
    
    
    @Column(name = "FAE_FECHA_AVISO")
    private Date fechaAviso;
    
    @Column(name = "FAE_COMENTARIOS_BC")
    private String comentariosBC;
    
    @Column(name = "FAE_OBSERVACIONES")
    private String observaciones;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_MEB_ID")
    private DDMotivosEstadoBC validacionBC;
    
    @Column(name = "FAE_MOTIVO_ANULACION")
    private String motivoAnulacion;
    
    @Version   
	private Long version;

	@Embedded
	private Auditoria auditoria;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public ExpedienteComercial getExpedienteComercial() {
		return expedienteComercial;
	}

	public void setExpedienteComercial(ExpedienteComercial expedienteComercial) {
		this.expedienteComercial = expedienteComercial;
	}

	public Date getFechaEnvio() {
		return fechaEnvio;
	}

	public void setFechaEnvio(Date fechaEnvio) {
		this.fechaEnvio = fechaEnvio;
	}

	public Date getFechaPropuesta() {
		return fechaPropuesta;
	}

	public void setFechaPropuesta(Date fechaPropuesta) {
		this.fechaPropuesta = fechaPropuesta;
	}

	public Date getFechaRespuestaBC() {
		return fechaRespuestaBC;
	}

	public void setFechaRespuestaBC(Date fechaRespuestaBC) {
		this.fechaRespuestaBC = fechaRespuestaBC;
	}



	public Date getFechaAviso() {
		return fechaAviso;
	}

	public void setFechaAviso(Date fechaAviso) {
		this.fechaAviso = fechaAviso;
	}

	public String getComentariosBC() {
		return comentariosBC;
	}

	public void setComentariosBC(String comentariosBC) {
		this.comentariosBC = comentariosBC;
	}

	public String getObservaciones() {
		return observaciones;
	}

	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}

	public Long getVersion() {
		return version;
	}

	public void setVersion(Long version) {
		this.version = version;
	}

	public Auditoria getAuditoria() {
		return auditoria;
	}

	public void setAuditoria(Auditoria auditoria) {
		this.auditoria = auditoria;
	}

	public DDMotivosEstadoBC getValidacionBC() {
		return validacionBC;
	}

	public void setValidacionBC(DDMotivosEstadoBC validacionBC) {
		this.validacionBC = validacionBC;
	}

	public String getMotivoAnulacion() {
		return motivoAnulacion;
	}

	public void setMotivoAnulacion(String motivoAnulacion) {
		this.motivoAnulacion = motivoAnulacion;
	}
	
	
	
}