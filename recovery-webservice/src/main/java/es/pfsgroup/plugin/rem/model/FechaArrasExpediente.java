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
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "FAE_VALIDACION_BC")
    private DDApruebaDeniega validacionBC;
    
    @Column(name = "FAE_FECHA_AVISO")
    private Date fechaAviso;
    
    @Column(name = "FAE_COMENTARIOS_BC")
    private String fechaComentariosBC;
    
    @Column(name = "FAE_OBSERVACIONES")
    private String fechaObservaciones;
    
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

	public DDApruebaDeniega getValidacionBC() {
		return validacionBC;
	}

	public void setValidacionBC(DDApruebaDeniega validacionBC) {
		this.validacionBC = validacionBC;
	}

	public Date getFechaAviso() {
		return fechaAviso;
	}

	public void setFechaAviso(Date fechaAviso) {
		this.fechaAviso = fechaAviso;
	}

	public String getFechaComentariosBC() {
		return fechaComentariosBC;
	}

	public void setFechaComentariosBC(String fechaComentariosBC) {
		this.fechaComentariosBC = fechaComentariosBC;
	}

	public String getFechaObservaciones() {
		return fechaObservaciones;
	}

	public void setFechaObservaciones(String fechaObservaciones) {
		this.fechaObservaciones = fechaObservaciones;
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
	
	
	
}