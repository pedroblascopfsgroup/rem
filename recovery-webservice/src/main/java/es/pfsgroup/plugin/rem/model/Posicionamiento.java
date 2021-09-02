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
import javax.persistence.Inheritance;
import javax.persistence.InheritanceType;
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
import es.pfsgroup.plugin.rem.model.dd.DDMotivoAnulacionBC;
import es.pfsgroup.plugin.rem.model.dd.DDMotivosEstadoBC;

/**
 * Modelo que gestiona la informacion de un posicionamiento de un expediente
 * comercial
 * 
 * @author Jose Villel
 *
 */
@Entity
@Table(name = "POS_POSICIONAMIENTO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
@Inheritance(strategy = InheritanceType.JOINED)
public class Posicionamiento implements Serializable, Auditable, Comparable<Posicionamiento> {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	@Id
	@Column(name = "POS_ID")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "PosicionamientoGenerator")
	@SequenceGenerator(name = "PosicionamientoGenerator", sequenceName = "S_POS_POSICIONAMIENTO")
	private Long id;

	@OneToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "ECO_ID")
	private ExpedienteComercial expediente;

	@Column(name = "POS_FECHA_AVISO")
	private Date fechaAviso;

	@Column(name = "POS_FECHA_POSICIONAMIENTO")
	private Date fechaPosicionamiento;

	@Column(name = "POS_MOTIVO_APLAZAMIENTO")
	private String motivoAplazamiento;

	@ManyToOne
	@JoinColumn(name = "PVE_ID_NOTARIO")
	private ActivoProveedor notario;
	
	@Column(name = "POS_FECHA_FIN_POSICIONAMIENTO")
	private Date fechaFinPosicionamiento;

	@Column(name = "LUGAR_FIRMA")
	private String lugarFirma;

	@Column(name = "POS_FECHA_ENVIO")
	private Date fechaEnvioPos;
		
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "POS_VALIDACION_BC")
    private DDMotivosEstadoBC validacionBCPos;
	
	@Column(name = "POS_FECHA_VALIDACION_BC")
	private Date fechaValidacionBCPos;

	@Column(name = "POS_OBSERVACIONES_BC")
	private String observacionesBcPos;
	
	@Column(name = "POS_OBSERVACIONES_REM")
	private String observacionesRem;
	
	@ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "DD_MAB_ID")
    private DDMotivoAnulacionBC motivoAnulacionBc;
	
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

	public ExpedienteComercial getExpediente() {
		return expediente;
	}

	public void setExpediente(ExpedienteComercial expediente) {
		this.expediente = expediente;
	}

	public Date getFechaAviso() {
		return fechaAviso;
	}

	public void setFechaAviso(Date fechaAviso) {
		this.fechaAviso = fechaAviso;
	}

	public Date getFechaPosicionamiento() {
		return fechaPosicionamiento;
	}

	public void setFechaPosicionamiento(Date fechaPosicionamiento) {
		this.fechaPosicionamiento = fechaPosicionamiento;
	}

	public String getMotivoAplazamiento() {
		return motivoAplazamiento;
	}

	public void setMotivoAplazamiento(String motivoAplazamiento) {
		this.motivoAplazamiento = motivoAplazamiento;
	}

	public ActivoProveedor getNotario() {
		return notario;
	}

	public void setNotario(ActivoProveedor notario) {
		this.notario = notario;
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

	@Override
	public int compareTo(Posicionamiento o) {
		int resultado = 0;
		if (this.getAuditoria() != null && this.getAuditoria().getFechaCrear() != null && o.getAuditoria() != null
				&& o.getAuditoria().getFechaCrear() != null){
			resultado = this.getAuditoria().getFechaCrear().compareTo(o.getAuditoria().getFechaCrear());			
		}
		return resultado;
		

	}

	public Date getFechaFinPosicionamiento() {
		return fechaFinPosicionamiento;
	}

	public void setFechaFinPosicionamiento(Date fechaFinPosicionamiento) {
		this.fechaFinPosicionamiento = fechaFinPosicionamiento;
	}

	public String getLugarFirma() {
		return lugarFirma;
	}

	public void setLugarFirma(String lugarFirma) {
		this.lugarFirma = lugarFirma;
	}

	public Date getFechaEnvioPos() {
		return fechaEnvioPos;
	}

	public void setFechaEnvioPos(Date fechaEnvioPos) {
		this.fechaEnvioPos = fechaEnvioPos;
	}

	public DDMotivosEstadoBC getValidacionBCPos() {
		return validacionBCPos;
	}

	public void setValidacionBCPos(DDMotivosEstadoBC validacionBCPos) {
		this.validacionBCPos = validacionBCPos;
	}

	public Date getFechaValidacionBCPos() {
		return fechaValidacionBCPos;
	}

	public void setFechaValidacionBCPos(Date fechaValidacionBCPos) {
		this.fechaValidacionBCPos = fechaValidacionBCPos;
	}

	public String getObservacionesBcPos() {
		return observacionesBcPos;
	}

	public void setObservacionesBcPos(String observacionesBcPos) {
		this.observacionesBcPos = observacionesBcPos;
	}
	
	public String getObservacionesRem() {
		return observacionesRem;
	}

	public void setObservacionesRem(String observacionesRem) {
		this.observacionesRem = observacionesRem;
	}

	public DDMotivoAnulacionBC getMotivoAnulacionBc() {
		return motivoAnulacionBc;
	}

	public void setMotivoAnulacionBc(DDMotivoAnulacionBC motivoAnulacionBc) {
		this.motivoAnulacionBc = motivoAnulacionBc;
	}
	
}
