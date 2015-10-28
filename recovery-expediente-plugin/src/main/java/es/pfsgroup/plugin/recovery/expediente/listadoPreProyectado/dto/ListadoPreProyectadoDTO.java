package es.pfsgroup.plugin.recovery.expediente.listadoPreProyectado.dto;

import java.math.BigDecimal;
import java.util.List;

import es.capgemini.pfs.acuerdo.model.DDTipoAcuerdo;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.capgemini.pfs.vencidos.model.DDTramosDiasVencidos;
import es.capgemini.pfs.zona.model.DDZona;

public class ListadoPreProyectadoDTO {
	
	public static final String AGRUPADOPOREXP = "EXP";
	public static final String AGRUPADOPORCTO = "CTO";
	
	//Pestanya datos generales
	private String codEstadoGestion;
	private String codTipoPersona;
	private BigDecimal minRiesgoTotal;
	private BigDecimal maxRiesgoTotal;
	private BigDecimal minDeudaIrregular;
	private BigDecimal maxDeudaIrregular;
	private String codAgruparPor;
	private List<String> tramos;
	private List<String> propuestas;
	
	//Pestanya Expediente
	private String codExpediente;
	private List<String> zonasExp;
	private List<String> itinerarios;
	
	//Pestanya Contrato
	private String codContrato;
	private String fechaPrevRegularizacion;
	private String fechaPrevRegularizacionHasta;
	private List<String> zonasCto;
	
	public String getCodEstadoGestion() {
		return codEstadoGestion;
	}
	
	public void setCodEstadoGestion(String codEstadoGestion) {
		this.codEstadoGestion = codEstadoGestion;
	}
	
	public String getCodTipoPersona() {
		return codTipoPersona;
	}
	
	public void setCodTipoPersona(String codTipoPersona) {
		this.codTipoPersona = codTipoPersona;
	}
	
	public BigDecimal getMinRiesgoTotal() {
		return minRiesgoTotal;
	}
	
	public void setMinRiesgoTotal(BigDecimal minRiesgoTotal) {
		this.minRiesgoTotal = minRiesgoTotal;
	}
	
	public BigDecimal getMaxRiesgoTotal() {
		return maxRiesgoTotal;
	}
	
	public void setMaxRiesgoTotal(BigDecimal maxRiesgoTotal) {
		this.maxRiesgoTotal = maxRiesgoTotal;
	}
	
	public BigDecimal getMinDeudaIrregular() {
		return minDeudaIrregular;
	}
	
	public void setMinDeudaIrregular(BigDecimal minDeudaIrregular) {
		this.minDeudaIrregular = minDeudaIrregular;
	}
	
	public BigDecimal getMaxDeudaIrregular() {
		return maxDeudaIrregular;
	}
	
	public void setMaxDeudaIrregular(BigDecimal maxDeudaIrregular) {
		this.maxDeudaIrregular = maxDeudaIrregular;
	}
	
	public String getCodAgruparPor() {
		return codAgruparPor;
	}
	
	public void setCodAgruparPor(String codAgruparPor) {
		this.codAgruparPor = codAgruparPor;
	}
	
	public List<String> getTramos() {
		return tramos;
	}
	
	public void setTramos(List<String> tramos) {
		this.tramos = tramos;
	}
	
	public List<String> getPropuestas() {
		return propuestas;
	}
	
	public void setPropuestas(List<String> propuestas) {
		this.propuestas = propuestas;
	}
	
	public String getCodExpediente() {
		return codExpediente;
	}
	
	public void setCodExpediente(String codExpediente) {
		this.codExpediente = codExpediente;
	}
	
	public List<String> getZonasExp() {
		return zonasExp;
	}
	
	public void setZonasExp(List<String> zonasExp) {
		this.zonasExp = zonasExp;
	}
	
	public List<String> getItinerarios() {
		return itinerarios;
	}
	
	public void setItinerarios(List<String> itinerarios) {
		this.itinerarios = itinerarios;
	}
	
	public String getCodContrato() {
		return codContrato;
	}
	
	public void setCodContrato(String codContrato) {
		this.codContrato = codContrato;
	}
	
	public String getFechaPrevRegularizacion() {
		return fechaPrevRegularizacion;
	}
	
	public void setFechaPrevRegularizacion(String fechaPrevRegularizacion) {
		this.fechaPrevRegularizacion = fechaPrevRegularizacion;
	}
	
	public String getFechaPrevRegularizacionHasta() {
		return fechaPrevRegularizacionHasta;
	}
	
	public void setFechaPrevRegularizacionHasta(String fechaPrevRegularizacionHasta) {
		this.fechaPrevRegularizacionHasta = fechaPrevRegularizacionHasta;
	}
	
	public List<String> getZonasCto() {
		return zonasCto;
	}
	
	public void setZonasCto(List<String> zonasCto) {
		this.zonasCto = zonasCto;
	}
	
		
	
}
