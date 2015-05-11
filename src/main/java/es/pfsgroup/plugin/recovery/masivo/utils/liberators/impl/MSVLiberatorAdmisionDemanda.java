package es.pfsgroup.plugin.recovery.masivo.utils.liberators.impl;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.pfs.asunto.model.DDEstadoProcedimiento;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.contrato.model.Contrato;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.masivo.api.impl.MSVProcesoManager;
import es.pfsgroup.plugin.recovery.masivo.api.ExcelManagerApi;
import es.pfsgroup.plugin.recovery.masivo.callbacks.admisionDemanda.MSVAdmisionDemandaBPMCallback;
import es.pfsgroup.plugin.recovery.masivo.inputfactory.MSVInputFactory;
import es.pfsgroup.plugin.recovery.masivo.inputfactory.MSVSelectorTipoInput;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDOperacionMasiva;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDocumentoMasivo;
import es.pfsgroup.plugin.recovery.masivo.utils.filecolumns.MSVAdmisionDemandaColumns;
import es.pfsgroup.plugin.recovery.masivo.utils.impl.MSVHojaExcel;
import es.pfsgroup.plugin.recovery.masivo.utils.liberators.MSVLiberator;
import es.pfsgroup.plugin.recovery.masivo.utils.liberators.impl.dinamicFields.MSVAdmisionDemandaDinamicFields;
import es.pfsgroup.recovery.bpmframework.api.RecoveryBPMfwkBatchApi;
import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkInputDto;
import es.pfsgroup.recovery.bpmframework.exceptions.RecoveryBPMfwkError;

