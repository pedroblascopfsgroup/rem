package es.pfsgroup.plugin.rem.api.impl;

import java.io.IOException;
import java.text.ParseException;
import java.util.Date;
import java.util.List;
import java.util.regex.Pattern;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.adapter.ProcessAdapter;
import es.pfsgroup.framework.paradise.bulkUpload.liberators.MSVLiberator;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDDOperacionMasiva;
import es.pfsgroup.framework.paradise.bulkUpload.model.ResultadoProcesarFila;
import es.pfsgroup.framework.paradise.bulkUpload.utils.impl.MSVHojaExcel;
import es.pfsgroup.framework.paradise.utils.JsonViewerException;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.GastoApi;
import es.pfsgroup.plugin.rem.api.GastoProveedorApi;
import es.pfsgroup.plugin.rem.model.AdjuntoGasto;
import es.pfsgroup.plugin.rem.model.GastoGestion;
import es.pfsgroup.plugin.rem.model.GastoLineaDetalle;
import es.pfsgroup.plugin.rem.model.GastoLineaDetalleTrabajo;
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.plugin.rem.model.GastoRefacturable;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoAutorizacionHaya;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoAutorizacionPropietario;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoGasto;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoRechazoAutorizacionHaya;

@Component
public class MSVActualizadorEstadosGastos extends AbstractMSVActualizador implements MSVLiberator {
	
	@Autowired
	ProcessAdapter processAdapter;

	@Autowired
	private GastoApi gastoApi;

	@Autowired
	private GastoProveedorApi gastoProveedorApi;
	
	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private GenericABMDao genericDao;
	
	private static final String ESTADO_AUTORIZADO = "01";
	
	public static final class COL_NUM {
		static final int FILA_CABECERA = 0;
		static final int FILA_DATOS = 1;

		static final int NUM_GASTO = 0;
		static final int ESTADO = 1;
		static final int MOTIVO_RECHAZO = 2;
	}

	@Override
	public String getValidOperation() {
		return MSVDDOperacionMasiva.CODE_FILE_BULKUPLOAD_CARGA_MASIVA_ESTADOS_GASTOS;
	}

	@Override
	@Transactional
	public ResultadoProcesarFila procesaFila(MSVHojaExcel exc, int fila, Long prmToken)
			throws IOException, ParseException {
		ResultadoProcesarFila resultado = new ResultadoProcesarFila();
		try {
			
			final String numGasto = exc.dameCelda(fila, COL_NUM.NUM_GASTO);
			final String estado = exc.dameCelda(fila, COL_NUM.ESTADO);
			final String motivoRechazo = exc.dameCelda(fila, COL_NUM.MOTIVO_RECHAZO);
			
			if(ESTADO_AUTORIZADO.equals(estado)) {
				autorizarGasto(numGasto);
			}else {
				rechazarGasto(numGasto,motivoRechazo);
			}
			
		} catch (Exception e) {
			throw new JsonViewerException(e.getMessage());
		}
		return resultado;
	}

	private void autorizarGasto(final String numGasto) {
		GastoProveedor gasto = gastoApi.getByNumGasto(Long.parseLong(numGasto));
		DDEstadoAutorizacionHaya estadoAutorizacionHaya = (DDEstadoAutorizacionHaya) utilDiccionarioApi
				.dameValorDiccionarioByCod(DDEstadoAutorizacionHaya.class, DDEstadoAutorizacionHaya.CODIGO_AUTORIZADO);

		DDEstadoAutorizacionPropietario estadoAutorizacionPropietario = (DDEstadoAutorizacionPropietario) utilDiccionarioApi
				.dameValorDiccionarioByCod(DDEstadoAutorizacionPropietario.class,
						DDEstadoAutorizacionPropietario.CODIGO_PENDIENTE);
		GastoGestion gastoGestion = gasto.getGastoGestion();
		gastoGestion.setEstadoAutorizacionHaya(estadoAutorizacionHaya);
		// Poner el estado autorizado propietario pendiente
		gastoGestion.setEstadoAutorizacionPropietario(estadoAutorizacionPropietario);
		gastoGestion.setUsuarioEstadoAutorizacionHaya(genericAdapter.getUsuarioLogado());
		gastoGestion.setFechaEstadoAutorizacionHaya(new Date());
		gastoGestion.setMotivoRechazoAutorizacionHaya(null);
		gastoGestion.getAuditoria().setUsuarioModificar(genericAdapter.getUsuarioLogado().getUsername());
		gastoGestion.getAuditoria().setFechaModificar(new Date());
		gastoGestion.setFechaEnvioPropietario(null);
		gasto.setGastoGestion(gastoGestion);
		updaterStateGastoProveedor(gasto, DDEstadoGasto.AUTORIZADO_ADMINISTRACION);
		gasto.setProvision(null);
		gasto.getAuditoria().setUsuarioModificar(genericAdapter.getUsuarioLogado().getUsername());
		gasto.getAuditoria().setFechaModificar(new Date());
		genericDao.update(GastoProveedor.class, gasto);
	}
	
