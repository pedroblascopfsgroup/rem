package es.pfsgroup.framework.paradise.bulkUpload.api.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.framework.paradise.bulkUpload.api.MSVDiccionarioApi;
import es.pfsgroup.framework.paradise.bulkUpload.dao.MSVDDOperacionMasivaDao;
import es.pfsgroup.framework.paradise.bulkUpload.dao.MSVPlantillaOperacionDao;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVPlantillaOperacion;
import es.pfsgroup.recovery.api.UsuarioApi;

@Service
@Transactional(readOnly = false)
public class MSVDiccionarioManager implements MSVDiccionarioApi{
	
	@Autowired
	private MSVDDOperacionMasivaDao operacionDao;
	
	@Autowired
	private MSVPlantillaOperacionDao plantillaDao;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ApiProxyFactory proxyFactory;

	@Override
	@BusinessOperation(MSV_BO_DAME_LISTA_OPERACIONES)
	public List<MSVDDOperacionMasiva> dameListaOperacionesDeUsuario() {
		List<MSVDDOperacionMasiva> lista;
		
		Usuario usu=proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		lista=operacionDao.dameListaOperacionesDeUsuario(usu);
		
		return lista;
	}

	@Override
	@BusinessOperation(MSV_BO_DAME_LISTA_PLANTILLAS)
	public List<MSVPlantillaOperacion> dameListaPlantillasUsuario() {
		List<MSVPlantillaOperacion> lista;
		
		Usuario usu=proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
		lista=plantillaDao.dameListaPlantillasUsuario(usu);
		
		return lista;
	}
	
	@SuppressWarnings("rawtypes")
	@Override
	@BusinessOperation(MSV_BO_DAME_VALORES_DICCIONARIO)
	public List dameValoresDiccionario(Class clazz) {
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		Order order = new Order(OrderType.ASC,"descripcion");
		@SuppressWarnings("unchecked")
		List lista = genericDao.getListOrdered(clazz, order, filtro);
		//List lista = genericDao.getList(clazz, filtro);
		return lista;
	}

	/* (non-Javadoc)
	 * @see es.pfsgroup.plugin.recovery.masivo.api.MSVDiccionarioApi#obtenerRutaExcel(java.lang.Long)
	 */
	@Override
	@BusinessOperation(MSV_BO_OBTENER_RUTA_EXCEL)
	public String obtenerRutaExcel(Long tipoPlantilla) {
		
		MSVPlantillaOperacion msvPlantillaOperacion = plantillaDao.obtenerRutaExcel(tipoPlantilla);
		return msvPlantillaOperacion.getDirectorio();
	}

}
