package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import es.capgemini.devon.dto.WebDto;



/**
 * Dto para la pestaña cabecera de la ficha de Activo
 * @author Benjamín Guerrero
 *
 */
public class DtoAdmisionDocumento extends WebDto {

	private static final long serialVersionUID = 0L;

	private Long idAdmisionDoc;
	private Long idActivo;
	private Long idConfiguracionDoc;
	private String numDocumento;
	private Date fechaSolicitud;
	private Date fechaEmision;
	private Date fechaCaducidad;
	private Date fechaEtiqueta;
	private Date fechaCalificacion;
	private Integer calificacion;
	private String tipoCalificacionCodigo;
	private String tipoCalificacionDescripcion;
	private Date fechaObtencion;
	private Date fechaVerificado;
	private Integer aplica;
	private String estadoDocumento;
	private String tipoLetraConsumoCodigo;
	private String tipoLetraConsumoDescripcion;
	private String dataIdDocumento;
	private String letraConsumo;
	private String consumo;
	private String letraEmisiones;
	private String emision;
	private String registro;
	
	//Mapeado a mano
	private String descripcionTipoDocumentoActivo;
	private String codigoTipoDocumentoActivo;
	

	public Long getIdAdmisionDoc() {
		return idAdmisionDoc;
	}

	public void setIdAdmisionDoc(Long idAdmisionDoc) {
		this.idAdmisionDoc = idAdmisionDoc;
	}

	public Long getIdActivo() {
		return idActivo;
	}

	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}

	public Long getIdConfiguracionDoc() {
		return idConfiguracionDoc;
	}

	public void setIdConfiguracionDoc(Long idConfiguracionDoc) {
		this.idConfiguracionDoc = idConfiguracionDoc;
	}

	public String getNumDocumento() {
		return numDocumento;
	}

	public void setNumDocumento(String numDocumento) {
		this.numDocumento = numDocumento;
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

	public Date getFechaCaducidad() {
		return fechaCaducidad;
	}

	public void setFechaCaducidad(Date fechaCaducidad) {
		this.fechaCaducidad = fechaCaducidad;
	}

	public String getDescripcionTipoDocumentoActivo() {
		return descripcionTipoDocumentoActivo;
	}

	public void setDescripcionTipoDocumentoActivo(String descripcionTipoDocumentoActivo) {
		this.descripcionTipoDocumentoActivo = descripcionTipoDocumentoActivo;
	}
	
	public Date getFechaEtiqueta() {
		return fechaEtiqueta;
	}

	public void setFechaEtiqueta(Date fechaEtiqueta) {
		this.fechaEtiqueta = fechaEtiqueta;
	}

	public Integer getCalificacion() {
		return calificacion;
	}

	public void setCalificacion(Integer calificacion) {
		this.calificacion = calificacion;
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

	public Integer getAplica() {
		return aplica;
	}

	public void setAplica(Integer aplica) {
		this.aplica = aplica;
	}

	public String getEstadoDocumento() {
		return estadoDocumento;
	}

	public void setEstadoDocumento(String estadoDocumento) {
		this.estadoDocumento = estadoDocumento;
	}

	public Date getFechaCalificacion() {
		return fechaCalificacion;
	}

	public void setFechaCalificacion(Date fechaCalificacion) {
		this.fechaCalificacion = fechaCalificacion;
	}

	public String getTipoCalificacionCodigo() {
		return tipoCalificacionCodigo;
	}

	public void setTipoCalificacionCodigo(String tipoCalificacionCodigo) {
		this.tipoCalificacionCodigo = tipoCalificacionCodigo;
	}

	public String getTipoCalificacionDescripcion() {
		return tipoCalificacionDescripcion;
	}

	public void setTipoCalificacionDescripcion(String tipoCalificacionDescripcion) {
		this.tipoCalificacionDescripcion = tipoCalificacionDescripcion;
	}

	public String getCodigoTipoDocumentoActivo() {
		return codigoTipoDocumentoActivo;
	}

	public void setCodigoTipoDocumentoActivo(String codigoTipoDocumentoActivo) {
		this.codigoTipoDocumentoActivo = codigoTipoDocumentoActivo;
	}

	public String getTipoLetraConsumoCodigo() {
		return tipoLetraConsumoCodigo;
	}

	public void setTipoLetraConsumoCodigo(String tipoLetraConsumoCodigo) {
		this.tipoLetraConsumoCodigo = tipoLetraConsumoCodigo;
	}

	public String getTipoLetraConsumoDescripcion() {
		return tipoLetraConsumoDescripcion;
	}

	public void setTipoLetraConsumoDescripcion(String tipoLetraConsumoDescripcion) {
		this.tipoLetraConsumoDescripcion = tipoLetraConsumoDescripcion;
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

	
}