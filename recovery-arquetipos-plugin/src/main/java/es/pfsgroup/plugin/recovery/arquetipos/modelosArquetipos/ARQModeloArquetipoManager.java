package es.pfsgroup.plugin.recovery.arquetipos.modelosArquetipos;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.eventfactory.EventFactory;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.Conversiones;
import es.pfsgroup.plugin.recovery.arquetipos.PluginArquetiposBusinessOperations;
import es.pfsgroup.plugin.recovery.arquetipos.arquetipos.dao.ARQArquetipoDao;
import es.pfsgroup.plugin.recovery.arquetipos.arquetipos.model.ARQListaArquetipo;
import es.pfsgroup.plugin.recovery.arquetipos.estadoModelo.dao.ARQDDEstadoModeloDao;
import es.pfsgroup.plugin.recovery.arquetipos.estadoModelo.model.ARQDDEstadoModelo;
import es.pfsgroup.plugin.recovery.arquetipos.itinerario.dao.ARQItinerarioDao;
import es.pfsgroup.plugin.recovery.arquetipos.modelos.dao.ARQModeloDao;
import es.pfsgroup.plugin.recovery.arquetipos.modelos.model.ARQModelo;
import es.pfsgroup.plugin.recovery.arquetipos.modelosArquetipos.dao.ARQModeloArquetipoDao;
import es.pfsgroup.plugin.recovery.arquetipos.modelosArquetipos.dto.ARQDtoEditarArqsMod;
import es.pfsgroup.plugin.recovery.arquetipos.modelosArquetipos.dto.ARQDtoInsertarArquetiposModelo;
import es.pfsgroup.plugin.recovery.arquetipos.modelosArquetipos.model.ARQModeloArquetipo;


@Service("ARQModeloArquetipoManager")
public class ARQModeloArquetipoManager {
	
	@Autowired
	private ARQModeloDao modeloDao;
	
	@Autowired
	private ARQModeloArquetipoDao modeloArquetipoDao;
	
	@Autowired
	private ARQArquetipoDao arquetipoDao;
	
	@Autowired
	private ARQDDEstadoModeloDao arqDDEstadoModeloDao;
	
	@Autowired
	private Executor executor;
	
	@Autowired
	private ARQItinerarioDao itinerarioDao;
	
	public ARQModeloArquetipoManager(){
		
	}
	
	public ARQModeloArquetipoManager(ARQModeloArquetipoDao modeloArquetipoDao) {
		this.modeloArquetipoDao=modeloArquetipoDao;
		
	}


	/**
	 * @param id de la relaci�n entre modelos y arquetipos
	 * @return devuelve el objeto ARQModeloArquetipo cuyo id coincide con el que le pasamos 
	 * como entrada
	 */
	@BusinessOperation(PluginArquetiposBusinessOperations.MODELOARQUETIPO_MGR_GET)
	public ARQModeloArquetipo getModeloArquetipo(Long id){
		EventFactory.onMethodStart(this.getClass());
		return modeloArquetipoDao.get(id);
	}
	
	
	
	/**
	 * @param id del modelo
	 * @return devuelve la lista de objetos de tipo modeloArquetipo cuya id del modelo
	 * coincide con el id que se le pasa como entrada
	 */
	@BusinessOperation(PluginArquetiposBusinessOperations.MODELOARQUETIPO_MGR_LISTA_ARQUETIPOS)
	public List<ARQModeloArquetipo> listaArquetiposModelo (Long idModelo){
		EventFactory.onMethodStart(this.getClass());
		
		if(idModelo == null) {
			throw new IllegalArgumentException("El argumento de entrada no es v�lido");
		}
		if(executor.execute(PluginArquetiposBusinessOperations.MODELO_MGR_GET, idModelo)== null){
			throw new BusinessOperationException("No existe el modelo buscado");
		}
		
		EventFactory.onMethodStop(this.getClass());
		return modeloArquetipoDao.listaArquetiposModelo(idModelo);
	}
	
	
	
	
	/**
	 * @param dtoInsertarArquetiposModelo
	 * Guarda en la tabla MAR_MODELO_ARQUETIPO el arquetipo con los valores que se le pasan en el Dto
	 */
	@Transactional(readOnly=false)
	@BusinessOperation(PluginArquetiposBusinessOperations.MODELOARQUETIPO_MGR_INSERTAR_ARQ)
	public void insertarArquetiposModelo (ARQDtoInsertarArquetiposModelo dto){
		if (Checks.esNulo(dto)) {
			throw new IllegalArgumentException("dto no puede ser null");
		}
		List<ARQModeloArquetipo> lista = this.listaArquetiposModelo(dto.getIdModelo());
		Collection<Long> arquetipos = Conversiones.createLongCollection (dto.getArquetipos(),",");
		ARQModelo modelo = (ARQModelo) executor.execute(PluginArquetiposBusinessOperations.MODELO_MGR_GET, dto.getIdModelo());
		Long i = lista.size()+ 0L ;
		for (Long arq : arquetipos){
			i= i+1L;
			ARQModeloArquetipo modArq = modeloArquetipoDao.createNewModeloArquetipo();
			ARQListaArquetipo arquetipo = (ARQListaArquetipo) executor.execute(PluginArquetiposBusinessOperations.ARQ_MGR_GET,arq);
			modArq.setNivel(0L);
			modArq.setModelo(modelo);
			modArq.setArquetipo(arquetipo);
			modArq.setPrioridad(i);
			modArq.setPlazoDisparo(arquetipo.getPlazoDisparo());
			modeloArquetipoDao.save(modArq);
		}
		
		//Volvemos al estado CONFORMACION el modelo afectado
		modelo.setEstado(arqDDEstadoModeloDao.getByCodigo(ARQDDEstadoModelo.CODIGO_ESTADO_CONFORMACION));
		modeloDao.saveOrUpdate(modelo);

	}
	
