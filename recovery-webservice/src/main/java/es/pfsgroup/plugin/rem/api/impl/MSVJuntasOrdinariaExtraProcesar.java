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
import org.springframework.transaction.annotation.Transactional;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.api.ParticularValidatorApi;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoJuntaPropietarios;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDJuntaComunidades;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;


@Component
public class MSVJuntasOrdinariaExtraProcesar extends AbstractMSVActualizador implements MSVLiberator {

	@Autowired
	private ActivoApi activoApi;

	@Autowired
	private GenericABMDao genericDao;
		
	@Autowired
	private ParticularValidatorApi particularValidator;

	protected static final Log logger = LogFactory.getLog(MSVJuntasOrdinariaExtraProcesar.class);
	
	public static final class COL_NUM {
		static final int FILA_CABECERA = 0;
		static final int DATOS_PRIMERA_FILA = 1;
		
		static final int COL_NUM_FECHA_JUNTA = 0;
		static final int COL_NUM_COMUNIDAD = 1;
		static final int COL_NUM_ID_ACTIVO_HAYA = 2;
		static final int COL_NUM_PORCENTAJE_PARTICIPACION = 3;
		static final int COL_NUM_PROMOCION_50 = 4;
		static final int COL_NUM_PREJUICIO_ECONOMICO = 5;
		static final int COL_NUM_JGO_JE = 6;
		static final int COL_NUM_ACT_JUDIC = 7;
		static final int COL_NUM_MOD_ESTATUTOS = 8;
		static final int COL_NUM_ITE = 9;
		static final int COL_NUM_MOROSOS = 10;
		static final int COL_NUM_MOD_CUOTA = 11;
		static final int COL_NUM_OTROS = 12;
		static final int COL_NUM_IMPORTE = 13;
		static final int COL_NUM_CUOTA_ORDINARIA = 14;
		static final int COL_NUM_CUOTA_EXTRA = 15;
		static final int COL_NUM_SUMINISTROS = 16;
		static final int COL_NUM_PROPUESTA = 17;
		static final int COL_NUM_GUION_VOTO = 18;
		static final int COL_NUM_INDICACIONES = 19;
		static final int COL_NUM_ACCION = 20;
	}
	
