package es.pfsgroup.plugin.recovery.masivo.utils.liberators.impl;

import java.io.IOException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.tareaNotificacion.model.TareaNotificacion;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.masivo.api.ExcelManagerApi;
import es.pfsgroup.plugin.recovery.masivo.callbacks.redaccDem.MSVRedaccDemBPMCallback;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDOperacionMasiva;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDocumentoMasivo;
import es.pfsgroup.plugin.recovery.masivo.utils.filecolumns.MSVEnvioDemandaColumns;
import es.pfsgroup.plugin.recovery.masivo.utils.impl.MSVHojaExcel;
import es.pfsgroup.plugin.recovery.masivo.utils.liberators.MSVLiberator;
import es.pfsgroup.recovery.bpmframework.api.RecoveryBPMfwkBatchApi;
import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkInputDto;
import es.pfsgroup.recovery.bpmframework.exceptions.RecoveryBPMfwkError;

@SuppressWarnings("deprecation")
@Component
public class MSVLiberatorEnvioDemanda implements MSVLiberator {

	private static final String CODIGO_PROC_ETJ = "P72";

	private static final Object TAREA_CONFIRMAR_ENVIO_DEMANDA = "P72_ConfirmarEnvioDemanda";

	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Override
	public Boolean isValidFor(MSVDDOperacionMasiva tipoOperacion) {
		if (!Checks.esNulo(tipoOperacion)){
			if (MSVDDOperacionMasiva.CODIGO_ENVIO_DEMANDA.equals(tipoOperacion.getCodigo())){
				return true;
			}else {
				return false;
			}
		}else{
			return false;
		}
	}
	
	@Override
	public Boolean liberaFichero(MSVDocumentoMasivo fichero) throws IllegalArgumentException, IOException {

		final String CAMPO_ASUNTO = "idAsunto";
		final String CAMPO_FECHA_ENVIO = "d_fecEnvioDemanda";
		final String CAMPO_NUM_AUTOS = "d_numAutos";
		final String CAMPO_OBSERVACIONES = "d_observaciones";
		final String CAMPO_NUMERO_FILA = "NUM_FILA";

		
		MSVHojaExcel exc = proxyFactory.proxy(ExcelManagerApi.class).getHojaExcel(fichero);
		List<String> listaCabeceras=exc.getCabeceras();

		boolean ok = true;
		
		for (int fila = 1; fila < exc.getNumeroFilas(); fila++) {
			
			//Nos creamos un dto por cada fila del fichero
			RecoveryBPMfwkInputDto input=new RecoveryBPMfwkInputDto();
			// mapeamos el  dto con los valores de las columnas
			Map<String, Object> map = new HashMap<String, Object>();
			map.put(CAMPO_NUMERO_FILA, fila);
			for (int columna = 0; columna < exc.getCabeceras().size(); columna++) {
				String dato = exc.dameCelda(fila, columna);
				if (listaCabeceras.get(columna).equals(MSVEnvioDemandaColumns.CASO_NOVA)){
					Procedimiento procedimiento=buscaProcedimientoDelContratoETJ(dato);
					if(Checks.esNulo(procedimiento)){
						throw new BusinessOperationException("No se ha encontrado ningún procedimiento activo del tipo esperado para este contrato "+ dato);
					}
					input.setIdProcedimiento(procedimiento.getId());
					//Se añade el asunto por defecto.
					map.put(CAMPO_ASUNTO,procedimiento.getAsunto().getId());
					//Se añade el nº de autos
					map.put(CAMPO_NUM_AUTOS,procedimiento.getCodigoProcedimientoEnJuzgado());
					//Se añade observaciones vacío
					map.put(CAMPO_OBSERVACIONES,"");
				} 	else if (listaCabeceras.get(columna).equals(MSVEnvioDemandaColumns.FECHA_ENVIO)){
					//Se añade LA FECHA DE ENVIO DE LA DEMANDA
					// Corregido el formato y quitando la parte de la hora
					dato = dato.replaceAll(" ", "/").substring(0, 10);
					map.put(CAMPO_FECHA_ENVIO,dato);
				}
			}
			String tipoInput=MSVDDOperacionMasiva.CODIGO_INPUT_ENVIO_DEMANDA_BATCH;
			input.setDatos(map);
			input.setCodigoTipoInput(tipoInput.toString());
			
			// nos creamos el callback específico de este tipo de operación
			MSVRedaccDemBPMCallback callback = new MSVRedaccDemBPMCallback();
			
			try {
				proxyFactory.proxy(RecoveryBPMfwkBatchApi.class).programaProcesadoInput(fichero.getProcesoMasivo().getToken(), input, callback);
			} catch (RecoveryBPMfwkError e) {
				ok = false;
				e.printStackTrace();
			}

		}
		
		return ok;


	}	

	/**
	 * Busca procedimiento de tipo P72 (ETJ) correspondiente al contrato.
	 * Si no lo encientra devuelve null.
	 * 
	 * @param valorCelda se le pasa el identificador del contrato nova
	 * @return procedimiento activo al que pertenece ese contrato
	 */
	private Procedimiento buscaProcedimientoDelContratoETJ(String valorCelda) {
		
		Procedimiento p = null;
		Long valorCeldaLong=null;
		try {
			valorCeldaLong=Long.parseLong(valorCelda);
		} catch (Exception e) {
			throw new BusinessOperationException("El número del contrato no es válido");
		}
		
		Contrato c= genericDao.get(Contrato.class, genericDao.createFilter(FilterType.EQUALS, "nroContrato", valorCeldaLong));
		if(!Checks.esNulo(c)){
			for(Procedimiento proc : c.getProcedimientos()){
				//p=proc;
				// Si está aceptado, no hace falta que siga buscando
				if ((proc.getEstaAceptado() || DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_DERIVADO
						.equals(proc.getEstadoProcedimiento().getCodigo()))
						&& proc.getAsunto() != null
						&& proc.getTipoProcedimiento().getCodigo().equals(CODIGO_PROC_ETJ)
						&& proc.getTareas() != null) {
					Set<TareaNotificacion> tareas = proc.getTareas();
					for (Iterator<TareaNotificacion> iterator = tareas.iterator(); iterator
							.hasNext();) {
						TareaNotificacion tareaNotificacion = (TareaNotificacion) iterator
								.next();
						if ((tareaNotificacion.getTareaFinalizada() == null ||
								tareaNotificacion.getTareaFinalizada().booleanValue() != false) &&
								tareaNotificacion.getTareaExterna() != null &&
								tareaNotificacion.getTareaExterna().getTareaProcedimiento() != null &&
								tareaNotificacion.getTareaExterna().getTareaProcedimiento().getCodigo().equals(TAREA_CONFIRMAR_ENVIO_DEMANDA)) {
							p = proc;
							break;
						}
						
					}
					if (p != null) {
						break;
					}
				}
			}
		}
		return p;
	}


}
