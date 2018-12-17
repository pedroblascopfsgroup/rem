package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.text.ParseException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoPatrimonioDao;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoPatrimonio;
import es.pfsgroup.plugin.rem.model.dd.DDAdecuacionAlquiler;


@Component
public class MSVActualizadorAdecuacionCargaMasiva extends AbstractMSVActualizador implements MSVLiberator {
	
	private static final Integer COL_NUM_ACTIVO = 0;
	private static final Integer COL_ADECUACION = 1;
	
	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;
	
	@Autowired
	private ActivoDao activoDao;
	
	@Autowired
	private ActivoPatrimonioDao activoPatrimonioDao;

	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_VALIDADOR_CARGA_MASIVA_ADECUACION;
	}
	
	@Override	
	@Transactional(readOnly = false)
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken) throws IOException, ParseException {
		String valorAdecuacion = exc.dameCelda(fila, COL_ADECUACION);
		Activo activo = activoDao.getActivoByNumActivo(Long.parseLong( exc.dameCelda(fila, COL_NUM_ACTIVO)));
		
		ActivoPatrimonio activoPatrimonio = activoPatrimonioDao.getActivoPatrimonioByActivo(activo.getId());
		
		if((valorAdecuacion.equalsIgnoreCase("S")) || (valorAdecuacion.equalsIgnoreCase("SI"))){
			activoPatrimonio.setAdecuacionAlquiler( (DDAdecuacionAlquiler) utilDiccionarioApi.dameValorDiccionarioByCod(DDAdecuacionAlquiler.class, DDAdecuacionAlquiler.CODIGO_ADA_SI ));
		}		   
		else if((valorAdecuacion.equalsIgnoreCase("N")) || (valorAdecuacion.equalsIgnoreCase("NO"))) {
			activoPatrimonio.setAdecuacionAlquiler( (DDAdecuacionAlquiler) utilDiccionarioApi.dameValorDiccionarioByCod(DDAdecuacionAlquiler.class, DDAdecuacionAlquiler.CODIGO_ADA_NO ));
		}
		else if(valorAdecuacion.equalsIgnoreCase("NA"))  {
			activoPatrimonio.setAdecuacionAlquiler( (DDAdecuacionAlquiler) utilDiccionarioApi.dameValorDiccionarioByCod(DDAdecuacionAlquiler.class, DDAdecuacionAlquiler.CODIGO_ADA_NO_APLICA ));
		}
		else {
			activoPatrimonio.setAdecuacionAlquiler( (DDAdecuacionAlquiler) utilDiccionarioApi.dameValorDiccionarioByCod(DDAdecuacionAlquiler.class, DDAdecuacionAlquiler.CODIGO_ADA_NULO));
		}
		
		activoPatrimonioDao.save(activoPatrimonio);

		return new ResultadoProcesarFila();
	}
	
	
}
