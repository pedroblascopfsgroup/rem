package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;

import es.pfsgroup.framework.paradise.bulkUpload.adapter.ProcessAdapter;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.adapter.AgrupacionAdapter;
import es.pfsgroup.plugin.rem.api.ActivoAgrupacionApi;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;

@Component
public class MSVAgruparActivosRestringido extends AbstractMSVActualizador implements MSVLiberator {

	private static final Integer COL_ID_ACTIVO_AUX = 1;

	@Autowired
	private ActivoApi activoApi;

	
	@Autowired
	AgrupacionAdapter agrupacionAdapter;

	@Autowired
	ProcessAdapter processAdapter;

	@Autowired
	ActivoAgrupacionApi activoAgrupacionApi;

	@Resource(name = "entityTransactionManager")
	private PlatformTransactionManager transactionManager;
	
	@Autowired
	private ActivoAdapter activoAdapter;

	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_AGRUPATION_RESTRICTED;
	}
	
	protected static final Log logger = LogFactory.getLog(MSVAgruparActivosRestringido.class);

	@Override
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken)
			throws IOException, ParseException, JsonViewerException, SQLException {
		ResultadoProcesarFila resultado = new ResultadoProcesarFila();
		try {
			Long agrupationId = activoAgrupacionApi.getAgrupacionIdByNumAgrupRem(new Long(exc.dameCelda(fila, 0)));
			agrupacionAdapter.createActivoAgrupacionMasivo(new Long(exc.dameCelda(fila, 1)), agrupationId,
					new Integer(exc.dameCelda(fila, 2)), false);
		} catch (Exception e) {
			throw new JsonViewerException(e.getMessage());
		}
		return resultado;
	}
	
	@Override
	public void postProcesado(MSVHojaExcel exc) throws Exception {
		TransactionStatus transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
		Integer numFilas = exc.getNumeroFilas();
		ArrayList<Long> idList = new ArrayList<Long>();
		try{
			for (int fila = this.getFilaInicial(); fila < numFilas; fila++) {
				Activo activo = activoApi.getByNumActivo(Long.parseLong(exc.dameCelda(fila, COL_ID_ACTIVO_AUX)));
				idList.add(activo.getId());
			}
			activoAdapter.actualizarEstadoPublicacionActivo(idList, true);
			transactionManager.commit(transaction);
		}catch(Exception e){
			transactionManager.rollback(transaction);
			throw e;
		}
		
	}

}
