package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.model.ActivoTrabajo;
import es.pfsgroup.plugin.rem.model.ConfiguracionTarifa;
import es.pfsgroup.plugin.rem.model.PresupuestoTrabajo;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.TrabajoConfiguracionTarifa;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTarifa;


@Component
public class MSVActualizadorTarifasPresupuestos extends AbstractMSVActualizador {

	private final String VALID_OPERATION = MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_MASIVO_TARIFAS_PRESUPUESTO;

	private final static int COL_NUM_TRABAJO = 0;
	private final static int COL_TIPO_REGISTRO = 1;
	private final static int COL_COD_TARIFA = 2;
	private final static int COL_UNIDADES = 3;
	private final static int COL_COD_PROVEEDOR = 4;
	private final static int COL_REF_PRESUPUESTO = 5;
	private final static int COL_FECHA = 6;
	private final static int COL_IMPORTE = 7;
	private final static String TIPO_TARIFA = "TRF";
	private final static String TIPO_PRESUPUESTO = "PRS";
	protected final Log logger = LogFactory.getLog(getClass());

	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private TrabajoApi trabajoApi;

	@Override
	public String getValidOperation() {
		return VALID_OPERATION;
	}

	@Override
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken)
			throws IOException, ParseException, JsonViewerException, SQLException, Exception {

		String tipoRegistro = exc.dameCelda(fila, COL_TIPO_REGISTRO);
		String numTrabajo = exc.dameCelda(fila, COL_NUM_TRABAJO);
		Trabajo trabajo = trabajoApi.getTrabajoByNumeroTrabajo(Long.valueOf(numTrabajo));
 
		if (TIPO_TARIFA.equals(tipoRegistro)) {

			String codTarifa = exc.dameCelda(fila, COL_COD_TARIFA);
			String unidades = exc.dameCelda(fila, COL_UNIDADES);

			TrabajoConfiguracionTarifa trabajoConfig = new TrabajoConfiguracionTarifa();
			ConfiguracionTarifa configuracionTarifa = getConfigTarifaByCodigoTarifaAndNumTrabajo(codTarifa, trabajo);

			if (configuracionTarifa != null) {
				trabajoConfig.setConfigTarifa(configuracionTarifa);
				trabajoConfig.setTrabajo(trabajo);
				if(configuracionTarifa.getPrecioUnitario() != null) {
					trabajoConfig.setPrecioUnitario(configuracionTarifa.getPrecioUnitario());
				}
				if(configuracionTarifa.getPrecioUnitarioCliente() != null) {
					trabajoConfig.setPrecioUnitarioCliente(configuracionTarifa.getPrecioUnitarioCliente());
				}
				trabajoConfig.setMedicion(Float.valueOf(unidades));
				if (unidades != null && !unidades.isEmpty()) {
					trabajoConfig.setMedicion(Float.parseFloat(unidades));
				}
				genericDao.save(TrabajoConfiguracionTarifa.class, trabajoConfig);
				trabajoApi.actualizarImporteTotalTrabajo(trabajo.getId());
			}

		} else if (TIPO_PRESUPUESTO.equals(tipoRegistro)) {

			// String codProveedor = exc.dameCelda(fila, COL_COD_PROVEEDOR); -> Se puede
			// obtener desde el trabajo ( nos ahorramos una query )
			String refPresupuesto = exc.dameCelda(fila, COL_REF_PRESUPUESTO);
			String fecha = exc.dameCelda(fila, COL_FECHA);
			String importe = exc.dameCelda(fila, COL_IMPORTE);

			PresupuestoTrabajo presupuestoTrabajo = new PresupuestoTrabajo();

			presupuestoTrabajo.setTrabajo(trabajo);
			if (trabajo.getProveedorContacto() != null) {
				presupuestoTrabajo.setProveedorContacto(trabajo.getProveedorContacto());
				presupuestoTrabajo.setProveedor(trabajo.getProveedorContacto().getProveedor());
				presupuestoTrabajo.setRefPresupuestoProveedor(refPresupuesto);
				if (fecha != null && !fecha.isEmpty()) {
					presupuestoTrabajo.setFecha(new SimpleDateFormat("dd/MM/yyyy").parse(fecha));
				}
				if (importe != null && !importe.isEmpty()) {
					presupuestoTrabajo.setImporte(Double.parseDouble(importe));
				}
				genericDao.save(PresupuestoTrabajo.class, presupuestoTrabajo);
				trabajoApi.actualizarImporteTotalTrabajo(trabajo.getId());
			}

		}

		return new ResultadoProcesarFila();
	}

	private ConfiguracionTarifa getConfigTarifaByCodigoTarifaAndNumTrabajo(String codTarifa, Trabajo trabajo) {
		Long idCartera = null;
		Long idSubcartera = null;
		//Long idSubtipoTrabajo = null;
		//Long idTipoTrabajo = null;
		Long idTipoTarifa = null;

//		if (trabajo.getTipoTrabajo() != null) {
//			idTipoTrabajo = trabajo.getTipoTrabajo().getId();
//
//			if (trabajo.getSubtipoTrabajo() != null) {
//				idSubtipoTrabajo = trabajo.getSubtipoTrabajo().getId();
//			}
//		}

		DDTipoTarifa tipoTarifa = genericDao.get(DDTipoTarifa.class,
				genericDao.createFilter(FilterType.EQUALS, "codigo", codTarifa));
		if (tipoTarifa != null) {
			idTipoTarifa = tipoTarifa.getId();
		}

		if (trabajo.getActivo() != null) {
			idCartera = trabajo.getActivo().getCartera().getId();
			idSubcartera = trabajo.getActivo().getSubcartera().getId();
		} else {
			List<ActivoTrabajo> activosTrabajo = genericDao.getList(ActivoTrabajo.class,
					genericDao.createFilter(FilterType.EQUALS, "trabajo.id", trabajo.getId()));
			if (activosTrabajo != null && activosTrabajo.get(0) != null && activosTrabajo.get(0).getActivo() != null) {
				idCartera = activosTrabajo.get(0).getActivo().getCartera().getId();
				idSubcartera = activosTrabajo.get(0).getActivo().getSubcartera().getId();
			}
		}

		return getConfiguracionTarifa(idTipoTarifa, idCartera, idSubcartera, trabajo);
	}

	private ConfiguracionTarifa getConfiguracionTarifa(Long idTipoTarifa, Long idCartera, Long idSubcartera, Trabajo trabajo) {

		if (idCartera != null && idTipoTarifa != null && idSubcartera != null && trabajo.getTipoTrabajo() != null && trabajo.getSubtipoTrabajo() != null) {
			Filter fCartera = genericDao.createFilter(FilterType.EQUALS, "cartera.id", idCartera);
			Filter fTipoTarifa = genericDao.createFilter(FilterType.EQUALS, "tipoTarifa.id", idTipoTarifa);
			Filter fSubcartera = genericDao.createFilter(FilterType.EQUALS, "subcartera.id", idSubcartera);
			Filter fTipoTrabajo = genericDao.createFilter(FilterType.EQUALS, "tipoTrabajo.id", trabajo.getTipoTrabajo().getId());
			Filter fSubtipoTrabajo = genericDao.createFilter(FilterType.EQUALS, "subtipoTrabajo.id", trabajo.getSubtipoTrabajo().getId());
			Filter fProveedor;
			
			ConfiguracionTarifa  cfg = null; 
			if(trabajo.getProveedorContacto() != null) {
				fProveedor = genericDao.createFilter(FilterType.EQUALS, "proveedor.id", trabajo.getProveedorContacto().getId());
				cfg = genericDao.get(ConfiguracionTarifa.class, fCartera, fTipoTarifa, fSubcartera, fTipoTrabajo, fSubtipoTrabajo, fProveedor);
			}
			
			
			if( cfg == null) {
				fProveedor = genericDao.createFilter(FilterType.NULL, "proveedor.id");
				List<ConfiguracionTarifa> cfgList = genericDao.getList(ConfiguracionTarifa.class, fCartera, fTipoTarifa, fSubcartera, fTipoTrabajo, fSubtipoTrabajo, fProveedor);
				if(cfgList == null || cfgList.isEmpty()) {
					fSubcartera = genericDao.createFilter(FilterType.NULL, "subcartera.id");
					cfgList = genericDao.getList(ConfiguracionTarifa.class, fCartera, fTipoTarifa, fTipoTrabajo, fSubtipoTrabajo, fProveedor);
					if(cfgList != null && !cfgList.isEmpty() ) {
						cfg = cfgList.get(0);
					}
				}else {
					if(cfgList != null && !cfgList.isEmpty()) {
						cfg = cfgList.get(0);
					}
				}
			}
			return cfg;
		}
		return null;
	}

}