	private void rechazarGasto(String numGasto, String motivoRechazo) {

		DDEstadoAutorizacionHaya estadoAutorizacionHaya = (DDEstadoAutorizacionHaya) utilDiccionarioApi
				.dameValorDiccionarioByCod(DDEstadoAutorizacionHaya.class, DDEstadoAutorizacionHaya.CODIGO_RECHAZADO);
		DDMotivoRechazoAutorizacionHaya motivo = null;
		if (!Checks.esNulo(motivoRechazo)) {
			motivo = (DDMotivoRechazoAutorizacionHaya) utilDiccionarioApi
					.dameValorDiccionarioByCod(DDMotivoRechazoAutorizacionHaya.class, motivoRechazo);
		}
		GastoProveedor gasto = gastoApi.getByNumGasto(Long.parseLong(numGasto));
		Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
		GastoRefacturable gastoRefacturado = genericDao.get(GastoRefacturable.class, filtroBorrado,
				genericDao.createFilter(FilterType.EQUALS, "idGastoProveedorRefacturado", gasto.getId()));
		if (!Checks.esNulo(gastoRefacturado)) {
			GastoProveedor gastoPadre = gastoProveedorApi.findOne(gastoRefacturado.getGastoProveedor());

			throw new JsonViewerException("El gasto " + gasto.getNumGastoHaya()
					+ " no se puede rechazar: Hay que desvincularlo primero del gasto" + gastoPadre.getNumGastoHaya());
		}

		// Se activa el borrado de los gastos-trabajo, y dejamos el trabajo como
		// diponible para un
		// futuro nuevo gasto
		for (GastoLineaDetalle gastoLinea : gasto.getGastoLineaDetalleList()) {
			this.reactivarTrabajoParaGastos(gastoLinea.getGastoLineaTrabajoList());
		}

		GastoGestion gastoGestion = gasto.getGastoGestion();
		gastoGestion.setEstadoAutorizacionHaya(estadoAutorizacionHaya);
		gastoGestion.setUsuarioEstadoAutorizacionHaya(genericAdapter.getUsuarioLogado());
		gastoGestion.setFechaEstadoAutorizacionHaya(new Date());
		gastoGestion.setMotivoRechazoAutorizacionHaya(motivo);
		if(!Checks.esNulo(motivo) && DDMotivoRechazoAutorizacionHaya.OTROS.equals(motivo.getCodigo()))
			gastoGestion.setMotivoRechazoDescripcionHaya(motivo.getDescripcion());
		
		gastoGestion.getAuditoria().setUsuarioModificar(genericAdapter.getUsuarioLogado().getUsername());
		gastoGestion.getAuditoria().setFechaModificar(new Date());
		
		gasto.setGastoGestion(gastoGestion);

		if (Checks.esNulo(gastoGestion.getEstadoAutorizacionPropietario())) {
			updaterStateGastoProveedor(gasto, DDEstadoGasto.RECHAZADO_ADMINISTRACION);
		} else {
			updaterStateGastoProveedor(gasto, DDEstadoGasto.RECHAZADO_PROPIETARIO);
		}

		gasto.setProvision(null);

		genericDao.save(GastoProveedor.class, gasto);

	}

