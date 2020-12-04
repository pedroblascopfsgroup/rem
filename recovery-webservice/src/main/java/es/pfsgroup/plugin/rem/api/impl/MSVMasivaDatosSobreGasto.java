package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.adapter.ProcessAdapter;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.GastoApi;
import es.pfsgroup.plugin.rem.api.GastoProveedorApi;
import es.pfsgroup.plugin.rem.model.GastoDetalleEconomico;
import es.pfsgroup.plugin.rem.model.GastoInfoContabilidad;
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoGasto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPrecio;
import es.pfsgroup.plugin.rem.updaterstate.UpdaterStateGastoApi;

@Component
public class MSVMasivaDatosSobreGasto extends AbstractMSVActualizador {

	private static final Integer COL_ID_GASTO = 0;
	private static final Integer COL_FECHA_CONTA = 1;
	private static final Integer COL_FECHA_PAGO = 2;
	private String fechaConta;
	private String fechaPago;

	private final String BORRAR = "X";
	
	@Autowired
	ProcessAdapter processAdapter;

	@Autowired
	private GastoApi gastoApi;

	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
 	private GenericAdapter genericAdapter;

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
		String usuarioModificar = genericAdapter.getUsuarioLogado().getUsername();
		Date fechaModificar = new Date();
		
		try {
			Filter filter = genericDao.createFilter(FilterType.EQUALS, "numGastoHaya", Long.parseLong(exc.dameCelda(fila, COL_ID_GASTO)));
			GastoProveedor gasto = genericDao.get(GastoProveedor.class, filter);
			boolean cambioGic = false;
			boolean cambioGde = false;
			if(gasto != null) {
				fechaConta = exc.dameCelda(fila, COL_FECHA_CONTA);
				fechaPago = exc.dameCelda(fila, COL_FECHA_PAGO);
				
				if(!Checks.esNulo(fechaConta)) {
					cambioGic = true;
					if(BORRAR.equalsIgnoreCase(fechaConta)) {
						gasto.getGastoInfoContabilidad().setFechaContabilizacion(null);
						
					}else {
						gasto.getGastoInfoContabilidad().setFechaContabilizacion(format.parse(fechaConta));
					}
				}	
				
				if(!Checks.esNulo(fechaPago)) {
					cambioGde = true;
					if(BORRAR.equalsIgnoreCase(fechaPago)) {
						gasto.getGastoDetalleEconomico().setFechaPago(null);
						
					}else {
						gasto.getGastoDetalleEconomico().setFechaPago(format.parse(fechaPago));
					}
				}
				
				if(gasto.getGastoDetalleEconomico().getFechaPago() != null) {
					DDEstadoGasto nuevoEstado = (DDEstadoGasto) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoGasto.class, DDEstadoGasto.PAGADO);
					gasto.setEstadoGasto(nuevoEstado);
				}else if(gasto.getGastoInfoContabilidad().getFechaContabilizacion() != null){
					DDEstadoGasto nuevoEstado = (DDEstadoGasto) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoGasto.class, DDEstadoGasto.CONTABILIZADO);
					gasto.setEstadoGasto(nuevoEstado);
				}else {
					DDEstadoGasto nuevoEstado = (DDEstadoGasto) utilDiccionarioApi.dameValorDiccionarioByCod(DDEstadoGasto.class, DDEstadoGasto.AUTORIZADO_ADMINISTRACION);
					gasto.setEstadoGasto(nuevoEstado);
				}
				
				
				if(cambioGde) {
					gasto.getGastoDetalleEconomico().getAuditoria().setUsuarioModificar(usuarioModificar);
					gasto.getGastoDetalleEconomico().getAuditoria().setFechaModificar(fechaModificar);

					genericDao.save(GastoDetalleEconomico.class, gasto.getGastoDetalleEconomico());
				}
				if(cambioGic) {
					gasto.getGastoInfoContabilidad().getAuditoria().setUsuarioModificar(usuarioModificar);
					gasto.getGastoInfoContabilidad().getAuditoria().setFechaModificar(fechaModificar);
					
					genericDao.save(GastoInfoContabilidad.class, gasto.getGastoInfoContabilidad());
				}
				
				gasto.getAuditoria().setUsuarioModificar(usuarioModificar);
				gasto.getAuditoria().setFechaModificar(fechaModificar);
				
				
				genericDao.save(GastoProveedor.class, gasto);
		
			}
			

		} catch (Exception e) {
			throw new JsonViewerException(e.getMessage());
		}
		return resultado;
	}

}