	/**
	 * @param se le pasa como entrada el id de la relaci�n arquetipos-modelo y el id del modelo al que pertenece ese
	 * arquetipo
	 * Este m�todo marcar� como borrado l�gico esa relaci�n y les subir� la prioridad a todos los arquetipos que
	 * tengan una prioridad menor
	 */
	@Transactional(readOnly=false)
	@BusinessOperation(PluginArquetiposBusinessOperations.MODELOARQUETIPO_MGR_REMOVE)
	public void eliminarArquetipoModelo (Long idModeloArquetipo, Long idModelo){
		List<ARQModeloArquetipo> listaArq = this.listaArquetiposModelo(idModelo);
		ARQModeloArquetipo modArq = modeloArquetipoDao.get(idModeloArquetipo);
		for (ARQModeloArquetipo m : listaArq){
			if (!Checks.esNulo(m.getPrioridad())&& !Checks.esNulo(modArq.getPrioridad())&&
					m.getPrioridad()> modArq.getPrioridad()){
				m.setPrioridad(m.getPrioridad()-1);
				modeloArquetipoDao.saveOrUpdate(m);
			}
		}
		modeloArquetipoDao.deleteById(idModeloArquetipo);
		
		//Volvemos al estado CONFORMACION el modelo afectado
		ARQModelo modelo = (ARQModelo) executor.execute(PluginArquetiposBusinessOperations.MODELO_MGR_GET, idModelo);		
		modelo.setEstado(arqDDEstadoModeloDao.getByCodigo(ARQDDEstadoModelo.CODIGO_ESTADO_CONFORMACION));
		modeloDao.saveOrUpdate(modelo);
	}
	
	/**
	 * @param id del la entrada ModeloArquetipo
	 * aumenta la prioridad del arquetipo dentro del modelo y le baja la prioridad al que tenga una prioridad superior a la suya
	 * 
	 */
	@Transactional(readOnly=false)
	@BusinessOperation(PluginArquetiposBusinessOperations.MODELOARQUETIPO_MGR_SUBIRPRIORIDAD)
	public void subirPrioridadArquetipo (Long id){
		ARQModeloArquetipo modArq = modeloArquetipoDao.get(id);
		Long idModelo = modArq.getModelo().getId();
		List<ARQModeloArquetipo> listaArq = this.listaArquetiposModelo(idModelo);
		Long prioridad = modArq.getPrioridad();
		if (!prioridad.equals(1L)){
			for (ARQModeloArquetipo m : listaArq){
				if (m.getPrioridad().equals(prioridad-1)){
					m.setPrioridad(prioridad);
					break;
				}
			}
			modArq.setPrioridad(prioridad -1);
			//modeloArquetipoDao.saveOrUpdate(modArq);
		}
		
		modArq.getModelo().setEstado(arqDDEstadoModeloDao.getByCodigo(ARQDDEstadoModelo.CODIGO_ESTADO_CONFORMACION));
		modeloDao.saveOrUpdate(modArq.getModelo());
	}
	
