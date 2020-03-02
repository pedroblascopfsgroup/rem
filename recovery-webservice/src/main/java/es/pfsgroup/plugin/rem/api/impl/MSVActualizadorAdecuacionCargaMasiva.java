package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.text.ParseException;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoPatrimonioDao;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
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

	@Autowired
	private ActivoAdapter activoAdapter;
	
	protected static final Log logger = LogFactory.getLog(MSVActualizadorAdecuacionCargaMasiva.class);

	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_VALIDADOR_CARGA_MASIVA_ADECUACION;
	}

	@Override
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken)
			throws IOException, ParseException {
		ResultadoProcesarFila resultado = new ResultadoProcesarFila();
		try {
			String valorAdecuacion = exc.dameCelda(fila, COL_ADECUACION);
			Activo activo = activoDao.getActivoByNumActivo(Long.parseLong(exc.dameCelda(fila, COL_NUM_ACTIVO)));

			ActivoPatrimonio activoPatrimonio = activoPatrimonioDao.getActivoPatrimonioByActivo(activo.getId());

			if ((valorAdecuacion.equalsIgnoreCase("S")) || (valorAdecuacion.equalsIgnoreCase("SI"))) {
				activoPatrimonio.setAdecuacionAlquiler((DDAdecuacionAlquiler) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDAdecuacionAlquiler.class, DDAdecuacionAlquiler.CODIGO_ADA_SI));
			} else if ((valorAdecuacion.equalsIgnoreCase("N")) || (valorAdecuacion.equalsIgnoreCase("NO"))) {
				activoPatrimonio.setAdecuacionAlquiler((DDAdecuacionAlquiler) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDAdecuacionAlquiler.class, DDAdecuacionAlquiler.CODIGO_ADA_NO));
			} else if (valorAdecuacion.equalsIgnoreCase("NA")) {
				activoPatrimonio.setAdecuacionAlquiler(
						(DDAdecuacionAlquiler) utilDiccionarioApi.dameValorDiccionarioByCod(DDAdecuacionAlquiler.class,
								DDAdecuacionAlquiler.CODIGO_ADA_NO_APLICA));
			} else if(valorAdecuacion.equalsIgnoreCase("EP")){
				activoPatrimonio.setAdecuacionAlquiler((DDAdecuacionAlquiler) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDAdecuacionAlquiler.class, DDAdecuacionAlquiler.CODIGO_ADA_EN_PROCESO));
			} else {
				activoPatrimonio.setAdecuacionAlquiler((DDAdecuacionAlquiler) utilDiccionarioApi
						.dameValorDiccionarioByCod(DDAdecuacionAlquiler.class, DDAdecuacionAlquiler.CODIGO_ADA_NULO));
			}

			activoPatrimonioDao.save(activoPatrimonio);

			this.actualizarEstadoPublicacion(activo);
		} catch (Exception e) {
			throw new JsonViewerException(e.getMessage());
		}
		return resultado;

	}

	// HREOS-5433. Los registros de la fila son correctos. Se lanza el
	// SP_CAMBIO_ESTADO_PUBLICACION.
	private void actualizarEstadoPublicacion(Activo activo) {
		@SuppressWarnings("unused")
		boolean result = activoAdapter.actualizarEstadoPublicacionActivo(activo.getId());
	}
}