@SuppressWarnings("deprecation")
@Component
public class MSVLiberatorAdmisionDemanda implements MSVLiberator{

	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private MSVInputFactory factoria;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Override
	public Boolean isValidFor(MSVDDOperacionMasiva tipoOperacion) {
		if (!Checks.esNulo(tipoOperacion)){
			if (MSVDDOperacionMasiva.CODIGO_ADMISION_DEMANDA.equals(tipoOperacion.getCodigo())){
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
		
		MSVHojaExcel exc = proxyFactory.proxy(ExcelManagerApi.class).getHojaExcel(fichero);
		List<String> listaCabeceras=exc.getCabeceras();
		
		for (int fila = 1; fila < exc.getNumeroFilas(); fila++) {			
			//Nos creamos un dto por cada fila del fichero
			RecoveryBPMfwkInputDto input=new RecoveryBPMfwkInputDto();
			// mapeamos el  dto con los valores de las columnas
			Map<String, Object> map = new HashMap<String, Object>();
			map.put(MSVProcesoManager.COLUMNA_NUMERO_FILA, fila);
			String tipoProcedimiento = null;
			String numNova = null;
			Procedimiento procedimiento = null;
			
			for (int columna = 0; columna < exc.getCabeceras().size(); columna++) {
				String dato = exc.dameCelda(fila, columna);
					// Se añaden el resto de datos excepto las comunes a las dos si el tipo de prc es ejecutivo
					if ((!Checks.esNulo(tipoProcedimiento)) && (tipoProcedimiento.equals("1249") || tipoProcedimiento.equals("1441")) && (
						listaCabeceras.get(columna).equals(MSVAdmisionDemandaColumns.FECHA_NOTIFICACION) ||
						listaCabeceras.get(columna).equals(MSVAdmisionDemandaColumns.FECHA_RESOLUCION) ||
						listaCabeceras.get(columna).equals(MSVAdmisionDemandaColumns.TIPO_ADMISION))) {			
							map.put(MSVAdmisionDemandaDinamicFields.getFields().get(listaCabeceras.get(columna)+"_AUDE"), dato);
					} else {
						map.put(MSVAdmisionDemandaDinamicFields.getFields().get(listaCabeceras.get(columna)), dato);
						if (listaCabeceras.get(columna).equals(MSVAdmisionDemandaColumns.NUM_NOVA)){
							numNova = dato;
						} 
						
						if (listaCabeceras.get(columna).equals(MSVAdmisionDemandaColumns.TIPO_PROCEDIMIENTO)){
							//Reemplazamos el código introducido en el excel con la descripcion por el id solamente
							tipoProcedimiento = getIdDato(dato);
							map.put(MSVAdmisionDemandaDinamicFields.getFields().get(MSVAdmisionDemandaColumns.TIPO_PROCEDIMIENTO),tipoProcedimiento);
						}
						
						if ((!Checks.esNulo(tipoProcedimiento) && (!Checks.esNulo(numNova)) && (Checks.esNulo(procedimiento)))) {
							procedimiento=buscaProcedimientoDelContrato(numNova, Long.parseLong(tipoProcedimiento));
							if(Checks.esNulo(procedimiento)){
								throw new BusinessOperationException("No se ha encontrado ningún procedimiento activo del tipo esperado para este contrato "+ dato);
							}
							input.setIdProcedimiento(procedimiento.getId());	
							//Se añade el asunto por defecto.
							map.put(MSVAdmisionDemandaDinamicFields.getFields().get(MSVAdmisionDemandaDinamicFields.ID_ASUNTO),procedimiento.getAsunto().getId());
						}
						
						if ((listaCabeceras.get(columna).equals(MSVAdmisionDemandaColumns.NUM_AUTOS)) && ("".equals(dato)) && (!Checks.esNulo(procedimiento))){
							map.put(MSVAdmisionDemandaDinamicFields.getFields().get(MSVAdmisionDemandaColumns.NUM_AUTOS), procedimiento.getCodigoProcedimientoEnJuzgado());
						}
						
						if ((listaCabeceras.get(columna).equals(MSVAdmisionDemandaColumns.PARTIDO_JUDICIAL)) && ("".equals(dato)) &&
								(!Checks.esNulo(procedimiento)) && (!Checks.esNulo(procedimiento.getJuzgado()) && (!Checks.esNulo(procedimiento.getJuzgado().getPlaza())))) {
							//Reemplazamos el código introducido en el excel con la descripcion por el id solamente
							map.put(MSVAdmisionDemandaDinamicFields.getFields().get(MSVAdmisionDemandaColumns.PARTIDO_JUDICIAL),procedimiento.getJuzgado().getPlaza().getId());
						}

						if ((listaCabeceras.get(columna).equals(MSVAdmisionDemandaColumns.JUZGADO)) && ("".equals(dato)) &&
								(!Checks.esNulo(procedimiento)) && (!Checks.esNulo(procedimiento.getJuzgado()))) {
							//Reemplazamos el código introducido en el excel con la descripcion por el id solamente
							map.put(MSVAdmisionDemandaDinamicFields.getFields().get(MSVAdmisionDemandaColumns.JUZGADO),procedimiento.getJuzgado().getId());
						}

					}
			}
			String tipoInput=buscarTipoInput(fichero.getProcesoMasivo().getTipoOperacion(), map);
			input.setDatos(map);
			input.setCodigoTipoInput(tipoInput.toString());
			
			// nos creamos el callback específico de este tipo de operación
			MSVAdmisionDemandaBPMCallback callback = new MSVAdmisionDemandaBPMCallback();
			
			try {
				proxyFactory.proxy(RecoveryBPMfwkBatchApi.class).programaProcesadoInput(fichero.getProcesoMasivo().getToken(), input, callback);
			} catch (RecoveryBPMfwkError e) {
				return false;
			}
		}	
		return true;
	}

	private String getIdDato(String dato) {
		String[] arrDato = dato.split("-");
		return (arrDato.length >= 2) ? arrDato[0] : dato;
	}
	
	private String buscarTipoInput(MSVDDOperacionMasiva tipoOperacion,
			Map<String, Object> map) {
		
		MSVSelectorTipoInput s = factoria.dameSelector(tipoOperacion, map);
		String codigoTipoInput=s.getTipoInput(map);;
		return codigoTipoInput;
	}

	private Procedimiento buscaProcedimientoDelContrato(String valorCelda, long tipoProcedimiento) {
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
				p=proc;
				// Si está aceptado y tiene asunto, no hace falta que siga buscando
				if ((p.getEstaAceptado() || DDEstadoProcedimiento.ESTADO_PROCEDIMIENTO_DERIVADO
						.equals(p.getEstadoProcedimiento().getCodigo()))
						&& p.getAsunto() != null && p.getTipoProcedimiento().getId()==tipoProcedimiento) {
					break;
				}
			}
		}
		return p;
	}
}
