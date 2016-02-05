package es.pfsgroup.plugin.recovery.arquetipos.modelos;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.ruleengine.RuleResult;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.arquetipos.PluginArquetiposBusinessOperations;
import es.pfsgroup.plugin.recovery.arquetipos.arquetipos.model.ARQArquetipoSim;
import es.pfsgroup.plugin.recovery.arquetipos.arquetipos.model.ARQListaArquetipo;
import es.pfsgroup.plugin.recovery.arquetipos.estadoModelo.dao.ARQDDEstadoModeloDao;
import es.pfsgroup.plugin.recovery.arquetipos.estadoModelo.model.ARQDDEstadoModelo;
import es.pfsgroup.plugin.recovery.arquetipos.modelos.dao.ARQModeloDao;
import es.pfsgroup.plugin.recovery.arquetipos.modelos.dto.ARQDtoBusquedaModelo;
import es.pfsgroup.plugin.recovery.arquetipos.modelos.dto.ARQDtoResultadoSimulacion;
import es.pfsgroup.plugin.recovery.arquetipos.modelos.model.ARQModelo;
import es.pfsgroup.plugin.recovery.arquetipos.modelosArquetipos.ARQModeloArquetipoManager;
import es.pfsgroup.plugin.recovery.arquetipos.modelosArquetipos.model.ARQModeloArquetipo;

@Component
public class ARQSimulacionDeModelosManager {

	@Autowired
	private ARQModeloManager modeloManagager;
	
	@Autowired
	private ARQModeloDao modeloDao;

	@Autowired
	private ARQModeloArquetipoManager modeloArquetipoManager;
	
	@Autowired
	private ARQDDEstadoModeloDao estadoModeloDao;
	
	@Autowired
	private Executor executor;
	
	@Autowired
	private GenericABMDao genericDao;

	private final Log logger = LogFactory.getLog(getClass());
	
	/**
	 * Muestra los arquetipos del modelo vigente
	 * 
	 * @return
	 */
	@BusinessOperation(PluginArquetiposBusinessOperations.SIM_MUESTRA_MODELO_VIGENTE)
	public List<ARQDtoResultadoSimulacion> muestraModeloVigente() {
		ARQModelo modelo = buscaModeloVigente();	
		List<ARQListaArquetipo> arquetipos = getArquetiposDelModelo(modelo
				.getId());
		ArrayList<ARQDtoResultadoSimulacion> resultado = muestraModelo(arquetipos);
		return resultado;
	}
	
	/**
	 * Ejecuta una simulación
	 * @return
	 */
	@BusinessOperation(PluginArquetiposBusinessOperations.SIM_SIMULA_MODELO_VIGENTE)
	public List<ARQDtoResultadoSimulacion> simulaModeloVigente() {
		ARQModelo modelo = buscaModeloVigente();
		//modelo.setEstado(estadoModeloDao.getByCodigo(ARQDDEstadoModelo.CODIGO_ESTADO_VIGENTE));
		List<ARQListaArquetipo> arquetipos = getArquetiposDelModelo(modelo
				.getId());
		ArrayList<ARQDtoResultadoSimulacion> resultado = simulaModelo(arquetipos);
		
		return resultado;
	}

	/**
	 * Muestra los arquetipos de un deterrminado modelo
	 * 
	 * @param idModelo
	 * @return
	 */
	@BusinessOperation(PluginArquetiposBusinessOperations.SIM_MUESTRA_MODELO)
	public List<ARQDtoResultadoSimulacion> muestraModelo(Long idModelo) {
		List<ARQListaArquetipo> arquetipos = getArquetiposDelModelo(idModelo);
		return muestraModelo(arquetipos);
	}
	
	@SuppressWarnings("unchecked")
	private List<ARQModelo> listModelos (CharSequence codigoEstado){
		ARQDtoBusquedaModelo dto = new ARQDtoBusquedaModelo();
		dto.setStart(0);
		dto.setLimit(100);
		dto.setEstadoModelo(codigoEstado.toString());
		List<ARQModelo> modelos = (List<ARQModelo>) modeloManagager.buscaModelos(dto).getResults();		
		return modelos;
	}
	
	@Transactional(readOnly = false)
	@BusinessOperation(PluginArquetiposBusinessOperations.SIM_PENDIENTE_SIMULACION)
	public void pendienteSimulacionModelo (Long id){
		List<ARQModelo> modelos = listModelos (ARQDDEstadoModelo.CODIGO_ESTADO_PENDIENTE_SIMULACION);
		if (modelos != null && modelos.size() > 0)
			throw new BusinessOperationException("Existe más de un modelo marcado como pendiente de simulación");
		pendienteSimulacion(id);
	}	
	
	private void pendienteSimulacion(Long id){

		//Primero validamos si el modelo estÃ¡ completamente configurado
		ARQModelo modelo = modeloDao.get(id);
		String errores = modeloManagager.validar(modelo);
		if (errores.equals("")) {
			try{
				Date fecha = new Date();
				modelo.setEstado(estadoModeloDao.getByCodigo(ARQDDEstadoModelo.CODIGO_ESTADO_PENDIENTE_SIMULACION));
				modelo.setFechaInicioVigencia(fecha);
				modeloDao.saveOrUpdate(modelo);
				List<ARQModeloArquetipo> listaNuevos = modeloArquetipoManager.listaArquetiposModelo(modelo.getId());
				for (ARQModeloArquetipo arqModeloArquetipo : listaNuevos) {
					ARQArquetipoSim nuevoArquetipo = new ARQArquetipoSim();
					nuevoArquetipo.setItinerario(arqModeloArquetipo.getItinerario());
					nuevoArquetipo.setPrioridad(arqModeloArquetipo.getPrioridad());
					nuevoArquetipo.setNombre(arqModeloArquetipo.getArquetipo().getNombre());
					nuevoArquetipo.setNivel(arqModeloArquetipo.getNivel());
					nuevoArquetipo.setGestion(arqModeloArquetipo.getArquetipo().getGestion());
					nuevoArquetipo.setPlazoDisparo(arqModeloArquetipo.getPlazoDisparo());
					nuevoArquetipo.setTipoSaltoNivel(arqModeloArquetipo.getArquetipo().getTipoSaltoNivel());
					nuevoArquetipo.setRule(arqModeloArquetipo.getArquetipo().getRule());
					nuevoArquetipo.setModeloArquetipo(arqModeloArquetipo);				
					genericDao.save(ARQArquetipoSim.class,nuevoArquetipo);
				}
			}catch(Exception e){
				logger.error(e.getMessage());
				throw new BusinessOperationException(errores);
			}
			
		} else {
			throw new BusinessOperationException(errores);
		}
	}
	