	private boolean updaterStateGastoProveedor(GastoProveedor gasto, String codigo) {
		// Si no recibimos un estado
		if(Checks.esNulo(codigo)) {
			if(!Checks.esNulo(gasto.getEstadoGasto()) && !Checks.esNulo(gasto.getEstadoGasto().getCodigo())) {
				if(DDEstadoGasto.INCOMPLETO.equals(gasto.getEstadoGasto().getCodigo())) {
					codigo = estadoGastoDesdeIncompleto(gasto);
					
				}else if(DDEstadoGasto.PENDIENTE.equals(gasto.getEstadoGasto().getCodigo())) {
					codigo = estadoGastoDesdePendiente(gasto);
					
				}else if(DDEstadoGasto.RECHAZADO_ADMINISTRACION.equals(gasto.getEstadoGasto().getCodigo())) {
					//codigo = estadoGastoDesdeRechazadoAdmin(gasto);
					return true;
					
				}else if(DDEstadoGasto.RECHAZADO_PROPIETARIO.equals(gasto.getEstadoGasto().getCodigo())) {
					//codigo = estadoGastoDesdeRechazadoProp(gasto);
					return true;
					
				}else if(DDEstadoGasto.SUBSANADO.equals(gasto.getEstadoGasto().getCodigo())) {
					codigo = estadoGastoDesdeSubsanado(gasto);
					
				}else if(DDEstadoGasto.AUTORIZADO_ADMINISTRACION.equals(gasto.getEstadoGasto().getCodigo())) {
					codigo = estadoGastoDesdeAutorizadoAdmin(gasto);
					
				}else if(DDEstadoGasto.AUTORIZADO_PROPIETARIO.equals(gasto.getEstadoGasto().getCodigo())) {
					codigo = estadoGastoDesdeAutorizadoProp(gasto);
					
				}else if(DDEstadoGasto.ANULADO.equals(gasto.getEstadoGasto().getCodigo())) {
					codigo = estadoGastoDesdeAnulado(gasto);
					
				}else if(DDEstadoGasto.PAGADO.equals(gasto.getEstadoGasto().getCodigo())) {
					codigo = estadoGastoDesdePagado(gasto);
					
				}else if(DDEstadoGasto.PAGADO_SIN_JUSTIFICACION_DOC.equals(gasto.getEstadoGasto().getCodigo())) {
					codigo = estadoGastoDesdeSinJusti(gasto);
					
				}else if(DDEstadoGasto.RETENIDO.equals(gasto.getEstadoGasto().getCodigo())) {
					codigo = estadoGastoDesdeRetenido(gasto);
				}else if(DDEstadoGasto.CONTABILIZADO.equals(gasto.getEstadoGasto().getCodigo())) {
					codigo = estadoGastoDesdeContabilizado(gasto);
				}
				
				
			}else {
				codigo = DDEstadoGasto.INCOMPLETO;
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", codigo);
				DDEstadoGasto estadoGasto = genericDao.get(DDEstadoGasto.class, filtro);
				gasto.setEstadoGasto(estadoGasto);
				updaterStateGastoProveedor(gasto, null);
			}
					
		}
		// Si tenemos definido un estado, lo búscamos y modificamos en el gasto
		
		if(!Checks.esNulo(codigo)) {
			if(DDEstadoGasto.RETENIDO.equals(codigo) && !Checks.esNulo(gasto.getEstadoGasto().getCodigo())) {
				if(gasto.getEstadoGasto().getCodigo().equals(DDEstadoGasto.INCOMPLETO)) {
					cambiarEstadosAutorizacionGasto(gasto,null,null);
				}else if(gasto.getEstadoGasto().getCodigo().equals(DDEstadoGasto.PENDIENTE)) {
					cambiarEstadosAutorizacionGasto(gasto,DDEstadoAutorizacionHaya.CODIGO_PENDIENTE,null);
				}else if(gasto.getEstadoGasto().getCodigo().equals(DDEstadoGasto.SUBSANADO)) {
					cambiarEstadosAutorizacionGasto(gasto,DDEstadoAutorizacionHaya.CODIGO_RECHAZADO,null);
				}
			}
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", codigo);
			DDEstadoGasto estadoGasto = genericDao.get(DDEstadoGasto.class, filtro);
			gasto.setEstadoGasto(estadoGasto);
		
			return true;
		}
		
		return false;
		
	}
	
	/*
	 * Deja el Trabajo disponible para que sea asignable a un gasto, y activa el
	 * borrado lógico de la relación gastoProveedor-Trabajo
	 */
	private void reactivarTrabajoParaGastos(List<GastoLineaDetalleTrabajo> listaGastoTrabajo) {
		if (!Checks.estaVacio(listaGastoTrabajo)) {
			for (GastoLineaDetalleTrabajo gpvTrabajo : listaGastoTrabajo) {

				Trabajo trabajo = gpvTrabajo.getTrabajo();
				if (!Checks.esNulo(trabajo)) {
					trabajo.setFechaEmisionFactura(null);
					genericDao.update(Trabajo.class, trabajo);
				}
			}
		}
	}
	
