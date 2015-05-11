package es.pfsgroup.plugin.recovery.masivo.utils.liberators.impl;

import java.io.IOException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.bo.BusinessOperationException;
import es.capgemini.pfs.asunto.model.Procedimiento;
import es.capgemini.pfs.contrato.model.Contrato;
import es.capgemini.pfs.procesosJudiciales.model.TipoProcedimiento;
import es.capgemini.pfs.utils.FormatUtils;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.masivo.api.ExcelManagerApi;
import es.pfsgroup.plugin.recovery.masivo.api.MSVEnvioImpresionApi;
import es.pfsgroup.plugin.recovery.masivo.api.MSVProcedimientoApi;
import es.pfsgroup.plugin.recovery.masivo.api.impl.MSVProcesoManager;
import es.pfsgroup.plugin.recovery.masivo.callbacks.bpmBO.api.MSVProcedimientoBackOfficeCallbackApi;
import es.pfsgroup.plugin.recovery.masivo.dto.MSVBuscaProcedimientoDelContratoDto;
import es.pfsgroup.plugin.recovery.masivo.model.MSVConfEnvioImpresion;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDOperacionMasiva;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDocumentoMasivo;
import es.pfsgroup.plugin.recovery.masivo.utils.filecolumns.MSVEnvioImpresionColumns;
import es.pfsgroup.plugin.recovery.masivo.utils.impl.MSVHojaExcel;
import es.pfsgroup.plugin.recovery.masivo.utils.liberators.MSVLiberator;
import es.pfsgroup.recovery.bpmframework.api.dto.RecoveryBPMfwkInputDto;
import es.pfsgroup.recovery.bpmframework.exceptions.RecoveryBPMfwkError;

/*
 * Utilizado para la operación Envío masivo impresión.
 * */
@SuppressWarnings("deprecation")
@Component
public class MSVLiberatorEnvioImpresion implements MSVLiberator{

	private static final String CODIGO_PROC_MONITORIO = "P70";
	private static final String CODIGO_PROC_ETJ = "P72";

	@Autowired
	private ApiProxyFactory proxyFactory;
	
	@Autowired
	private GenericABMDao genericDao;
	
	//Utilizamos los callbacks genericos de BO para guardar los errores
	@Autowired
	private MSVProcedimientoBackOfficeCallbackApi callBack;
	
	@Override
	public Boolean isValidFor(MSVDDOperacionMasiva tipoOperacion) {
		if (!Checks.esNulo(tipoOperacion)){
			if (MSVDDOperacionMasiva.CODIGO_ENVIO_IMPRESION.equals(tipoOperacion.getCodigo())){
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
		Long token = fichero.getProcesoMasivo().getToken();
		callBack.onStartProcess(token);
		
		MSVHojaExcel exc = proxyFactory.proxy(ExcelManagerApi.class).getHojaExcel(fichero);
		List<String> listaCabeceras=exc.getCabeceras();
		DateFormat df = new SimpleDateFormat(FormatUtils.DDMMYYYY);
		
		Long idTipoProcedimientoMonitorio = obtenerIdTipoProcedimiento(CODIGO_PROC_MONITORIO);
		Long idTipoProcedimientoETJ = obtenerIdTipoProcedimiento(CODIGO_PROC_ETJ);
		boolean error = false;
		
		for (int fila = 1; fila < exc.getNumeroFilas(); fila++) {
			error = false;
			//Recuperamos los valores de los campos
			String numNova = null;
			Procedimiento procedimiento = null;
			Long idTipoProcedimiento = null;
			String tipoDocumentacion = null;
			String fecha = null;
			Date fechaImpresion = new Date();
			//Creamos un input ficticio para crear el excel de errores
			RecoveryBPMfwkInputDto input = new RecoveryBPMfwkInputDto();
			Map<String, Object> datos = new HashMap<String,Object>();
			datos.put(MSVProcesoManager.COLUMNA_NUMERO_FILA,String.valueOf(fila));
			input.setDatos(datos);
			
			for (int columna = 0; columna < exc.getCabeceras().size(); columna++) {
				String dato = exc.dameCelda(fila, columna);
				if (listaCabeceras.get(columna).equals(MSVEnvioImpresionColumns.CASO_NOVA)) {
					numNova = dato;
				} else if (listaCabeceras.get(columna).equals(MSVEnvioImpresionColumns.FECHA_SOLICITUD)) {
					fecha = dato;
					if (!Checks.esNulo(fecha)) {
						try {
							fechaImpresion = df.parse(fecha);
						} catch (ParseException e) {
							callBack.onError(token, input, "La fecha es incorrecta: "+e.getMessage());
							error=true;
							e.printStackTrace();
							break;
						}
					}
				} else if (listaCabeceras.get(columna).equals(MSVEnvioImpresionColumns.TIPO_DOCUMENTACION)) {
					tipoDocumentacion = dato;
					if (tipoDocumentacion.contains(MSVConfEnvioImpresion.MONITORIO)) {
						idTipoProcedimiento = idTipoProcedimientoMonitorio;
					} else if (tipoDocumentacion.contains(MSVConfEnvioImpresion.ETJ)) {
						idTipoProcedimiento = idTipoProcedimientoETJ;
					} 
				}
			}

			if (Checks.esNulo(numNova)) {
				callBack.onError(token, input, "El número del contrato no es válido");
				error=true;
			}
			
			if (!error) {
				MSVBuscaProcedimientoDelContratoDto dtoBusqueda = new MSVBuscaProcedimientoDelContratoDto();
				try {
					dtoBusqueda.setNumeroCasoNova(Long.parseLong(numNova));					
				
					dtoBusqueda.setTipoProcedimiento(idTipoProcedimiento);
					dtoBusqueda.setTieneJuzgado(true);
					
					procedimiento=proxyFactory.proxy(MSVProcedimientoApi.class).buscaProcedimientoDelContrato(dtoBusqueda);
				} catch (Exception e) {
					callBack.onError(token, input, "El número del contrato no es válido");
					error=true;
				}
			}
			
			if (!error) {
				if (!Checks.esNulo(procedimiento)) {
					try {
						proxyFactory.proxy(MSVEnvioImpresionApi.class).envioImpresion(procedimiento, fechaImpresion, tipoDocumentacion);
					} catch (RecoveryBPMfwkError e) {
						// No hacemos nada: simplemente no se envía a imprimir					
						callBack.onError(token, input, "Ha habido un error al enviar a imprimir: "+e.getMessage());
						error=true;
						e.printStackTrace();
					}
				} else {
					//TODO - enviar error "No se ha encontrado ningún procedimiento";
					callBack.onError(token, input, "No se ha encontrado ningún procedimiento");
					error=true;
				}
			}
		}
		
		callBack.onEndProcess(token);
		
		return true;
	}

	private Long obtenerIdTipoProcedimiento(String codigoProc) {
		TipoProcedimiento tipoProc = genericDao.get(TipoProcedimiento.class, 
				genericDao.createFilter(FilterType.EQUALS, "codigo", codigoProc));
		if (tipoProc != null) {
			return tipoProc.getId();
		} else {
			return null;
		}
	}

	
	/**
	 * 
	 * @param valorCelda
	 * @param tipoProcedimiento
	 * @return
	 */
	@SuppressWarnings("unused")
	@Deprecated
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
				if (p.getAsunto() != null && p.getAuditoria().isBorrado() != false &&
						p.getTipoProcedimiento().getId()==tipoProcedimiento) {
					break;
				}
			}
		}
		return p;
	}
}
