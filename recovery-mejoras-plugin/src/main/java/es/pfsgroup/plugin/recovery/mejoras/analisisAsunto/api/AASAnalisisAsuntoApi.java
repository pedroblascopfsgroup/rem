package es.pfsgroup.plugin.recovery.mejoras.analisisAsunto.api;

import es.pfsgroup.commons.utils.api.BusinessOperationDefinition;
import es.pfsgroup.plugin.recovery.mejoras.analisisAsunto.dto.AASDtoAnalisisAsunto;
import es.pfsgroup.plugin.recovery.mejoras.analisisAsunto.model.AASAnalisisAsunto;

public interface AASAnalisisAsuntoApi {
	
	public static final String BO_ANALISISASUNTO_GETANALISIS = "plugin.mejoras.analisisAsunto.getAnalisis";
	public static final String BO_ANALISISASUNTO_GUARDARANALISIS = "plugin.mejoras.analisisAsunto.saveAnalisis";

	
	@BusinessOperationDefinition(BO_ANALISISASUNTO_GETANALISIS)
	public AASAnalisisAsunto getAnalisis(Long id);
	
	@BusinessOperationDefinition(BO_ANALISISASUNTO_GUARDARANALISIS)
	public void guardarAnalisis(AASDtoAnalisisAsunto dto);

}