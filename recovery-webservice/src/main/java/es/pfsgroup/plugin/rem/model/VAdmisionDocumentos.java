package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;


@Entity
@Table(name = "V_ADMISION_DOCUMENTOS", schema = "${entity.schema}")
public class VAdmisionDocumentos implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name = "DD_TPD_ID")  
	private String id;

	@Column(name = "ACT_ID")
	private String idActivo;

	@Column(name = "ADO_ID")
	private String idAdmisionDoc;
	
	@Column(name = "CFD_ID")
	private String idConfiguracionDoc;
	
	@Column(name = "DD_TPD_DESCRIPCION")  
	private String descripcionTipoDoc;
	
	@Column(name = "FLAG_APLICA")
	private String aplica;
		
    @Column(name = "DD_EDC_CODIGO")
    private String estadoDocumento;  
	
	@Column(name = "ADO_FECHA_SOLICITUD")
	private Date fechaSolicitud;
	
	@Column(name = "ADO_FECHA_OBTENCION")
	private Date fechaObtencion;

	@Column(name = "ADO_FECHA_VERIFICADO")
	private Date fechaVerificado;
	
	@Column(name = "DD_TGE_ID")
	private String gestor;
	
	@Column(name = "DD_TGE_CODIGO")
	private String gestorCodigo;
	
	@Column(name = "DD_STR_ID")
	private String subtipoTrabajo;
	
	@Column(name= "ADO_FECHA_CADUCIDAD")
	private Date fechaCaducidad;
	
	@Column(name="ADO_FECHA_ETIQUETA")
	private Date fechaEtiqueta;
	
	@Column(name="DD_TCE_CODIGO")
	private String tipoCalificacionCodigo;
	
	@Column(name = "DATA_ID_DOCUMENTO")
	private String dataIdDocumento;
	
	@Column(name = "LETRA_CONSUMO")
	private String letraConsumo;

	@Column(name = "CONSUMO")
	private String consumo;
	
	@Column(name = "LETRA_EMISIONES")
	private String letraEmisiones;

	@Column(name = "EMISION")
	private String emision;

	@Column(name = "REGISTRO")
	private String registro;
	
	@Column(name = "MOTIVO_EXONERACION_CEE")
	private String motivoExoneracionCee;
	
	@Column(name = "INCIDENCIA_CEE")
	private String incidenciaCee;

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getIdActivo() {
		return idActivo;
	}

	public void setIdActivo(String idActivo) {
		this.idActivo = idActivo;
	}

	public String getIdAdmisionDoc() {
		return idAdmisionDoc;
	}

	public void setIdAdmisionDoc(String idAdmisionDoc) {
		this.idAdmisionDoc = idAdmisionDoc;
	}

	public String getIdConfiguracionDoc() {
		return idConfiguracionDoc;
	}

	public void setIdConfiguracionDoc(String idConfiguracionDoc) {
		this.idConfiguracionDoc = idConfiguracionDoc;
	}

	public String getEstadoDocumento() {
		return estadoDocumento;
	}

	public void setEstadoDocumento(String estadoDocumento) {
		this.estadoDocumento = estadoDocumento;
	}

	public String getDescripcionTipoDoc() {
		return descripcionTipoDoc;
	}

	public void setDescripcionTipoDoc(String descripcionTipoDoc) {
		this.descripcionTipoDoc = descripcionTipoDoc;
	}

	public String getAplica() {
		return aplica;
	}

	public void setAplica(String aplica) {
		this.aplica = aplica;
	}

	public Date getFechaSolicitud() {
		return fechaSolicitud;
	}

	public void setFechaSolicitud(Date fechaSolicitud) {
		this.fechaSolicitud = fechaSolicitud;
	}

	public Date getFechaObtencion() {
		return fechaObtencion;
	}

	public void setFechaObtencion(Date fechaObtencion) {
		this.fechaObtencion = fechaObtencion;
	}

	public Date getFechaVerificado() {
		return fechaVerificado;
	}

	public void setFechaVerificado(Date fechaVerificado) {
		this.fechaVerificado = fechaVerificado;
	}

	public String getGestor() {
		return gestor;
	}

	public void setGestor(String gestor) {
		this.gestor = gestor;
	}
	
	public String getGestorCodigo() {
		return gestorCodigo;
	}

	public void setGestorCodigo(String gestorCodigo) {
		this.gestorCodigo = gestorCodigo;
	}

	public String getSubtipoTrabajo() {
		return subtipoTrabajo;
	}

	public void setSubtipoTrabajo(String subtipoTrabajo) {
		this.subtipoTrabajo = subtipoTrabajo;
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

	public String getTipoCalificacionCodigo() {
		return tipoCalificacionCodigo;
	}

	public void setTipoCalificacionCodigo(String tipoCalificacionCodigo) {
		this.tipoCalificacionCodigo = tipoCalificacionCodigo;
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

	public String getLetraEmisiones() {
		return letraEmisiones;
	}

	public void setLetraEmisiones(String letraEmisiones) {
		this.letraEmisiones = letraEmisiones;
	}

	public String getMotivoExoneracionCee() {
		return motivoExoneracionCee;
	}

	public void setMotivoExoneracionCee(String motivoExoneracionCee) {
		this.motivoExoneracionCee = motivoExoneracionCee;
	}

	public String getIncidenciaCee() {
		return incidenciaCee;
	}

	public void setIncidenciaCee(String incidenciaCee) {
		this.incidenciaCee = incidenciaCee;
	}
	
}