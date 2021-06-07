package es.pfsgroup.plugin.rem.security.jupiter;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;

@Component
public class TraductorCodigosJupiter {

    @Autowired
    private GenericABMDao genericDao;
    
	private Map<String, MapeoJupiterREM> mapaCompleto = null;
	
	public Map<String, MapeoJupiterREM> getMap() {
		if (mapaCompleto == null) {
			Order orden = new Order(OrderType.ASC,"codigoJupiter");
			List<MapeoJupiterREM> lista = genericDao.getListOrdered(MapeoJupiterREM.class, orden);
			mapaCompleto = new HashMap<String, MapeoJupiterREM>();
			for (MapeoJupiterREM mapa : lista) {
				mapaCompleto.put(mapa.getCodigoJupiter(), mapa);
			}
		}
		return mapaCompleto;
	}
}