	@Transactional(readOnly = false)
	@BusinessOperation(PluginArquetiposBusinessOperations.SIM_CANCELAR_PENDIENTE_SIMULACION)
	public void cancelarPendienteSimulacionModelo (Long id){
		try{
			ARQModelo modelo = modeloDao.get(id);
			Date fecha = new Date();
			modelo.setEstado(estadoModeloDao.getByCodigo(ARQDDEstadoModelo.CODIGO_ESTADO_CONFORMACION));
			modelo.setFechaInicioVigencia(fecha);
			modeloDao.saveOrUpdate(modelo);
			List<ARQModeloArquetipo> listaCancelados = modeloArquetipoManager.listaArquetiposModelo(modelo.getId());
			for (ARQModeloArquetipo arqModeloArquetipo : listaCancelados) {
				Filter f = genericDao.createFilter(FilterType.EQUALS, "modeloArquetipo.id", arqModeloArquetipo.getId());
				List<ARQArquetipoSim> listARQArquetipoSim = genericDao.getList(ARQArquetipoSim.class, f);
				for(ARQArquetipoSim arquetipoSim : listARQArquetipoSim)
					genericDao.deleteById(ARQArquetipoSim.class, arquetipoSim.getId());
			}
		}catch(Exception e){
			logger.error(e.getMessage());
			throw new BusinessOperationException("Error al cancelar estado pendiente de simulación");
		}
	}		
	
	/**
	 * Ejecuta una simulación de un deterrminado modelo
	 * @param idModelo
	 * @return
	 */
	@Transactional(readOnly=false)
	@BusinessOperation(PluginArquetiposBusinessOperations.SIM_SIMULA_MODELO)
	public List<ARQDtoResultadoSimulacion> simulaModelo(Long idModelo) {
		ARQModelo modelo = modeloDao.get(idModelo) ;
		if (modelo.getEstado()== estadoModeloDao.getByCodigo(ARQDDEstadoModelo.CODIGO_ESTADO_CONFORMACION)){
			modelo.setEstado(estadoModeloDao.getByCodigo(ARQDDEstadoModelo.CODIGO_ESTADO_PRUEBAS));
		}
		List<ARQListaArquetipo> arquetipos = getArquetiposDelModelo(idModelo);
		return simulaModelo(arquetipos);
	}

	private ARQModelo buscaModeloVigente() {

		List<ARQModelo> modelos = listModelos (ARQDDEstadoModelo.CODIGO_ESTADO_VIGENTE);

		if (modelos == null) {
			throw new IllegalStateException("LISTA DE MODELOS NULL");
		}

		if (modelos.size() < 1) {
			throw new BusinessOperationException(
					"No existe ningún modelo marcado como vigente");
		}

		if (modelos.size() > 1) {
			throw new BusinessOperationException(
					"Existe más de un modelo marcado como vigente");
		}

		return modelos.get(0);

	}

	private List<ARQListaArquetipo> getArquetiposDelModelo(Long idModelo) {
		List<ARQModeloArquetipo> list = modeloArquetipoManager
				.listaArquetiposModelo(idModelo);
		ArrayList<ARQListaArquetipo> arquetipos = new ArrayList<ARQListaArquetipo>();
		for (ARQModeloArquetipo m : list) {
			arquetipos.add(m.getArquetipo());
		}
		return arquetipos;
	}

	private ArrayList<ARQDtoResultadoSimulacion> muestraModelo(
			List<ARQListaArquetipo> arquetipos) {
		ArrayList<ARQDtoResultadoSimulacion> resultado = new ArrayList<ARQDtoResultadoSimulacion>();
		for (ARQListaArquetipo a : arquetipos) {
			ARQDtoResultadoSimulacion r = new ARQDtoResultadoSimulacion();
			r.setArquetipo(a);
			resultado.add(r);
		}
		return resultado;
	}
	
	private ArrayList<ARQDtoResultadoSimulacion> simulaModelo(
			List<ARQListaArquetipo> arquetipos) {
		ArrayList<ARQDtoResultadoSimulacion> resultado = new ArrayList<ARQDtoResultadoSimulacion>();
		StringBuilder errores = new StringBuilder("");
		for (ARQListaArquetipo a : arquetipos) {
			ARQDtoResultadoSimulacion r = new ARQDtoResultadoSimulacion();
			r.setArquetipo(a);
			RuleResult rr = (RuleResult)executor.execute("arquetiposRuleExecutor.checkRule",a.getRuleDefinition());
			r.setTotalClientes(rr.getRowsModified());
			if (rr.getError() != null){
				errores.append("\n".concat(rr.getError()));
			}
			resultado.add(r);
		}
		if (! "".equals(errores.toString().trim())){
			
		}
		return resultado;
	}
}
