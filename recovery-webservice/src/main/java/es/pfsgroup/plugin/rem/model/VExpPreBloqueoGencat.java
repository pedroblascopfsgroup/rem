package es.pfsgroup.plugin.rem.model;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * 
 *  
 * @author Ivan Rubio
 *
 */
@Entity
@Table(name = "V_EXP_PREBLOQUEO_GENCAT", schema = "${entity.schema}")
public class VExpPreBloqueoGencat implements Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Id
	@Column(name = "ACT_ID")
	private Long idActivo;

	@Column(name = "CMG_ID")
	private Long idCmg;
	
	@Column(name = "CMG_FECHA_COMUNICACION")
	private Date fecha_comunicacion;
	
	@Column(name = "CMG_FECHA_SANCION")
	private Date fecha_sancion;
	
	@Column(name = "DD_SAN_CODIGO")
	private String codigoSancion;
	
	@Column(name = "OFR_ID")
	private Long idOferta;
	
	@Column(name = "OFG_IMPORTE")
	private Double importeOferta;
	
	@Column(name = "DD_TPE_CODIGO")
	private String tipoPersona;
	
	@Column(name = "DD_SIP_CODIGO")
	private String codigoSituacionPosesoria;
	
	@Column(name = "CMG_FECHA_ANULACION")
	private Date fecha_anulacion;
	
	@Column(name = "CMG_CHECK_ANULACION")
	private Boolean check_anulacion;

	public Long getIdActivo() {
		return idActivo;
	}

	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}

	public Long getIdCmg() {
		return idCmg;
	}

	public void setIdCmg(Long idCmg) {
		this.idCmg = idCmg;
	}

	public Date getFecha_comunicacion() {
		return fecha_comunicacion;
	}

	public void setFecha_comunicacion(Date fecha_comunicacion) {
		this.fecha_comunicacion = fecha_comunicacion;
	}

	public Date getFecha_sancion() {
		return fecha_sancion;
	}

	public void setFecha_sancion(Date fecha_sancion) {
		this.fecha_sancion = fecha_sancion;
	}

	public String getCodigoSancion() {
		return codigoSancion;
	}

	public void setCodigoSancion(String codigoSancion) {
		this.codigoSancion = codigoSancion;
	}

	public Long getIdOferta() {
		return idOferta;
	}

	public void setIdOferta(Long idOferta) {
		this.idOferta = idOferta;
	}

	public Double getImporteOferta() {
		return importeOferta;
	}

	public void setImporteOferta(Double importeOferta) {
		this.importeOferta = importeOferta;
	}

	public String getTipoPersona() {
		return tipoPersona;
	}

	public void setTipoPersona(String tipoPersona) {
		this.tipoPersona = tipoPersona;
	}

	public String getSituacionPosesoria() {
		return codigoSituacionPosesoria;
	}

	public void setSituacionPosesoria(String situacionPosesoria) {
		this.codigoSituacionPosesoria = situacionPosesoria;
	}

	public Date getFecha_anulacion() {
		return fecha_anulacion;
	}

	public void setFecha_anulacion(Date fecha_anulacion) {
		this.fecha_anulacion = fecha_anulacion;
	}

	public Boolean getCheck_anulacion() {
		return check_anulacion;
	}

	public void setCheck_anulacion(Boolean check_anulacion) {
		this.check_anulacion = check_anulacion;
	}
	
	

}
