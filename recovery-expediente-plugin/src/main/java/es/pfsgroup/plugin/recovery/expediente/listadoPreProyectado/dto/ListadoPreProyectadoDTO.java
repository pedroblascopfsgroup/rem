package es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.dto;

import java.util.Date;

public class ListadoPreProyectadoDTO {
	
	public static final String AGRUPADOPOREXP = "EXP";
	public static final String AGRUPADOPORCTO = "CTO";
	
	//Pestanya datos generales
	private String codEstadoGestion;
	private String codTipoPersona;
	private Long minRiesgoTotal;
	private Long maxRiesgoTotal;
	private Long minDeudaIrregular;
	private Long maxDeudaIrregular;
	private String codAgruparPor;
	private String codTramo;
	private String codPropuesta;
	
	//Pestanya Expediente
	private String codExpediente;
	private String codJerarquiaExp;
	private String codigoZona;
	private String codEstadoItinerario;
	
	//Pestanya Contrato
	private String codContrato;
	private Date fechaPrevRegularizacion;
	private Date fechaPrevRegularizacionHasta;
	private String codJerarquiaCto;
	private String codigoZonaCto;
	
	/**
	 * @return codEstadoGestion
	 */
	public String getCodEstadoGestion() {
		return codEstadoGestion;
	}
	
	/**
	 * @param codEstadoGestion
	 */
	public void setCodEstadoGestion(String codEstadoGestion) {
		this.codEstadoGestion = codEstadoGestion;
	}
	
	/**
	 * @return codTipoPersona
	 */
	public String getCodTipoPersona() {
		return codTipoPersona;
	}
	
	/**
	 * @param codTipoPersona
	 */
	public void setCodTipoPersona(String codTipoPersona) {
		this.codTipoPersona = codTipoPersona;
	}
	
	/**
	 * @return minRiesgoTotal
	 */
	public Long getMinRiesgoTotal() {
		return minRiesgoTotal;
	}
	
	/**
	 * @param minRiesgoTotal
	 */
	public void setMinRiesgoTotal(Long minRiesgoTotal) {
		this.minRiesgoTotal = minRiesgoTotal;
	}
	
	/**
	 * @return maxRiesgoTotal
	 */
	public Long getMaxRiesgoTotal() {
		return maxRiesgoTotal;
	}
	
	/**
	 * @param maxRiesgoTotal
	 */
	public void setMaxRiesgoTotal(Long maxRiesgoTotal) {
		this.maxRiesgoTotal = maxRiesgoTotal;
	}
	
	/**
	 * @return minDeudaIrregular
	 */
	public Long getMinDeudaIrregular() {
		return minDeudaIrregular;
	}
	
	/**
	 * @param minDeudaIrregular
	 */
	public void setMinDeudaIrregular(Long minDeudaIrregular) {
		this.minDeudaIrregular = minDeudaIrregular;
	}
	
	/**
	 * @return maxDeudaIrregular
	 */
	public Long getMaxDeudaIrregular() {
		return maxDeudaIrregular;
	}
	
	/**
	 * @param maxDeudaIrregular
	 */
	public void setMaxDeudaIrregular(Long maxDeudaIrregular) {
		this.maxDeudaIrregular = maxDeudaIrregular;
	}
	
	/**
	 * @return codAgruparPor
	 */
	public String getCodAgruparPor() {
		return codAgruparPor;
	}
	
	/**
	 * @param codAgruparPor
	 */
	public void setCodAgruparPor(String codAgruparPor) {
		this.codAgruparPor = codAgruparPor;
	}
	
	/**
	 * @return codTramo
	 */
	public String getCodTramo() {
		return codTramo;
	}
	
	/**
	 * @param codTramo
	 */
	public void setCodTramo(String codTramo) {
		this.codTramo = codTramo;
	}
	
	/**
	 * @return codPropuesta
	 */
	public String getCodPropuesta() {
		return codPropuesta;
	}
	
	/**
	 * @param codPropuesta
	 */
	public void setCodPropuesta(String codPropuesta) {
		this.codPropuesta = codPropuesta;
	}
	
	/**
	 * @return codExpediente
	 */
	public String getCodExpediente() {
		return codExpediente;
	}
	
	/**
	 * @param codExpediente
	 */
	public void setCodExpediente(String codExpediente) {
		this.codExpediente = codExpediente;
	}
	
	/**
	 * @return codJerarquiaExp
	 */
	public String getCodJerarquiaExp() {
		return codJerarquiaExp;
	}
	
	/**
	 * @param codJerarquiaExp
	 */
	public void setCodJerarquiaExp(String codJerarquiaExp) {
		this.codJerarquiaExp = codJerarquiaExp;
	}
	
	/**
	 * @return codigoZona
	 */
	public String getcodZonaExp() {
		return codigoZona;
	}
	
	/**
	 * @param codigoZona
	 */
	public void setcodZonaExp(String codigoZona) {
		this.codigoZona = codigoZona;
	}
	
	/**
	 * @return ddEstadoItinerarioExp
	 */
	public String getDdEstadoItinerarioExp() {
		return codEstadoItinerario;
	}
	
	/**
	 * @param ddEstadoItinerarioExp
	 */
	public void setDdEstadoItinerarioExp(String codEstadoItinerario) {
		this.codEstadoItinerario = codEstadoItinerario;
	}
	
	/**
	 * @return codContrato
	 */
	public String getCodContrato() {
		return codContrato;
	}
	
	/**
	 * @param codContrato
	 */
	public void setCodContrato(String codContrato) {
		this.codContrato = codContrato;
	}
	
	/**
	 * @return fechaPrevRegularizacion
	 */
	public Date getFechaPrevRegularizacion() {
		return fechaPrevRegularizacion;
	}
	
	/**
	 * @param fechaPrevRegularizacion
	 */
	public void setFechaPrevRegularizacion(Date fechaPrevRegularizacion) {
		this.fechaPrevRegularizacion = fechaPrevRegularizacion;
	}
	
	/**
	 * @return fechaPrevRegularizacionHasta
	 */
	public Date getFechaPrevRegularizacionHasta() {
		return fechaPrevRegularizacionHasta;
	}

	/**
	 * @param fechaPrevRegularizacionHasta
	 */
	public void setFechaPrevRegularizacionHasta(
			Date fechaPrevRegularizacionHasta) {
		this.fechaPrevRegularizacionHasta = fechaPrevRegularizacionHasta;
	}
	
	/**
	 * @return codJerarquiaCto
	 */
	public String getCodJerarquiaCto() {
		return codJerarquiaCto;
	}
	
	/**
	 * @param codJerarquiaCto
	 */
	public void setCodJerarquiaCto(String codJerarquiaCto) {
		this.codJerarquiaCto = codJerarquiaCto;
	}
	
	/**
	 * @return ddZonaCto
	 */
	public String getDdZonaCto() {
		return codigoZonaCto;
	}
	
	/**
	 * @param ddZonaCto
	 */
	public void setDdZonaCto(String codigoZonaCto) {
		this.codigoZonaCto = codigoZonaCto;
	}
	
	
}