	private String validacionEstadoAutorizacionHaya(GastoProveedor gasto) {
		if(!Checks.esNulo(gasto.getGastoGestion().getEstadoAutorizacionHaya()) && !Checks.esNulo(gasto.getGastoGestion().getEstadoAutorizacionHaya().getCodigo())) {			
			if(DDEstadoAutorizacionHaya.CODIGO_PENDIENTE.equals(gasto.getGastoGestion().getEstadoAutorizacionHaya().getCodigo())) {
				return gasto.getEstadoGasto().getCodigo().equals(DDEstadoGasto.SUBSANADO)? DDEstadoGasto.SUBSANADO : DDEstadoGasto.PENDIENTE;
			}else if(DDEstadoAutorizacionHaya.CODIGO_AUTORIZADO.equals(gasto.getGastoGestion().getEstadoAutorizacionHaya().getCodigo())) {
				return DDEstadoGasto.AUTORIZADO_ADMINISTRACION;
			}else if(DDEstadoAutorizacionHaya.CODIGO_RECHAZADO.equals(gasto.getGastoGestion().getEstadoAutorizacionHaya().getCodigo())){
				return DDEstadoGasto.SUBSANADO;
			}else {
				return DDEstadoGasto.PENDIENTE;
			}
		}else {
			return DDEstadoGasto.PENDIENTE;
		}
	}
	
	private String validarSiTieneFechaPago(GastoProveedor gasto) {
		//HREOS-3456:  hay supuestos en los que, aunque se haga constar una fecha de pago,
		//el gasto no debe posicionarse en estado pagado: 
		//1) Cuando se marque el check de "pagado por conexión Bankia"; 
		//2) Cuando se marque el check de "anticipo".
		if (!Checks.esNulo(gasto.getGastoDetalleEconomico().getFechaPago())) {
			if(Checks.esNulo(gasto.getGestoria())) {
				if (!Checks.esNulo(gasto.getGastoDetalleEconomico())) {
					if ((Checks.esNulo(gasto.getGastoDetalleEconomico().getAnticipo())
							|| gasto.getGastoDetalleEconomico().getAnticipo().equals(Integer.valueOf(0)))
							&& (Checks.esNulo(gasto.getGastoDetalleEconomico().getPagadoConexionBankia())
									|| gasto.getGastoDetalleEconomico().getPagadoConexionBankia()
											.equals(Integer.valueOf(0)))) {
	
						return DDEstadoGasto.PAGADO;
					}
				}
			}else {
				Pattern justPattern = Pattern.compile(".*-CERA-.*");
				if (!Checks.esNulo(gasto.getGastoDetalleEconomico())) {
					if ((Checks.esNulo(gasto.getGastoDetalleEconomico().getAnticipo())
							|| gasto.getGastoDetalleEconomico().getAnticipo().equals(Integer.valueOf(0)))
							&& (Checks.esNulo(gasto.getGastoDetalleEconomico().getIncluirPagoProvision())
									|| gasto.getGastoDetalleEconomico().getIncluirPagoProvision()
											.equals(Integer.valueOf(0)))) {
						if(!Checks.estaVacio(gasto.getAdjuntos())) {
							for(AdjuntoGasto adjunto : gasto.getAdjuntos()) {
								if(justPattern.matcher(adjunto.getTipoDocumentoGasto().getMatricula()).matches()){
									return DDEstadoGasto.PAGADO;
								}else {
									return DDEstadoGasto.PAGADO_SIN_JUSTIFICACION_DOC;
								}
							}
						}else {
							return DDEstadoGasto.PAGADO_SIN_JUSTIFICACION_DOC;
						}
						
					}
				}
			}
		}
		return null;
	}
	
