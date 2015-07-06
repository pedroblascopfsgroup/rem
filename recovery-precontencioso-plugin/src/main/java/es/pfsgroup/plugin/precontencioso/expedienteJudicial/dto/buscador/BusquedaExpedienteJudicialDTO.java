package es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.buscador;

import es.capgemini.devon.dto.WebDto;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.buscador.filtro.BurofaxFiltroDTO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.buscador.filtro.DocumentoFiltroDTO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.buscador.filtro.ContratoFiltroDTO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.buscador.filtro.ExpedienteJudicialFiltroDTO;
import es.pfsgroup.plugin.precontencioso.expedienteJudicial.dto.buscador.filtro.LiquidacionFiltroDTO;

public class BusquedaExpedienteJudicialDTO extends WebDto {

	private static final long serialVersionUID = -2788426813833240396L;

	private String tipoBusqueda;
	private ExpedienteJudicialFiltroDTO filtroExpedienteJudicial;
	private ContratoFiltroDTO filtroContrato;
	private DocumentoFiltroDTO filtroDocumento;
	private LiquidacionFiltroDTO filtroLiquidacion;
	private BurofaxFiltroDTO filtroBurofax;

	public String getTipoBusqueda() {
		return tipoBusqueda;
	}
	public void setTipoBusqueda(String tipoBusqueda) {
		this.tipoBusqueda = tipoBusqueda;
	}
	public ExpedienteJudicialFiltroDTO getFiltroExpedienteJudicial() {
		return filtroExpedienteJudicial;
	}
	public void setFiltroExpedienteJudicial(ExpedienteJudicialFiltroDTO filtroExpedienteJudicial) {
		this.filtroExpedienteJudicial = filtroExpedienteJudicial;
	}
	public ContratoFiltroDTO getFiltroContrato() {
		return filtroContrato;
	}
	public void setFiltroContrato(ContratoFiltroDTO filtroContrato) {
		this.filtroContrato = filtroContrato;
	}
	public DocumentoFiltroDTO getFiltroDocumento() {
		return filtroDocumento;
	}
	public void setFiltroDocumento(DocumentoFiltroDTO filtroDocumento) {
		this.filtroDocumento = filtroDocumento;
	}
	public LiquidacionFiltroDTO getFiltroLiquidacion() {
		return filtroLiquidacion;
	}
	public void setFiltroLiquidacion(LiquidacionFiltroDTO filtroLiquidacion) {
		this.filtroLiquidacion = filtroLiquidacion;
	}
	public BurofaxFiltroDTO getFiltroBurofax() {
		return filtroBurofax;
	}
	public void setFiltroBurofax(BurofaxFiltroDTO filtroBurofax) {
		this.filtroBurofax = filtroBurofax;
	}
}
