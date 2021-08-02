package es.pfsgroup.plugin.rem.model;

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

import es.capgemini.pfs.auditoria.Auditable;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoDocumento;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCalificacionEnergetica;



/**
 * Modelo que gestiona la informacion de la gestión de admisión de los documentos de los activos
 * 
 * @author Anahuac de Vicente
 *
 */
@Entity
@Table(name = "ACT_ADO_ADMISION_DOCUMENTO", schema = "${entity.schema}")
@Cache(usage = CacheConcurrencyStrategy.READ_WRITE)
@Where(clause = Auditoria.UNDELETED_RESTICTION)
public class ActivoAdmisionDocumento implements Serializable, Auditable {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 8057711215697128040L;
		
	
	@Id
    @Column(name = "ADO_ID")
    @GeneratedValue(strategy = GenerationType.AUTO, generator = "ActivoAdmisionDocumentoGenerator")
    @SequenceGenerator(name = "ActivoAdmisionDocumentoGenerator", sequenceName = "S_ACT_ADO_ADMISION_DOCUMENTO")
    private Long id;
	
	@ManyToOne
    @JoinColumn(name = "ACT_ID")
    private Activo activo;    
	
	@ManyToOne
    @JoinColumn(name = "CFD_ID")
    private ActivoConfigDocumento configDocumento;   
	
	@ManyToOne
    @JoinColumn(name = "DD_EDC_ID")
    private DDEstadoDocumento estadoDocumento;  
	
	@Column(name = "ADO_APLICA")
	private Boolean aplica;

//HREOS-1618
//	@Column(name = "ADO_NUM_DOC")
//	private Integer numDocumento;

	@Column(name = "ADO_REF_DOC")
	private String numDocumento;
	
	@Column(name = "ADO_FECHA_VERIFICADO")
	private Date fechaVerificado;
	
	@Column(name = "ADO_FECHA_SOLICITUD")
	private Date fechaSolicitud;
	
	@Column(name = "ADO_FECHA_EMISION")
	private Date fechaEmision;
	
	@Column(name = "ADO_FECHA_OBTENCION")
	private Date fechaObtencion;
	
	@Column(name = "ADO_FECHA_CADUCIDAD")
	private Date fechaCaducidad;
	
	@Column(name = "ADO_FECHA_ETIQUETA")
	private Date fechaEtiqueta;
	
	@ManyToOne
    @JoinColumn(name = "DD_TCE_ID")
    private DDTipoCalificacionEnergetica tipoCalificacionEnergetica; 
	
	@Column(name = "ADO_FECHA_CALIFICACION")
	private Date fechaCalificacion;
	
	@Column(name = "DATA_ID_DOCUMENTO")
	private String dataIdDocumento;
	
	@Column(name = "LETRA_CONSUMO")
	private String letraConsumo;

	@Column(name = "CONSUMO")
	private String consumo;

	@Column(name = "EMISION")
	private String emision;

	@Column(name = "REGISTRO")
	private String registro;
	
	@Column(name = "ADO_NO_VALIDADO")
	private Boolean noValidado;
		
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

	public Activo getActivo() {
		return activo;
	}

	public void setActivo(Activo activo) {
		this.activo = activo;
	}

	public DDEstadoDocumento getEstadoDocumento() {
		return estadoDocumento;
	}

	public void setEstadoDocumento(DDEstadoDocumento estadoDocumento) {
		this.estadoDocumento = estadoDocumento;
	}

	public ActivoConfigDocumento getConfigDocumento() {
		return configDocumento;
	}

	public void setConfigDocumento(ActivoConfigDocumento configDocumento) {
		this.configDocumento = configDocumento;
	}

	public Boolean getAplica() {
		if(Checks.esNulo(aplica)){
			if(getConfigDocumento() != null){
				return getConfigDocumento().getObligatorio();		
			}else{
				return null;
			}
		}else{
			return aplica;
		}		
	}

	public void setAplica(Boolean aplica) {
		this.aplica = aplica;
	}

	public String getNumDocumento() {
		return numDocumento;
	}

	public void setNumDocumento(String numDocumento) {
		this.numDocumento = numDocumento;
	}

	public Date getFechaVerificado() {
		return fechaVerificado;
	}

	public void setFechaVerificado(Date fechaVerificado) {
		this.fechaVerificado = fechaVerificado;
	}

	public Date getFechaSolicitud() {
		return fechaSolicitud;
	}

	public void setFechaSolicitud(Date fechaSolicitud) {
		this.fechaSolicitud = fechaSolicitud;
	}

	public Date getFechaEmision() {
		return fechaEmision;
	}

	public void setFechaEmision(Date fechaEmision) {
		this.fechaEmision = fechaEmision;
	}

	public Date getFechaObtencion() {
		return fechaObtencion;
	}

	public void setFechaObtencion(Date fechaObtencion) {
		this.fechaObtencion = fechaObtencion;
	}

	public Date getFechaCaducidad() {
		return fechaCaducidad;
	}

	public void setFechaCaducidad(Date fechaCaducidad) {
		this.fechaCaducidad = fechaCaducidad;
	}

	public Date getFechaEtiqueta() {
		return fechaEtiqueta;
	}

	public void setFechaEtiqueta(Date fechaEtiqueta) {
		this.fechaEtiqueta = fechaEtiqueta;
	}

	public DDTipoCalificacionEnergetica getTipoCalificacionEnergetica() {
		return tipoCalificacionEnergetica;
	}

	public void setTipoCalificacionEnergetica(
			DDTipoCalificacionEnergetica tipoCalificacionEnergetica) {
		this.tipoCalificacionEnergetica = tipoCalificacionEnergetica;
	}

	public Date getFechaCalificacion() {
		return fechaCalificacion;
	}

	public void setFechaCalificacion(Date fechaCalificacion) {
		this.fechaCalificacion = fechaCalificacion;
	}

	public String getDataIdDocumento() {
		return dataIdDocumento;
	}

	public void setDataIdDocumento(String dataIdDocumento) {
		this.dataIdDocumento = dataIdDocumento;
	}
	
	public String getLetraConsumo() {
		return letraConsumo;
	}

	public void setLetraConsumo(String letraConsumo) {
		this.letraConsumo = letraConsumo;
	}

	public String getConsumo() {
		return consumo;
	}

	public void setConsumo(String consumo) {
		this.consumo = consumo;
	}

	public String getEmision() {
		return emision;
	}

	public void setEmision(String emision) {
		this.emision = emision;
	}

	public String getRegistro() {
		return registro;
	}

	public void setRegistro(String registro) {
		this.registro = registro;
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

	public Boolean getNoValidado() {
		return noValidado;
	}

	public void setNoValidado(Boolean noValidado) {
		this.noValidado = noValidado;
	}


	
	
}
