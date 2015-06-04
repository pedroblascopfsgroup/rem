package es.pfsgroup.plugin.recovery.masivo.callbacks.lanzarEJTdesdeFM.api.impl;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.Collections;
import java.util.LinkedList;
import java.util.List;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.ConcurrentMap;

import jxl.write.WriteException;
import jxl.write.biff.RowsExceededException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.asunto.dao.ProcedimientoDao;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.asunto.model.DDEstadoAsunto;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.masivo.api.ExcelManagerApi;
import es.pfsgroup.plugin.recovery.masivo.api.MSVProcedimientoApi;
import es.pfsgroup.plugin.recovery.masivo.api.MSVProcesoApi;
import es.pfsgroup.plugin.recovery.masivo.api.impl.MSVProcesoManager;
import es.pfsgroup.plugin.recovery.masivo.callbacks.lanzarEJTdesdeFM.api.MSVLanzarETJdesdeFMCallbackApi;
import es.pfsgroup.plugin.recovery.masivo.dao.MSVContratoDao;
import es.pfsgroup.plugin.recovery.masivo.dao.MSVFicheroDao;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVDtoAltaProceso;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDEstadoProceso;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDocumentoMasivo;
import es.pfsgroup.plugin.recovery.masivo.model.MSVProcesoMasivo;
import es.pfsgroup.plugin.recovery.masivo.utils.filecolumns.MSVLanzaETJdesdeFMColumns;
import es.pfsgroup.plugin.recovery.masivo.utils.impl.MSVHojaExcel;
import es.pfsgroup.procedimientos.recoveryapi.JBPMProcessApi;
import es.pfsgroup.recovery.bpmframework.api.AbstractRecoveryBPMfwCallbackBOTemplate;
import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkInputDto;
import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkInputInfo;
import es.pfsgroup.plugin.recovery.masivo.utils.MSVUtils;
import es.pfsgroup.plugin.recovery.mejoras.procedimiento.model.MEJProcedimiento;

