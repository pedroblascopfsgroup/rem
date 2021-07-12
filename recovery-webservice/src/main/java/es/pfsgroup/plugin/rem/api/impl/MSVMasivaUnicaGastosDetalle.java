package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.MathContext;
import java.math.RoundingMode;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;

import javax.annotation.Resource;
import javax.persistence.NonUniqueResultException;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.hibernate.HibernateUtils;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ProcesoMasivoContext;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.GastoLineaDetalleApi;
import es.pfsgroup.plugin.rem.api.GastoProveedorApi;
import es.pfsgroup.plugin.rem.gasto.dao.GastoDao;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoGenerico;
import es.pfsgroup.plugin.rem.model.ActivoPropietario;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.DtoCargaMasivaUnicaGastos;
import es.pfsgroup.plugin.rem.model.DtoLineaDetalleGasto;
import es.pfsgroup.plugin.rem.model.Ejercicio;
import es.pfsgroup.plugin.rem.model.GastoDetalleEconomico;
import es.pfsgroup.plugin.rem.model.GastoGestion;
import es.pfsgroup.plugin.rem.model.GastoInfoContabilidad;
import es.pfsgroup.plugin.rem.model.GastoLineaDetalle;
import es.pfsgroup.plugin.rem.model.GastoLineaDetalleEntidad;
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDDestinatarioGasto;
import es.pfsgroup.plugin.rem.model.dd.DDEntidadGasto;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoGasto;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoGasto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComisionado;
import es.pfsgroup.plugin.rem.model.dd.DDTipoGasto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOperacionGasto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPeriocidad;
import es.pfsgroup.plugin.rem.model.dd.DDTipoRecargoGasto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoRetencion;
import es.pfsgroup.plugin.rem.model.dd.DDTiposImpuesto;


@Component
public class MSVMasivaUnicaGastosDetalle extends AbstractMSVActualizador implements MSVLiberator {
	private static final int DATOS_PRIMERA_FILA = 1;
	
	public static final Integer COL_ID_AGRUPADOR_GASTO = 0;
	public static final Integer COL_TIPO_GASTO = 1;
	public static final Integer COL_PEDIODICIDAD_GASTO = 2;
	public static final Integer COL_CONCEPTO_GASTO = 3;
	public static final Integer COL_IDENTIFICADOR_UNICO = 4;
	public static final Integer COL_NUM_FACTURA_LIQUIDACION = 5;
	public static final Integer COL_COD_PROVEEDOR_REM = 6;
	public static final Integer COL_NIF_EMISOR = 7;
	public static final Integer COL_DESTINATARIO = 8;
	public static final Integer COL_NIF_PROPIETARIO = 9;
	public static final Integer COL_F_EMISION_DEVENGO = 10;
	public static final Integer COL_TIPO_OPERACION = 11;
	public static final Integer COL_C_GASTO_REFACTURABLE = 12;
	public static final Integer COL_REPERCUTIBLE_INQUILINO = 13;
	public static final Integer COL_C_PAGO_CONEXION = 14;
	public static final Integer COL_NUM_CONEXION = 15;
	public static final Integer COL_F_CONEXION = 16;
	public static final Integer COL_OFICINA = 17;
	public static final Integer COL_RETENCION_GARANTIA_PORCENTAJE = 18;
	public static final Integer COL_TIPO_RETENCION = 19;
	public static final Integer COL_IRPF_BASE = 20;
	public static final Integer COL_IRPF_PORCENTAJE = 21;
	public static final Integer COL_IRPF_CLAVE = 22;
	public static final Integer COL_IRPF_SUBCLAVE = 23;
	public static final Integer COL_PLAN_VISITAS = 24;
	public static final Integer COL_ACTIVABLE = 25;
	public static final Integer COL_EJERCICIO = 26;
	public static final Integer COL_TIPO_COMISIONADO = 27;
	public static final Integer COL_COD_AGRUPACION_LINEA_DETALLE = 28;
	public static final Integer COL_SUBTIPO_GASTO = 29;
	public static final Integer COL_PRINCIPAL_SUJETO_IMPUESTOS = 30;
	public static final Integer COL_PRINCIPAL_NO_SUJETO_IMPUESTOS = 31;
	public static final Integer COL_TIPO_RECARGO = 32;
	public static final Integer COL_IMPORTE_RECARGO = 33;
	public static final Integer COL_INTERES_DEMORA = 34;
	public static final Integer COL_COSTES = 35;
	public static final Integer COL_OTROS_INCREMENTOS = 36;
	public static final Integer COL_PROVISIONES_Y_SUPLIDOS = 37;
	public static final Integer COL_TIPO_IMPUESTO = 38;
	public static final Integer COL_OPERACION_EXENTA = 39;
	public static final Integer COL_RENUNCIA_EXENCION = 40;
	public static final Integer COL_TIPO_IMPOSITIVO = 41;
	public static final Integer COL_OPTA_CRITERIO_CAJA_IVA = 42;
	public static final Integer COL_ID_ELEMENTO = 43;
	public static final Integer COL_TIPO_ELEMENTO = 44;
	public static final Integer COL_PARTICIPACION_LINEA_DETALLE = 45;

	
	
	private static final String[] listaValidosPositivos = { "S", "SI" };
	
	protected static final Log logger = LogFactory.getLog(MSVMasivaUnicaGastosDetalle.class);
	
	private static DtoCargaMasivaUnicaGastos dtoGastos;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private GastoDao gastoDao;

	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private GastoProveedorApi gastoProveedorApi;
	
	@Autowired
	private GastoLineaDetalleApi gastoLineaDetalleApi;
	
