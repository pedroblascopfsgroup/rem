package es.pfsgroup.plugin.rem.model;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;

import org.hibernate.annotations.Check;

import es.capgemini.devon.dto.WebDto;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.rem.model.dd.DDApruebaDeniega;


/**
 * Dto que gestiona la informacion de los posicionamientos de un expediente.
 *  
 * @author Luis Caballero
 *
 */
public class DtoPosicionamiento extends WebDto implements Comparable<DtoPosicionamiento> {

	/**
	 * 
	 */
	private static final long serialVersionUID = 3574353502838449106L;
	

	private Long idPosicionamiento;
	private Date fechaAviso;
	private Long idProveedorNotario;
	private Date fechaPosicionamiento;
	private String motivoAplazamiento;
	private Date horaAviso;
	private Date horaPosicionamiento;
	private Date fechaHoraPosicionamiento;
	private Date fechaHoraAviso;
	private Date fechaAlta;
	private Date fechaFinPosicionamiento;
	private String lugarFirma;
	private Date fechaHoraFirma;
	
	private Date fechaEnvioPos;
	private String validacionBCPosi;
	private Date fechaValidacionBCPos;
	private String observacionesBcPos;
	private String observacionesRem;
	private String validacionBCPosiDesc;
	private String motivoAnulacionBc;
	
	
	public Long getIdPosicionamiento() {
		return idPosicionamiento;
	}
	public void setIdPosicionamiento(Long idPosicionamiento) {
		this.idPosicionamiento = idPosicionamiento;
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
	public Long getIdProveedorNotario() {
		return idProveedorNotario;
	}
	public void setIdProveedorNotario(Long idProveedorNotario) {
		this.idProveedorNotario = idProveedorNotario;
	}
	public Date getHoraAviso() {
		return horaAviso;
	}
	public void setHoraAviso(Date horaAviso) {
		this.horaAviso = horaAviso;
	}
	public Date getHoraPosicionamiento() {
		return horaPosicionamiento;
	}
	public void setHoraPosicionamiento(Date horaPosicionamiento) {
		this.horaPosicionamiento = horaPosicionamiento;
	}
	public Date getFechaHoraPosicionamiento() {
		return fechaHoraPosicionamiento;
	}
	public void setFechaHoraPosicionamiento(Date fechaHoraPosicionamiento) {
		this.fechaHoraPosicionamiento = fechaHoraPosicionamiento;
	}
	public Date getFechaHoraAviso() {
		return fechaHoraAviso;
	}
	public void setFechaHoraAviso(Date fechaHoraAviso) {
		this.fechaHoraAviso = fechaHoraAviso;
	}
	public Date getFechaAlta() {
		return fechaAlta;
	}
	public void setFechaAlta(Date fechaAlta) {
		this.fechaAlta = fechaAlta;
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
	public Date getFechaHoraFirma() {
		return fechaHoraFirma;
	}
	public void setFechaHoraFirma(Date fechaHoraFirma) {
		this.fechaHoraFirma = fechaHoraFirma;
	}

	@Override
	public int compareTo(DtoPosicionamiento o) {
		
		if(!Checks.esNulo(this.getFechaFinPosicionamiento()) || !Checks.esNulo(o.getFechaFinPosicionamiento())){
			if(Checks.esNulo(this.getFechaFinPosicionamiento())){
				return -1;
			}
			else if(Checks.esNulo(o.getFechaFinPosicionamiento())){
				return 1;
			}
			return o.getFechaFinPosicionamiento().compareTo(this.getFechaFinPosicionamiento());
		}
		else{
			return o.getFechaAlta().compareTo(this.getFechaAlta());
		}
	}
	public Date getFechaEnvioPos() {
		return fechaEnvioPos;
	}
	public void setFechaEnvioPos(Date fechaEnvioPos) {
		this.fechaEnvioPos = fechaEnvioPos;
	}
	public String getValidacionBCPosi() {
		return validacionBCPosi;
	}
	public void setValidacionBCPosi(String validacionBCPosi) {
		this.validacionBCPosi = validacionBCPosi;
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
	public void setObservacionesBcPos(String observacionesBcPo) {
		this.observacionesBcPos = observacionesBcPo;
	}
	public String getObservacionesRem() {
		return observacionesRem;
	}
	public void setObservacionesRem(String observacionesRem) {
		this.observacionesRem = observacionesRem;
	}
	public String getValidacionBCPosiDesc() {
		return validacionBCPosiDesc;
	}
	public void setValidacionBCPosiDesc(String validacionBCPosiDesc) {
		this.validacionBCPosiDesc = validacionBCPosiDesc;
	}
	public String getMotivoAnulacionBc() {
		return motivoAnulacionBc;
	}
	public void setMotivoAnulacionBc(String motivoAnulacionBc) {
		this.motivoAnulacionBc = motivoAnulacionBc;
	}
	
	
   	
}