@SuppressWarnings("deprecation")
@Component
public class MSVLanzarETJdesdeFMCallback extends
		AbstractRecoveryBPMfwCallbackBOTemplate implements
		MSVLanzarETJdesdeFMCallbackApi {

	@Autowired
	private MSVFicheroDao ficheroDao;

	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ProcedimientoDao procedimientoDao;
	
	@Autowired
	private MSVContratoDao msvContratoDao;
	
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
	@BusinessOperation(MSV_LANZAR_ETJ_DESDE_FM_CALLBACK_ONEND)
	public void onEndProcess(Long tokenProceso) {
		MSVProcesoMasivo msvProcesoMasivo = proxyFactory.proxy(MSVProcesoApi.class).getByToken(tokenProceso);
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
				proxyFactory.proxy(ExcelManagerApi.class).updateErrores(msvProcesoMasivo.getId(), erroresFichero);
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
			proxyFactory.proxy(MSVProcesoApi.class).modificarProcesoMasivo(dtoUpdateEstado);
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
	@BusinessOperation(MSV_LANZAR_ETJ_DESDE_FM_CALLBACK_ONERROR)
	public void onError(Long tokenProceso, RecoveryBPMfwkInputDto input,
			String errorMessage) {
		// Obtenemos el map concurrente y le a�adimos el error donde el index de
		// la lista es la columna del excel
		List<String> listaErrores = mapaErrores.get(tokenProceso);
		Integer numFila = new Integer(Integer.parseInt((String) input.getDatos().get(MSVProcesoManager.COLUMNA_NUMERO_FILA)));
		numFila = numFila - 1;
		if (!Checks.esNulo(listaErrores)) {
			if (!Checks.esNulo(numFila)) {		
				if (numFila >= listaErrores.size()) {
					throw new BusinessOperationException("La fila seleccionada es mayor que el n�mero de filas del excel");
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
	@BusinessOperation(MSV_LANZAR_ETJ_DESDE_FM_CALLBACK_ONSTART)
	public void onStartProcess(Long tokenProceso) {
		MSVProcesoMasivo msvProcesoMasivo = proxyFactory.proxy(MSVProcesoApi.class).getByToken(tokenProceso);
		if (Checks.esNulo(msvProcesoMasivo)) {
			throw new BusinessOperationException("No se encuentra el proceso masivo por el token: " + tokenProceso);
		}
		MSVHojaExcel hojaExcel = getHojaExcel(msvProcesoMasivo.getId());
		
		int numFilas = 0;
		try {
			numFilas = hojaExcel.getNumeroFilas();
		} catch (Exception e) {
			throw new BusinessOperationException("No se puede obtener el n�mero de filas del fichero");
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
			proxyFactory.proxy(MSVProcesoApi.class).modificarProcesoMasivo(dtoUpdateEstado);
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
	@BusinessOperation(MSV_LANZAR_ETJ_DESDE_FM_CALLBACK_ONSUCCESS)
	public void onSuccess(Long tokenProceso, RecoveryBPMfwkInputDto input) {
		int estado = 0;
		Procedimiento procedimiento = null;
		
		MEJProcedimiento procedimientoHijo = null;
		DDEstadoProcedimiento estadoPrcAnt = null;
		DDEstadoAsunto estadoAsuAnt = null;
		try {
			/*Lanza el nuevo procedimiento Hijo*/
			TipoProcedimiento tipoProcedimiento = genericDao.get(TipoProcedimiento.class, genericDao.createFilter(FilterType.EQUALS, "codigo", MSVProcesoManager.TIPO_PROCEDIMIENTO_ETJ));
			procedimiento = procedimientoDao.get(input.getIdProcedimiento()); // proxyFactory.proxy(ProcedimientoApi.class).getProcedimiento(input.getIdProcedimiento());
			
			if (Checks.esNulo(tipoProcedimiento) || Checks.esNulo(procedimiento)) {
				this.onError(tokenProceso, input, "No se encuentra el procedimiento o el tipo de procedimiento "+MSVProcesoManager.TIPO_PROCEDIMIENTO_ETJ);
			} else {
				procedimientoHijo = (MEJProcedimiento) proxyFactory.proxy(MSVProcedimientoApi.class).creaProcedimientoHijoMasivo(tipoProcedimiento, procedimiento);
				
				if (Checks.esNulo(procedimientoHijo)) {
					this.onError(tokenProceso, input, "Error al lanzar el ETJ");
				} else {
					estado = 1;					
					/*Actualizamos el principal del procedimiento hijo si se ha informado en el excel*/					
					BigDecimal principal = MSVUtils.getBigDecimal(String.valueOf(input.getDatos().get(MSVLanzaETJdesdeFMColumns.PRINCIPAL)));
					/*Si no se ha informado se obtiene el principal restante*/
					if (Checks.esNulo(principal)) {		
						Set<Contrato> contratos = procedimiento.getAsunto().getContratos();

						for (Contrato contrato : contratos) {
								principal = msvContratoDao.getRestanteDemanda(contrato.getId());
							
//								EXTInfoAdicionalContratoInfo infoAdicional = proxyFactory.proxy(EXTContratoApi.class).getInfoAdicionalContratoByTipo(contrato.getId(), MSVProcesoManager.PRINCIPAL_RESTANTE_ADICIONALCONTRATO);
//								if (!Checks.esNulo(infoAdicional)) {
//									principal = MSVUtils.getBigDecimal(infoAdicional.getValue());
//								}
						}
					}				
					/*Si existe en el excel o el "principal restante" se actualiza, sino se deja el principal del Monitorio*/
					if (!Checks.esNulo(principal)) { 
						procedimientoHijo.setSaldoRecuperacion(principal);
						procedimientoDao.saveOrUpdate(procedimientoHijo);
					}
					
					/*Actualizamos el estado del procedimiento padre a cerrado*/
					estadoPrcAnt = procedimiento.getEstadoProcedimiento();
					DDEstadoProcedimiento ddEstadoPrcCerrado = genericDao.get(DDEstadoProcedimiento.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_CERRADO)); 
					if (Checks.esNulo(ddEstadoPrcCerrado)) {
						this.onError(tokenProceso, input, "No se encuentra el estado cerrado del procedimiento y no se ha podido cambiar");
					} else {
						procedimiento.setEstadoProcedimiento(ddEstadoPrcCerrado);
						procedimientoDao.saveOrUpdate(procedimiento);
					}
					estado = 2;
					
					/*Cambiamos el estado del asunto a Aceptado*/					
					DDEstadoAsunto ddEstadoAsuntoAceptado = genericDao.get(DDEstadoAsunto.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoAsunto.ESTADO_ASUNTO_ACEPTADO));
					if (Checks.esNulo(ddEstadoAsuntoAceptado)) {
						this.onError(tokenProceso, input, "No se encuentra el estado aceptado del asunto y no se ha podido cambiar");
					} else {						
						Asunto asunto = procedimiento.getAsunto();
						estadoAsuAnt = asunto.getEstadoAsunto();
						asunto.setEstadoAsunto(ddEstadoAsuntoAceptado);
						genericDao.update(Asunto.class, asunto);
					}
					estado = 3;
					
					/*Inicializamos el bpm del procedimiento hijo*/
					long idProcessBPM = proxyFactory.proxy(JBPMProcessApi.class).lanzaBPMAsociadoAProcedimiento(procedimientoHijo.getId(), null);
					if (Checks.esNulo(idProcessBPM)) {
						this.onError(tokenProceso, input, "No se ha lanzado correctamente el BPM");
					}
				}
			}
		} catch (Exception e) {
			if (estado >= 1) { /*Ya se ha derivado*/
				if (!Checks.esNulo(procedimientoHijo)) procedimientoDao.deleteById(procedimientoHijo.getId());
			}
			if (estado >= 2) { /*Se ha cambiado el estado del prc padre*/
				if (!Checks.esNulo(procedimiento)) {
					procedimiento.setEstadoProcedimiento(estadoPrcAnt);
					procedimientoDao.saveOrUpdate(procedimiento);
				}
			}
			if (estado >= 3) { /*Se ha cambiado el estado del asunto*/
				if (!Checks.esNulo(procedimiento)) {
					Asunto asunto = procedimiento.getAsunto();
					asunto.setEstadoAsunto(estadoAsuAnt);
					genericDao.update(Asunto.class, asunto);
				}
			}
			this.onError(tokenProceso, input, "Ha ocurrido un error: " + e.getMessage());
		}
	}

	/**
	 * Devuelve si el list contine alguna posici�n no nula
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
	 * M�todos creado para los tests
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
	public void onSuccess(Long idProcess, RecoveryBPMfwkInputInfo input) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void onError(Long idProcess, RecoveryBPMfwkInputInfo input,
			String errorMessage) {
		// TODO Auto-generated method stub
		
	}
	

}
