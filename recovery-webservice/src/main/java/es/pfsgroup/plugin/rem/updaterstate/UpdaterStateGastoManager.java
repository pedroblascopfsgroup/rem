package es.pfsgroup.plugin.rem.updaterstate;


import java.util.Date;
import java.util.regex.Pattern;

import javax.annotation.Resource;

import org.apache.commons.lang.BooleanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.message.MessageService;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.model.AdjuntoGasto;
import es.pfsgroup.plugin.rem.model.GastoGestion;
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoAutorizacionHaya;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoAutorizacionPropietario;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoGasto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoGasto;

@Service("updaterStateGastoManager")
public class UpdaterStateGastoManager implements UpdaterStateGastoApi{

	
	@Autowired
	private GenericABMDao genericDao;	
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Resource
    MessageService messageServices;
	
	//Textos de validación
	private static final String VALIDACION_DOCUMENTO_ADJUNTO_GASTO = "msg.validacion.gasto.documento.adjunto";
	private static final String VALIDACION_ACTIVOS_ASIGNADOS = "msg.validacion.gasto.activos.asignados";
	private static final String VALIDACION_PARTIDA_PRESUPUESTARIA = "msg.validacion.gasto.partida.presupuestaria";
	private static final String VALIDACION_CUENTA_CONTABLE = "msg.validacion.gasto.cuenta.contable";
	private static final String VALIDACION_IMPORTE_TOTAL = "msg.validacion.gasto.importe.total";
	private static final String VALIDACION_TIPO_PERIODICIDAD = "msg.validacion.gasto.tipo.periodicidad";
	private static final String VALIDACION_TIPO_OPERACION = "msg.validacion.gasto.tipo.operacion";
	private static final String VALIDACION_PROPIETARIO = "msg.validacion.gasto.propietario";
	private static final String VALIDACION_TIPO_SUBTIPO = "msg.validacion.gasto.tipo.subtipo";
	
	private static final String COD_DESTINATARIO_HAYA = "02";

	private static final String VALIDACION_GASTO_SIN_ID = "msg.validacion.gasto.sin.id";

	private static final String VALIDACION_GESTORIA_DE_GASTO_SIN_ID = "msg.validacion.gestoria.de.gasto.sin.id";

	private static final String VALIDACION_GASTO_SIN_NUM_FACTURA = "msg.validacion.gasto.sin.num.factura";

	private static final String VALIDACION_GASTO_SIN_EMISOR = "msg.validacion.gasto.sin.emisor";

	private static final String VALIDACION_GASTO_SIN_FECHA_EMISION = "msg.validacion.gasto.sin.fecha.emision";

	private static final String VALIDACION_GASTO_SIN_CONCEPTO = "msg.validacion.gasto.sin.concepto";

	private static final String VALIDACION_GASTO_SIN_TIPO_IMP_INDIRECTO = "msg.validacion.gasto.sin.tipo.impuesto.indirecto";
	
	
	
	@Override
	public boolean updaterStates(GastoProveedor gasto, String codigo) {
		return this.updaterStateGastoProveedor(gasto, codigo);
	}
	
