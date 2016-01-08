package es.pfsgroup.listadoPreProyectado.dto;

import java.math.BigDecimal;
import java.util.List;
import java.util.Set;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.pagination.PaginationParamsImpl;
import es.capgemini.pfs.acuerdo.model.DDTipoAcuerdo;
import es.capgemini.pfs.itinerario.model.DDEstadoItinerario;
import es.capgemini.pfs.users.domain.Usuario;
import es.capgemini.pfs.vencidos.model.DDTramosDiasVencidos;
import es.capgemini.pfs.zona.model.DDZona;

public class ListadoPreProyectadoDTO extends WebDto {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = -5491493462626948203L;
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
	private String tramos;
	private String propuestas;
	
	//Pestanya Expediente
	private String codExpediente;
	private String zonasExp;
	private String itinerarios;
	
	//Pestanya Contrato
	private String codContrato;
	private String fechaPrevRegularizacion;
	private String fechaPrevRegularizacionHasta;
	private String zonasCto;
	
	private Usuario usuarioLogado;
	
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
	
	public String getTramos() {
		return tramos;
	}
	
	public void setTramos(String tramos) {
		this.tramos = tramos;
	}
	
	public String getPropuestas() {
		return propuestas;
	}
	
	public void setPropuestas(String propuestas) {
		this.propuestas = propuestas;
	}
	
	public String getCodExpediente() {
		return codExpediente;
	}
	
	public void setCodExpediente(String codExpediente) {
		this.codExpediente = codExpediente;
	}
	
	public String getZonasExp() {
		return zonasExp;
	}
	
	public void setZonasExp(String zonasExp) {
		this.zonasExp = zonasExp;
	}
	
	public String getItinerarios() {
		return itinerarios;
	}
	
	public void setItinerarios(String itinerarios) {
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
	
	public String getZonasCto() {
		return zonasCto;
	}
	
	public void setZonasCto(String zonasCto) {
		this.zonasCto = zonasCto;
	}

	public Usuario getUsuarioLogado() {
		return usuarioLogado;
	}

	public void setUsuarioLogado(Usuario usuarioLogado) {
		this.usuarioLogado = usuarioLogado;
	}
	
		
	
}
