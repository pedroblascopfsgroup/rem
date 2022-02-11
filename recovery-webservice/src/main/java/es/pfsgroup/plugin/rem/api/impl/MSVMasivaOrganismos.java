package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.direccion.model.DDComunidadAutonoma;
import es.capgemini.pfs.users.domain.Usuario;
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
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.GastoApi;
import es.pfsgroup.plugin.rem.api.GastoProveedorApi;
import es.pfsgroup.plugin.rem.api.impl.MSVAltaBBVAExcelValidator.COL_NUM;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoBbvaActivos;
import es.pfsgroup.plugin.rem.model.ActivoDeudoresAcreditados;
import es.pfsgroup.plugin.rem.model.ActivoInfAdministrativa;
import es.pfsgroup.plugin.rem.model.Albaran;
import es.pfsgroup.plugin.rem.model.DtoAltaActivoThirdParty;
import es.pfsgroup.plugin.rem.model.GastoDetalleEconomico;
import es.pfsgroup.plugin.rem.model.GastoInfoContabilidad;
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.plugin.rem.model.Organismos;
import es.pfsgroup.plugin.rem.model.PerimetroActivo;
import es.pfsgroup.plugin.rem.model.Prefactura;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoAdmision;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoGasto;
import es.pfsgroup.plugin.rem.model.dd.DDOrganismos;
import es.pfsgroup.plugin.rem.model.dd.DDPromocionBBVA;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.model.dd.DDTAUTipoActuacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAlta;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDeDocumento;
import es.pfsgroup.plugin.rem.model.dd.DDTipoSegmento;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTransmision;
import es.pfsgroup.plugin.rem.model.dd.DDTipoVpo;
import es.pfsgroup.plugin.rem.service.AltaActivoThirdPartyService;

@Component
public class MSVMasivaOrganismos extends AbstractMSVActualizador {

	public static final class COL_NUM {
		static final Integer NUM_ACTIVO_HAYA = 0;
		static final Integer COD_ORGANISMO = 1;
		static final Integer COD_COMUNIDAD_AUTONOMA = 2;
		static final Integer FECHA = 3;
		static final Integer COD_ACTUACION = 4;
	}
	

	@Autowired
	ProcessAdapter processAdapter;

	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
 	private GenericAdapter genericAdapter;

	@Autowired
	private ActivoApi activoApi;



	protected static final Log logger = LogFactory.getLog(MSVMasivaOrganismos.class);

	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_DE_ORGANISMOS;
	}

	@Override
	@Transactional(readOnly = false)
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken)
			throws IOException, ParseException, JsonViewerException, SQLException, Exception {
		ResultadoProcesarFila resultado = new ResultadoProcesarFila();

		final String celdaNumActivo = exc.dameCelda(fila, COL_NUM.NUM_ACTIVO_HAYA);
		final String celdaCodOrganismo = exc.dameCelda(fila, COL_NUM.COD_ORGANISMO);
		final String celdaCodComunidadAutonoma = exc.dameCelda(fila, COL_NUM.COD_COMUNIDAD_AUTONOMA);
		final String celdaFecha = exc.dameCelda(fila, COL_NUM.FECHA);
		final String celdaCodActuacion = exc.dameCelda(fila, COL_NUM.COD_ACTUACION);
		
		try {
			
			Activo activo = activoApi.getByNumActivo(Long.parseLong(celdaNumActivo));
			
			Organismos organismo = new Organismos();

			Filter filtroDdOrganismos = genericDao.createFilter(FilterType.EQUALS, "codigo", celdaCodOrganismo);
			DDOrganismos tipoOrganismo = genericDao.get(DDOrganismos.class, filtroDdOrganismos);
			
			Filter filtroDdComunidadesAutonomas = genericDao.createFilter(FilterType.EQUALS, "codigo", celdaCodComunidadAutonoma);
			DDComunidadAutonoma comunidadAutonoma = genericDao.get(DDComunidadAutonoma.class, filtroDdComunidadesAutonomas);
			
			Filter filtroDdActuaciones = genericDao.createFilter(FilterType.EQUALS, "codigo", celdaCodActuacion);
			DDTAUTipoActuacion tipoActuacion = genericDao.get(DDTAUTipoActuacion.class, filtroDdActuaciones);
			
			if(activo != null) {		
				organismo.setActivo(activo);
				organismo.setOrganismo(tipoOrganismo);
				organismo.setComunidad(comunidadAutonoma);
				organismo.setTipoActuacion(tipoActuacion);
				organismo.setFechaOrganismo(obtenerDateExcel(celdaFecha));
				organismo.setAuditoria(Auditoria.getNewInstance());
				
			}
			
			genericDao.save(Organismos.class, organismo);
			
			return resultado;
		}catch (Exception e) {
			throw new JsonViewerException(e.getMessage());
		}
	}
	
	private Date obtenerDateExcel(String celdaExcel) {
		if (Checks.esNulo(celdaExcel)) {
			return null;
		}

		SimpleDateFormat ft = new SimpleDateFormat("dd/MM/yy");
		Date fecha = null;

		try {
			fecha = ft.parse(celdaExcel);
		} catch (ParseException e) {
			e.printStackTrace();
		}

		return fecha;
	}

}
