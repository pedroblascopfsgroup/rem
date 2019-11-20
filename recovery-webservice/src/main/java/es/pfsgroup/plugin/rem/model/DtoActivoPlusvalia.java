package es.pfsgroup.plugin.rem.model;

import java.util.Date;

/**
 * Dto para el tab de activo plusvalia
 * @author Mariam Lliso
 *
 */
public class DtoActivoPlusvalia extends DtoTabActivo {

	/**
	 * 
	 */
	private static final long serialVersionUID = -7429602301888781560L;

	private Long idPlusvalia;
	private Long idActivo;
	private Date dateRecepcionPlus;
	private Date datePresentacionPlus;
	private Date datePresentacionRecu;
	private Date dateRespuestaRecu;
	private String aperturaSeguimientoExp;
	private Integer importePagado;
	private Long idGasto;
	private String minusvalia;
	private Long numGastoHaya;
	private String exento;
	private String autoliquidacion;
	private String observaciones;
	
	public Long getIdPlusvalia() {
		return idPlusvalia;
	}
	public void setIdPlusvalia(Long idPlusvalia) {
		this.idPlusvalia = idPlusvalia;
	}
	public Long getIdActivo() {
		return idActivo;
	}
	public void setIdActivo(Long idActivo) {
		this.idActivo = idActivo;
	}
	public Date getDateRecepcionPlus() {
		return dateRecepcionPlus;
	}
	public void setDateRecepcionPlus(Date dateRecepcionPlus) {
		this.dateRecepcionPlus = dateRecepcionPlus;
	}
	public Date getDatePresentacionPlus() {
		return datePresentacionPlus;
	}
	public void setDatePresentacionPlus(Date datePresentacionPlus) {
		this.datePresentacionPlus = datePresentacionPlus;
	}
	public Date getDatePresentacionRecu() {
		return datePresentacionRecu;
	}
	public void setDatePresentacionRecu(Date datePresentacionRecu) {
		this.datePresentacionRecu = datePresentacionRecu;
	}
	public Date getDateRespuestaRecu() {
		return dateRespuestaRecu;
	}
	public void setDateRespuestaRecu(Date dateRespuestaRecu) {
		this.dateRespuestaRecu = dateRespuestaRecu;
	}
	public String getAperturaSeguimientoExp() {
		return aperturaSeguimientoExp;
	}
	public void setAperturaSeguimientoExp(String aperturaSeguimientoExp) {
		this.aperturaSeguimientoExp = aperturaSeguimientoExp;
	}
	public Integer getImportePagado() {
		return importePagado;
	}
	public void setImportePagado(Integer importePagado) {
		this.importePagado = importePagado;
	}
	public Long getIdGasto() {
		return idGasto;
	}
	public void setIdGasto(Long idGasto) {
		this.idGasto = idGasto;
	}
	public String getMinusvalia() {
		return minusvalia;
	}
	public void setMinusvalia(String minusvalia) {
		this.minusvalia = minusvalia;
	}
	
	public Long getNumGastoHaya() {
		return numGastoHaya;
	}
	public void setNumGastoHaya(Long numGastoHaya) {
		this.numGastoHaya = numGastoHaya;
	}
	public String getExento() {
		return exento;
	}
	public void setExento(String exento) {
		this.exento = exento;
	}
	public String getAutoliquidacion() {
		return autoliquidacion;
	}
	public void setAutoliquidacion(String autoliquidacion) {
		this.autoliquidacion = autoliquidacion;
	}
	public String getObservaciones() {
		return observaciones;
	}
	public void setObservaciones(String observaciones) {
		this.observaciones = observaciones;
	}
	
}