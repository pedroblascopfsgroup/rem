package es.pfsgroup.plugin.recovery.mejoras.asunto.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.plugin.recovery.mejoras.web.viewHandlers.RecoveryViewHandlersCache;
import es.pfsgroup.plugin.recovery.mejoras.web.viewHandlers.ViewHandlersOverrideDefaultPattern;

/**
 * Factoría de ViewHandlers para los elementos del Histórico del Asunto
 * <p>
 * Esta clase se encarga de localizar y devolver los manejadores para abrir los
 * elementos del Histórico del Asunto.
 * 
 * @author bruno
 * 
 */
@Component
public class HistoricoAsuntoAbrirDetalleFactoryImpl extends ViewHandlersOverrideDefaultPattern<HistoricoAsuntoAbrirDetalleHandler, HistoricoAsuntoAbrirDetalleCustomHandler> implements
		HistoricoAsuntoAbrirDetalleFactory {

	private static Map<String, HistoricoAsuntoAbrirDetalleHandler> viewHandlersByTipoTraza = new HashMap<String, HistoricoAsuntoAbrirDetalleHandler>();;

	private static RecoveryViewHandlersCache<HistoricoAsuntoAbrirDetalleHandler> cacheByTipoTraza = new RecoveryViewHandlersCache<HistoricoAsuntoAbrirDetalleHandler>(viewHandlersByTipoTraza);

	@Autowired(required = false)
	private List<HistoricoAsuntoAbrirDetalleHandler> genericHandlers;

	@Autowired(required = false)
	private List<HistoricoAsuntoAbrirDetalleCustomHandler> customHandlers;

	@Override
	protected List<HistoricoAsuntoAbrirDetalleHandler> getGenericHandlerCollection() {
		return genericHandlers;
	}

	@Override
	protected List<HistoricoAsuntoAbrirDetalleCustomHandler> getCustomHandlerCollection() {
		return customHandlers;
	}

	@Override
	public HistoricoAsuntoAbrirDetalleHandler getForTipoTraza(String tipoTraza) {
		return getGetHandlerWithCacheSupport(tipoTraza, cacheByTipoTraza);
	}

}
