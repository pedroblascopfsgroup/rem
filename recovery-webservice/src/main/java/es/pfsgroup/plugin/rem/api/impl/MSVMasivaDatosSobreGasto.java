package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.framework.paradise.bulkUpload.adapter.ProcessAdapter;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.api.GastoApi;
import es.pfsgroup.plugin.rem.api.GastoProveedorApi;
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoGasto;
import es.pfsgroup.plugin.rem.updaterstate.UpdaterStateGastoApi;

@Component
public class MSVMasivaDatosSobreGasto extends AbstractMSVActualizador {

	private static final Integer COL_ID_GASTO = 0;
	private static final Integer COL_FECHA_CONTA = 1;
	private static final Integer COL_FECHA_PAGO = 2;
	private String fechaConta;
	private String fechaPago;

	@Autowired
	ProcessAdapter processAdapter;

	@Autowired
	private GastoApi gastoApi;

	@Autowired
	private GastoProveedorApi gastoProveedorManager;

	@Autowired
	private UpdaterStateGastoApi updaterStateApi;

	protected static final Log logger = LogFactory.getLog(MSVMasivaDatosSobreGasto.class);

	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_SOBRE_GASTOS;
	}

	@Override
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken)
			throws IOException, ParseException, JsonViewerException, SQLException, Exception {
		ResultadoProcesarFila resultado = new ResultadoProcesarFila();
		SimpleDateFormat format = new SimpleDateFormat("dd/MM/yyyy");
		try {

			GastoProveedor gasto = gastoApi.getByNumGasto(Long.parseLong(exc.dameCelda(fila, COL_ID_GASTO)));
			fechaConta = exc.dameCelda(fila, COL_FECHA_CONTA);
			fechaPago = exc.dameCelda(fila, COL_FECHA_PAGO);
			
			if (!Checks.esNulo(fechaConta)) {
				gasto.getGastoInfoContabilidad().setFechaContabilizacion(format.parse(fechaConta));
				
				if (!gasto.getEstadoGasto().getCodigo().contentEquals(DDEstadoGasto.PAGADO)) {
					updaterStateApi.updaterStates(gasto, DDEstadoGasto.CONTABILIZADO);
				}		
			
			} else if (!Checks.esNulo(fechaPago)) {
				gasto.getGastoDetalleEconomico().setFechaPago(format.parse(fechaPago));
				updaterStateApi.updaterStates(gasto, DDEstadoGasto.PAGADO);
			}

		} catch (Exception e) {
			throw new JsonViewerException(e.getMessage());
		}
		return resultado;
	}

}