	private String estadoGastoDesdeIncompleto(GastoProveedor gasto) {
		
		String estado = validacionEstadoAutorizacionHaya(gasto);
		if(DDEstadoGasto.PENDIENTE.equals(estado) || DDEstadoGasto.SUBSANADO.equals(estado)) {
			if(!Checks.esNulo(gasto.getGestoria())){
				if(DDEstadoGasto.SUBSANADO.equals(estado)) {
					cambiarEstadosAutorizacionGasto(gasto, DDEstadoAutorizacionHaya.CODIGO_AUTORIZADO, DDEstadoAutorizacionPropietario.CODIGO_PENDIENTE);
					return estado;
				}
			}
			cambiarEstadosAutorizacionGasto(gasto, DDEstadoAutorizacionHaya.CODIGO_PENDIENTE, null);
			return estado;
		}
		
		cambiarEstadosAutorizacionGasto(gasto, null, null);
		return null;
	}
	
	private void cambiarEstadosAutorizacionGasto(GastoProveedor gasto, String codigoEstadoAutorizacionHaya, String codigoEstadoAutorizacionPropietario){
		DDEstadoAutorizacionHaya estadoAutorizacionHaya = null;
		if(!Checks.esNulo(codigoEstadoAutorizacionHaya)){
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", codigoEstadoAutorizacionHaya);
			estadoAutorizacionHaya= genericDao.get(DDEstadoAutorizacionHaya.class, filtro);
		}
		if(!Checks.esNulo(gasto.getGastoGestion())){
			gasto.getGastoGestion().setEstadoAutorizacionHaya(estadoAutorizacionHaya);
		}
		
		DDEstadoAutorizacionPropietario estadoAutorizacionPropietario = null;
		if(!Checks.esNulo(codigoEstadoAutorizacionPropietario)){
			Filter filtro2 = genericDao.createFilter(FilterType.EQUALS, "codigo", codigoEstadoAutorizacionPropietario);
			estadoAutorizacionPropietario = genericDao.get(DDEstadoAutorizacionPropietario.class, filtro2);
		}
		if(!Checks.esNulo(gasto.getGastoGestion())){
			gasto.getGastoGestion().setEstadoAutorizacionPropietario(estadoAutorizacionPropietario);
		}
	}
	
	private String estadoGastoDesdeSubsanado(GastoProveedor gasto) {
		
		String codigo = validarSiTieneFechaPago(gasto);
		if(Checks.esNulo(codigo)) {
			String estado = validacionEstadoAutorizacionHaya(gasto);
			return estado;
		}else {
			cambiarEstadosAutorizacionGasto(gasto, DDEstadoAutorizacionHaya.CODIGO_RECHAZADO, null);
		}
		
		return DDEstadoGasto.INCOMPLETO;
	}
	
	private String estadoGastoDesdePendiente(GastoProveedor gasto) {
		String codigo = validarSiTieneFechaPago(gasto);
		if(Checks.esNulo(codigo)) {
			String estado = validacionEstadoAutorizacionHaya(gasto);
			return estado.equals(DDEstadoGasto.PENDIENTE)? null : estado;
		}else {
			cambiarEstadosAutorizacionGasto(gasto, null, null);
		}
		
		return codigo;
	}
	
	private String estadoGastoDesdeAutorizadoAdmin(GastoProveedor gasto) {
		return validarSiTieneFechaPago(gasto);
	}
	
	private String estadoGastoDesdeAutorizadoProp(GastoProveedor gasto) {
		return validarSiTieneFechaPago(gasto);
	}
	
	private String estadoGastoDesdeAnulado(GastoProveedor gasto) {
		// TODO Auto-generated method stub
		return null;
	}
	
	private String estadoGastoDesdePagado(GastoProveedor gasto) {
		// TODO Auto-generated method stub
		return null;
	}
	
	private String estadoGastoDesdeSinJusti(GastoProveedor gasto) {
		return validarSiTieneFechaPago(gasto);
	}
	
	private String estadoGastoDesdeRetenido(GastoProveedor gasto) {
		if(Checks.esNulo(gasto.getGastoGestion().getMotivoRetencionPago())) {
			
			String estado = validacionEstadoAutorizacionHaya(gasto);
			if(DDEstadoGasto.SUBSANADO.equals(estado)) {
				cambiarEstadosAutorizacionGasto(gasto, DDEstadoAutorizacionHaya.CODIGO_AUTORIZADO, DDEstadoAutorizacionPropietario.CODIGO_PENDIENTE);
			}
			
			return estado;
		}
		return null;
	}
	
	private String estadoGastoDesdeContabilizado(GastoProveedor gasto) {
		return validarSiTieneFechaPago(gasto);
	}

}