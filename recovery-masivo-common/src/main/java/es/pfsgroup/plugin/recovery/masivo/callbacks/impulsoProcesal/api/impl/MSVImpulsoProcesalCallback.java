package es.pfsgroup.plugin.recovery.masivo.callbacks.impulsoProcesal.api.impl;

import java.io.File;
import java.io.IOException;
import java.util.Collections;
import java.util.LinkedList;
import java.util.List;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

import jxl.write.WriteException;
import jxl.write.biff.RowsExceededException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.files.FileItem;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.plugin.recovery.masivo.api.ExcelManagerApi;
import es.pfsgroup.plugin.recovery.masivo.api.MSVProcesoApi;
import es.pfsgroup.plugin.recovery.masivo.api.impl.MSVProcesoManager;
import es.pfsgroup.plugin.recovery.masivo.callbacks.impulsoProcesal.api.MSVImpulsoProcesalCallbackApi;
import es.pfsgroup.plugin.recovery.masivo.dao.MSVFicheroDao;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVDtoAltaProceso;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDEstadoProceso;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDocumentoMasivo;
import es.pfsgroup.plugin.recovery.masivo.model.MSVProcesoMasivo;
import es.pfsgroup.plugin.recovery.masivo.utils.impl.MSVHojaExcel;
import es.pfsgroup.recovery.bpmframework.api.AbstractRecoveryBPMfwCallbackBOTemplate;
import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkInputDto;
import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkInputInfo;

