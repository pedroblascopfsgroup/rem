package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;
import javax.persistence.NonUniqueResultException;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.LazyInitializationException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.Transactional;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.hibernate.HibernateUtils;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.GastoLineaDetalleApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoPatrimonioContrato;
import es.pfsgroup.plugin.rem.model.ActivoProveedor;
import es.pfsgroup.plugin.rem.model.DtoLineaDetalleGasto;
import es.pfsgroup.plugin.rem.model.GastoDetalleEconomico;
import es.pfsgroup.plugin.rem.model.GastoLineaDetalle;
import es.pfsgroup.plugin.rem.model.GastoLineaDetalleEntidad;
import es.pfsgroup.plugin.rem.model.GastoLineaDetalleTrabajo;
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDCarteraBc;
import es.pfsgroup.plugin.rem.model.dd.DDEntidadGasto;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionComercial;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoGasto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoRecargoGasto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTransmision;
import es.pfsgroup.plugin.rem.model.dd.DDTiposImpuesto;


@Component
public class MSVMasivaModificacionLineasDetalle extends AbstractMSVActualizador implements MSVLiberator {
	private static final int DATOS_PRIMERA_FILA = 1;
	private static final int ID_GASTO = 0;
	private static final int ACCION_LINIA_DETALLE = 1;
	private static final int ID_LINEA = 2;
	private static final int SUBTIPO_GASTO = 3;
	private static final int PRINCIPAL_SUJETO_A_IMPUESTO = 4;
	private static final int PRINCIPAL_NO_SUJETO_A_IMPUESTO = 5;
	private static final int TIPO_RECARGO = 6;
	private static final int IMPORTE_RECARGO = 7;
	private static final int INTERES_DEMORA = 8;
	private static final int COSTES = 9;
	private static final int OTROS_INCREMENTOS = 10;
	private static final int PROVISIONES_SUPLIDOS = 11;
	private static final int TIPO_IMPUESTO = 12;
	private static final int OPERACION_EXENTA = 13;
	private static final int RENUNCIA_EXENCION = 14;
	private static final int TIPO_IMPOSITIVO = 15;
	private static final int OPTA_POR_CRITERIO_DE_CAJA_EN_IVA = 16;
	private static final int ID_ELEMENTO = 17;
	private static final int TIPO_ELEMENTO = 18;
	private static final int PARTICIPACION_LINEA_DETALLE = 19;
	
	private static final String[] listaCampoAccionAnyadir = { "AÑADIR" , "A" };
	private static final String[] listaCampoAccionBorrar = { "BORRAR" , "B" };
	
	private static final String SI = "SI";
	private static final String S = "S";
	
	protected static final Log logger = LogFactory.getLog(MSVMasivaModificacionLineasDetalle.class);
	
	private static List<GastoLineaDetalle> nuevasLineasList;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private GastoLineaDetalleApi gastoLineaDetalleApi;
	
