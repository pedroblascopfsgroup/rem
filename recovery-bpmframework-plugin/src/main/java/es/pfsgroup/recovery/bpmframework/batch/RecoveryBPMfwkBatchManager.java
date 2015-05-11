package es.pfsgroup.recovery.bpmframework.batch;

import java.util.Date;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.Executor;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.exception.FrameworkException;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.recovery.bpmframework.api.RecoveryBPMfwkBatchApi;
import es.pfsgroup.recovery.bpmframework.api.RecoveryBPMfwkProcedimientoApi;
import es.pfsgroup.recovery.bpmframework.api.RecoveryBPMfwkRunApi;
import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkCallback;
import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkInputDto;
import es.pfsgroup.recovery.bpmframework.batch.dao.RecoveryBPMfwkPeticionBatchDao;
import es.pfsgroup.recovery.bpmframework.batch.model.RecoveryBPMfwkPeticionBatch;
import es.pfsgroup.recovery.bpmframework.exceptions.RecoveryBPMfwkError;
import es.pfsgroup.recovery.bpmframework.input.RecoveryBPMfwkInputApi;
import es.pfsgroup.recovery.bpmframework.input.model.RecoveryBPMfwkInput;
import es.pfsgroup.recovery.bpmframework.tareas.RecoveryBPMfwkInputsTareasApi;
import es.pfsgroup.recovery.bpmframework.util.RecoveryBPMfwkUtils;

/**
 * Manager batch para el framework del BPM
 * 
 * @author bruno
 * 
 */
@Component
public class RecoveryBPMfwkBatchManager implements RecoveryBPMfwkBatchApi {

	private static final String MAX_INPUTS = "procesarInputs.num.maximo.inputs";
	private static final String MAX_INPUTS_DEFAULT = "2000";

	@Autowired
	private transient ApiProxyFactory proxyFactory;

	@Autowired
	private transient GenericABMDao genericDao;

	@Autowired
	private transient Executor executor;

	@Autowired
	private RecoveryBPMfwkPeticionBatchDao recoveryBPMfwkPeticionBatchDao;

	@Resource
	private Properties appProperties;