@SuppressWarnings("deprecation")
@Component
public class MSVImpulsoProcesalCallback extends
		AbstractRecoveryBPMfwCallbackBOTemplate implements
		MSVImpulsoProcesalCallbackApi {

	@Autowired
	private MSVFicheroDao ficheroDao;

	@Autowired
	private ApiProxyFactory apiProxy;

	// Creamos un Map concurrente para almacenar la lista de errores
	private static ConcurrentMap<Long, List<String>> mapaErrores;
	static {
		mapaErrores = new ConcurrentHashMap<Long, List<String>>();
	}


	MSVProcesoMasivo procesoMasivo = null;
	
	/*
	 * (non-Javadoc)
	 * 
	 * @see es.pfsgroup.plugin.recovery.masivo.callbacks.bpmBO.api.impl.
	 * MSVLiberarRecepcionDocumentacionCallbackApi#onEndProcess(java.lang.Long)
	 */
	@Override
	@BusinessOperation(MSV_IMPULSO_PROCESAL_CALLBACK_ONEND)
	public void onEndProcess(Long tokenProceso) {
		MSVProcesoMasivo msvProcesoMasivo = apiProxy.proxy(MSVProcesoApi.class).getByToken(tokenProceso);
		if (Checks.esNulo(msvProcesoMasivo)) {
			throw new BusinessOperationException("No se encuentra el proceso masivo por el token");
		}
		MSVHojaExcel hojaExcel = getHojaExcel(msvProcesoMasivo.getId());

		MSVDtoAltaProceso dtoUpdateEstado = new MSVDtoAltaProceso();
		dtoUpdateEstado.setIdProceso(msvProcesoMasivo.getId());

		String nombFichErrores = null;		
		Boolean estaVacio = isVacio(mapaErrores.get(tokenProceso));
			
		if (!estaVacio) {
			try {
				// Insertamos los errores en el fichero de errores
				nombFichErrores = hojaExcel.crearExcelErrores(mapaErrores.get(tokenProceso));
			} catch (RowsExceededException e) {
				throw new BusinessOperationException(e.getCause() + " " + e.getMessage());
			} catch (IllegalArgumentException e) {
				throw new BusinessOperationException(e.getCause() + " " + e.getMessage());
			} catch (WriteException e) {
				throw new BusinessOperationException(e.getCause() + " " + e.getMessage());
			} catch (IOException e) {
				throw new BusinessOperationException(e.getCause() + " " + e.getMessage());
			}

			// Casteamos el file a fileItem
			FileItem erroresFichero = new FileItem();
			File fichErrores = new File(nombFichErrores);
			erroresFichero.setFile(fichErrores);
			erroresFichero.setFileName(nombFichErrores);
			erroresFichero.setLength(nombFichErrores.length());

			// Updateamos el fichero de errores
			try {
				apiProxy.proxy(ExcelManagerApi.class).updateErrores(msvProcesoMasivo.getId(), erroresFichero);
			} catch (Exception e) {
				throw new BusinessOperationException(e.getMessage());
			}

			// Cambiamos el estado del proceso "Procesado con errores"
			dtoUpdateEstado.setCodigoEstadoProceso(MSVDDEstadoProceso.CODIGO_PROCESADO_CON_ERRORES);
		} else {
			// Cambiamos el estado del proceso "Procesado"
			dtoUpdateEstado.setCodigoEstadoProceso(MSVDDEstadoProceso.CODIGO_PROCESADO);
		}
		// Updateamos el estado
		try {
			apiProxy.proxy(MSVProcesoApi.class).modificarProcesoMasivo(dtoUpdateEstado);
		} catch (Exception e1) {
			throw new BusinessOperationException(e1.getMessage());
		}
		// Eliminamos el mapa concurrente para vaciar memoria del batch
		mapaErrores.remove(tokenProceso);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see es.pfsgroup.plugin.recovery.masivo.callbacks.bpmBO.api.impl.
	 * MSVLiberarRecepcionDocumentacionCallbackApi#onError(java.lang.Long,
	 * es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkInputDto,
	 * java.lang.String)
	 */
	@Override
	@BusinessOperation(MSV_IMPULSO_PROCESAL_CALLBACK_ONERROR)
	public void onError(Long tokenProceso, RecoveryBPMfwkInputDto input,
			String errorMessage) {
		// Obtenemos el map concurrente y le añadimos el error donde el index de
		// la lista es la columna del excel
		List<String> listaErrores = mapaErrores.get(tokenProceso);
		Integer numFila = new Integer(Integer.parseInt((String) input.getDatos().get(MSVProcesoManager.COLUMNA_NUMERO_FILA)));
		numFila = numFila - 1;
		if (!Checks.esNulo(listaErrores)) {
			if (!Checks.esNulo(numFila)) {		
				if (numFila >= listaErrores.size()) {
					throw new BusinessOperationException("La fila seleccionada es mayor que el número de filas del excel");
				}
				mapaErrores.get(tokenProceso).set(numFila, errorMessage);
			} else {
				throw new BusinessOperationException("No existe el identificador de fila en el mapa de errores para el token: "+tokenProceso);
			}
		} else {
			throw new BusinessOperationException("No se encuentra el mapa de errores del token: " + tokenProceso);
		}
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see es.pfsgroup.plugin.recovery.masivo.callbacks.bpmBO.api.impl.
	 * MSVLiberarRecepcionDocumentacionCallbackApi
	 * #onStartProcess(java.lang.Long)
	 */
	@Override
	@BusinessOperation(MSV_IMPULSO_PROCESAL_CALLBACK_ONSTART)
	public void onStartProcess(Long tokenProceso) {
		MSVProcesoMasivo msvProcesoMasivo = apiProxy.proxy(MSVProcesoApi.class).getByToken(tokenProceso);
		if (Checks.esNulo(msvProcesoMasivo)) {
			throw new BusinessOperationException("No se encuentra el proceso masivo por el token: " + tokenProceso);
		}
		MSVHojaExcel hojaExcel = getHojaExcel(msvProcesoMasivo.getId());
		
		int numFilas = 0;
		try {
			numFilas = hojaExcel.getNumeroFilas();
		} catch (Exception e) {
			throw new BusinessOperationException("No se puede obtener el número de filas del fichero");
		}
		// Creamos el mapa de errores con un list concurrente
		List<String> list = Collections.synchronizedList(new LinkedList<String>());
		for (int i=1;i<numFilas;i++) list.add(null);
		
		mapaErrores.put(tokenProceso, list);

		// Updateamos el estado del proceso "Procesado con errores"
		MSVDtoAltaProceso dtoUpdateEstado = new MSVDtoAltaProceso();
		dtoUpdateEstado.setIdProceso(msvProcesoMasivo.getId());
		dtoUpdateEstado.setCodigoEstadoProceso(MSVDDEstadoProceso.CODIGO_EN_PROCESO);
		try {
			apiProxy.proxy(MSVProcesoApi.class).modificarProcesoMasivo(
					dtoUpdateEstado);
		} catch (Exception e1) {
			throw new BusinessOperationException("No se ha podido actualizar el estado: "+e1.getCause());
		}
	}

	private MSVHojaExcel getHojaExcel(Long idProceso) {
		// Obtenemos el fichero para averiguar la cantidad de filas
		MSVDocumentoMasivo fichero = ficheroDao.findByIdProceso(idProceso);
		if (Checks.esNulo(fichero)) {
			throw new BusinessOperationException("No se encuentra el fichero");
		}
		MSVHojaExcel hojaExcel = new MSVHojaExcel();		
		// Se lo pasamos a la clase HojaExcel para tratarlo
		hojaExcel.setFile(fichero.getContenidoFichero().getFile());
		
		return hojaExcel;		
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see es.pfsgroup.plugin.recovery.masivo.callbacks.bpmBO.api.impl.
	 * MSVLiberarRecepcionDocumentacionCallbackApi#onSuccess(java.lang.Long,
	 * es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkInputDto)
	 */
	@Override
	@BusinessOperation(MSV_IMPULSO_PROCESAL_CALLBACK_ONSUCCESS)
	public void onSuccess(Long tokenProceso, RecoveryBPMfwkInputDto arg1) {

	}

	/**
	 * Devuelve si el list contine alguna posición no nula
	 * @param list
	 * @return
	 */
	private Boolean isVacio(List<String> list) {
		for (int i=0;i<list.size();i++) {
			if (!Checks.esNulo(list.get(i))) {
				return false;				
			}
		}
		return true;
	}
	
	/**
	 * Métodos creado para los tests
	 * 
	 * @return
	 */
	public int getLengthMapaErrores() {
		return mapaErrores.size();
	}

	public ConcurrentMap<Long, List<String>> getMapaErrores() {
		return mapaErrores;
	}

	@Override
	public void onError(Long arg0, RecoveryBPMfwkInputInfo arg1, String arg2) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void onSuccess(Long arg0, RecoveryBPMfwkInputInfo arg1) {
		// TODO Auto-generated method stub
		
	}
	

}
