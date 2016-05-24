package es.pfsgroup.plugin.recovery.arquetipos.modelos;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.pfs.ruleengine.RuleResult;
import es.pfsgroup.plugin.recovery.arquetipos.PluginArquetiposBusinessOperations;
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
		ARQDtoBusquedaModelo dto = new ARQDtoBusquedaModelo();
		dto.setStart(0);
		dto.setLimit(100);
		dto.setEstadoModelo(ARQDDEstadoModelo.CODIGO_ESTADO_VIGENTE);
		List<ARQModelo> modelos = (List<ARQModelo>) modeloManagager
				.buscaModelos(dto).getResults();

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
	/*
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
	*/
	private ArrayList<ARQDtoResultadoSimulacion> simulaModelo(
			List<ARQListaArquetipo> arquetipos) {
		ArrayList<ARQDtoResultadoSimulacion> resultado = new ArrayList<ARQDtoResultadoSimulacion>();
		StringBuilder errores = new StringBuilder("");
		List<String> sqlMostPriority = new ArrayList<String>();
		for (ARQListaArquetipo a : arquetipos) {
			ARQDtoResultadoSimulacion r = new ARQDtoResultadoSimulacion();
			r.setArquetipo(a);
			
			RuleResult rr = (RuleResult)executor.execute("arquetiposRuleExecutor.checkRule",a.getRuleDefinition(),sqlMostPriority);
			r.setTotalClientes(rr.getRowsModified());
			if (rr.getError() != null){
				errores.append("\n".concat(rr.getError()));
			}
			resultado.add(r);
			String sqlGen = (String)executor.execute("arquetiposRuleExecutor.generateMostPriorityBaseRule",a.getRuleDefinition());
			sqlMostPriority.add(sqlGen);
		}
		if (! "".equals(errores.toString().trim())){
			
		}
		return resultado;
	}
}