	@Resource(name = "entityTransactionManager")
	private PlatformTransactionManager transactionManager;

	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_UNICA_GASTOS;
	}
	
	@Transactional(readOnly = false)
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken) throws JsonViewerException, IOException, ParseException, SQLException, Exception {
		return procesaFila(exc, fila, prmToken, new ProcesoMasivoContext());
	}

	@Transactional(readOnly = false)
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken, ProcesoMasivoContext context)
			throws IOException, ParseException, JsonViewerException, SQLException, Exception {
		String usuario = genericAdapter.getUsuarioLogado().getUsername();
		try {
				GastoProveedor newGastoProveedor = null;
				GastoLineaDetalle newGastoLineaDetalle = null;
				Double importeTotal = 0.0;

				dtoGastos = DtoCargaMasivaUnicaGastos.getDtoCargaMasivaUnicaGastos(exc.dameCelda(fila, COL_ID_AGRUPADOR_GASTO));
				
				if(dtoGastos.getIdAgrupador() == null) {
					dtoGastos.setIdAgrupador(exc.dameCelda(fila, COL_ID_AGRUPADOR_GASTO));	
				}else {
					newGastoProveedor = dtoGastos.getGastoProveedor();
				}
				
				if(newGastoProveedor == null) {
					
					newGastoProveedor = new GastoProveedor();
					
					newGastoProveedor.setNumGastoHaya(gastoDao.getNextNumGasto());
					
					DDEstadoGasto estadoGasto = genericDao.get(DDEstadoGasto.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoGasto.INCOMPLETO)); 
					newGastoProveedor.setEstadoGasto(estadoGasto);
					
					
					if(exc.dameCelda(fila, COL_TIPO_GASTO) != null && !exc.dameCelda(fila, COL_TIPO_GASTO).isEmpty()) {
						DDTipoGasto tipoGasto = genericDao.get(DDTipoGasto.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, COL_TIPO_GASTO))); 
						if (!Checks.esNulo(tipoGasto)) {
							newGastoProveedor.setTipoGasto(tipoGasto);
						}
					}
					
					if(exc.dameCelda(fila, COL_PEDIODICIDAD_GASTO) != null && !exc.dameCelda(fila, COL_PEDIODICIDAD_GASTO).isEmpty()) {
						DDTipoPeriocidad tipoPeriocidad = genericDao.get(DDTipoPeriocidad.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, COL_PEDIODICIDAD_GASTO)));
						if(!Checks.esNulo(tipoPeriocidad)) {
							newGastoProveedor.setTipoPeriocidad(tipoPeriocidad);
						}
					}
					
					if(exc.dameCelda(fila, COL_CONCEPTO_GASTO) != null && !exc.dameCelda(fila, COL_CONCEPTO_GASTO).isEmpty()) {
						newGastoProveedor.setConcepto(exc.dameCelda(fila, COL_CONCEPTO_GASTO));
					}
					
					if(exc.dameCelda(fila, COL_IDENTIFICADOR_UNICO) != null && !exc.dameCelda(fila, COL_IDENTIFICADOR_UNICO).isEmpty()) {
						newGastoProveedor.setIdentificadorUnico(exc.dameCelda(fila, COL_IDENTIFICADOR_UNICO));
					}
					
					if(exc.dameCelda(fila, COL_NUM_FACTURA_LIQUIDACION) != null && !exc.dameCelda(fila, COL_NUM_FACTURA_LIQUIDACION).isEmpty()) {
						newGastoProveedor.setReferenciaEmisor(exc.dameCelda(fila, COL_NUM_FACTURA_LIQUIDACION));
					}
					
					List<ActivoProveedor> emisor = null;
					
					if (Checks.esNulo(exc.dameCelda(fila, COL_COD_PROVEEDOR_REM))) {
						emisor = genericDao.getList(ActivoProveedor.class, genericDao.createFilter(FilterType.EQUALS, "docIdentificativo", exc.dameCelda(fila, COL_NIF_EMISOR)));
					} else {
						emisor = genericDao.getList(ActivoProveedor.class, genericDao.createFilter(FilterType.EQUALS, "codigoProveedorRem", Long.parseLong(exc.dameCelda(fila, COL_COD_PROVEEDOR_REM).trim())));
					}
					
					if(!Checks.esNulo(emisor) && !emisor.isEmpty()) {
						newGastoProveedor.setProveedor(emisor.get(0));
					}
					
					
					if(exc.dameCelda(fila, COL_DESTINATARIO) != null && !exc.dameCelda(fila, COL_DESTINATARIO).isEmpty()) {
						DDDestinatarioGasto destinatario = genericDao.get(DDDestinatarioGasto.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, COL_DESTINATARIO))); 
						if (!Checks.esNulo(destinatario)) {
							newGastoProveedor.setDestinatarioGasto(destinatario);
						}
					}
					
					if(exc.dameCelda(fila, COL_NIF_PROPIETARIO) != null && !exc.dameCelda(fila, COL_NIF_PROPIETARIO).isEmpty()) {
						List <ActivoPropietario> propietarios = genericDao.getList(ActivoPropietario.class, genericDao.createFilter(FilterType.EQUALS, "docIdentificativo", exc.dameCelda(fila, COL_NIF_PROPIETARIO)));
						if(!Checks.esNulo(propietarios) && !propietarios.isEmpty()) {
							newGastoProveedor.setPropietario(propietarios.get(0));
						}
					}
					
					if(exc.dameCelda(fila, COL_F_EMISION_DEVENGO) != null && !exc.dameCelda(fila, COL_F_EMISION_DEVENGO).isEmpty()) {
						newGastoProveedor.setFechaEmision(new SimpleDateFormat("dd/MM/yyyy").parse(exc.dameCelda(fila, COL_F_EMISION_DEVENGO)));
					}
					
					if(exc.dameCelda(fila, COL_TIPO_OPERACION) != null && !exc.dameCelda(fila, COL_TIPO_OPERACION).isEmpty()) {
						DDTipoOperacionGasto tipoOperacion = genericDao.get(DDTipoOperacionGasto.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, COL_TIPO_OPERACION))); 
						if (!Checks.esNulo(tipoOperacion)) {
							newGastoProveedor.setTipoOperacion(tipoOperacion);
						}
					}
					
					newGastoProveedor.setAuditoria(Auditoria.getNewInstance());
	
					
					genericDao.save(GastoProveedor.class, newGastoProveedor);

					
					dtoGastos.setGastoProveedor(newGastoProveedor);
				}
				 
				////////////////////////////////////////////
				/// Comienza inserción GastoLineaDetalle ///
				////////////////////////////////////////////
				
				newGastoLineaDetalle = dtoGastos.getGastoLineaDetalle(exc.dameCelda(fila, COL_COD_AGRUPACION_LINEA_DETALLE));

				
				if(Checks.esNulo(newGastoLineaDetalle)) {
					dtoGastos.setGastoLineaDetalle(exc.dameCelda(fila, COL_COD_AGRUPACION_LINEA_DETALLE));
					
					newGastoLineaDetalle = dtoGastos.getGastoLineaDetalle(exc.dameCelda(fila, COL_COD_AGRUPACION_LINEA_DETALLE));
					newGastoLineaDetalle.setGastoProveedor(newGastoProveedor);
					
					if(exc.dameCelda(fila, COL_SUBTIPO_GASTO) != null && !exc.dameCelda(fila, COL_SUBTIPO_GASTO).isEmpty()) {
						DDSubtipoGasto subtipo = genericDao.get(DDSubtipoGasto.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, COL_SUBTIPO_GASTO))); 
						if (!Checks.esNulo(subtipo)) {
							newGastoLineaDetalle.setSubtipoGasto(subtipo);
						}
					}
					
					if(exc.dameCelda(fila, COL_PRINCIPAL_SUJETO_IMPUESTOS) != null && !exc.dameCelda(fila, COL_PRINCIPAL_SUJETO_IMPUESTOS).isEmpty()) {
						newGastoLineaDetalle.setPrincipalSujeto(Double.parseDouble(exc.dameCelda(fila, COL_PRINCIPAL_SUJETO_IMPUESTOS)));
						importeTotal = importeTotal + Double.parseDouble(exc.dameCelda(fila, COL_PRINCIPAL_SUJETO_IMPUESTOS));
					}
					
					if(exc.dameCelda(fila, COL_PRINCIPAL_NO_SUJETO_IMPUESTOS) != null && !exc.dameCelda(fila, COL_PRINCIPAL_NO_SUJETO_IMPUESTOS).isEmpty()) {
						newGastoLineaDetalle.setPrincipalNoSujeto(Double.parseDouble(exc.dameCelda(fila, COL_PRINCIPAL_NO_SUJETO_IMPUESTOS)));
						importeTotal = importeTotal + Double.parseDouble(exc.dameCelda(fila, COL_PRINCIPAL_NO_SUJETO_IMPUESTOS));
					}
					
					if(exc.dameCelda(fila, COL_TIPO_RECARGO) != null && !exc.dameCelda(fila, COL_TIPO_RECARGO).isEmpty()) {
						DDTipoRecargoGasto tipoRecargoGasto = genericDao.get(DDTipoRecargoGasto.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, COL_TIPO_RECARGO)));
						if(!Checks.esNulo(tipoRecargoGasto)){
							newGastoLineaDetalle.setTipoRecargoGasto(tipoRecargoGasto);
						}
					}
					
					if(exc.dameCelda(fila, COL_IMPORTE_RECARGO) != null && !exc.dameCelda(fila, COL_IMPORTE_RECARGO).isEmpty()) {
						newGastoLineaDetalle.setRecargo(Double.parseDouble(exc.dameCelda(fila, COL_IMPORTE_RECARGO)));
						importeTotal = importeTotal + Double.parseDouble(exc.dameCelda(fila, COL_IMPORTE_RECARGO));
					}
					
					if(exc.dameCelda(fila, COL_INTERES_DEMORA) != null && !exc.dameCelda(fila, COL_INTERES_DEMORA).isEmpty()) {
						newGastoLineaDetalle.setInteresDemora(Double.parseDouble(exc.dameCelda(fila, COL_INTERES_DEMORA)));
						importeTotal = importeTotal + Double.parseDouble(exc.dameCelda(fila, COL_INTERES_DEMORA));
					}
					
					if(exc.dameCelda(fila, COL_COSTES) != null && !exc.dameCelda(fila, COL_COSTES).isEmpty()) {
						newGastoLineaDetalle.setCostas(Double.parseDouble(exc.dameCelda(fila, COL_COSTES)));
						importeTotal = importeTotal + Double.parseDouble(exc.dameCelda(fila, COL_COSTES));
					}
					
					if(exc.dameCelda(fila, COL_OTROS_INCREMENTOS) != null && !exc.dameCelda(fila, COL_OTROS_INCREMENTOS).isEmpty()) {
						newGastoLineaDetalle.setOtrosIncrementos(Double.parseDouble(exc.dameCelda(fila, COL_OTROS_INCREMENTOS)));
						importeTotal = importeTotal + Double.parseDouble(exc.dameCelda(fila, COL_OTROS_INCREMENTOS));
					}
					
					if(exc.dameCelda(fila, COL_PROVISIONES_Y_SUPLIDOS) != null && !exc.dameCelda(fila, COL_PROVISIONES_Y_SUPLIDOS).isEmpty()) {
						newGastoLineaDetalle.setProvSuplidos(Double.parseDouble(exc.dameCelda(fila, COL_PROVISIONES_Y_SUPLIDOS)));
						importeTotal = importeTotal + Double.parseDouble(exc.dameCelda(fila, COL_PROVISIONES_Y_SUPLIDOS));
					}
					
					if(exc.dameCelda(fila, COL_TIPO_IMPUESTO) != null && !exc.dameCelda(fila, COL_TIPO_IMPUESTO).isEmpty()) {
						DDTiposImpuesto tipoImpuesto = genericDao.get(DDTiposImpuesto.class, genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, COL_TIPO_IMPUESTO)));
						if(!Checks.esNulo(tipoImpuesto)){
							newGastoLineaDetalle.setTipoImpuesto(tipoImpuesto);
						}
					}
					
					if(exc.dameCelda(fila, COL_OPERACION_EXENTA) != null && !exc.dameCelda(fila, COL_OPERACION_EXENTA).isEmpty()) {
						newGastoLineaDetalle.setEsImporteIndirectoExento(stringToBoolean(exc.dameCelda(fila, COL_OPERACION_EXENTA)));
					}
					
					if(exc.dameCelda(fila, COL_RENUNCIA_EXENCION) != null && !exc.dameCelda(fila, COL_RENUNCIA_EXENCION).isEmpty()) {
						newGastoLineaDetalle.setEsImporteIndirectoExento(stringToBoolean(exc.dameCelda(fila, COL_RENUNCIA_EXENCION)));
					}
					
					if(exc.dameCelda(fila, COL_TIPO_IMPOSITIVO) != null && !exc.dameCelda(fila, COL_TIPO_IMPOSITIVO).isEmpty()) {
						newGastoLineaDetalle.setImporteIndirectoTipoImpositivo(Double.parseDouble(exc.dameCelda(fila, COL_TIPO_IMPOSITIVO)));
					}
					
					boolean anyadirCuota = true;
					if(exc.dameCelda(fila, COL_TIPO_IMPOSITIVO) != null && !exc.dameCelda(fila, COL_TIPO_IMPOSITIVO).isEmpty() && 
					exc.dameCelda(fila, COL_PRINCIPAL_SUJETO_IMPUESTOS) != null && !exc.dameCelda(fila, COL_PRINCIPAL_SUJETO_IMPUESTOS).isEmpty()) {
						BigDecimal tipoImpositivo = new BigDecimal(exc.dameCelda(fila, COL_TIPO_IMPOSITIVO));
						BigDecimal principalSujeto = new BigDecimal(exc.dameCelda(fila, COL_PRINCIPAL_SUJETO_IMPUESTOS));
						if(BigDecimal.ZERO.compareTo(tipoImpositivo) != 0 && BigDecimal.ZERO.compareTo(principalSujeto) != 0) {
							BigDecimal cuota = tipoImpositivo.multiply(principalSujeto).divide(new BigDecimal(100));
							newGastoLineaDetalle.setImporteIndirectoCuota(cuota.doubleValue());
							if(stringToBoolean(exc.dameCelda(fila, COL_OPERACION_EXENTA))){
								anyadirCuota = false;
							}
							if(!anyadirCuota && stringToBoolean(exc.dameCelda(fila, COL_RENUNCIA_EXENCION))) {
								anyadirCuota = true;
							}
							if(anyadirCuota) {
								importeTotal = importeTotal + newGastoLineaDetalle.getImporteIndirectoCuota();
							}
						}else {
							newGastoLineaDetalle.setImporteIndirectoCuota(new Double(0));
						}
					}
					
					
					if(exc.dameCelda(fila, COL_TIPO_ELEMENTO) != null && !exc.dameCelda(fila, COL_TIPO_ELEMENTO).isEmpty()) {
						Filter filtroTipoEntidad = genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, COL_TIPO_ELEMENTO));
						DDEntidadGasto entidadGasto = genericDao.get(DDEntidadGasto.class, filtroTipoEntidad);
						
						if(entidadGasto != null && DDEntidadGasto.CODIGO_SIN_ACTIVOS.equals(entidadGasto.getCodigo())) {
							newGastoLineaDetalle.setLineaSinActivos(true);
						}
					}
					newGastoLineaDetalle.setImporteTotal(importeTotal);
					
					newGastoLineaDetalle.setAuditoria(Auditoria.getNewInstance());
					genericDao.save(GastoLineaDetalle.class, newGastoLineaDetalle);
					
				}
				dtoGastos.getGastoLineaDetalleList().add(newGastoLineaDetalle);
				///////////////////////////////////////////////////
				/// Comienza inserción GastoLineaDetalleEntidad ///
				///////////////////////////////////////////////////
				
				
				if(exc.dameCelda(fila, COL_ID_ELEMENTO) != null && !exc.dameCelda(fila, COL_ID_ELEMENTO).isEmpty()) {
					Filter filtroTipoEntidad = genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, COL_TIPO_ELEMENTO));
					DDEntidadGasto entidadGasto = genericDao.get(DDEntidadGasto.class, filtroTipoEntidad);
					
					if(DDEntidadGasto.CODIGO_AGRUPACION.equals(entidadGasto.getCodigo())) {
						Filter filtroAgrupacion = genericDao.createFilter(FilterType.EQUALS, "numAgrupRem", Long.parseLong(exc.dameCelda(fila, COL_ID_ELEMENTO)));
						ActivoAgrupacion agrupacion = genericDao.get(ActivoAgrupacion.class, filtroAgrupacion);
						
						if(agrupacion != null) {
							List<ActivoAgrupacionActivo> activosAgrupacion= agrupacion.getActivos();
							int i = 0;
							if(activosAgrupacion != null && !activosAgrupacion.isEmpty()) {
								Filter filtroTipoEntidadActivo = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEntidadGasto.CODIGO_ACTIVO);
								DDEntidadGasto entidadGastoActivo = genericDao.get(DDEntidadGasto.class, filtroTipoEntidadActivo);
								BigDecimal participacion = new BigDecimal(exc.dameCelda(fila, COL_PARTICIPACION_LINEA_DETALLE)); 
								BigDecimal numActivos = new BigDecimal(activosAgrupacion.size());
								BigDecimal participacionPorActivo = participacion.divide(numActivos, 2, RoundingMode.HALF_UP);
								BigDecimal sumaParticipacion = BigDecimal.valueOf(0.0);
								for (ActivoAgrupacionActivo activoAgrupacionActivo : activosAgrupacion) {
									GastoLineaDetalleEntidad gastoLineaDetalleEntidad = new GastoLineaDetalleEntidad();
									gastoLineaDetalleEntidad.setGastoLineaDetalle(newGastoLineaDetalle);
									gastoLineaDetalleEntidad.setEntidad(activoAgrupacionActivo.getActivo().getId());
									gastoLineaDetalleEntidad.setEntidadGasto(entidadGastoActivo);
									 sumaParticipacion = sumaParticipacion.add(participacionPorActivo);
								    if((i++ == activosAgrupacion.size() - 1) && sumaParticipacion != participacion){
										BigDecimal decimal = sumaParticipacion.subtract(participacion);
										participacionPorActivo = participacionPorActivo.subtract(decimal);									
								     }
									 
								  
								   gastoLineaDetalleEntidad.setParticipacionGasto(participacionPorActivo.doubleValue());
								   genericDao.save(GastoLineaDetalleEntidad.class,gastoLineaDetalleEntidad);
								}
								
								
							}
						}
					}else if (DDEntidadGasto.CODIGO_ACTIVO.equals(entidadGasto.getCodigo())) {
						
						Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "numActivo",  Long.parseLong(exc.dameCelda(fila, COL_ID_ELEMENTO)));
						Activo activo = genericDao.get(Activo.class, filtroActivo);
						
						GastoLineaDetalleEntidad gastoLineaDetalleEntidad = new GastoLineaDetalleEntidad();
						gastoLineaDetalleEntidad.setGastoLineaDetalle(newGastoLineaDetalle);
						gastoLineaDetalleEntidad.setEntidad(activo.getId());
						gastoLineaDetalleEntidad.setEntidadGasto(entidadGasto);
						gastoLineaDetalleEntidad.setParticipacionGasto(Double.parseDouble(exc.dameCelda(fila, COL_PARTICIPACION_LINEA_DETALLE)));
						genericDao.save(GastoLineaDetalleEntidad.class,gastoLineaDetalleEntidad);
						
					}else if(DDEntidadGasto.CODIGO_ACTIVO_GENERICO.equals(entidadGasto.getCodigo())) {
					
						Filter filtroNumActivoGen = genericDao.createFilter(FilterType.EQUALS, "numActivoGenerico", exc.dameCelda(fila, COL_ID_ELEMENTO));
						Filter filtroSubtipoGasto = genericDao.createFilter(FilterType.EQUALS, "subtipoGasto.codigo", newGastoLineaDetalle.getSubtipoGasto().getCodigo());
						Filter filtroPropietario= genericDao.createFilter(FilterType.EQUALS, "propietario.id", newGastoLineaDetalle.getGastoProveedor().getPropietario().getId());
						Filter filtroAnyo;
						    if(newGastoLineaDetalle.getGastoProveedor().getFechaEmision() != null) {
								SimpleDateFormat fyear = new SimpleDateFormat("yyyy");
								String year = fyear.format(newGastoLineaDetalle.getGastoProveedor().getFechaEmision());
								filtroAnyo = genericDao.createFilter(FilterType.EQUALS, "anyoActivoGenerico", Integer.parseInt(year));
							}else {
								filtroAnyo = genericDao.createFilter(FilterType.NULL, "anyoActivoGenerico");
							}
						ActivoGenerico activoGenerico =  genericDao.get(ActivoGenerico.class, filtroNumActivoGen, filtroSubtipoGasto,filtroPropietario, filtroAnyo);
							if(activoGenerico == null) {
								filtroAnyo = genericDao.createFilter(FilterType.NULL, "anyoActivoGenerico");
								activoGenerico =  genericDao.get(ActivoGenerico.class, filtroNumActivoGen, filtroSubtipoGasto,filtroPropietario,filtroAnyo);
						        }

						if(activoGenerico != null) {
							GastoLineaDetalleEntidad gastoLineaDetalleEntidad = new GastoLineaDetalleEntidad();
							gastoLineaDetalleEntidad.setGastoLineaDetalle(newGastoLineaDetalle);
							gastoLineaDetalleEntidad.setEntidad(activoGenerico.getId());
							gastoLineaDetalleEntidad.setEntidadGasto(entidadGasto);
							gastoLineaDetalleEntidad.setParticipacionGasto(Double.parseDouble(exc.dameCelda(fila, COL_PARTICIPACION_LINEA_DETALLE)));
							genericDao.save(GastoLineaDetalleEntidad.class,gastoLineaDetalleEntidad);
						}
						
					
					}else if(DDEntidadGasto.CODIGO_SIN_ACTIVOS.equals(entidadGasto.getCodigo())) {		
						
					}else {
						GastoLineaDetalleEntidad gastoLineaDetalleEntidad = new GastoLineaDetalleEntidad();
						gastoLineaDetalleEntidad.setGastoLineaDetalle(newGastoLineaDetalle);
						gastoLineaDetalleEntidad.setEntidad(Long.parseLong(exc.dameCelda(fila, COL_ID_ELEMENTO)));
						gastoLineaDetalleEntidad.setEntidadGasto(entidadGasto);
						gastoLineaDetalleEntidad.setParticipacionGasto(Double.parseDouble(exc.dameCelda(fila, COL_PARTICIPACION_LINEA_DETALLE)));
						
						genericDao.save(GastoLineaDetalleEntidad.class,gastoLineaDetalleEntidad);
						
					}
				}
				
				
				////////////////////////////////////////////////
				/// Comienza inserción GastoDetalleEconomico ///
				////////////////////////////////////////////////
				
				
				Filter filtroGastoEconomico = genericDao.createFilter(FilterType.EQUALS, "gastoProveedor.id", newGastoProveedor.getId());
				GastoDetalleEconomico gastoDetalleEconomico = genericDao.get(GastoDetalleEconomico.class, filtroGastoEconomico);
				
				if(gastoDetalleEconomico == null){
					
					gastoDetalleEconomico = new GastoDetalleEconomico();
					gastoDetalleEconomico.setGastoProveedor(newGastoProveedor);
					gastoDetalleEconomico.setAuditoria(Auditoria.getNewInstance());
				
				
					if(exc.dameCelda(fila, COL_REPERCUTIBLE_INQUILINO) != null && !exc.dameCelda(fila, COL_REPERCUTIBLE_INQUILINO).isEmpty()) {
						gastoDetalleEconomico.setRepercutibleInquilino(booleanToInt(stringToBoolean(exc.dameCelda(fila, COL_REPERCUTIBLE_INQUILINO))));
					}
					
					if(exc.dameCelda(fila, COL_C_PAGO_CONEXION) != null && !exc.dameCelda(fila, COL_C_PAGO_CONEXION).isEmpty()) {
						gastoDetalleEconomico.setPagadoConexionBankia(booleanToInt(stringToBoolean(exc.dameCelda(fila, COL_C_PAGO_CONEXION))));
					}
					
					if(exc.dameCelda(fila, COL_NUM_CONEXION) != null && !exc.dameCelda(fila, COL_NUM_CONEXION).isEmpty()) {
						gastoDetalleEconomico.setNumeroConexionBankia(exc.dameCelda(fila, COL_NUM_CONEXION));
					}
					
					if(exc.dameCelda(fila, COL_F_CONEXION) != null && !exc.dameCelda(fila, COL_F_CONEXION).isEmpty()) {
						gastoDetalleEconomico.setFechaConexion(new SimpleDateFormat("dd/MM/yyyy").parse(exc.dameCelda(fila, COL_F_CONEXION)));
					}
					
					if(exc.dameCelda(fila, COL_OFICINA) != null && !exc.dameCelda(fila, COL_OFICINA).isEmpty()) {
						gastoDetalleEconomico.setOficinaBankia(exc.dameCelda(fila, COL_OFICINA));
					}
					
					if(exc.dameCelda(fila, COL_RETENCION_GARANTIA_PORCENTAJE) != null && !exc.dameCelda(fila, COL_RETENCION_GARANTIA_PORCENTAJE).isEmpty()) {
						gastoDetalleEconomico.setRetencionGarantiaTipoImpositivo(Double.parseDouble(exc.dameCelda(fila, COL_RETENCION_GARANTIA_PORCENTAJE)));
						gastoDetalleEconomico.setRetencionGarantiaAplica(true);
					}
					
					if(exc.dameCelda(fila, COL_IRPF_BASE) != null && !exc.dameCelda(fila, COL_IRPF_BASE).isEmpty()) {
						gastoDetalleEconomico.setIrpfBase(Double.parseDouble(exc.dameCelda(fila, COL_IRPF_BASE)));
					}
					
					if(exc.dameCelda(fila, COL_IRPF_PORCENTAJE) != null && !exc.dameCelda(fila, COL_IRPF_PORCENTAJE).isEmpty()) {
						gastoDetalleEconomico.setIrpfTipoImpositivo(Double.parseDouble(exc.dameCelda(fila, COL_IRPF_PORCENTAJE)));
					}
					
					if(exc.dameCelda(fila, COL_IRPF_CLAVE) != null && !exc.dameCelda(fila, COL_IRPF_CLAVE).isEmpty()) {
						gastoDetalleEconomico.setIrpfClave(exc.dameCelda(fila, COL_IRPF_CLAVE));
					}
					
					if(exc.dameCelda(fila, COL_IRPF_SUBCLAVE) != null && !exc.dameCelda(fila, COL_IRPF_SUBCLAVE).isEmpty()) {
						gastoDetalleEconomico.setIrpfSubclave(exc.dameCelda(fila, COL_IRPF_SUBCLAVE));
					}
					
					if(exc.dameCelda(fila, COL_C_GASTO_REFACTURABLE) != null && !exc.dameCelda(fila, COL_C_GASTO_REFACTURABLE).isEmpty()) {
						gastoDetalleEconomico.setGastoRefacturable(stringToBoolean(exc.dameCelda(fila, COL_C_GASTO_REFACTURABLE)));
					}
					
					if(!Checks.esNulo(exc.dameCelda(fila, COL_IRPF_BASE)) && !Checks.esNulo(exc.dameCelda(fila, COL_IRPF_PORCENTAJE))) {
						BigDecimal irpfPorcentaje = new BigDecimal(exc.dameCelda(fila, COL_IRPF_BASE));
						BigDecimal irpfBase = new BigDecimal(exc.dameCelda(fila, COL_IRPF_PORCENTAJE));
						if(BigDecimal.ZERO.compareTo(irpfPorcentaje) != 0 && BigDecimal.ZERO.compareTo(irpfBase) != 0) {
							BigDecimal cuota = irpfPorcentaje.multiply(irpfBase).divide(new BigDecimal(100));
							gastoDetalleEconomico.setIrpfCuota(cuota.doubleValue());
						}else {
							gastoDetalleEconomico.setIrpfCuota(new Double(0));
						}
					}
					
					DDTipoRetencion tipoRetencion = genericDao.get(DDTipoRetencion.class, genericDao.createFilter(FilterType.EQUALS, "codigo",  exc.dameCelda(fila, COL_TIPO_RETENCION)));
					
					if(tipoRetencion != null) {
						gastoDetalleEconomico.setTipoRetencion(tipoRetencion);
					}
						
					genericDao.save(GastoDetalleEconomico.class, gastoDetalleEconomico);
				}
			
				dtoGastos.setGastoDetalleEconomico(gastoDetalleEconomico);

				////////////////////////////////////////////////
				/// Comienza inserción GastoGestion ////////////
				////////////////////////////////////////////////
				
				Filter filtroGestionEconomica = genericDao.createFilter(FilterType.EQUALS, "gastoProveedor.id", newGastoProveedor.getId());
				GastoGestion gastoInfoGestion = genericDao.get(GastoGestion.class, filtroGestionEconomica);
				
				
				 if(gastoInfoGestion == null) {
					 gastoInfoGestion = new GastoGestion(); 
					 gastoInfoGestion.setGastoProveedor(newGastoProveedor);
					 gastoInfoGestion.setFechaAlta(new Date());
					 gastoInfoGestion.setUsuarioAlta(genericAdapter.getUsuarioLogado());
					 
					 genericDao.save(GastoGestion.class, gastoInfoGestion);
				 }
				 
				
				////////////////////////////////////////////////
				/// Comienza inserción GastoInfoContabilidad ///
				////////////////////////////////////////////////
				
			
				Filter filtroInfoContabilidad = genericDao.createFilter(FilterType.EQUALS, "gastoProveedor.id", newGastoProveedor.getId());
				GastoInfoContabilidad gastoInfoContabilidad = genericDao.get(GastoInfoContabilidad.class, filtroInfoContabilidad);
				
				
				if(gastoInfoContabilidad == null) {
					
					gastoInfoContabilidad = new GastoInfoContabilidad();
					gastoInfoContabilidad.setAuditoria(Auditoria.getNewInstance());
					gastoInfoContabilidad.setGastoProveedor(newGastoProveedor);
					
					if(exc.dameCelda(fila, COL_ACTIVABLE) !=  null && !exc.dameCelda(fila, COL_ACTIVABLE).isEmpty()) {
						if(stringToBoolean(exc.dameCelda(fila, COL_ACTIVABLE))) {
							gastoInfoContabilidad.setActivable(genericDao.get(DDSinSiNo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDSinSiNo.CODIGO_SI)));
						} else {
							gastoInfoContabilidad.setActivable(genericDao.get(DDSinSiNo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDSinSiNo.CODIGO_NO)));
						}
					}
					
					if(exc.dameCelda(fila, COL_PLAN_VISITAS) != null && !exc.dameCelda(fila, COL_PLAN_VISITAS).isEmpty()) {
						if(stringToBoolean(exc.dameCelda(fila, COL_PLAN_VISITAS))) {
							gastoInfoContabilidad.setGicPlanVisitas(genericDao.get(DDSinSiNo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDSinSiNo.CODIGO_SI)));
						} else {
							gastoInfoContabilidad.setGicPlanVisitas(genericDao.get(DDSinSiNo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDSinSiNo.CODIGO_NO)));
						}
					}
					
					if(exc.dameCelda(fila, COL_TIPO_COMISIONADO) != null && !exc.dameCelda(fila, COL_TIPO_COMISIONADO).isEmpty()) {
						Filter filtroTipoEntidad = genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, COL_TIPO_ELEMENTO));
						DDTipoComisionado tipoComisionado = genericDao.get(DDTipoComisionado.class, filtroTipoEntidad);
						if(!Checks.esNulo(tipoComisionado)) {
							gastoInfoContabilidad.setTipoComisionadoHre(tipoComisionado);
						}
					}
					
					Filter filtroEjercicio = genericDao.createFilter(FilterType.EQUALS, "anyo", exc.dameCelda(fila, COL_EJERCICIO));
					Ejercicio ejercicio = genericDao.get(Ejercicio.class, filtroEjercicio);
					
					if(ejercicio != null) {
						gastoInfoContabilidad.setEjercicio(ejercicio);
					}else {
						String fecha = exc.dameCelda(fila, COL_F_EMISION_DEVENGO);
						Date hoy=new SimpleDateFormat("dd/MM/yyyy").parse(fecha);  
						Calendar calendar = new GregorianCalendar();
						calendar.setTime(hoy);
						String year =  Integer.toString(calendar.get(Calendar.YEAR));
						filtroEjercicio = genericDao.createFilter(FilterType.EQUALS, "anyo", year);
						ejercicio = genericDao.get(Ejercicio.class, filtroEjercicio);
						gastoInfoContabilidad.setEjercicio(ejercicio);
					}
										
					
					genericDao.save(GastoInfoContabilidad.class, gastoInfoContabilidad);
				
				}
				
				//////////////////////////////////////////
				/// Comienza inserción ActivoProveedor ///
				/////////////////////////////////////////
				
				if(exc.dameCelda(fila, COL_OPTA_CRITERIO_CAJA_IVA) != null && !exc.dameCelda(fila, COL_OPTA_CRITERIO_CAJA_IVA).isEmpty()) {
					List<ActivoProveedor> emisorList = null;
					
					if (Checks.esNulo(exc.dameCelda(fila, COL_COD_PROVEEDOR_REM))) {
						emisorList = genericDao.getList(ActivoProveedor.class, genericDao.createFilter(FilterType.EQUALS, "docIdentificativo", exc.dameCelda(fila, COL_NIF_EMISOR)));
					} else {
						emisorList = genericDao.getList(ActivoProveedor.class, genericDao.createFilter(FilterType.EQUALS, "codigoProveedorRem", exc.dameCelda(fila, COL_COD_PROVEEDOR_REM)));
					}
					
					if(emisorList != null && !emisorList.isEmpty()) {
						for (ActivoProveedor emisor : emisorList) {
							if(emisor != null) {
								emisor.setCriterioCajaIVA(booleanToInt(stringToBoolean(exc.dameCelda(fila, COL_OPTA_CRITERIO_CAJA_IVA))));
								emisor.getAuditoria().setUsuarioModificar(usuario);
								emisor.getAuditoria().setFechaModificar(new Date());
								genericDao.update(ActivoProveedor.class, emisor);
							}
						}	
					}
				}
				
				if((exc.getNumeroFilas() -1 ) ==  fila) {
					List<GastoDetalleEconomico> gastosList = dtoGastos.getAllGastoDetalleEconomico();

					if(gastosList != null && !gastosList.isEmpty()) {
						for (GastoDetalleEconomico gastoDetalle : gastosList) {
								
								Double importeGarantiaBase = gastoProveedorApi.recalcularImporteRetencionGarantia(gastoDetalle);
								gastoDetalle.setRetencionGarantiaBase(importeGarantiaBase);
								Double importeCuota = gastoProveedorApi.recalcularCuotaRetencionGarantia(gastoDetalle, importeGarantiaBase);
								gastoDetalle.setRetencionGarantiaCuota(importeCuota);
								
								importeTotal = gastoProveedorApi.recalcularImporteTotalGasto(gastoDetalle);
								gastoDetalle.setImporteTotal(importeTotal);
								GastoDetalleEconomico updateGastoDetalleEconomico = HibernateUtils.merge(gastoDetalle);
								genericDao.update(GastoDetalleEconomico.class, updateGastoDetalleEconomico);
						}
					}
					
					List<GastoLineaDetalle> gastoLineaDetalleList = dtoGastos.getAllLineasDetalle();
					if(gastoLineaDetalleList != null && !gastoLineaDetalleList.isEmpty()) {
						for (GastoLineaDetalle gastoLineaDetalle : gastoLineaDetalleList) {
							String subtipoGastoCodigo = gastoLineaDetalle.getSubtipoGasto().getCodigo();
							DtoLineaDetalleGasto dtoLinea = gastoLineaDetalleApi.calcularCuentasYPartidas(gastoLineaDetalle.getGastoProveedor(), gastoLineaDetalle.getId(), subtipoGastoCodigo, null);	
							gastoLineaDetalle = gastoLineaDetalleApi.setCuentasPartidasDtoToObject( gastoLineaDetalle, dtoLinea);
							GastoLineaDetalle updateLinea = HibernateUtils.merge(gastoLineaDetalle);
							genericDao.update(GastoLineaDetalle.class, updateLinea);
						}
					}
					
					List<GastoProveedor> listaGastoProveedor = dtoGastos.getAllGastoProveedor();
					
					if(listaGastoProveedor != null && !listaGastoProveedor.isEmpty()) {
						for (GastoProveedor gastoProveedor : listaGastoProveedor) {
							if(DDCartera.CODIGO_CARTERA_LIBERBANK.equals(gastoProveedor.getPropietario().getCartera().getCodigo())) {
								gastoLineaDetalleApi.actualizarDiariosLbk(gastoProveedor.getId());
							}
						}
					}
					
					dtoGastos.vaciarInstancias();
					
				}
		
		}catch (NumberFormatException e){
			dtoGastos.vaciarInstancias();
			logger.error("Error en MSVMasivaModificacionLineasDetalle", e);
		}catch (ParseException e){
			dtoGastos.vaciarInstancias();
			logger.error("Error en MSVMasivaModificacionLineasDetalle", e);
		}catch (NonUniqueResultException e){
			dtoGastos.vaciarInstancias();
			logger.error("Error en MSVMasivaModificacionLineasDetalle", e);
		} catch (Exception e) {
			dtoGastos.vaciarInstancias();
			logger.error("Error en MSVMasivaModificacionLineasDetalle", e);
		}
	
		return new ResultadoProcesarFila();
	}

	@Override
	public int getFilaInicial() {
		return DATOS_PRIMERA_FILA;
	}

	private boolean stringToBoolean(String valor){
		boolean bool = false;
		if(!Checks.esNulo(valor) && Arrays.asList(listaValidosPositivos).contains(valor.toUpperCase())) {
			bool = true;
		}
		return bool;
	}
	
	private int booleanToInt(Boolean b) {
		int i = b ? 1 : 0;
		
		return i;
	}
	
	
}