	private static final String DD_ACM_DEL = "02";
	private static final String COD_SI = "S";

	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_JUNTAS;
	}

	@Override
	@Transactional(readOnly = false)
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken)
			throws IOException, ParseException, JsonViewerException, SQLException, Exception {

		Activo activo;
		DDJuntaComunidades ddJunta = new DDJuntaComunidades();
		ActivoJuntaPropietarios activoJuntaPropietarios = new ActivoJuntaPropietarios();
		ActivoProveedor activoProveedor = new ActivoProveedor();
		
		String celdaFechaJunta = exc.dameCelda(fila, COL_NUM.COL_NUM_FECHA_JUNTA);
		String celdaComunidad = exc.dameCelda(fila, COL_NUM.COL_NUM_COMUNIDAD);
		String celdaActivoHaya = exc.dameCelda(fila, COL_NUM.COL_NUM_ID_ACTIVO_HAYA);
		String celdaParticipacion = exc.dameCelda(fila, COL_NUM.COL_NUM_PORCENTAJE_PARTICIPACION);
		String celdaPromocion = exc.dameCelda(fila, COL_NUM.COL_NUM_PROMOCION_50);
		String celdaPrejEconomico = exc.dameCelda(fila, COL_NUM.COL_NUM_PREJUICIO_ECONOMICO);
		String celdaJGOJE = exc.dameCelda(fila, COL_NUM.COL_NUM_JGO_JE);
		String celdaActJudic = exc.dameCelda(fila, COL_NUM.COL_NUM_ACT_JUDIC);
		String celdaEstatutos = exc.dameCelda(fila, COL_NUM.COL_NUM_MOD_ESTATUTOS);
		String celdaITE = exc.dameCelda(fila, COL_NUM.COL_NUM_ITE);
		String celdaMorosos = exc.dameCelda(fila, COL_NUM.COL_NUM_MOROSOS);
		String celdaCuota = exc.dameCelda(fila, COL_NUM.COL_NUM_MOD_CUOTA);
		String celdaOtros = exc.dameCelda(fila, COL_NUM.COL_NUM_OTROS);
		String celdaImporte = exc.dameCelda(fila, COL_NUM.COL_NUM_IMPORTE);
		String celdaCuotaOrd = exc.dameCelda(fila, COL_NUM.COL_NUM_CUOTA_ORDINARIA);
		String celdaCuotaExt = exc.dameCelda(fila, COL_NUM.COL_NUM_CUOTA_EXTRA);
		String celdaSuministros = exc.dameCelda(fila, COL_NUM.COL_NUM_SUMINISTROS);
		String celdaPropuesta = exc.dameCelda(fila, COL_NUM.COL_NUM_PROPUESTA);
		String celdaGuionVoto = exc.dameCelda(fila, COL_NUM.COL_NUM_GUION_VOTO);
		String celdaIndicaciones = exc.dameCelda(fila, COL_NUM.COL_NUM_INDICACIONES);
		String celdaAccion = exc.dameCelda(fila, COL_NUM.COL_NUM_ACCION);
		
		try {
			
			String idActivoJuntas = particularValidator.getActivoJunta(celdaActivoHaya, celdaFechaJunta);
			
			if(!Checks.esNulo(idActivoJuntas)) {
				Filter filtroIdActivoPlusvalia = genericDao.createFilter(FilterType.EQUALS, "id",  Long.parseLong(idActivoJuntas));
				activoJuntaPropietarios = genericDao.get(ActivoJuntaPropietarios.class, filtroIdActivoPlusvalia);
			}
			
			if(DD_ACM_DEL.equals(celdaAccion)) {
				
				if(!Checks.esNulo(activoJuntaPropietarios)) {
					genericDao.deleteById(ActivoJuntaPropietarios.class, activoJuntaPropietarios.getId());
					return new ResultadoProcesarFila();
				}else {
					throw new IllegalArgumentException(
							"MSVJuntasOrdinariaExtraProcesar::ResultadoProcesarFila -> No existe registro del activoJunta para eliminar");
				}
				
			}else{
	
				activo = activoApi.getByNumActivo(Long.parseLong(celdaActivoHaya));
				
				Filter filtroSi = genericDao.createFilter(FilterType.EQUALS, "codigo",  DDSinSiNo.CODIGO_SI);
				Filter filtroNo = genericDao.createFilter(FilterType.EQUALS, "codigo",  DDSinSiNo.CODIGO_NO);
				
				DDSinSiNo ddSi = genericDao.get(DDSinSiNo.class, filtroSi);
				DDSinSiNo ddNo = genericDao.get(DDSinSiNo.class,filtroNo);
				
				activoJuntaPropietarios.setActivo(activo);
				activoJuntaPropietarios.setJudicial(COD_SI.equals(celdaActJudic) ? ddSi : ddNo );
				activoJuntaPropietarios.setMorosos(COD_SI.equals(celdaMorosos) ? ddSi : ddNo );
				activoJuntaPropietarios.setExtra(this.obtenerDoubleExcel(celdaCuotaExt));
				activoJuntaPropietarios.setOrdinaria(this.obtenerDoubleExcel(celdaCuotaOrd));
				activoJuntaPropietarios.setFechaAltaJunta(this.obtenerDateExcel(celdaFechaJunta));
				activoJuntaPropietarios.setVoto(celdaGuionVoto);
				activoJuntaPropietarios.setImporte(this.obtenerDoubleExcel(celdaImporte));
				activoJuntaPropietarios.setIndicaciones(celdaIndicaciones);
				activoJuntaPropietarios.setIte(COD_SI.equals(celdaITE) ? ddSi : ddNo );
				activoJuntaPropietarios.setEstatutos(COD_SI.equals(celdaEstatutos) ? ddSi : ddNo );
				activoJuntaPropietarios.setCuota(COD_SI.equals(celdaCuota) ? ddSi : ddNo );
				activoJuntaPropietarios.setOtros(celdaOtros);
				activoJuntaPropietarios.setPorcentaje(this.obtenerDoubleExcel(celdaParticipacion));
				activoJuntaPropietarios.setPromo20a50(COD_SI.equals(celdaPrejEconomico) ? ddSi : ddNo );
				activoJuntaPropietarios.setPromoMayor50(COD_SI.equals(celdaPromocion) ? ddSi : ddNo );
				activoJuntaPropietarios.setPropuesta(celdaPropuesta);
				activoJuntaPropietarios.setSuministros(this.obtenerDoubleExcel(celdaSuministros));
								
				
				if(!Checks.esNulo(celdaJGOJE)) {
					Filter filtroGasto = genericDao.createFilter(FilterType.EQUALS, "codigo", celdaJGOJE);				
					ddJunta = genericDao.get(DDJuntaComunidades.class, filtroGasto);
					activoJuntaPropietarios.setJunta(ddJunta);
				}
				
				if(!Checks.esNulo(celdaComunidad)) {
					Filter filtroGasto = genericDao.createFilter(FilterType.EQUALS, "codigoProveedorRem", this.obtenerLongExcel(celdaComunidad));				
					activoProveedor = genericDao.get(ActivoProveedor.class, filtroGasto);
					activoJuntaPropietarios.setComunidad(activoProveedor);
				}
				
				genericDao.save(ActivoJuntaPropietarios.class, activoJuntaPropietarios);

			}

		} catch (Exception e) {
			logger.error("Error en MSVSReclamacionesPlusvaliasProcesar", e);			
		}

		return new ResultadoProcesarFila();
		
	}
	

	private Long obtenerLongExcel(String celdaExcel) {
		if (Checks.esNulo(celdaExcel)) {
			return null;
		}

		return Long.valueOf(celdaExcel);
	}
	
	private Double obtenerDoubleExcel(String celdaExcel) {
		if (Checks.esNulo(celdaExcel)) {
			return null;
		}

		return Double.valueOf(celdaExcel);
	}
	
	private Date obtenerDateExcel(String celdaExcel) {
		if (Checks.esNulo(celdaExcel)) {
			return null;
		}

		SimpleDateFormat ft = new SimpleDateFormat("dd/MM/yyyy");
		Date fecha = null;

		try {
			fecha = ft.parse(celdaExcel);
		} catch (ParseException e) {
			e.printStackTrace();
		}

		return fecha;
	}

}