	@Override
	public String validarCamposMinimos(GastoProveedor gasto) {
		
		String error = null;
		
		if(!Checks.esNulo(gasto)) {
			if(Checks.esNulo(gasto.getId())) {
				error = messageServices.getMessage(VALIDACION_GASTO_SIN_ID);
				return error;
			}
			if(!Checks.esNulo(gasto.getGestoria()) && Checks.esNulo(gasto.getGestoria().getId())) {
				error = messageServices.getMessage(VALIDACION_GESTORIA_DE_GASTO_SIN_ID);
				return error;
			}
			if(Checks.esNulo(gasto.getReferenciaEmisor())) {
				error = messageServices.getMessage(VALIDACION_GASTO_SIN_NUM_FACTURA);
				return error;
			}
			if(Checks.esNulo(gasto.getTipoGasto()) || Checks.esNulo(gasto.getSubtipoGasto())) {
				error = messageServices.getMessage(VALIDACION_TIPO_SUBTIPO);
				return error;
			}
			if(Checks.esNulo(gasto.getProveedor())) {
				error = messageServices.getMessage(VALIDACION_GASTO_SIN_EMISOR);
				return error;
			}
			if(!Checks.esNulo(gasto.getDestinatarioGasto()) && !COD_DESTINATARIO_HAYA.equals(gasto.getDestinatarioGasto().getCodigo()) &&  Checks.esNulo(gasto.getPropietario())) {
				error = messageServices.getMessage(VALIDACION_PROPIETARIO);
				return error;
			}
			if(Checks.esNulo(gasto.getFechaEmision())) {
				error = messageServices.getMessage(VALIDACION_GASTO_SIN_FECHA_EMISION);
				return error;
			}
			if(Checks.esNulo(gasto.getTipoOperacion())) {
				error = messageServices.getMessage(VALIDACION_TIPO_OPERACION);
				return error;
			}
			if(Checks.esNulo(gasto.getTipoPeriocidad())) {
				error = messageServices.getMessage(VALIDACION_TIPO_PERIODICIDAD);
				return error;
			}
			if(Checks.esNulo(gasto.getGestoria()) && Checks.esNulo(gasto.getConcepto())) {
				error = messageServices.getMessage(VALIDACION_GASTO_SIN_CONCEPTO);
				return error;
			}
			
			if(Checks.esNulo(gasto.getGastoDetalleEconomico()) || Checks.esNulo(gasto.getGastoDetalleEconomico().getImporteTotal())) {
				error = messageServices.getMessage(VALIDACION_IMPORTE_TOTAL);
				return error;
			}
			if(Checks.esNulo(gasto.getGestoria()) && (Checks.esNulo(gasto.getGastoDetalleEconomico()) || Checks.esNulo(gasto.getGastoDetalleEconomico().getImpuestoIndirectoTipo()))) {
				error = messageServices.getMessage(VALIDACION_GASTO_SIN_TIPO_IMP_INDIRECTO);
				return error;
			}
			
			if(!Checks.esNulo(gasto.getPropietario())){
				if(!DDCartera.CODIGO_CARTERA_LIBERBANK.equals(gasto.getPropietario().getCartera().getCodigo())){
					if (Checks.esNulo(gasto.getGastoInfoContabilidad()) ||
							(Checks.esNulo(gasto.getGastoInfoContabilidad().getCuentaContable()) &&
									(!DDCartera.CODIGO_CARTERA_BANKIA.equals(gasto.getPropietario().getCartera().getCodigo())))) {
						error = messageServices.getMessage(VALIDACION_CUENTA_CONTABLE);
						return error;
					}
				}
			}else{
				if (Checks.esNulo(gasto.getGastoInfoContabilidad()) ||
						(Checks.esNulo(gasto.getGastoInfoContabilidad().getCuentaContable()) &&
								(!Checks.esNulo(gasto.getPropietario()) && !DDCartera.CODIGO_CARTERA_BANKIA.equals(gasto.getPropietario().getCartera().getCodigo())))) {
					error = messageServices.getMessage(VALIDACION_CUENTA_CONTABLE);
					return error;
				}
			}
			
			if(!Checks.esNulo(gasto.getPropietario()) && !DDCartera.CODIGO_CARTERA_LIBERBANK.equals(gasto.getPropietario().getCartera().getCodigo())){
				if(Checks.esNulo(gasto.getGastoInfoContabilidad()) || Checks.esNulo(gasto.getGastoInfoContabilidad().getPartidaPresupuestaria())) {
					error = messageServices.getMessage(VALIDACION_PARTIDA_PRESUPUESTARIA); 
					return error;
				}
			}
			
			if(Checks.estaVacio(gasto.getGastoProveedorActivos()) && !gasto.esAutorizadoSinActivos()) {
				error = messageServices.getMessage(VALIDACION_ACTIVOS_ASIGNADOS); 
				return error;
			}
			
			if(Checks.esNulo(gasto.getExisteDocumento()) || !BooleanUtils.toBoolean(gasto.getExisteDocumento())) {
				error = messageServices.getMessage(VALIDACION_DOCUMENTO_ADJUNTO_GASTO);
				return error;
			}
		}
		return error;
	}
	

