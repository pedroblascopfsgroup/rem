package es.pfsgroup.plugin.rem.auditoriaExportaciones;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.fasterxml.jackson.databind.ObjectMapper;

import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.plugin.rem.api.AuditoriaExportacionesApi;
import es.pfsgroup.plugin.rem.model.AuditoriaExportaciones;
import es.pfsgroup.plugin.rem.model.DtoActivoGridFilter;

@Service("auditoriaExportacionesManager")
public class AuditoriaExportacionesManager extends BusinessOperationOverrider<AuditoriaExportacionesApi> implements AuditoriaExportacionesApi {

	@Autowired
	private GenericABMDao genericDao;

	@Override
	public String managerName() {
		return "auditoriaExportacionesManager";
	}

	@Override
	public boolean permiteBusqueda(DtoActivoGridFilter dto,Usuario user, String buscador) throws Exception {
		
		String filtros = dtoParser(dto);
		boolean permitido = true;
		
		Filter filtroUsuario = genericDao.createFilter(FilterType.EQUALS, "usuario.id", user.getId());
		Filter filtroConsulta = genericDao.createFilter(FilterType.EQUALS, "filtros", filtros);
		Filter filtroAccion = genericDao.createFilter(FilterType.EQUALS, "isBusqueda", true);
		Filter filtroBuscador = genericDao.createFilter(FilterType.EQUALS, "buscador", buscador);
		Order orden = new Order(OrderType.DESC, "fechaExportacion");
		List<AuditoriaExportaciones> listaExportaciones = 
				genericDao.getListOrdered(AuditoriaExportaciones.class, orden, filtroUsuario, filtroConsulta, filtroAccion,filtroBuscador);
		
		if(listaExportaciones != null && !listaExportaciones.isEmpty()) {
			Long ultimaExport = listaExportaciones.get(0).getFechaExportacion().getTime();
			permitido = (System.currentTimeMillis() - ultimaExport) > 60000 ? true : false;
		}
		
		if (permitido)
			registraBusqueda(filtros, user, buscador);

		return permitido;
	}
	
	@Transactional()
	private void registraBusqueda(String filtros,Usuario user, String buscador) throws Exception {

		AuditoriaExportaciones ae = new AuditoriaExportaciones();
		ae.setFechaExportacion(new Date());
		ae.setBuscador(buscador);
		ae.setUsuario(user);
		ae.setFiltros(filtros);
		ae.setIsBusqueda(true);
		genericDao.save(AuditoriaExportaciones.class, ae);
	}
	
	private String dtoParser(DtoActivoGridFilter dto) {
		ObjectMapper mapper = new ObjectMapper();
		HashMap<String, Object> filtro = new HashMap<String, Object>();
        Map<String, Object> map = mapper.convertValue(dto, Map.class);
        
        for (Map.Entry it : map.entrySet()) {
        	String stringIt = it.getKey().toString();
	    	if(!stringIt.equals("sort") && !stringIt.equals("limit")
	    			&& !stringIt.equals("dir") && !stringIt.equals("start")
	    			&& !Checks.esNulo(it.getValue())) {
	    		filtro.put(stringIt, it.getValue());
	    	}
	    }
        
        return filtro.toString();
	}
}