	/*
	 * (non-Javadoc)
	 * 
	 * @see es.pfsgroup.recovery.bpmframework.api.RecoveryBPMfwkBatchApi# programaProcesadoInput(java.lang.Long,
	 * es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkInputDto,
	 * es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkCallback)
	 */
	@Override
	@BusinessOperation(PLUGIN_RECOVERYBPMFWK_BO_PROGRAMA_INPUT_BATCH)
	public void programaProcesadoInput(final Long idProcess,
			final RecoveryBPMfwkInputDto dto,
			final RecoveryBPMfwkCallback callback) throws RecoveryBPMfwkError {

		RecoveryBPMfwkUtils.isNotNull(idProcess,
				"El idProcess no puede ser NULL");
		RecoveryBPMfwkUtils.isNotNull(dto, "El input no puede ser NULL");

		RecoveryBPMfwkInput input;
		try {
			input = proxyFactory.proxy(RecoveryBPMfwkInputApi.class).saveInput(
					dto);

			final RecoveryBPMfwkPeticionBatch pet = new RecoveryBPMfwkPeticionBatch();

			pet.setIdToken(idProcess);
			pet.setInput(input);
			if (!Checks.esNulo(callback)) {
				pet.setOnStartBo(callback.onProcessStart());
				pet.setOnEndBo(callback.onProcessEnd());
				pet.setOnSuccessBo(callback.onSuccess());
				pet.setOnErrorBo(callback.onError());
				pet.setProcesado(RecoveryBPMfwkPeticionBatch.NO_PROCESADO);

			}

			genericDao.save(RecoveryBPMfwkPeticionBatch.class, pet);
		} catch (RecoveryBPMfwkError e) {
			throw e;
		} catch (Exception e) {
			throw new RecoveryBPMfwkError(
					RecoveryBPMfwkError.ProblemasConocidos.ERROR_PROGRAMAR_BATCH,
					"Error al intentar programar el procesado de un input", e);
		}
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see es.pfsgroup.recovery.bpmframework.api.RecoveryBPMfwkBatchApi# ejecutaPeticionesBatchPendientes
	 */
	@Override
	@Transactional(readOnly = false)
	@BusinessOperation(PLUGIN_RECOVERYBPMFWK_BO_EJECUTA_PETICIONES_BATCH)
	@Deprecated
	public void ejecutaPeticionesBatchPendientes() throws RecoveryBPMfwkError {
		
		System.out.println("[RecoveryBPMfwkBatchManager:ejecutaPeticionesBatchPendientes] - Inicio de proceso: " + new Date());
		// Recuperamos la lista de peticiones pendientes ordenada por token
		// marcados como no procesados (
		try {
			List<RecoveryBPMfwkPeticionBatch> listaPeticionesPendientes = 
					obtenerListaPeticionesPendientes();
			// Recorremos la lista de peticiones pendientes y las marcamos como
			// procesadas
			int sizeLista = listaPeticionesPendientes.size();
			System.out.println("[RecoveryBPMfwkBatchManager:ejecutaPeticionesBatchPendientes] - Numero de peticiones pendientes: " + sizeLista);
			final Date fechaProcesado = new Date();
			Long anteriorToken;
			Long actualToken = 0L;
			Long siguienteToken;
			RecoveryBPMfwkPeticionBatch peticion = null;
			boolean esNecesarioEjecutarOnEnd = false;
			for (int i = 0; i < sizeLista; i++) {
				try{
					peticion = listaPeticionesPendientes.get(i);
					anteriorToken = actualToken;
					actualToken = peticion.getIdToken();
					boolean esNecesarioEjecutarOnStart = (i == 0 || !actualToken
							.equals(anteriorToken));
					if (i + 1 == sizeLista) {
						siguienteToken = -1L;
					} else {
						siguienteToken = listaPeticionesPendientes.get(i + 1)
								.getIdToken();
					}
					esNecesarioEjecutarOnEnd = !siguienteToken.equals(actualToken);
					procesarInput(peticion, esNecesarioEjecutarOnStart,
							esNecesarioEjecutarOnEnd, fechaProcesado);
				}catch(Throwable e){
					gestionarProcesadoInputError(peticion, esNecesarioEjecutarOnEnd, fechaProcesado, e.getMessage());
				}
			}

		} catch (Exception e) {
			throw new RecoveryBPMfwkError(
					RecoveryBPMfwkError.ProblemasConocidos.ERROR_DE_EJECUCION,
					"Error en la ejecución del batch.", e);
		}catch(Throwable e){
			throw new RecoveryBPMfwkError(
					RecoveryBPMfwkError.ProblemasConocidos.ERROR_DE_EJECUCION,
					"Error en la ejecución del batch.", e);
		}		
		System.out.println("[RecoveryBPMfwkBatchManager:ejecutaPeticionesBatchPendientes] - Fin de proceso: " + new Date());
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(PLUGIN_RECOVERYBPMFWK_BO_GET_TOKEN)
	public Long getToken() throws RecoveryBPMfwkError {
		try {
			return recoveryBPMfwkPeticionBatchDao.getToken();
		} catch (Exception e) {
			throw new RecoveryBPMfwkError(
					RecoveryBPMfwkError.ProblemasConocidos.ERROR_PROGRAMAR_BATCH,
					"Error al intentar obtener un token para el procesado batch.", e);
		}
	}

	/**
	 * {@inheritDoc}
	 */
	@Transactional(readOnly = false)
	@Override
	@BusinessOperation(PLUGIN_RECOVERYBPMFWK_BO_PROCESAR_INPUT)
	public void procesarInput(RecoveryBPMfwkPeticionBatch peticion,
			boolean esNecesarioEjecutarOnStart,
			boolean esNecesarioEjecutarOnEnd, Date fechaProcesado) {

		boolean procesoOK = true;
		String descripcionError = "";
		String bo = "";

		// Si es el primero del grupo de peticiones con el mismo token,
		// ejecutar callback onStartProcess
		if (esNecesarioEjecutarOnStart) {
			bo = peticion.getOnStartBo();
			if (bo != null) {
				try {
					executor.execute(bo, peticion.getIdToken());
				} catch (FrameworkException e) {
					procesoOK = false;
					descripcionError = e.getMessage();
					e.printStackTrace();
				}
			}
		}

		// Procesar input
		if (procesoOK) {
			RecoveryBPMfwkInput input = peticion.getInput();
			descripcionError = "";
			procesoOK = true;
			try {
				proxyFactory.proxy(RecoveryBPMfwkRunApi.class).procesaInput(
						input);
			} catch (Exception e) {
				descripcionError = e.getMessage();
				procesoOK = false;
			}
			
			//Introducimos esto para que el input batch (la resolucion) 
			// quede relacionado con la tarea activa (la mas reciente)
			if (procesoOK) {
				try {
					Long idProcedimiento = input.getIdProcedimiento();
					Long idTareaExterna = proxyFactory.proxy(
							RecoveryBPMfwkProcedimientoApi.class)
							.obtenerTareaActivaMasReciente(idProcedimiento);
					Long idInput = input.getId();
					if ((!Checks.esNulo(idInput) && (!Checks.esNulo(idTareaExterna)))) {
						proxyFactory.proxy(RecoveryBPMfwkInputsTareasApi.class).save(idInput, idTareaExterna);
					}
				} catch (Exception e) {
					//Ignoramos los errores que se produzcan aquí
					// Simplemente no se asociará la resolución a la tarea
					descripcionError = e.getMessage();
					//procesoOK = false;
				}
			}
			
			RecoveryBPMfwkInputDto dto = new RecoveryBPMfwkInputDto();
			dto.setAdjunto(input.getAdjunto());
			dto.setCodigoTipoInput(input.getCodigoTipoInput());
			try{
				dto.setDatos(input.getDatos()); // si el proceso es ko esto falla, hay que protegerlo para que guarde el error
			}catch(Throwable e){
				e.printStackTrace();
			}
			dto.setIdProcedimiento(input.getIdProcedimiento());

			// Según la respuesta (si hay error, se captura una excepcion),
			// ejecutar callbacks onError y onSuccess
			if (procesoOK) {
				bo = peticion.getOnSuccessBo();
				if (bo != null) {
					try {
						executor.execute(bo, peticion.getIdToken(), dto);
					} catch (FrameworkException e) {
						e.printStackTrace();
						descripcionError = e.getMessage();
						procesoOK = false;
					}
				}
			}

			// Si es el último del grupo de peticiones con el mismo token,
			// ejecutar callback onEndProcess
			if (esNecesarioEjecutarOnEnd) {
				bo = peticion.getOnEndBo();
				if (bo != null) {
					try {
						executor.execute(bo, peticion.getIdToken());
					} catch (FrameworkException e) {
						e.printStackTrace();
						procesoOK = false;
					}
				}
			}
			if (procesoOK) {
				peticion.setProcesado(RecoveryBPMfwkPeticionBatch.PROCESADO_OK);
				peticion.setFechaProcesado(fechaProcesado);
				genericDao.update(RecoveryBPMfwkPeticionBatch.class, peticion);
			} else {
				// Lanzamos la excepción el error que hemos recogido para que el catch del padre trate los errores
				// y la transacción los los eche para atrás
				throw new RecoveryBPMfwkError(RecoveryBPMfwkError.ProblemasConocidos.ERROR_DE_EJECUCION, descripcionError);
			}
			
		} else {
			throw new RecoveryBPMfwkError(RecoveryBPMfwkError.ProblemasConocidos.ERROR_DE_EJECUCION, descripcionError);
		}
	}
	
	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(PLUGIN_RECOVERYBPMFWK_BO_COMPRUEBA_NUM_INPUTS)
	public String compruebaInputsPendientes() {
		
		String maxInputs = (appProperties.getProperty(MAX_INPUTS) == null ? MAX_INPUTS_DEFAULT
				: appProperties.getProperty(MAX_INPUTS));
		
		Long numMaxInputs = null;
		try {
			numMaxInputs = Long.parseLong(maxInputs);
		} catch (NumberFormatException e) {
			e.printStackTrace();
		}
		if (numMaxInputs == null) {
			numMaxInputs = 2000L;
		}

		Long sizeLista = obtenerNumeroPeticionesPendientes();

		String resultado = "";
		if (sizeLista == 0) {
			resultado = "VACIO";
		} else if (sizeLista <= numMaxInputs) {
			resultado = "OK";
		} else {
			resultado = "KO";
		}
		return resultado;

	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(PLUGIN_RECOVERYBPMFWK_BO_OBTENER_LISTA_PETICIONES_PENDIENTES)
	public List<RecoveryBPMfwkPeticionBatch> obtenerListaPeticionesPendientes(){
		
		Filter filtro = genericDao.createFilter(FilterType.EQUALS,
				"procesado", RecoveryBPMfwkPeticionBatch.NO_PROCESADO);
		Order orden = new Order(OrderType.ASC, "idToken");
		List<RecoveryBPMfwkPeticionBatch> listaPeticionesPendientes = genericDao
				.getListOrdered(RecoveryBPMfwkPeticionBatch.class, orden,
						filtro);
		
		return listaPeticionesPendientes;
		
	}
	
	/**
	 * {@inheritDoc}
	 */
	@Override
	@BusinessOperation(PLUGIN_RECOVERYBPMFWK_BO_OBTENER_NUMERO_PETICIONES_PENDIENTES)
	public Long obtenerNumeroPeticionesPendientes(){
		
		return recoveryBPMfwkPeticionBatchDao.obtenerNumeroPeticionesPendientes();
				
	}

	/**
	 * {@inheritDoc}
	 */
	@Transactional(readOnly = false)
	@Override
	@BusinessOperation(PLUGIN_RECOVERYBPMFWK_BO_GESTIONAR_PROCESADO_INPUT_ERROR)
	public void gestionarProcesadoInputError(RecoveryBPMfwkPeticionBatch peticion,
			boolean esNecesarioEjecutarOnEnd, Date fechaProcesado, String descripcionError) throws RecoveryBPMfwkError {
		RecoveryBPMfwkInput input = null;
		String bo = "";
		try{
			// Primero marcamos el registro individual con error
			System.out.println("[RecoveryBPMFwkJmxFacade:ejecutaPeticionesBatchPendientes] - Error procesando petición con Id: " + peticion.getId());
			peticion.setProcesado(RecoveryBPMfwkPeticionBatch.PROCESADO_ERROR);
			peticion.setFechaProcesado(fechaProcesado);
			genericDao.update(RecoveryBPMfwkPeticionBatch.class, peticion);
			// Obtenemos el input de la petición
			input = peticion.getInput();			
			if(input!=null){
				// Creamos la Dto necesaria para seguir gestionando el error
				RecoveryBPMfwkInputDto dto = new RecoveryBPMfwkInputDto();
				dto.setAdjunto(input.getAdjunto());
				dto.setCodigoTipoInput(input.getCodigoTipoInput());
				try{
					dto.setDatos(input.getDatos()); // si el proceso es ko esto falla, hay que protegerlo para que guarde el error
				}catch(Throwable e){
					e.printStackTrace();
				}
				dto.setIdProcedimiento(input.getIdProcedimiento());
				// Procesamos el callback onError
				bo = peticion.getOnErrorBo();
				if (bo != null) {
					try {
						executor.execute(bo, peticion.getIdToken(), dto, descripcionError);
					} catch (FrameworkException e) {
						e.printStackTrace();
					}
				}
			}
			// En caso de que falle el último registro realizamos su callback correspondiente de onEnd
			if (esNecesarioEjecutarOnEnd) {
				bo = peticion.getOnEndBo();
				if (bo != null) {
					try {
						executor.execute(bo, peticion.getIdToken());
					} catch (FrameworkException e) {
						e.printStackTrace();
					}
				}
			}
		}catch(Throwable e){
			throw new RecoveryBPMfwkError(
					RecoveryBPMfwkError.ProblemasConocidos.ERROR_DE_EJECUCION,
					"[RecoveryBPMFwkJmxFacade:ejecutaPeticionesBatchPendientes] - "
					+ "Error procesando petición con Id: " + peticion.getId(), e);
		}
	}
	
}