	/**
	 * Función que actualiza el estado del gasto. 
	 * Si recibe código, busca el estado y lo inserta, sino, determina el estado en función
	 * de las situaciones indicadas por los datos del gasto recibido.
	 * El gasto deberá ser persistido finalmente, para actualizarlo.
	 * @param gasto
	 * @param codigo
	 */
	private boolean updaterStateGastoProveedor(GastoProveedor gasto, String codigo) {
		
		Usuario usuario = genericAdapter.getUsuarioLogado();	
		
		// Si no recibimos un estado
		if(Checks.esNulo(codigo)) {
			if(!Checks.esNulo(gasto.getEstadoGasto())) {
				if(DDEstadoGasto.INCOMPLETO.equals(gasto.getEstadoGasto().getCodigo())) {
					codigo = estadoGastoDesdeIncompleto(gasto);
					
				}else if(DDEstadoGasto.PENDIENTE.equals(gasto.getEstadoGasto().getCodigo())) {
					codigo = estadoGastoDesdePendiente(gasto);
					
				}else if(DDEstadoGasto.RECHAZADO_ADMINISTRACION.equals(gasto.getEstadoGasto().getCodigo())) {
					codigo = estadoGastoDesdeRechazadoAdmin(gasto);
					
				}else if(DDEstadoGasto.RECHAZADO_PROPIETARIO.equals(gasto.getEstadoGasto().getCodigo())) {
					codigo = estadoGastoDesdeRechazadoProp(gasto);
					
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
			
			
			
			
			
			
			/*
		// Comprobamos la situación del gasto y determinamos el próximo código de estado
			GastoGestion gastoGestion = gasto.getGastoGestion();
			if(!Checks.esNulo(gasto.getEstadoGasto())){
				
				
			// Si el pago sigue retenido, ningún cambio en el gasto implica cambio de estado.
				if(Checks.esNulo(gastoGestion.getMotivoRetencionPago())) {
					if(!DDEstadoGasto.PAGADO.equals(gasto.getEstadoGasto().getCodigo()) 
							&& (!Checks.esNulo(gasto.getGastoGestion().getEstadoAutorizacionHaya()) 
									|| (Checks.esNulo(gasto.getGastoGestion().getEstadoAutorizacionHaya()) 
											&& DDEstadoGasto.RETENIDO.equals(gasto.getEstadoGasto().getCodigo()))) ){
						String error = validarCamposMinimos(gasto);
						if(Checks.esNulo(error)) {
							if(DDEstadoAutorizacionHaya.CODIGO_RECHAZADO.equals(gasto.getGastoGestion().getEstadoAutorizacionHaya().getCodigo())) {
								codigo = DDEstadoGasto.RECHAZADO_ADMINISTRACION;
							}else if(DDEstadoAutorizacionHaya.CODIGO_AUTORIZADO.equals(gasto.getGastoGestion().getEstadoAutorizacionHaya().getCodigo())) {
								codigo = DDEstadoGasto.AUTORIZADO_ADMINISTRACION;
							}else if(DDEstadoAutorizacionHaya.CODIGO_PENDIENTE.equals(gasto.getGastoGestion().getEstadoAutorizacionHaya().getCodigo())){
								codigo = DDEstadoGasto.PENDIENTE;
							}							
						}else {
							codigo = DDEstadoGasto.INCOMPLETO;
							updaterStateGastoProveedor(gasto,codigo);
						}
						
						if(!Checks.esNulo(gasto.getEstadoGasto())){
							if(DDEstadoGasto.RECHAZADO_PROPIETARIO.equals(gasto.getEstadoGasto().getCodigo()) || DDEstadoGasto.RECHAZADO_ADMINISTRACION.equals(gasto.getEstadoGasto().getCodigo())){
								codigo = DDEstadoGasto.SUBSANADO;
								updateStatesGastosGestion(gasto);
							}
						}
					}
					
					
					if(!DDEstadoGasto.INCOMPLETO.equals(codigo) 
					&& !DDEstadoGasto.ANULADO.equals(gasto.getEstadoGasto().getCodigo()) 
					&& !DDEstadoGasto.RECHAZADO_ADMINISTRACION.equals(gasto.getEstadoGasto().getCodigo()) 
					&& !DDEstadoGasto.RECHAZADO_PROPIETARIO.equals(gasto.getEstadoGasto().getCodigo()) 
					&& !DDEstadoGasto.RETENIDO.equals(gasto.getEstadoGasto().getCodigo())
					&& !DDEstadoGasto.PAGADO.equals(gasto.getEstadoGasto().getCodigo())
					&& !Checks.esNulo(gasto.getGastoDetalleEconomico().getFechaPago())) {

						
						
						Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoAutorizacionHaya.CODIGO_AUTORIZADO);
						DDEstadoAutorizacionHaya estadoAutorizacionHaya= genericDao.get(DDEstadoAutorizacionHaya.class, filtro);
						filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoAutorizacionPropietario.CODIGO_PENDIENTE);
						DDEstadoAutorizacionPropietario estadoAutorizacionPropietario= genericDao.get(DDEstadoAutorizacionPropietario.class, filtro);
						if(!Checks.esNulo(gasto.getGastoGestion())){
							gasto.getGastoGestion().setEstadoAutorizacionHaya(estadoAutorizacionHaya);
							gasto.getGastoGestion().setFechaEstadoAutorizacionHaya(new Date());
							gasto.getGastoGestion().setUsuarioEstadoAutorizacionHaya(usuario);
							gasto.getGastoGestion().setEstadoAutorizacionPropietario(estadoAutorizacionPropietario);
						}

					}
					
				}
				
			}	*/			
		}/*
		else {
			String valido = validarCamposMinimos(gasto);
			if(!codigo.equals(DDEstadoGasto.INCOMPLETO) && !codigo.equals(DDEstadoGasto.ANULADO) && !codigo.equals(DDEstadoGasto.RETENIDO) && !Checks.esNulo(valido)) {
				codigo = null;
			}
		}
		*/
		// Si tenemos definido un estado, lo búscamos y modificamos en el gasto
		
		if(!Checks.esNulo(codigo)) {
			if(codigo.equals(DDEstadoGasto.RETENIDO)) {
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


	private boolean validacionMinima(GastoProveedor gasto) {
			// Comprobamos la situación del gasto y determinamos el próximo código de estado
		GastoGestion gastoGestion = gasto.getGastoGestion();
		if(!Checks.esNulo(gasto.getEstadoGasto())){				
			
		// Si el pago sigue retenido, ningún cambio en el gasto implica cambio de estado.
			if(Checks.esNulo(gastoGestion.getMotivoRetencionPago())) {
				String error = validarCamposMinimos(gasto);
				if(Checks.esNulo(error)) {
					return true;
				}
				else {
					return false;
				}
			}		
		}
		return false;
	}
	
	private String validacionEstadoAutorizacionHaya(GastoProveedor gasto) {
		if(!Checks.esNulo(gasto.getGastoGestion().getEstadoAutorizacionHaya())) {			
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
		if (validacionMinima(gasto)) {		
			String estado = validacionEstadoAutorizacionHaya(gasto);
			if(DDEstadoGasto.PENDIENTE.equals(estado) || DDEstadoGasto.SUBSANADO.equals(estado)) {
				if(!Checks.esNulo(gasto.getGestoria())){
					if(DDEstadoGasto.SUBSANADO.equals(estado)) {
						cambiarEstadosAutorizacionGasto(gasto, DDEstadoAutorizacionHaya.CODIGO_AUTORIZADO, DDEstadoAutorizacionPropietario.CODIGO_PENDIENTE);
						return estado;
					}
				}
				cambiarEstadosAutorizacionGasto(gasto, DDEstadoAutorizacionHaya.CODIGO_PENDIENTE, null);
			}
			return estado;
			
		}
		cambiarEstadosAutorizacionGasto(gasto, null, null);
		return null;
	}
	
	private String estadoGastoDesdePendiente(GastoProveedor gasto) {
		if (validacionMinima(gasto)) {
			String codigo = validarSiTieneFechaPago(gasto);
			if(Checks.esNulo(codigo)) {
				String estado = validacionEstadoAutorizacionHaya(gasto);
				return estado.equals(DDEstadoGasto.PENDIENTE)? null : estado;
			}else {
				return codigo;
			}
		}
		cambiarEstadosAutorizacionGasto(gasto, null, null);
		return DDEstadoGasto.INCOMPLETO;
	}

	private String estadoGastoDesdeRechazadoAdmin(GastoProveedor gasto) {
		if (validacionMinima(gasto)) {
			String estado = validacionEstadoAutorizacionHaya(gasto);
			if(!Checks.esNulo(gasto.getGestoria())){
				if(DDEstadoGasto.SUBSANADO.equals(estado)) {
					cambiarEstadosAutorizacionGasto(gasto, DDEstadoAutorizacionHaya.CODIGO_AUTORIZADO, DDEstadoAutorizacionPropietario.CODIGO_PENDIENTE);
				}
			}else {
				cambiarEstadosAutorizacionGasto(gasto, DDEstadoAutorizacionHaya.CODIGO_PENDIENTE, null);
			}
			return estado;
		}
		return DDEstadoGasto.INCOMPLETO;
	}
	
	private String estadoGastoDesdeRechazadoProp(GastoProveedor gasto) {
		if (validacionMinima(gasto)) {
			String estado = validacionEstadoAutorizacionHaya(gasto);
			if(DDEstadoGasto.SUBSANADO.equals(estado)) {
				cambiarEstadosAutorizacionGasto(gasto, DDEstadoAutorizacionHaya.CODIGO_AUTORIZADO, DDEstadoAutorizacionPropietario.CODIGO_PENDIENTE);
			}
			return estado;
		}
		return DDEstadoGasto.INCOMPLETO;
	}
	
	private String estadoGastoDesdeSubsanado(GastoProveedor gasto) {
		if (validacionMinima(gasto)) {
			String codigo = validarSiTieneFechaPago(gasto);
			if(Checks.esNulo(codigo)) {
				String estado = validacionEstadoAutorizacionHaya(gasto);
				return estado;
			}else {
				return codigo;
			}
		}
		cambiarEstadosAutorizacionGasto(gasto, DDEstadoAutorizacionHaya.CODIGO_RECHAZADO, null);
		return DDEstadoGasto.INCOMPLETO;
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
			if (validacionMinima(gasto)) {
				String estado = validacionEstadoAutorizacionHaya(gasto);
				if(DDEstadoGasto.SUBSANADO.equals(estado)) {
					cambiarEstadosAutorizacionGasto(gasto, DDEstadoAutorizacionHaya.CODIGO_AUTORIZADO, DDEstadoAutorizacionPropietario.CODIGO_PENDIENTE);
				}
				return estado;
			}
			return DDEstadoGasto.INCOMPLETO;
		}
		return null;
	}
	
	private String estadoGastoDesdeContabilizado(GastoProveedor gasto) {
		return validarSiTieneFechaPago(gasto);
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
	/*
	private void updateStatesGastosGestion(GastoProveedor gasto){
		//Si no esta sujeto a impuesto indirecto
		if(!Checks.esNulo(gasto.getGastoGestion().getGastoProveedor().getGestoria())){
			cambiarEstadosAutorizacionGasto(gasto, DDEstadoAutorizacionHaya.CODIGO_AUTORIZADO, DDEstadoAutorizacionPropietario.CODIGO_PENDIENTE);
		}
		//Si esta sujeto a impuesto indirecto tipo IVA
		else if(DDEstadoGasto.RECHAZADO_ADMINISTRACION.equals(gasto.getEstadoGasto().getCodigo())
				|| DDEstadoGasto.PENDIENTE.equals(gasto.getEstadoGasto().getCodigo())
				|| (DDEstadoGasto.INCOMPLETO.equals(gasto.getEstadoGasto().getCodigo()) 
						&& (Checks.esNulo(gasto.getGastoGestion().getEstadoAutorizacionHaya()) 
						|| DDEstadoAutorizacionHaya.CODIGO_RECHAZADO.equals(gasto.getGastoGestion().getEstadoAutorizacionHaya().getCodigo())))){
			cambiarEstadosAutorizacionGasto(gasto, DDEstadoAutorizacionHaya.CODIGO_PENDIENTE, null);
		}else if(DDEstadoGasto.SUBSANADO.equals(gasto.getEstadoGasto().getCodigo())) {
			cambiarEstadosAutorizacionGasto(gasto, DDEstadoAutorizacionHaya.CODIGO_RECHAZADO, null);
		}else if((DDEstadoGasto.INCOMPLETO.equals(gasto.getEstadoGasto().getCodigo()) 
				|| DDEstadoGasto.PENDIENTE.equals(gasto.getEstadoGasto().getCodigo())) 
				&& DDEstadoAutorizacionHaya.CODIGO_PENDIENTE.equals(gasto.getGastoGestion().getEstadoAutorizacionHaya().getCodigo())) {
			return;
		}
		else{
			cambiarEstadosAutorizacionGasto(gasto, DDEstadoAutorizacionHaya.CODIGO_PENDIENTE, DDEstadoAutorizacionPropietario.CODIGO_RECHAZADO_CONTABILIDAD);
		}
		
	}*/
}
