package es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.cambiogestores.dao.impl;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.pfs.despachoExterno.model.DespachoExterno;
import es.capgemini.pfs.multigestor.model.EXTDDTipoGestor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.CambiosMasivosAsuntoPluginConfig;
import es.pfsgroup.plugin.recovery.cambiosMasivosAsunto.cambiogestores.dao.CambioMasivoGestoresAsuntoGenericDaoFacade;

@Component
public class CambioMasivoGestoresAsuntoGenericDaoFacadeImpl implements CambioMasivoGestoresAsuntoGenericDaoFacade{
	
	@Autowired
	private GenericABMDao genericDao;

	@Override
	public List<EXTDDTipoGestor> getTiposGestor(CambiosMasivosAsuntoPluginConfig config) {
		Order order = new Order(OrderType.ASC, "descripcion");
		Filter filtro1 = genericDao.createFilter(FilterType.EQUALS, "borrado", false);

		List<EXTDDTipoGestor> unfiltered = genericDao.getListOrdered(EXTDDTipoGestor.class, order, filtro1);
		
		if (config.isFiltrarTiposGestor()){
			return filter(unfiltered, config.getTiposGestorValidos());
		}else{
			return unfiltered;
		}
	}
	
	
	@Override
	public List<DespachoExterno> getTodosLosDespachos() {
		Filter filtro1 = genericDao.createFilter(FilterType.EQUALS, "borrado", false);
		Order order = new Order(OrderType.ASC, "despacho");
		return genericDao.getListOrdered(DespachoExterno.class, order, filtro1);
	}

	private List<EXTDDTipoGestor> filter(List<EXTDDTipoGestor> unfiltered, List<String> tiposGestorValidos) {
		ArrayList<EXTDDTipoGestor> filtered = new ArrayList<EXTDDTipoGestor>();
		if (!Checks.estaVacio(unfiltered)){
			if (! Checks.estaVacio(tiposGestorValidos)){
				for (EXTDDTipoGestor tge : unfiltered){
					if (tiposGestorValidos.contains(tge.getCodigo())){
						filtered.add(tge);
					}
				}
			}else{
				return unfiltered;
			}
		}
		return filtered;
	}

}
