package es.pfsgroup.plugin.recovery.arquetipos.arquetipos;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.pagination.Page;
import es.capgemini.devon.web.DynamicElement;
import es.capgemini.pfs.arquetipo.model.DDTipoSaltoNivel;
import es.capgemini.pfs.core.api.web.DynamicElementApi;
import es.capgemini.pfs.eventfactory.EventFactory;
import es.capgemini.pfs.ruleengine.rule.definition.RuleDefinition;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.arquetipos.PluginArquetiposBusinessOperations;
import es.pfsgroup.plugin.recovery.arquetipos.arquetipos.dao.ARQArquetipoDao;
import es.pfsgroup.plugin.recovery.arquetipos.arquetipos.dto.ARQDtoArquetipo;
import es.pfsgroup.plugin.recovery.arquetipos.arquetipos.dto.ARQDtoBusquedaArquetipo;
import es.pfsgroup.plugin.recovery.arquetipos.arquetipos.model.ARQListaArquetipo;
import es.pfsgroup.plugin.recovery.arquetipos.modelosArquetipos.dao.ARQModeloArquetipoDao;
import es.pfsgroup.plugin.recovery.arquetipos.modelosArquetipos.model.ARQModeloArquetipo;

@Service("ARQArquetipoManager")
public class ARQArquetipoManager {
	
	@Autowired
	private Executor executor;
	
	@Autowired
	private ARQArquetipoDao arquetipoDao;
	
	@Autowired
	private ARQModeloArquetipoDao modeloArquetipoDao;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
	public ARQArquetipoManager() {
		}
	
	public ARQArquetipoManager(ARQArquetipoDao arquetipoDao ) {
		super ();
		this.arquetipoDao = arquetipoDao;
		
	}
	
	@BusinessOperation(PluginArquetiposBusinessOperations.ARQ_MGR_GET)
	public ARQListaArquetipo getArquetipo(Long id){
		EventFactory.onMethodStart(this.getClass());
		return arquetipoDao.get(id);
	}
	
	
	/**
	 * 
	 * @return lista de todos los Arquetipos dadas de alta en la base de datos
	 */
	@BusinessOperation(PluginArquetiposBusinessOperations.ARQ_MGR_LISTA)
	public List<ARQListaArquetipo> listaArquetipos(){
		return arquetipoDao.getList();
		
	}
	
	
	/**
	 * @param id del modelo
	 * @return devuelve todos los arquetipos que no están dados de alta
	 * en ese modelo
	 */
	@SuppressWarnings("unchecked")
	@BusinessOperation(PluginArquetiposBusinessOperations.ARQ_MGR_RESTO_ARQUETIPOS)
	public List<ARQListaArquetipo> listaRestoArquetipos (Long idModelo){
		List<ARQModeloArquetipo> arquetiposModelo = (List<ARQModeloArquetipo>) executor.execute(
				PluginArquetiposBusinessOperations.MODELOARQUETIPO_MGR_LISTA_ARQUETIPOS, idModelo);
		List <ARQListaArquetipo> restoArquetipos = arquetipoDao.getList();
		for(ARQModeloArquetipo ma : arquetiposModelo){
			restoArquetipos.remove(ma.getArquetipo());
		}
		
		return restoArquetipos;
	}

	/**
	 * 
	 * @param dto 
	 * @return Devuelve una lista paginada con todos los arquetipos 
	 * que se adaptan a los criterios de búsqueda
	 * Debemos de poder buscar por nombre y por paquete asociado al arquetipo
	 * Si no le metemos ningún criterio de búsqueda deberá devolver la lista de 
	 * todos los arquetipos existentes en la base de datos
	 */
	@BusinessOperation(PluginArquetiposBusinessOperations.ARQ_MGR_FIND)
	public Page findArquetipos (ARQDtoBusquedaArquetipo dto){
		EventFactory.onMethodStart(this.getClass());
		return arquetipoDao.findArquetipo(dto);
	}
	