	@Resource(name = "entityTransactionManager")
	private PlatformTransactionManager transactionManager;
			
	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_MODIFICACION_LINEAS_DE_DETALLE;
	}
	

	@Override
	@Transactional
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken)
			throws IOException, ParseException, JsonViewerException, SQLException, Exception {
		
		try {
			
			if(nuevasLineasList == null) {
				nuevasLineasList = new ArrayList<GastoLineaDetalle>();
			}
			String accionRealizar = exc.dameCelda(fila, ACCION_LINIA_DETALLE);
			
			if(Arrays.asList(listaCampoAccionAnyadir).contains(accionRealizar.toUpperCase())) {
				Double importeTotal = 0.0;
				GastoLineaDetalle gastoLineaDetalle = new GastoLineaDetalle();
				
				Filter filtroGasto = genericDao.createFilter(FilterType.EQUALS, "numGastoHaya", Long.parseLong(exc.dameCelda(fila, ID_GASTO)));
				GastoProveedor gastoProveedor = genericDao.get(GastoProveedor.class, filtroGasto);
				GastoDetalleEconomico gastoDetalleEconomico = gastoProveedor.getGastoDetalleEconomico();
				
				Filter tipoImpuestoFilter;
				Filter tipoImpositivoFilter;
				
				if(exc.dameCelda(fila, TIPO_IMPUESTO) == null || exc.dameCelda(fila, TIPO_IMPUESTO).isEmpty()) {
					tipoImpuestoFilter = genericDao.createFilter(FilterType.NULL, "tipoImpuesto");
				}else {
					tipoImpuestoFilter = genericDao.createFilter(FilterType.EQUALS, "tipoImpuesto.codigo", exc.dameCelda(fila, TIPO_IMPUESTO));
				}
				
				if(exc.dameCelda(fila, TIPO_IMPOSITIVO) == null || exc.dameCelda(fila, TIPO_IMPOSITIVO).isEmpty()) {
					tipoImpositivoFilter = genericDao.createFilter(FilterType.NULL, "importeIndirectoTipoImpositivo");
				}else {
					tipoImpositivoFilter = genericDao.createFilter(FilterType.EQUALS, "importeIndirectoTipoImpositivo", Double.parseDouble(exc.dameCelda(fila, TIPO_IMPOSITIVO)));
				}
				
				GastoLineaDetalle gastoLineaDetalleExistente = genericDao.get(GastoLineaDetalle.class, genericDao.createFilter(FilterType.EQUALS, "gastoProveedor.id", gastoProveedor.getId()),
						genericDao.createFilter(FilterType.EQUALS, "subtipoGasto.codigo", exc.dameCelda(fila, SUBTIPO_GASTO)),tipoImpuestoFilter, tipoImpositivoFilter );
				
				if(gastoLineaDetalleExistente == null) {
					gastoLineaDetalle.setGastoProveedor(gastoProveedor);
					
					Filter filtroSubGasto = genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, SUBTIPO_GASTO));
					DDSubtipoGasto subtipoGasto = genericDao.get(DDSubtipoGasto.class, filtroSubGasto);
					
					gastoLineaDetalle.setSubtipoGasto(subtipoGasto);
					
					if(exc.dameCelda(fila, PRINCIPAL_SUJETO_A_IMPUESTO) != null && !exc.dameCelda(fila, PRINCIPAL_SUJETO_A_IMPUESTO).isEmpty()) {
						gastoLineaDetalle.setPrincipalSujeto(Double.parseDouble(exc.dameCelda(fila, PRINCIPAL_SUJETO_A_IMPUESTO)));
						importeTotal = importeTotal + Double.parseDouble(exc.dameCelda(fila, PRINCIPAL_SUJETO_A_IMPUESTO));
					}
					
					if(exc.dameCelda(fila, PRINCIPAL_NO_SUJETO_A_IMPUESTO) != null && !exc.dameCelda(fila, PRINCIPAL_NO_SUJETO_A_IMPUESTO).isEmpty()) {
						gastoLineaDetalle.setPrincipalNoSujeto(Double.parseDouble(exc.dameCelda(fila, PRINCIPAL_NO_SUJETO_A_IMPUESTO)));
						importeTotal = importeTotal + Double.parseDouble(exc.dameCelda(fila, PRINCIPAL_NO_SUJETO_A_IMPUESTO));
					}
					
					if(exc.dameCelda(fila, TIPO_RECARGO) != null && !exc.dameCelda(fila, TIPO_RECARGO).isEmpty()) {
						Filter filtroTipoRecargo = genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, TIPO_RECARGO));
						DDTipoRecargoGasto tipoRecargoGasto = genericDao.get(DDTipoRecargoGasto.class, filtroTipoRecargo);
						
						gastoLineaDetalle.setTipoRecargoGasto(tipoRecargoGasto);
					}
					
					if(exc.dameCelda(fila, IMPORTE_RECARGO) != null && !exc.dameCelda(fila, IMPORTE_RECARGO).isEmpty()) {
						gastoLineaDetalle.setRecargo(Double.parseDouble(exc.dameCelda(fila, IMPORTE_RECARGO)));
						importeTotal = importeTotal + Double.parseDouble(exc.dameCelda(fila, IMPORTE_RECARGO));
					}
					
					if(exc.dameCelda(fila, INTERES_DEMORA) != null && !exc.dameCelda(fila, INTERES_DEMORA).isEmpty()) {
						gastoLineaDetalle.setInteresDemora(Double.parseDouble(exc.dameCelda(fila, INTERES_DEMORA)));
						importeTotal = importeTotal + Double.parseDouble(exc.dameCelda(fila, INTERES_DEMORA));
					}
					
					if(exc.dameCelda(fila, COSTES) != null && !exc.dameCelda(fila, COSTES).isEmpty()) {
						gastoLineaDetalle.setCostas(Double.parseDouble(exc.dameCelda(fila, COSTES)));
						importeTotal = importeTotal + Double.parseDouble(exc.dameCelda(fila, COSTES));
					}
					
					if(exc.dameCelda(fila, OTROS_INCREMENTOS) != null && !exc.dameCelda(fila, OTROS_INCREMENTOS).isEmpty()) {
						gastoLineaDetalle.setOtrosIncrementos(Double.parseDouble(exc.dameCelda(fila, OTROS_INCREMENTOS)));
						importeTotal = importeTotal + Double.parseDouble(exc.dameCelda(fila, OTROS_INCREMENTOS));
					}
					
					if(exc.dameCelda(fila, PROVISIONES_SUPLIDOS) != null && !exc.dameCelda(fila, PROVISIONES_SUPLIDOS).isEmpty()) {
						gastoLineaDetalle.setProvSuplidos(Double.parseDouble(exc.dameCelda(fila, PROVISIONES_SUPLIDOS)));
						importeTotal = importeTotal + Double.parseDouble(exc.dameCelda(fila, PROVISIONES_SUPLIDOS));
					}
					
					if(exc.dameCelda(fila, TIPO_IMPUESTO) != null && !exc.dameCelda(fila, TIPO_IMPUESTO).isEmpty()) {
						Filter filtroTipoImpuesto= genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, TIPO_IMPUESTO));
						DDTiposImpuesto tipoImpuesto = genericDao.get(DDTiposImpuesto.class, filtroTipoImpuesto);
						
						gastoLineaDetalle.setTipoImpuesto(tipoImpuesto);
					}
					
					if(exc.dameCelda(fila, OPERACION_EXENTA) != null && !exc.dameCelda(fila, OPERACION_EXENTA).isEmpty()) {
						
						if(SI.equalsIgnoreCase(exc.dameCelda(fila, OPERACION_EXENTA)) || S.equalsIgnoreCase(exc.dameCelda(fila, OPERACION_EXENTA))) {
							gastoLineaDetalle.setEsImporteIndirectoExento(true);
						} else {
							gastoLineaDetalle.setEsImporteIndirectoExento(false);
						}
					}
					
					if(exc.dameCelda(fila, RENUNCIA_EXENCION) != null && !exc.dameCelda(fila, RENUNCIA_EXENCION).isEmpty()) {
						
						if(SI.equalsIgnoreCase(exc.dameCelda(fila, RENUNCIA_EXENCION)) || S.equalsIgnoreCase(exc.dameCelda(fila, RENUNCIA_EXENCION))) {
							gastoLineaDetalle.setEsImporteIndirectoRenunciaExento(true);
						} else {
							gastoLineaDetalle.setEsImporteIndirectoRenunciaExento(false);
						}
					}
					
					if(exc.dameCelda(fila, TIPO_IMPOSITIVO) != null && !exc.dameCelda(fila, TIPO_IMPOSITIVO).isEmpty()) {
						gastoLineaDetalle.setImporteIndirectoTipoImpositivo(Double.parseDouble(exc.dameCelda(fila, TIPO_IMPOSITIVO)));
					}
					
					if(exc.dameCelda(fila, OPTA_POR_CRITERIO_DE_CAJA_EN_IVA) != null && !exc.dameCelda(fila, OPTA_POR_CRITERIO_DE_CAJA_EN_IVA).isEmpty()) {
						int optaCajaIvas= 0;
						if(SI.equalsIgnoreCase(exc.dameCelda(fila, OPTA_POR_CRITERIO_DE_CAJA_EN_IVA)) || S.equalsIgnoreCase(exc.dameCelda(fila, OPTA_POR_CRITERIO_DE_CAJA_EN_IVA))) {
							optaCajaIvas= 1;
						}
						if(gastoLineaDetalle.getGastoProveedor() != null && gastoLineaDetalle.getGastoProveedor().getProveedor() != null ) {
							if(gastoLineaDetalle.getGastoProveedor().getProveedor().getCriterioCajaIVA() != null ) {
								if(gastoLineaDetalle.getGastoProveedor().getProveedor().getCriterioCajaIVA() != optaCajaIvas) {
									gastoLineaDetalle.getGastoProveedor().getProveedor().setCriterioCajaIVA(optaCajaIvas);
									genericDao.update(ActivoProveedor.class, gastoLineaDetalle.getGastoProveedor().getProveedor());
								}
							}else {
								gastoLineaDetalle.getGastoProveedor().getProveedor().setCriterioCajaIVA(optaCajaIvas);
								genericDao.update(ActivoProveedor.class, gastoLineaDetalle.getGastoProveedor().getProveedor());
							}
							
						}
					}
					if(gastoLineaDetalle.getPrincipalSujeto() != null && gastoLineaDetalle.getImporteIndirectoTipoImpositivo() != null && 
						gastoLineaDetalle.getPrincipalSujeto() != 0 && gastoLineaDetalle.getImporteIndirectoTipoImpositivo() != 0) {
						
						BigDecimal importe =  (new BigDecimal(gastoLineaDetalle.getPrincipalSujeto()).multiply(new BigDecimal(gastoLineaDetalle.getImporteIndirectoTipoImpositivo())));
						importe = importe.divide(new BigDecimal(100));
						
						gastoLineaDetalle.setImporteIndirectoCuota(importe.doubleValue());
					}else {
						gastoLineaDetalle.setImporteIndirectoCuota(0.0);
					}
					
					importeTotal =  importeTotal+ gastoLineaDetalle.getImporteIndirectoCuota();
					gastoLineaDetalle.setImporteTotal(importeTotal);
					gastoDetalleEconomico.setImporteTotal(importeTotal);
					
					genericDao.update(GastoDetalleEconomico.class, gastoDetalleEconomico);
					genericDao.save(GastoLineaDetalle.class, gastoLineaDetalle);
					
					nuevasLineasList.add(gastoLineaDetalle);
					
				}else {
					gastoLineaDetalle = gastoLineaDetalleExistente;
				}
				
				
				

				if(exc.dameCelda(fila, ID_ELEMENTO) != null && !exc.dameCelda(fila, ID_ELEMENTO).isEmpty()) {
					Filter filtroTipoEntidad = genericDao.createFilter(FilterType.EQUALS, "codigo", exc.dameCelda(fila, TIPO_ELEMENTO));
					DDEntidadGasto entidadGasto = genericDao.get(DDEntidadGasto.class, filtroTipoEntidad);
					
					if(DDEntidadGasto.CODIGO_AGRUPACION.equals(entidadGasto.getCodigo())) {
						Filter filtroAgrupacion = genericDao.createFilter(FilterType.EQUALS, "numAgrupRem", Long.parseLong(exc.dameCelda(fila, ID_ELEMENTO)));
						ActivoAgrupacion agrupacion = genericDao.get(ActivoAgrupacion.class, filtroAgrupacion);
						
						if(agrupacion != null) {
							List<ActivoAgrupacionActivo> activosAgrupacion= agrupacion.getActivos();
							int i = 0;
							if(activosAgrupacion != null && !activosAgrupacion.isEmpty()) {
								Filter filtroTipoEntidadActivo = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEntidadGasto.CODIGO_ACTIVO);
								DDEntidadGasto entidadGastoActivo = genericDao.get(DDEntidadGasto.class, filtroTipoEntidadActivo);
								BigDecimal participacion = new BigDecimal(exc.dameCelda(fila, PARTICIPACION_LINEA_DETALLE)); 
								BigDecimal numActivos = new BigDecimal(activosAgrupacion.size());
								BigDecimal participacionPorActivo = participacion.divide(numActivos, 2, RoundingMode.HALF_UP);
								BigDecimal sumaParticipacion = BigDecimal.valueOf(0.0);
								for (ActivoAgrupacionActivo activoAgrupacionActivo : activosAgrupacion) {
									GastoLineaDetalleEntidad gastoLineaDetalleEntidad = new GastoLineaDetalleEntidad();
									gastoLineaDetalleEntidad.setGastoLineaDetalle(gastoLineaDetalle);
									gastoLineaDetalleEntidad.setEntidad(activoAgrupacionActivo.getActivo().getId());
									gastoLineaDetalleEntidad.setEntidadGasto(entidadGastoActivo);
									sumaParticipacion = sumaParticipacion.add(participacionPorActivo);
									if((i++ == activosAgrupacion.size() - 1) && sumaParticipacion != participacion){
										BigDecimal decimal = sumaParticipacion.subtract(participacion);
										participacionPorActivo = participacionPorActivo.subtract(decimal);									
								     }
									 
								   gastoLineaDetalleEntidad.setParticipacionGasto(participacionPorActivo.doubleValue());
								   if (activoAgrupacionActivo.getActivo() != null && activoAgrupacionActivo.getActivo().getId() != null) {
									   Filter filtroPatrimonioActivoContrato = genericDao.createFilter(FilterType.EQUALS, "activo.id", activoAgrupacionActivo.getActivo().getId());
									   ActivoPatrimonioContrato patrimonioContrato = genericDao.get(ActivoPatrimonioContrato.class, filtroPatrimonioActivoContrato);
									   if (patrimonioContrato != null) {
										   if (gastoLineaDetalleApi.activoPatrimonioContratoAlquilada(patrimonioContrato)) {
											   Filter filtroCarteraBc = genericDao.createFilter(FilterType.EQUALS, "codigo", DDCarteraBc.CODIGO_ALQUILER);
											   DDCarteraBc ddCarteraBc = genericDao.get(DDCarteraBc.class, filtroCarteraBc);
											   gastoLineaDetalleEntidad.setCarteraBc(ddCarteraBc);
										   } else {
											   Filter filtroCarteraBc = genericDao.createFilter(FilterType.EQUALS, "codigo", DDCarteraBc.CODIGO_VENTA);
											   DDCarteraBc ddCarteraBc = genericDao.get(DDCarteraBc.class, filtroCarteraBc);
											   gastoLineaDetalleEntidad.setCarteraBc(ddCarteraBc);
										   }
									   } else {
											Filter filtroCarteraBc = genericDao.createFilter(FilterType.EQUALS, "codigo", DDCarteraBc.CODIGO_VENTA);
											DDCarteraBc ddCarteraBc = genericDao.get(DDCarteraBc.class, filtroCarteraBc);
											gastoLineaDetalleEntidad.setCarteraBc(ddCarteraBc);
									   }
									   if (activoAgrupacionActivo.getActivo().getTipoTransmision() != null && activoAgrupacionActivo.getActivo().getTipoTransmision().getCodigo() != null) {
										   Filter filtroTipoTransmision = genericDao.createFilter(FilterType.EQUALS, "codigo", activoAgrupacionActivo.getActivo().getTipoTransmision().getCodigo());
										   DDTipoTransmision tipoTransmision = genericDao.get(DDTipoTransmision.class, filtroTipoTransmision);
										   if (tipoTransmision != null) {
											   gastoLineaDetalleEntidad.setTipoTransmision(tipoTransmision);
										   }
									   }
									   if (activoAgrupacionActivo.getActivo().getSituacionComercial() != null && activoAgrupacionActivo.getActivo().getSituacionComercial().getCodigo() != null
											  &&  DDSituacionComercial.CODIGO_VENDIDO.equals(activoAgrupacionActivo.getActivo().getSituacionComercial().getCodigo())) {
										   Filter filtroSituacionComercial= genericDao.createFilter(FilterType.EQUALS, "codigo", DDSituacionComercial.CODIGO_VENDIDO);
										   DDSituacionComercial ddSituacionComercial = genericDao.get(DDSituacionComercial.class, filtroSituacionComercial);
										   gastoLineaDetalleEntidad.setSituacionComercial(ddSituacionComercial);
									   } else {
										   gastoLineaDetalleEntidad.setSituacionComercial(null);
									   }
								   }
								   genericDao.save(GastoLineaDetalleEntidad.class,gastoLineaDetalleEntidad);
								}
								
								
							}
						}
					}else if (DDEntidadGasto.CODIGO_ACTIVO.equals(entidadGasto.getCodigo())) {
						
						Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "numActivo",  Long.parseLong(exc.dameCelda(fila, ID_ELEMENTO)));
						Activo activo = genericDao.get(Activo.class, filtroActivo);
						
						GastoLineaDetalleEntidad gastoLineaDetalleEntidad = new GastoLineaDetalleEntidad();
						gastoLineaDetalleEntidad.setGastoLineaDetalle(gastoLineaDetalle);
						gastoLineaDetalleEntidad.setEntidad(activo.getId());
						gastoLineaDetalleEntidad.setEntidadGasto(entidadGasto);
						gastoLineaDetalleEntidad.setParticipacionGasto(Double.parseDouble(exc.dameCelda(fila, PARTICIPACION_LINEA_DETALLE)));
						if (activo != null && activo.getId() != null) {
							Filter filtroPatrimonioActivoContrato = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
							ActivoPatrimonioContrato patrimonioContrato = genericDao.get(ActivoPatrimonioContrato.class, filtroPatrimonioActivoContrato);
							   if (patrimonioContrato != null) {
								   if (gastoLineaDetalleApi.activoPatrimonioContratoAlquilada(patrimonioContrato)) {
									   Filter filtroCarteraBc = genericDao.createFilter(FilterType.EQUALS, "codigo", DDCarteraBc.CODIGO_ALQUILER);
									   DDCarteraBc ddCarteraBc = genericDao.get(DDCarteraBc.class, filtroCarteraBc);
									   gastoLineaDetalleEntidad.setCarteraBc(ddCarteraBc);
								   } else {
									   Filter filtroCarteraBc = genericDao.createFilter(FilterType.EQUALS, "codigo", DDCarteraBc.CODIGO_VENTA);
									   DDCarteraBc ddCarteraBc = genericDao.get(DDCarteraBc.class, filtroCarteraBc);
									   gastoLineaDetalleEntidad.setCarteraBc(ddCarteraBc);
								   }
							   } else {
									Filter filtroCarteraBc = genericDao.createFilter(FilterType.EQUALS, "codigo", DDCarteraBc.CODIGO_VENTA);
									DDCarteraBc ddCarteraBc = genericDao.get(DDCarteraBc.class, filtroCarteraBc);
									gastoLineaDetalleEntidad.setCarteraBc(ddCarteraBc);
							   }
							   if (activo.getTipoTransmision() != null && activo.getTipoTransmision().getCodigo() != null) {
								   Filter filtroTipoTransmision = genericDao.createFilter(FilterType.EQUALS, "codigo", activo.getTipoTransmision().getCodigo());
								   DDTipoTransmision tipoTransmision = genericDao.get(DDTipoTransmision.class, filtroTipoTransmision);
								   if (tipoTransmision != null) {
									   gastoLineaDetalleEntidad.setTipoTransmision(tipoTransmision);
								   }
							   }
							   if (activo.getSituacionComercial() != null && activo.getSituacionComercial().getCodigo() != null
										  &&  DDSituacionComercial.CODIGO_VENDIDO.equals(activo.getSituacionComercial().getCodigo())) {
									   Filter filtroSituacionComercial= genericDao.createFilter(FilterType.EQUALS, "codigo", DDSituacionComercial.CODIGO_VENDIDO);
									   DDSituacionComercial ddSituacionComercial = genericDao.get(DDSituacionComercial.class, filtroSituacionComercial);
									   gastoLineaDetalleEntidad.setSituacionComercial(ddSituacionComercial);
							   } else {
									   gastoLineaDetalleEntidad.setSituacionComercial(null);
							   }
						   }
						genericDao.save(GastoLineaDetalleEntidad.class,gastoLineaDetalleEntidad);
						
					}else {
						GastoLineaDetalleEntidad gastoLineaDetalleEntidad = new GastoLineaDetalleEntidad();
						gastoLineaDetalleEntidad.setGastoLineaDetalle(gastoLineaDetalle);
						gastoLineaDetalleEntidad.setEntidad(Long.parseLong(exc.dameCelda(fila, ID_ELEMENTO)));
						gastoLineaDetalleEntidad.setEntidadGasto(entidadGasto);
						gastoLineaDetalleEntidad.setParticipacionGasto(Double.parseDouble(exc.dameCelda(fila, PARTICIPACION_LINEA_DETALLE)));
						genericDao.save(GastoLineaDetalleEntidad.class,gastoLineaDetalleEntidad);
					}
				}

			}else if(Arrays.asList(listaCampoAccionBorrar).contains(accionRealizar.toUpperCase())) {
				Double importeTotal = 0.0;
				Filter filtroGasto = genericDao.createFilter(FilterType.EQUALS, "numGastoHaya", Long.parseLong(exc.dameCelda(fila, ID_GASTO)));
				GastoProveedor gastoProveedor = genericDao.get(GastoProveedor.class, filtroGasto);
				GastoLineaDetalle gastoLineaDetalle = null;
				
				if (!Checks.esNulo(exc.dameCelda(fila, ID_LINEA))) {
					Filter filtroLinea = genericDao.createFilter(FilterType.EQUALS, "id", Long.parseLong(exc.dameCelda(fila, ID_LINEA)));
					gastoLineaDetalle = genericDao.get(GastoLineaDetalle.class,filtroLinea);
				}

				if(gastoLineaDetalle != null) {
					List<GastoLineaDetalleEntidad> gastoLineaDetalleEntidadList = gastoLineaDetalle.getGastoLineaEntidadList();
					
					if(gastoLineaDetalleEntidadList != null && !gastoLineaDetalleEntidadList.isEmpty()) {
						for (GastoLineaDetalleEntidad gastoLineaDetalleEntidad: gastoLineaDetalleEntidadList) {
							gastoLineaDetalleEntidad.getAuditoria().setBorrado(true);
							gastoLineaDetalleEntidad.getAuditoria().setFechaBorrar(new Date());
							gastoLineaDetalleEntidad.getAuditoria().setUsuarioBorrar(genericAdapter.getUsuarioLogado().getUsername());
							genericDao.update(GastoLineaDetalleEntidad.class, gastoLineaDetalleEntidad);
						}
					}
					
					List<GastoLineaDetalleTrabajo> gastoLineaDetalleTrabajoList = gastoLineaDetalle.getGastoLineaTrabajoList();
					
					if(gastoLineaDetalleTrabajoList != null && !gastoLineaDetalleTrabajoList.isEmpty()) {
						for (GastoLineaDetalleTrabajo gastoLineaDetalleTrabajo : gastoLineaDetalleTrabajoList) {
							gastoLineaDetalleTrabajo.getAuditoria().setBorrado(true);
							gastoLineaDetalleTrabajo.getAuditoria().setFechaBorrar(new Date());
							gastoLineaDetalleTrabajo.getAuditoria().setUsuarioBorrar(genericAdapter.getUsuarioLogado().getUsername());
							genericDao.update(GastoLineaDetalleTrabajo.class, gastoLineaDetalleTrabajo);
						}
					}
					
					gastoLineaDetalle.getAuditoria().setBorrado(true);
					gastoLineaDetalle.getAuditoria().setFechaBorrar(new Date());
					gastoLineaDetalle.getAuditoria().setUsuarioBorrar(genericAdapter.getUsuarioLogado().getUsername());
					genericDao.update(GastoLineaDetalle.class, gastoLineaDetalle);
					//Se actualiza el GDE
					
					
					GastoDetalleEconomico gastoDetalleEconomico = gastoProveedor.getGastoDetalleEconomico();
					List<GastoLineaDetalle> listaGastoLineasDetalle = gastoProveedor.getGastoLineaDetalleList();

					if(listaGastoLineasDetalle != null && !listaGastoLineasDetalle.isEmpty()) {
						for (GastoLineaDetalle gld : listaGastoLineasDetalle) {
							if(gld.getImporteTotal() != null) {
								importeTotal += gld.getImporteTotal();
							}
						}
						
						gastoDetalleEconomico.setImporteTotal(importeTotal);
						genericDao.update(GastoDetalleEconomico.class, gastoDetalleEconomico);
					}
				}
			}
			
			if((exc.getNumeroFilas() -1 ) ==  fila) {
				if(nuevasLineasList != null && !nuevasLineasList.isEmpty()) {
					for (GastoLineaDetalle gastoLineaDetalle : nuevasLineasList) {
						String subtipoGastoCodigo = gastoLineaDetalle.getSubtipoGasto().getCodigo(); 
						Filter filtroGasto = genericDao.createFilter(FilterType.EQUALS, "id", gastoLineaDetalle.getGastoProveedor().getId());
						GastoProveedor gastoProveedor = genericDao.get(GastoProveedor.class, filtroGasto);
						DtoLineaDetalleGasto dtoLinea = gastoLineaDetalleApi.calcularCuentasYPartidas(gastoProveedor, gastoLineaDetalle.getId(), subtipoGastoCodigo, null);	
						gastoLineaDetalle = gastoLineaDetalleApi.setCuentasPartidasDtoToObject( gastoLineaDetalle, dtoLinea);
						GastoLineaDetalle updateLinea = HibernateUtils.merge(gastoLineaDetalle);
						genericDao.update(GastoLineaDetalle.class, updateLinea);
					}
				}
				nuevasLineasList.clear();
			}
			
		}catch (NumberFormatException e){
			nuevasLineasList.clear();
			logger.error("Error en MSVMasivaModificacionLineasDetalle", e);
		}catch (ParseException e){
			nuevasLineasList.clear();
			logger.error("Error en MSVMasivaModificacionLineasDetalle", e);
		}catch (NonUniqueResultException e){
			nuevasLineasList.clear();
			logger.error("Error en MSVMasivaModificacionLineasDetalle", e);
		}catch (LazyInitializationException e){
			nuevasLineasList.clear();
			logger.error("Error en MSVMasivaModificacionLineasDetalle", e);
		}catch (Exception e) {
			nuevasLineasList.clear();
			logger.error("Error en MSVMasivaModificacionLineasDetalle", e);
		}	
		return new ResultadoProcesarFila();
	}

	@Override
	public int getFilaInicial() {
		return DATOS_PRIMERA_FILA;
	}

}
