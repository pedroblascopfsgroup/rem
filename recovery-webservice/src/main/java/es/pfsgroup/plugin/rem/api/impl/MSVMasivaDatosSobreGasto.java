package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

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
import es.pfsgroup.plugin.rem.model.Albaran;
import es.pfsgroup.plugin.rem.model.GastoDetalleEconomico;
import es.pfsgroup.plugin.rem.model.GastoInfoContabilidad;
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.plugin.rem.model.Prefactura;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoGasto;

@Component
public class MSVMasivaDatosSobreGasto extends AbstractMSVActualizador {

	private static final Integer COL_ID_GASTO = 0;
	private static final Integer COL_ENTIDAD = 1;
	private static final Integer COL_FECHA_CONTA = 2;
	private static final Integer COL_FECHA_PAGO = 3;
	private final String NOMENGLATURA_GASTO_UNO = "G";
	private final String NOMENGLATURA_GASTO_DOS = "Gasto";
	private final String NOMENGLATURA_PREFACTURA_DOS = "Prefactura";
	private final String NOMENGLATURA_PREFACTURA_UNO = "P";
	private final String NOMENGLATURA_ALBARAN_UNO = "Albarán";
	private final String NOMENGLATURA_ALBARAN_DOS = "Albaran";
	private final String NOMENGLATURA_ALBARAN_TRES = "A";
	private final String NOMENCLATURA_PROVISION_UNO = "Pro";
	private final String NOMENCLATURA_PROVISION_DOS = "Provisión";
	private final String NOMENCLATURA_PROVISION_TRES = "Provision";
	private String fechaConta;
	private String fechaPago;


	private final String BORRAR = "X";
	

	@Autowired
	ProcessAdapter processAdapter;

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
		
		try {
			String entidad = exc.dameCelda(fila, COL_ENTIDAD);
			if(NOMENGLATURA_GASTO_UNO.equalsIgnoreCase(entidad) || NOMENGLATURA_GASTO_DOS.equalsIgnoreCase(entidad)) {
				Filter filter = genericDao.createFilter(FilterType.EQUALS, "numGastoHaya", Long.parseLong(exc.dameCelda(fila, COL_ID_GASTO)));
				salvarGastos(filter,exc,fila);
			}else if(NOMENGLATURA_PREFACTURA_UNO.equalsIgnoreCase(entidad) || NOMENGLATURA_PREFACTURA_DOS.equalsIgnoreCase(entidad)) {
				Filter filter = genericDao.createFilter(FilterType.EQUALS, "prefactura.numPrefactura", Long.parseLong(exc.dameCelda(fila, COL_ID_GASTO)));
				salvarGastos(filter,exc,fila);
			}else if(NOMENGLATURA_ALBARAN_DOS.equalsIgnoreCase(entidad) || NOMENGLATURA_ALBARAN_UNO.equalsIgnoreCase(entidad) || NOMENGLATURA_ALBARAN_TRES.equalsIgnoreCase(entidad)) {
				List<Prefactura> listaPrefactura = genericDao.getList(Prefactura.class, genericDao.createFilter(FilterType.EQUALS, "albaran.numAlbaran", Long.parseLong(exc.dameCelda(fila, COL_ID_GASTO))));
				for (Prefactura prefactura : listaPrefactura) {
					Filter filter = genericDao.createFilter(FilterType.EQUALS, "prefactura.numPrefactura", prefactura.getNumPrefactura());
					salvarGastos(filter,exc,fila);
				}
			} else if (NOMENCLATURA_PROVISION_UNO.equalsIgnoreCase(entidad) || NOMENCLATURA_PROVISION_DOS.equalsIgnoreCase(entidad) || NOMENCLATURA_PROVISION_TRES.equalsIgnoreCase(entidad)) {
				Filter filter = genericDao.createFilter(FilterType.EQUALS, "provision.numProvision", Long.parseLong(exc.dameCelda(fila, COL_ID_GASTO)));
				salvarGastos(filter,exc,fila);
			}
			
		} catch (Exception e) {
			throw new JsonViewerException(e.getMessage());
		}
		return resultado;
	}
	
	private void salvarGastos(Filter filter,MSVHojaExcel exc, int fila) {
		SimpleDateFormat format = new SimpleDateFormat("dd/MM/yyyy");
		String usuarioModificar = genericAdapter.getUsuarioLogado().getUsername();
		Date fechaModificar = new Date();
		List<GastoProveedor> gastos = genericDao.getList(GastoProveedor.class, filter);
//		GastoProveedor gasto = genericDao.get(GastoProveedor.class, filter);
		boolean cambioGic = false;
		boolean cambioGde = false;
		try {
			for (GastoProveedor gasto : gastos) {
				if(gasto != null) {
					cambioGic = false;
					cambioGde = false;
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
			}
			
		}catch (Exception e) {
			throw new JsonViewerException(e.getMessage());
		}
		
	}

}