	/**
	 *  Almacena un arquetipo.
	 * 
	 * Este método sirve tanto para dar de alta un nuevo arquetipo como
	 * para modificar uno existente. En el caso que el DTO contenga el id del
	 * arquetipo intentará actualizarlo, si no creará uno nuevo.
	 * 
	 * @param dtoArquetipo
	 */
	@BusinessOperation(PluginArquetiposBusinessOperations.ARQ_MGR_SAVE)
	@Transactional(readOnly= false)
	public void guardaArquetipo (ARQDtoArquetipo dto){
		ARQListaArquetipo arq;
		if(dto.getId() == null){
			arq = arquetipoDao.createNewArquetipo();
			arq.setNombre(dto.getNombre());
			if (dto.getRule()!= null){
				RuleDefinition rule = (RuleDefinition) executor.execute(PluginArquetiposBusinessOperations.RULE_MGR_GET, dto.getRule());
				arq.setRule(rule);
			}
			if (dto.getTipoSaltoNivel()!= null){
				DDTipoSaltoNivel ddTipoSalto = (DDTipoSaltoNivel)executor.execute(PluginArquetiposBusinessOperations.DDTSN_MGR_GET, dto.getTipoSaltoNivel());
				arq.setTipoSaltoNivel(ddTipoSalto);
			}
			arq.setGestion(dto.getGestion());
			arq.setPlazoDisparo(dto.getPlazoDisparo());
			arquetipoDao.save(arq);
		}
		if(dto.getId() != null){
			arq = arquetipoDao.get(dto.getId());
			arq.setNombre(dto.getNombre());
			if (dto.getRule()!= null){
				RuleDefinition rule = (RuleDefinition) executor.execute(PluginArquetiposBusinessOperations.RULE_MGR_GET, dto.getRule());
				arq.setRule(rule);
			}
			if (dto.getTipoSaltoNivel()!= null){
				DDTipoSaltoNivel ddTipoSalto = (DDTipoSaltoNivel)executor.execute(PluginArquetiposBusinessOperations.DDTSN_MGR_GET, dto.getTipoSaltoNivel());
				arq.setTipoSaltoNivel(ddTipoSalto);
			}
			arq.setGestion(dto.getGestion());
			arq.setPlazoDisparo(dto.getPlazoDisparo());
			arquetipoDao.saveOrUpdate(arq);
		}
	}
	
	/**
	 * Elimina el arquetipo cuyo id coincide con el id que le pasamos como parámetro	
	 * @param id
	 * @return Si el id del arquetipo no existe o se le pasa como entrada
	 *         un null se deberá lanzar una excepción
	 */
	@Transactional(readOnly= false)
	@BusinessOperation(PluginArquetiposBusinessOperations.ARQ_MGR_REMOVE)
	public void borrarArquetipo (Long id){
		if(id == null){
			throw new IllegalArgumentException(
					"El argumento de entrada no es valido");
		}
		if(arquetipoDao.get(id)==null){
			throw new BusinessOperationException(
					"El arquetipo que desea eliminar no existe");
		}
		List<ARQModeloArquetipo> lista = modeloArquetipoDao.getList();
		
		for(ARQModeloArquetipo arq : lista ){
			if (arq.getArquetipo().getId().equals(id)){
				throw new BusinessOperationException(
				"No se pueden eliminar Arquetipos asociados a un modelo");
			}
		}
		arquetipoDao.deleteById(id);
		
	}
	
	
	@BusinessOperation("plugin.arquetipos.web.arquetipos.buttons.left")
	List<DynamicElement> getButtonConfiguracionArquetiposLeft() {
		List<DynamicElement> l = proxyFactory.proxy(DynamicElementApi.class)
				.getDynamicElements(
						"plugin.arquetipos.web.arquetipos.buttons.left",
						null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}

	@BusinessOperation("plugin.arquetipos.web.arquetipos.buttons.right")
	List<DynamicElement> getButtonsConfiguracionArquetiposRight() {
		List<DynamicElement> l =  proxyFactory.proxy(DynamicElementApi.class).getDynamicElements(
				"plugin.arquetipos.web.arquetipos.buttons.right", null);
		if (l == null)
			return new ArrayList<DynamicElement>();
		else
			return l;
	}
	
		
	

}
