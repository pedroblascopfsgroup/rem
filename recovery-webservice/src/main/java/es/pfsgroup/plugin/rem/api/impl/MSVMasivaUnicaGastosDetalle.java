package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Session;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.support.DefaultTransactionDefinition;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ProcesoMasivoContext;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.gasto.dao.GastoDao;
import es.pfsgroup.plugin.rem.gasto.linea.detalle.dao.GastoLineaDetalleDao;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoPropietario;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.Ejercicio;
import es.pfsgroup.plugin.rem.model.GastoDetalleEconomico;
import es.pfsgroup.plugin.rem.model.GastoInfoContabilidad;
import es.pfsgroup.plugin.rem.model.GastoLineaDetalle;
import es.pfsgroup.plugin.rem.model.GastoLineaDetalleEntidad;
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDDestinatarioGasto;
import es.pfsgroup.plugin.rem.model.dd.DDEntidadGasto;
import es.pfsgroup.plugin.rem.model.dd.DDSinSiNo;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoGasto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComisionado;
import es.pfsgroup.plugin.rem.model.dd.DDTipoGasto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoOperacionGasto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPeriocidad;
import es.pfsgroup.plugin.rem.model.dd.DDTipoRecargoGasto;
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
	public static final Integer COL_NIF_EMISOR = 6;
	public static final Integer COL_DESTINATARIO = 7;
	public static final Integer COL_NIF_PROPIETARIO = 8;
	public static final Integer COL_F_EMISION_DEVENGO = 9;
	public static final Integer COL_TIPO_OPERACION = 10;
	public static final Integer COL_C_GASTO_REFACTURABLE = 11;
	public static final Integer COL_REPERCUTIBLE_INQUILINO = 12;
	public static final Integer COL_C_PAGO_CONEXION = 13;
	public static final Integer COL_NUM_CONEXION = 14;
	public static final Integer COL_F_CONEXION = 15;
	public static final Integer COL_OFICINA = 16;
	public static final Integer COL_RETENCION_GARANTIA_BASE = 17;
	public static final Integer COL_RETENCION_GARANTIA_PORCENTAJE = 18;
	public static final Integer COL_IRPF_BASE = 19;
	public static final Integer COL_IRPF_PORCENTAJE = 20;
	public static final Integer COL_IRPF_CLAVE = 21;
	public static final Integer COL_IRPF_SUBCLAVE = 22;
	public static final Integer COL_PLAN_VISITAS = 23;
	public static final Integer COL_ACTIVABLE = 24;
	public static final Integer COL_COD_AGRUPACION_LINEA_DETALLE = 25;
	public static final Integer COL_SUBTIPO_GASTO = 26;
	public static final Integer COL_PRINCIPAL_SUJETO_IMPUESTOS = 27;
	public static final Integer COL_PRINCIPAL_NO_SUJETO_IMPUESTOS = 28;
	public static final Integer COL_TIPO_RECARGO = 29;
	public static final Integer COL_IMPORTE_RECARGO = 30;
	public static final Integer COL_INTERES_DEMORA = 31;
	public static final Integer COL_COSTES = 32;
	public static final Integer COL_OTROS_INCREMENTOS = 33;
	public static final Integer COL_PROVISIONES_Y_SUPLIDOS = 34;
	public static final Integer COL_TIPO_IMPUESTO = 35;
	public static final Integer COL_OPERACION_EXENTA = 36;
	public static final Integer COL_RENUNCIA_EXENCION = 37;
	public static final Integer COL_TIPO_IMPOSITIVO = 38;
	public static final Integer COL_OPTA_CRITERIO_CAJA_IVA = 39;
	public static final Integer COL_TIPO_COMISIONADO = 40;
	public static final Integer COL_EJERCICIO = 41;
	public static final Integer COL_ID_ELEMENTO = 42;
	public static final Integer COL_TIPO_ELEMENTO = 43;
	public static final Integer COL_PARTICIPACION_LINEA_DETALLE = 44;
	
	private static final String SI = "SI";
	private static final String S = "S";
	private static final String USUARIO = "CARGA_MASIVA";
	
	protected static final Log logger = LogFactory.getLog(MSVMasivaUnicaGastosDetalle.class);
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private GastoDao gastoDao;
	
	@Autowired
	private GastoLineaDetalleDao gastoLineaDetalleDao;
	
	@Resource(name = "entityTransactionManager")
	private PlatformTransactionManager transactionManager;
	
	private MSVHojaExcel excel;
		
	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_UNICA_GASTOS;
	}
	
	@Transactional(readOnly = false)
	@Override
	public void preProcesado(MSVHojaExcel exc, ProcesoMasivoContext context) throws NumberFormatException, IllegalArgumentException, IOException, ParseException {
		excel = exc;
		TransactionStatus transaction = null;
		transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
		HashMap<String, Long> listaAsociaciones = asociarIdsGldyGpv(excel);
		transactionManager.commit(transaction);
		context.put(ProcesoMasivoContext.LISTA_ASOCIACIONES, listaAsociaciones);

	}
	
	@Transactional(readOnly = false)
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken) throws JsonViewerException, IOException, ParseException, SQLException, Exception {
		return procesaFila(exc, fila, prmToken, new ProcesoMasivoContext());
	}

	@Transactional(readOnly = false)
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken, ProcesoMasivoContext context)
			throws IOException, ParseException, JsonViewerException, SQLException, Exception {
		
		try {
			
				Double importeTotal = 0.0;
				GastoProveedor newGastoProveedor = null;
				GastoLineaDetalle newGastoLineaDetalle = null;
				Map<String, Long> listaAsociaciones = (HashMap<String, Long>) context.get(ProcesoMasivoContext.LISTA_ASOCIACIONES);
				Long idGasto = null;
				Long idLinea = null;
				if (context.containsKey(ProcesoMasivoContext.LISTA_ASOCIACIONES)){
					String asociacionLinea = exc.dameCelda(fila, COL_ID_AGRUPADOR_GASTO).concat(exc.dameCelda(fila, COL_COD_AGRUPACION_LINEA_DETALLE));
					Iterator<Entry<String, Long>> it = listaAsociaciones.entrySet().iterator();
					
					while (it.hasNext()) {
						Map.Entry e = (Map.Entry)it.next();
						if(e.getKey().equals(exc.dameCelda(fila, COL_ID_AGRUPADOR_GASTO))) {
							idGasto = (Long) e.getValue();
						}
						if(e.getKey().equals(asociacionLinea)) {
							idLinea = (Long) e.getValue();
						}
					}	
				}
				
				if(!Checks.esNulo(idGasto))	{
					newGastoProveedor = genericDao.get(GastoProveedor.class, genericDao.createFilter(FilterType.EQUALS, "id", idGasto)); 
				}
				
				
				if(Checks.esNulo(newGastoProveedor)) {
					
					newGastoProveedor = new GastoProveedor();
					
					newGastoProveedor.setNumGastoHaya(gastoDao.getNextNumGasto());
					
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
					
					
					List<ActivoProveedor> emisor = genericDao.getList(ActivoProveedor.class, genericDao.createFilter(FilterType.EQUALS, "docIdentificativo", exc.dameCelda(fila, COL_NIF_EMISOR)));
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
					Auditoria auditoria = new Auditoria();
					auditoria.setBorrado(false);
					auditoria.setFechaCrear(new Date());
					auditoria.setUsuarioCrear(USUARIO);
					newGastoProveedor.setAuditoria(auditoria);
	
					gastoDao.saveGasto(newGastoProveedor);
				}
				 
				////////////////////////////////////////////
				/// Comienza inserción GastoLineaDetalle ///
				////////////////////////////////////////////
				

				if (!Checks.esNulo(idLinea)){
					newGastoLineaDetalle = genericDao.get(GastoLineaDetalle.class, genericDao.createFilter(FilterType.EQUALS, "id", idLinea)); 
				}
				
				if(Checks.esNulo(newGastoLineaDetalle)) {
					
					newGastoLineaDetalle = new GastoLineaDetalle();

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
						if(SI.equalsIgnoreCase(exc.dameCelda(fila, COL_OPERACION_EXENTA)) || S.equalsIgnoreCase(exc.dameCelda(fila, COL_OPERACION_EXENTA))) {
							newGastoLineaDetalle.setEsImporteIndirectoExento(true);
						} else {
							newGastoLineaDetalle.setEsImporteIndirectoExento(false);
						}
					}
					
					if(exc.dameCelda(fila, COL_RENUNCIA_EXENCION) != null && !exc.dameCelda(fila, COL_RENUNCIA_EXENCION).isEmpty()) {
						if(SI.equalsIgnoreCase(exc.dameCelda(fila, COL_RENUNCIA_EXENCION)) || S.equalsIgnoreCase(exc.dameCelda(fila, COL_RENUNCIA_EXENCION))) {
							newGastoLineaDetalle.setEsImporteIndirectoExento(true);
						} else {
							newGastoLineaDetalle.setEsImporteIndirectoExento(false);
						}
					}
					
					if(exc.dameCelda(fila, COL_TIPO_IMPOSITIVO) != null && !exc.dameCelda(fila, COL_TIPO_IMPOSITIVO).isEmpty()) {
						newGastoLineaDetalle.setImporteIndirectoTipoImpositivo(Double.parseDouble(exc.dameCelda(fila, COL_TIPO_IMPOSITIVO)));
					}
					
					if(exc.dameCelda(fila, COL_TIPO_IMPOSITIVO) != null && !exc.dameCelda(fila, COL_TIPO_IMPOSITIVO).isEmpty()) {
						newGastoLineaDetalle.setImporteIndirectoCuota(Double.parseDouble(exc.dameCelda(fila, COL_TIPO_IMPOSITIVO)) / 100);
						importeTotal = importeTotal + newGastoLineaDetalle.getImporteIndirectoCuota();
					}
					
					
					newGastoLineaDetalle.setImporteTotal(importeTotal);
					
					Auditoria auditoria = new Auditoria();
					auditoria.setBorrado(false);
					auditoria.setFechaCrear(new Date());
					auditoria.setUsuarioCrear(USUARIO);
					newGastoLineaDetalle.setAuditoria(auditoria);
					gastoLineaDetalleDao.saveGastoLineaDetalle(newGastoLineaDetalle);
				}
				
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
										if(decimal.compareTo(BigDecimal.ZERO) < 0) {
											participacionPorActivo = participacionPorActivo.add(decimal);
										}else if(decimal.compareTo(BigDecimal.ZERO) > 0) {
											participacionPorActivo = participacionPorActivo.subtract(decimal);
										}										
								    }
									 
								   gastoLineaDetalleEntidad.setParticipacionGasto(participacionPorActivo.doubleValue());
								   genericDao.save(GastoLineaDetalleEntidad.class,gastoLineaDetalleEntidad);
								}
								
								
							}
						}
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
				
				if(!Checks.esNulo(gastoDetalleEconomico)) {
					
					if(exc.dameCelda(fila, COL_REPERCUTIBLE_INQUILINO) != null && !exc.dameCelda(fila, COL_REPERCUTIBLE_INQUILINO).isEmpty()) {
						gastoDetalleEconomico.setRepercutibleInquilino(Integer.valueOf(exc.dameCelda(fila, COL_REPERCUTIBLE_INQUILINO)));
					}
					
					if(exc.dameCelda(fila, COL_C_PAGO_CONEXION) != null && !exc.dameCelda(fila, COL_C_PAGO_CONEXION).isEmpty()) {
						gastoDetalleEconomico.setPagadoConexionBankia(Integer.valueOf(exc.dameCelda(fila, COL_C_PAGO_CONEXION)));
					}
					
					if(exc.dameCelda(fila, COL_NUM_CONEXION) != null && !exc.dameCelda(fila, COL_NUM_CONEXION).isEmpty()) {
						gastoDetalleEconomico.setNumeroConexionBankia(exc.dameCelda(fila, COL_NUM_CONEXION));
					}
					
					if(exc.dameCelda(fila, COL_F_CONEXION) != null && !exc.dameCelda(fila, COL_F_CONEXION).isEmpty()) {
						gastoDetalleEconomico.setFechaConexion(new SimpleDateFormat("dd/MM/yyyy").parse(exc.dameCelda(fila, COL_F_CONEXION)));
					}
					
					if(exc.dameCelda(fila, COL_OFICINA) != null && exc.dameCelda(fila, COL_OFICINA).isEmpty()) {
						gastoDetalleEconomico.setOficinaBankia(exc.dameCelda(fila, COL_OFICINA));
					}
					
					if(exc.dameCelda(fila, COL_RETENCION_GARANTIA_BASE) != null && !exc.dameCelda(fila, COL_RETENCION_GARANTIA_BASE).isEmpty()) {
						gastoDetalleEconomico.setRetencionGarantiaBase(Double.parseDouble(exc.dameCelda(fila, COL_RETENCION_GARANTIA_BASE)));
					}
					
					if(exc.dameCelda(fila, COL_RETENCION_GARANTIA_PORCENTAJE) != null && !exc.dameCelda(fila, COL_RETENCION_GARANTIA_PORCENTAJE).isEmpty()) {
						gastoDetalleEconomico.setRetencionGarantiaTipoImpositivo(Double.parseDouble(exc.dameCelda(fila, COL_RETENCION_GARANTIA_PORCENTAJE)));
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
						if(SI.equalsIgnoreCase(exc.dameCelda(fila, COL_C_GASTO_REFACTURABLE)) || S.equalsIgnoreCase(exc.dameCelda(fila, COL_C_GASTO_REFACTURABLE))) {
							gastoDetalleEconomico.setGastoRefacturable(true);
						} else {
							gastoDetalleEconomico.setGastoRefacturable(false);
						}
					}
					
					
					// TODO recalcular importe total del gasto
					
					genericDao.update(GastoDetalleEconomico.class, gastoDetalleEconomico);

				} 
				else {
					gastoDetalleEconomico = new GastoDetalleEconomico();
					gastoDetalleEconomico.setGastoProveedor(newGastoProveedor);
					
					if(exc.dameCelda(fila, COL_REPERCUTIBLE_INQUILINO) != null && !exc.dameCelda(fila, COL_REPERCUTIBLE_INQUILINO).isEmpty()) {
						gastoDetalleEconomico.setRepercutibleInquilino(Integer.valueOf(exc.dameCelda(fila, COL_REPERCUTIBLE_INQUILINO)));
					}
					
					if(exc.dameCelda(fila, COL_C_PAGO_CONEXION) != null && !exc.dameCelda(fila, COL_C_PAGO_CONEXION).isEmpty()) {
						gastoDetalleEconomico.setPagadoConexionBankia(Integer.valueOf(exc.dameCelda(fila, COL_C_PAGO_CONEXION)));
					}
					
					if(exc.dameCelda(fila, COL_NUM_CONEXION) != null && !exc.dameCelda(fila, COL_NUM_CONEXION).isEmpty()) {
						gastoDetalleEconomico.setNumeroConexionBankia(exc.dameCelda(fila, COL_NUM_CONEXION));
					}
					
					if(exc.dameCelda(fila, COL_F_CONEXION) != null && !exc.dameCelda(fila, COL_F_CONEXION).isEmpty()) {
						gastoDetalleEconomico.setFechaConexion(new SimpleDateFormat("dd/MM/yyyy").parse(exc.dameCelda(fila, COL_F_CONEXION)));
					}
					
					if(exc.dameCelda(fila, COL_OFICINA) != null && exc.dameCelda(fila, COL_OFICINA).isEmpty()) {
						gastoDetalleEconomico.setOficinaBankia(exc.dameCelda(fila, COL_OFICINA));
					}
					
					if(exc.dameCelda(fila, COL_RETENCION_GARANTIA_BASE) != null && !exc.dameCelda(fila, COL_RETENCION_GARANTIA_BASE).isEmpty()) {
						gastoDetalleEconomico.setRetencionGarantiaBase(Double.parseDouble(exc.dameCelda(fila, COL_RETENCION_GARANTIA_BASE)));
					}
					
					if(exc.dameCelda(fila, COL_RETENCION_GARANTIA_PORCENTAJE) != null && !exc.dameCelda(fila, COL_RETENCION_GARANTIA_PORCENTAJE).isEmpty()) {
						gastoDetalleEconomico.setRetencionGarantiaTipoImpositivo(Double.parseDouble(exc.dameCelda(fila, COL_RETENCION_GARANTIA_PORCENTAJE)));
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
						if(SI.equalsIgnoreCase(exc.dameCelda(fila, COL_C_GASTO_REFACTURABLE)) || S.equalsIgnoreCase(exc.dameCelda(fila, COL_C_GASTO_REFACTURABLE))) {
							gastoDetalleEconomico.setGastoRefacturable(true);
						} else {
							gastoDetalleEconomico.setGastoRefacturable(false);
						}
					}
					
					
					// TODO recalcular importe total del gasto
					
					genericDao.save(GastoDetalleEconomico.class, gastoDetalleEconomico);
				}
				
				
				
				////////////////////////////////////////////////
				/// Comienza inserción GastoInfoContabilidad ///
				////////////////////////////////////////////////
				
			
				Filter filtroInfoContabilidad = genericDao.createFilter(FilterType.EQUALS, "gastoProveedor.id", newGastoProveedor.getId());
				GastoInfoContabilidad gastoInfoContabilidad = genericDao.get(GastoInfoContabilidad.class, filtroInfoContabilidad);
				
				
				if(!Checks.esNulo(gastoInfoContabilidad)) {
					if(exc.dameCelda(fila, COL_ACTIVABLE) !=  null && !exc.dameCelda(fila, COL_ACTIVABLE).isEmpty()) {
						if(SI.equalsIgnoreCase(exc.dameCelda(fila, COL_ACTIVABLE)) || S.equalsIgnoreCase(exc.dameCelda(fila, COL_ACTIVABLE))) {
							gastoInfoContabilidad.setActivable(genericDao.get(DDSinSiNo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDSinSiNo.CODIGO_SI)));
						} else {
							gastoInfoContabilidad.setActivable(genericDao.get(DDSinSiNo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDSinSiNo.CODIGO_NO)));
						}
					}
					
					if(exc.dameCelda(fila, COL_PLAN_VISITAS) != null && !exc.dameCelda(fila, COL_PLAN_VISITAS).isEmpty()) {
						if(SI.equalsIgnoreCase(exc.dameCelda(fila, COL_PLAN_VISITAS)) || S.equalsIgnoreCase(exc.dameCelda(fila, COL_PLAN_VISITAS))) {
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
					
					gastoInfoContabilidad.setEjercicio(ejercicio);
					
					genericDao.update(GastoInfoContabilidad.class, gastoInfoContabilidad);
					
				}
				
				else {
					
					gastoInfoContabilidad = new GastoInfoContabilidad();
					
					gastoInfoContabilidad.setGastoProveedor(newGastoProveedor);
					
					if(exc.dameCelda(fila, COL_ACTIVABLE) !=  null && !exc.dameCelda(fila, COL_ACTIVABLE).isEmpty()) {
						if(SI.equalsIgnoreCase(exc.dameCelda(fila, COL_ACTIVABLE)) || S.equalsIgnoreCase(exc.dameCelda(fila, COL_ACTIVABLE))) {
							gastoInfoContabilidad.setActivable(genericDao.get(DDSinSiNo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDSinSiNo.CODIGO_SI)));
						} else {
							gastoInfoContabilidad.setActivable(genericDao.get(DDSinSiNo.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDSinSiNo.CODIGO_NO)));
						}
					}
					
					if(exc.dameCelda(fila, COL_PLAN_VISITAS) != null && !exc.dameCelda(fila, COL_PLAN_VISITAS).isEmpty()) {
						if(SI.equalsIgnoreCase(exc.dameCelda(fila, COL_PLAN_VISITAS)) || S.equalsIgnoreCase(exc.dameCelda(fila, COL_PLAN_VISITAS))) {
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
					
					gastoInfoContabilidad.setEjercicio(ejercicio);
					
					genericDao.save(GastoInfoContabilidad.class, gastoInfoContabilidad);
				
				}
				
				//////////////////////////////////////////
				/// Comienza inserción ActivoProveedor ///
				/////////////////////////////////////////
				
				if(exc.dameCelda(fila, COL_OPTA_CRITERIO_CAJA_IVA) != null && !exc.dameCelda(fila, COL_OPTA_CRITERIO_CAJA_IVA).isEmpty()) {
					ActivoProveedor emisor = genericDao.get(ActivoProveedor.class, genericDao.createFilter(FilterType.EQUALS, "docIdentificativo", exc.dameCelda(fila, COL_NIF_EMISOR)));
					if(!Checks.esNulo(emisor)) {
						emisor.setCriterioCajaIVA(Integer.parseInt(exc.dameCelda(fila, COL_OPTA_CRITERIO_CAJA_IVA)));
						genericDao.update(ActivoProveedor.class, emisor);
					}
					
				}
				
				listaAsociaciones.put(exc.dameCelda(fila, COL_ID_AGRUPADOR_GASTO), newGastoProveedor.getId());
				listaAsociaciones.put(exc.dameCelda(fila, COL_ID_AGRUPADOR_GASTO).concat(exc.dameCelda(fila, COL_COD_AGRUPACION_LINEA_DETALLE)), newGastoLineaDetalle.getId());
				context.put(ProcesoMasivoContext.LISTA_ASOCIACIONES, listaAsociaciones);
			
		} catch (Exception e) {
			logger.error("Error en MSVMasivaModificacionLineasDetalle", e);
		}
		
		return new ResultadoProcesarFila();
	}

	@Override
	public int getFilaInicial() {
		return DATOS_PRIMERA_FILA;
	}
	
	
	/**
	 * Obtener los ids de la GLD y la GPV 
	 * y asociarlos a los identificadores de la excel
	 * 
	 * @param exc
	 * @throws IllegalArgumentException
	 * @throws IOException
	 * @throws ParseException
	 */
	@Transactional(readOnly = false)
	private HashMap<String, Long> asociarIdsGldyGpv(MSVHojaExcel exc)
			throws IllegalArgumentException, IOException, ParseException {
		HashMap<String, Long> listaAsociacion = new HashMap<String, Long>();
		String codigoGpvGld = null;
		Long id = 0L;
		for (int i = this.getFilaInicial(); i <= excel.getNumeroFilas() - 1; i++) {
			if(i == this.getFilaInicial()) {
				codigoGpvGld = exc.dameCelda(i, COL_ID_AGRUPADOR_GASTO);
				listaAsociacion.put(codigoGpvGld, id);
				codigoGpvGld = exc.dameCelda(i, COL_ID_AGRUPADOR_GASTO).concat(exc.dameCelda(i, COL_COD_AGRUPACION_LINEA_DETALLE));
				listaAsociacion.put(codigoGpvGld, id);
			}
			else {
				if(!exc.dameCelda(i, COL_ID_AGRUPADOR_GASTO).equals(exc.dameCelda(i-1, COL_ID_AGRUPADOR_GASTO))){
					codigoGpvGld = exc.dameCelda(i, COL_ID_AGRUPADOR_GASTO);
					listaAsociacion.put(codigoGpvGld, id);
					codigoGpvGld = exc.dameCelda(i, COL_ID_AGRUPADOR_GASTO).concat(exc.dameCelda(i, COL_COD_AGRUPACION_LINEA_DETALLE));
					listaAsociacion.put(codigoGpvGld, id);
				}
				if(!exc.dameCelda(i, COL_COD_AGRUPACION_LINEA_DETALLE).equals(exc.dameCelda(i-1, COL_COD_AGRUPACION_LINEA_DETALLE))){
					codigoGpvGld = exc.dameCelda(i, COL_ID_AGRUPADOR_GASTO).concat(exc.dameCelda(i, COL_COD_AGRUPACION_LINEA_DETALLE));
					listaAsociacion.put(codigoGpvGld, id);
				}
			}
		}
		return listaAsociacion;
	}
}
