package es.pfsgroup.plugin.recovery.arquetipos.modelos;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.pagination.Page;
import es.capgemini.devon.web.DynamicElement;
import es.capgemini.pfs.core.api.web.DynamicElementApi;
import es.capgemini.pfs.eventfactory.EventFactory;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.arquetipos.PluginArquetiposBusinessOperations;
import es.pfsgroup.plugin.recovery.arquetipos.estadoModelo.dao.ARQDDEstadoModeloDao;
import es.pfsgroup.plugin.recovery.arquetipos.estadoModelo.model.ARQDDEstadoModelo;
import es.pfsgroup.plugin.recovery.arquetipos.modelos.dao.ARQModeloDao;
import es.pfsgroup.plugin.recovery.arquetipos.modelos.dto.ARQDtoBusquedaModelo;
import es.pfsgroup.plugin.recovery.arquetipos.modelos.dto.ARQDtoModelo;
import es.pfsgroup.plugin.recovery.arquetipos.modelos.model.ARQModelo;
import es.pfsgroup.plugin.recovery.arquetipos.modelosArquetipos.ARQModeloArquetipoManager;

@Service("ARQModeloManager")
public class ARQModeloManager {
	
	@Autowired
	private ARQModeloDao modeloDao;
	
	@Autowired
	private ARQModeloArquetipoManager modeloArquetipoManager;
	
	@Autowired
	private ARQDDEstadoModeloDao estadoModeloDao;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	public ARQModeloManager(){
		
	}
	
	public ARQModeloManager(ARQModeloDao modeloDao) {
		this.modeloDao = modeloDao;
	}
	
	
	/**
	 * @param id
	 * @return devuelve el modelo cuyo id coincide con el que le pasamos como par�metro
	 */
	@BusinessOperation(PluginArquetiposBusinessOperations.MODELO_MGR_GET)
	public ARQModelo getModelo(Long id){
		EventFactory.onMethodStart(this.getClass());
		return modeloDao.get(id);
	}

	/**
	 * devuelve la lista de todos los modelos de arquetipos dados de alta en la base de datos
	 */
	@BusinessOperation(PluginArquetiposBusinessOperations.MODELO_MGR_LIST)
	public List<ARQModelo> listaModelos(){
		return modeloDao.getList();
	}
	
	/**
	 * @param dto
	 * @return devuelve la lista de todos los modelos de arquetipos dados de alta en la base de datos
	 */
	@BusinessOperation(PluginArquetiposBusinessOperations.MODELO_MGR_FIND)
	public Page buscaModelos(ARQDtoBusquedaModelo dto) {
		EventFactory.onMethodStart(this.getClass());
		return modeloDao.findModelos(dto);
	}
	
	/**
	 *  Almacena un modelo.
	 * 
	 * Este m�todo sirve tanto para dar de alta un nuevo modelo como
	 * para modificar uno existente. En el caso que el DTO contenga el id del
	 * modelo intentar� actualizarlo, si no crear� uno nuevo.
	 * 
	 * @param dtoModelo 
	 */
	@BusinessOperation(PluginArquetiposBusinessOperations.MODELO_MGR_SAVE)
	@Transactional(readOnly = false)
	public void guardaModelo(ARQDtoModelo dto){
		ARQModelo modelo;
		if (dto.getId()== null) {
			modelo = modeloDao.createNewModelo();
			modelo.setNombre(dto.getNombre());
			modelo.setDescripcion(dto.getDescripcion());
			modelo.setEstado(estadoModeloDao.getByCodigo(ARQDDEstadoModelo.CODIGO_ESTADO_CONFORMACION));
			modeloDao.save(modelo);
		}else{
			modelo = modeloDao.get(dto.getId());
			modelo.setNombre(dto.getNombre());
			modelo.setDescripcion(dto.getDescripcion());
			modelo.setEstado(estadoModeloDao.getByCodigo(ARQDDEstadoModelo.CODIGO_ESTADO_CONFORMACION));
			modeloDao.saveOrUpdate(modelo);
		}	
	}
	
	/**
	 * Elimina de la lista el modelo que hemos seleccionado
	 * @return Si el id del arquetipo no existe o se le pasa como entrada
	 *         un null se deberá lanzar una excepción
	 */
	@Transactional(readOnly = false)
	@BusinessOperation(PluginArquetiposBusinessOperations.MODELO_MGR_REMOVE)
	public void borraModelo (Long id){
		ARQModelo mod = modeloDao.get(id);
		ARQDDEstadoModelo estado = mod.getEstado();
		if (estado.getCodigo().equals(estadoModeloDao.getByCodigo(ARQDDEstadoModelo.CODIGO_ESTADO_HISTORICO)) || estado.getCodigo().equals(ARQDDEstadoModelo.CODIGO_ESTADO_VIGENTE)){
			throw new BusinessOperationException(
			"No se pueden eliminar Modelos cuyo estado sea Vigente o Histórico");
		}
		else {
			modeloDao.deleteById(id);
		}
	}
	
	
	@Transactional(readOnly = false)
	@BusinessOperation(PluginArquetiposBusinessOperations.MODELO_MGR_LIBERA)
	public void liberaModelo(Long id){
		Date fecha = new Date();
		List<ARQModelo> listaModelos = modeloDao.getList();
		for (ARQModelo m : listaModelos){
			if (m.getEstado().equals(estadoModeloDao.getByCodigo(ARQDDEstadoModelo.CODIGO_ESTADO_VIGENTE))){
				m.setEstado(estadoModeloDao.getByCodigo(ARQDDEstadoModelo.CODIGO_ESTADO_HISTORICO));
				m.setFechaFinVigencia(fecha);
				//TODO - Borrado lógico de arq_arquetipos
			}
		}
		ARQModelo modelo = modeloDao.get(id);
		modelo.setEstado(estadoModeloDao.getByCodigo(ARQDDEstadoModelo.CODIGO_ESTADO_VIGENTE));
		modelo.setFechaInicioVigencia(fecha);
		modeloDao.saveOrUpdate(modelo);
		//TODO - Insertar los arq_arquetipos
		
	}
	
	@Transactional(readOnly=false)
	@BusinessOperation(PluginArquetiposBusinessOperations.MODELO_MGR_COPIA)
	public void copiaModelo(Long id){
		ARQModelo copia = modeloDao.createNewModelo();
		ARQModelo original = modeloDao.get(id);
		copia.setNombre("copia"+original.getNombre());
		copia.setDescripcion(original.getDescripcion());
		copia.setEstado(estadoModeloDao.getByCodigo(ARQDDEstadoModelo.CODIGO_ESTADO_CONFORMACION));
		modeloDao.save(copia);
		modeloArquetipoManager.copiaArquetiposModelo(id, copia);
		
	}
		
	@BusinessOperation("plugin.arquetipos.web.modelosArquetipos.buttons.left")
	List<DynamicElement> getButtonConfiguracionModelosArquetiposLeft() {
		List<DynamicElement> l = proxyFactory.proxy(DynamicElementApi.class)
				.getDynamicElements(
						"plugin.arquetipos.web.modelosArquetipos.buttons.left",
						null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}

	@BusinessOperation("plugin.arquetipos.web.modelosArquetipos.buttons.right")
	List<DynamicElement> getButtonsConfiguracionModelosArquetiposRight() {
		List<DynamicElement> l =  proxyFactory.proxy(DynamicElementApi.class).getDynamicElements(
				"plugin.arquetipos.web.modelosArquetipos.buttons.right", null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}	

}
