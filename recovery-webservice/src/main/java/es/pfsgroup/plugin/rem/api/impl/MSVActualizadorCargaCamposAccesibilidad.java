package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.framework.paradise.bulkUpload.adapter.ProcessAdapter;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.impl.MSVSDocAdministrativaProcesar.COL_NUM;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAdmisionDocumento;
import es.pfsgroup.plugin.rem.model.ActivoConfigDocumento;
import es.pfsgroup.plugin.rem.model.ActivoSituacionPosesoria;
import es.pfsgroup.plugin.rem.model.GastoAsociadoAdquisicion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoDocumento;
import es.pfsgroup.plugin.rem.model.dd.DDTipoCalificacionEnergetica;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoGastoAsociado;

@Component
public class MSVActualizadorCargaCamposAccesibilidad extends AbstractMSVActualizador implements MSVLiberator {
	private final String VALID_OPERATION = MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_CAMPOS_ACCESIBILIDAD;
	
	public static final class COL_NUM {
		static final int COL_NUM_ACTIVO_HAYA = 0;
		static final int COL_TAPIADO = 1;
		static final int COL_F_TAPIADO = 2;
		static final int COL_PUERTA_ANTIOCUPA = 3;
		static final int COL_F_COLOCACION_PUERTA_ANTIOCUPA = 4;
		static final int COL_ALARMA = 5;
		static final int COL_F_INSTALACION_ALARMA = 6;
		static final int COL_F_DESINSTALACION_ALARMA = 7;
		static final int COL_VIGILANCIA = 8;
		static final int COL_F_INSTALACION_VIGILANCIA= 9;
		static final int COL_F_DESINSTALACION_VIGILANCIA = 10;
	}
	private static final String[] listaValidosPositivos = { "S", "SI" ,"si","Si","01"};
	
	@Autowired
	ProcessAdapter processAdapter;

	@Autowired
	private ActivoApi activoApi;

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private GenericAdapter adapter;

	@Override
	public String getValidOperation() {
		return VALID_OPERATION;
	}

	private int traducirSiNo(String celda) {
		if(celda != null && Arrays.asList(listaValidosPositivos).contains(celda)) {
			return 1;
		}
		
		return 0;
	}
	@Override
	@Transactional(readOnly = false)
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken) throws IOException, ParseException {

		final String numActivo = exc.dameCelda(fila, COL_NUM.COL_NUM_ACTIVO_HAYA);		
		final String colTapiado = exc.dameCelda(fila, COL_NUM.COL_TAPIADO);	
		final String colFTapiado = exc.dameCelda(fila, COL_NUM.COL_F_TAPIADO);	
		final String colPuertaAntiocupa = exc.dameCelda(fila, COL_NUM.COL_PUERTA_ANTIOCUPA);	
		final String colFColocacionPuertaAntiocupa = exc.dameCelda(fila, COL_NUM.COL_F_COLOCACION_PUERTA_ANTIOCUPA);	
		final String colConAlarma = exc.dameCelda(fila, COL_NUM.COL_ALARMA);	
		final String colFInstalacionAlarma = exc.dameCelda(fila, COL_NUM.COL_F_INSTALACION_ALARMA);	
		final String colFDesinstalacionAlarma = exc.dameCelda(fila, COL_NUM.COL_F_DESINSTALACION_ALARMA);	
		final String colConVigilancia = exc.dameCelda(fila, COL_NUM.COL_VIGILANCIA);	
		final String colFInstalacionVigilancia = exc.dameCelda(fila, COL_NUM.COL_F_INSTALACION_VIGILANCIA);	
		final String colFDesinstalacionVigilancia = exc.dameCelda(fila, COL_NUM.COL_F_DESINSTALACION_VIGILANCIA);	
		
		
			
		SimpleDateFormat formato = new SimpleDateFormat("dd/MM/yyyy");
		
		Activo activo = activoApi.getByNumActivo(Long.parseLong(numActivo));
		Filter filtroActivoSitPosesoria  = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
		ActivoSituacionPosesoria sitPosesoria = genericDao.get(ActivoSituacionPosesoria.class, filtroActivoSitPosesoria);
				
		if(sitPosesoria!=null) {
			//Tapiado
			if(!colTapiado.isEmpty()) {
				sitPosesoria.setAccesoTapiado(traducirSiNo(colTapiado));
			}
			if(!colFTapiado.isEmpty()) {
				sitPosesoria.setFechaAccesoTapiado(formato.parse(colFTapiado));
			}
			//PuertaAntiocupa
			if(!colPuertaAntiocupa.isEmpty()) {
				sitPosesoria.setAccesoAntiocupa(traducirSiNo(colPuertaAntiocupa));
			}
			if(!colFColocacionPuertaAntiocupa.isEmpty()) {
				sitPosesoria.setFechaAccesoAntiocupa(formato.parse(colFColocacionPuertaAntiocupa));
			}
			//ALARMA
			if(!colConAlarma.isEmpty() && colConAlarma!=null) {
				sitPosesoria.setConAlarma(traducirSiNo(colConAlarma));	
			}
			if(!colFInstalacionAlarma.isEmpty() && colFInstalacionAlarma!=null) {
				sitPosesoria.setFechaInstalacionAlarma(formato.parse(colFInstalacionAlarma));
			}
			if(!colFDesinstalacionAlarma.isEmpty() && colFDesinstalacionAlarma!=null) {
				sitPosesoria.setFechaDesinstalacionAlarma(formato.parse(colFDesinstalacionAlarma));
			}
			
			//VIGILANCIA
			if(!colConVigilancia.isEmpty() && colConVigilancia!=null) {
				sitPosesoria.setConVigilancia(traducirSiNo(colConVigilancia));	
			}
			if(!colFInstalacionVigilancia.isEmpty() && colFInstalacionVigilancia!=null) {
				sitPosesoria.setFechaInstalacionVigilancia(formato.parse(colFInstalacionVigilancia));
			}
			if(!colFDesinstalacionVigilancia.isEmpty() && colFDesinstalacionVigilancia!=null){
				sitPosesoria.setFechaDesinstalacionVigilancia(formato.parse(colFDesinstalacionVigilancia));
			}
			
		}
	
						
	
		
		genericDao.save(ActivoSituacionPosesoria.class, sitPosesoria);
		return new ResultadoProcesarFila();		
	}

}


