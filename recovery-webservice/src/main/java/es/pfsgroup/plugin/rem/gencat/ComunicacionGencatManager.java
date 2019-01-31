package es.pfsgroup.plugin.rem.gencat;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.activo.dao.ComunicacionGencatDao;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoTareaExternaApi;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.ComunicacionGencatApi;
import es.pfsgroup.plugin.rem.jbpm.handler.user.UserAssigantionServiceFactoryApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ComunicacionGencat;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoComunicacionGencat;

@Service("comunicacionGencatManager")
public class ComunicacionGencatManager extends AbstractEntityDao<ComunicacionGencat, Long> implements ComunicacionGencatApi {
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private ActivoTramiteApi activoTramiteApi;
	
	@Autowired
	private ActivoTareaExternaApi activoTareaExternaApi;
	
	@Autowired
	private UserAssigantionServiceFactoryApi userAssigantionServiceFactoryApi;
	
	@Autowired
	private ComunicacionGencatDao comunicacionGencatDao;
	
	
	@Override
	public ComunicacionGencat getByIdActivo(Long idActivo) {
		
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Filter filtroIdActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);

		
		List<ComunicacionGencat> listagencat =  genericDao.getList(ComunicacionGencat.class, filtroBorrado, filtroIdActivo);
		
		if(!Checks.estaVacio(listagencat)) {
			return listagencat.get(0);
		}
		
		return null;
	}

	@Override
	public ComunicacionGencat getByNumActivoHaya(Long numActivoHaya) {
		
		Activo activo = activoApi.getByNumActivo(numActivoHaya);
		
		if (!Checks.esNulo(activo) && !Checks.esNulo(activo.getId())) {
			return this.getByIdActivo(activo.getId());		
		}
		
		return null;
	}

	@Override
	public List<ComunicacionGencat> getByIdActivoAndNif(Long idActivo, String nif) {
		
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Filter filtroIdActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
		Filter filtroNif = genericDao.createFilter(FilterType.EQUALS, "nuevoCompradorNif", nif);
		
		return genericDao.getList(ComunicacionGencat.class, filtroBorrado, filtroIdActivo, filtroNif);

	}

	@Override
	public List<ComunicacionGencat> getByNumActivoHayaAndNif(Long numActivoHaya, String nif) {

		Activo activo = activoApi.getByNumActivo(numActivoHaya);
		
		if (!Checks.esNulo(activo) && !Checks.esNulo(activo.getId())) {
			return this.getByIdActivoAndNif(activo.getId(), nif);		
		}
		
		return new ArrayList<ComunicacionGencat>();
	}
	
	@Override
	public ComunicacionGencat getByIdActivoCreado(Long idActivo) {
		
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Filter filtroIdActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", idActivo);
		Filter filtroEstadoTramite = genericDao.createFilter(FilterType.EQUALS, "estadoComunicacion.codigo", DDEstadoComunicacionGencat.COD_CREADO);
		
		ComunicacionGencat cmg = genericDao.get(ComunicacionGencat.class, filtroBorrado, filtroIdActivo, filtroEstadoTramite);
		
		return cmg;
		
	}

	@Override
	public ComunicacionGencat getByIdActivoEstadoCreado(Long idActivo) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void actualizarTareas(Long idTrabajo) {
		// TODO Auto-generated method stub
		
	}
}