	@Transactional(readOnly=false)
	@BusinessOperation(PluginArquetiposBusinessOperations.MODELOARQUETIPO_MGR_BAJARPRIORIDAD)
	public void bajarPrioridadArquetipo (Long id){
		ARQModeloArquetipo modArq = modeloArquetipoDao.get(id);
		Long idModelo = modArq.getModelo().getId();
		List<ARQModeloArquetipo> listaArq = this.listaArquetiposModelo(idModelo);
		Long prioridad = modArq.getPrioridad();
		Long tam = listaArq.size()+0L;
		if (!prioridad.equals(tam)){
			for (ARQModeloArquetipo m : listaArq){
				if (m.getPrioridad().equals(prioridad+1L)){
					m.setPrioridad(prioridad);
					break;
				}
			}
			modArq.setPrioridad(prioridad +1L);
			//modeloArquetipoDao.saveOrUpdate(modArq);
		}
		
		modArq.getModelo().setEstado(arqDDEstadoModeloDao.getByCodigo(ARQDDEstadoModelo.CODIGO_ESTADO_CONFORMACION));
		modeloDao.saveOrUpdate(modArq.getModelo());
	}
	
	
	@Transactional(readOnly=false)
	@BusinessOperation(PluginArquetiposBusinessOperations.MODELOARQUETIPO_MGR_EDITARQS)
	public void editarArquetiposModelo (Long idModelo, List<ARQDtoEditarArqsMod> dtoArquetipos){
		for (ARQDtoEditarArqsMod dto:dtoArquetipos){
			ARQModeloArquetipo modArq= modeloArquetipoDao.get(dto.getId());
			if (dto.getItinerario()!=null)
				modArq.setItinerario(itinerarioDao.get(dto.getItinerario()));
			else
				modArq.setItinerario(null);
			modArq.setNivel((dto.getNivel()!=null)?dto.getNivel():0);
			modArq.setPlazoDisparo(dto.getPlazoDisparo());
			//Long idArquetipo = modArq.getArquetipo().getId();
			//ARQListaArquetipo arquetipo = arquetipoDao.get(idArquetipo);
			//arquetipo.setPlazoDisparo(dto.getPlazoDisparo());	
			modeloArquetipoDao.save(modArq);
			//arquetipoDao.save(arquetipo);
		}
		
		ARQModelo modelo = modeloDao.get(idModelo);
		modelo.setEstado(arqDDEstadoModeloDao.getByCodigo(ARQDDEstadoModelo.CODIGO_ESTADO_CONFORMACION));
		modeloDao.saveOrUpdate(modelo);
	}
	
	@Transactional(readOnly=false)
	@BusinessOperation(PluginArquetiposBusinessOperations.MODELOARQUETIPO_MGR_COPIAARQ)
	public void copiaArquetiposModelo (Long idOriginal, ARQModelo copia){
		List<ARQModeloArquetipo> lista = modeloArquetipoDao.listaArquetiposModelo(idOriginal);
		
		for(ARQModeloArquetipo ma : lista){
			ARQModeloArquetipo modArq = modeloArquetipoDao.createNewModeloArquetipo();
			modArq.setArquetipo(ma.getArquetipo());
			modArq.setItinerario(ma.getItinerario());
			modArq.setPrioridad(ma.getPrioridad());
			modArq.setNivel(ma.getNivel());
			modArq.setPlazoDisparo(ma.getPlazoDisparo());
			modArq.setModelo(copia);
			modeloArquetipoDao.save(modArq);
		}
	}
	
	@BusinessOperation(PluginArquetiposBusinessOperations.MODELOARQUETIPO_MGR_LISTA_DTOARQUETIPOS)
	public List<ARQDtoEditarArqsMod> listaDtoArqsMod(Long id){
		List<ARQDtoEditarArqsMod> dtoArqsMod = new ArrayList<ARQDtoEditarArqsMod>();
		
		List<ARQModeloArquetipo> listaArquetipos = this.listaArquetiposModelo(id);
		for(ARQModeloArquetipo  arq :listaArquetipos){
			ARQDtoEditarArqsMod dto= new ARQDtoEditarArqsMod();
			dto.setNivel(arq.getNivel());
			dto.setId(arq.getId());
			dto.setIdArquetipo(arq.getArquetipo().getId());
			dto.setIdModelo(arq.getModelo().getId());
			if (!Checks.esNulo(arq.getItinerario())){
				dto.setItinerario(arq.getItinerario().getId());
			}
			dto.setPlazoDisparo(arq.getPlazoDisparo());
			dtoArqsMod.add(dto);
		}
		return dtoArqsMod;
	}
	
	
}
