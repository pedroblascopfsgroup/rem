package es.pfsgroup.framework.paradise.agenda.model;

import java.util.Date;
import java.util.List;

public class Notificacion {

	Long idActivo;
	List<Long> idsNotificacionCreada;
	Long destinatario;
	String titulo;
	String descripcion;
	String strFecha;
	Date fecha;
	Long idTareaAppExterna;
	String cc;
	String para;
	
	public Long getIdActivo() {
		return idActivo;
	}
	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}
	public Long getDestinatario() {
		return destinatario;
	}
	public void setDestinatario(Long destinatario) {
		this.destinatario = destinatario;
	}
	public String getTitulo() {
		return titulo;
	}
	public void setTitulo(String titulo) {
		this.titulo = titulo;
	}
	public String getDescripcion() {
		return descripcion;
	}
	public void setDescripcion(String descripcion) {
		this.descripcion = descripcion;
	}
	public String getStrFecha() {
		return strFecha;
	}
	public void setStrFecha(String strFecha) {
		this.strFecha = strFecha;
	}
	public Date getFecha() {
		return fecha;
	}
	public void setFecha(Date fecha) {
		this.fecha = fecha;
	}
	public List<Long> getIdsNotificacionCreada() {
		return idsNotificacionCreada;
	}
	public void setIdsNotificacionCreada(List<Long> idsNotificacionCreada) {
		this.idsNotificacionCreada = idsNotificacionCreada;
	}
	public Long getIdTareaAppExterna() {
		return idTareaAppExterna;
	}
	public void setIdTareaAppExterna(Long idTareaAppExterna) {
		this.idTareaAppExterna = idTareaAppExterna;
	}
	public String getCc() {
		return cc;
	}
	public void setCc(String cc) {
		this.cc = cc;
	}
	public String getPara() {
		return para;
	}
	public void setPara(String para) {
		this.para = para;
	}	
	
}
