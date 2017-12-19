package es.pfsgroup.plugin.rem.updaterstate;

import java.util.Date;

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
import es.pfsgroup.plugin.rem.model.GastoGestion;
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoAutorizacionHaya;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoAutorizacionPropietario;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoGasto;

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
	
	
	
	@Override
	public boolean updaterStates(GastoProveedor gasto, String codigo) {
		return this.updaterStateGastoProveedor(gasto, codigo);
	}
	
	@Override
	public String validarAutorizacionGasto(GastoProveedor gasto) {
		
		String error = null;
		
		if(Checks.esNulo(gasto.getTipoGasto()) || Checks.esNulo(gasto.getSubtipoGasto())) {
			error = messageServices.getMessage(VALIDACION_TIPO_SUBTIPO);
			return error;
		}
		
		if(!Checks.esNulo(gasto.getDestinatarioGasto()) && !COD_DESTINATARIO_HAYA.equals(gasto.getDestinatarioGasto().getCodigo()) &&  Checks.esNulo(gasto.getPropietario())) {
			error = messageServices.getMessage(VALIDACION_PROPIETARIO);
			return error;
		}
		
		if(Checks.esNulo(gasto.getTipoOperacion())) {
			error = messageServices.getMessage(VALIDACION_TIPO_OPERACION);
			return error;
		}
		if(!Checks.esNulo(gasto.getGestoria()) && Checks.esNulo(gasto.getTipoPeriocidad())) {
			error = messageServices.getMessage(VALIDACION_TIPO_PERIODICIDAD);
			return error;
		}
		
		if(Checks.esNulo(gasto.getGastoDetalleEconomico()) || Checks.esNulo(gasto.getGastoDetalleEconomico().getImporteTotal())) {
			error = messageServices.getMessage(VALIDACION_IMPORTE_TOTAL);
			return error;
		}
		
		if (Checks.esNulo(gasto.getGastoInfoContabilidad()) ||
				(Checks.esNulo(gasto.getGastoInfoContabilidad().getCuentaContable()) &&
						(!Checks.esNulo(gasto.getPropietario()) && !DDCartera.CODIGO_CARTERA_BANKIA.equals(gasto.getPropietario().getCartera().getCodigo())))) {
			error = messageServices.getMessage(VALIDACION_CUENTA_CONTABLE);
			return error;
		}
		
		if(Checks.esNulo(gasto.getGastoInfoContabilidad()) || Checks.esNulo(gasto.getGastoInfoContabilidad().getPartidaPresupuestaria())) {
			error = messageServices.getMessage(VALIDACION_PARTIDA_PRESUPUESTARIA); 
			return error;
		}
		
		if(Checks.estaVacio(gasto.getGastoProveedorActivos()) && !gasto.esAutorizadoSinActivos()) {
			error = messageServices.getMessage(VALIDACION_ACTIVOS_ASIGNADOS); 
			return error;
		}
		
		if(Checks.esNulo(gasto.getExisteDocumento()) || !BooleanUtils.toBoolean(gasto.getExisteDocumento())) {
			error = messageServices.getMessage(VALIDACION_DOCUMENTO_ADJUNTO_GASTO);
			return error;
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
			
		// Comprobamos la situación del gasto y determinamos el próximo código de estado
			GastoGestion gastoGestion = gasto.getGastoGestion();
			if(!Checks.esNulo(gasto.getEstadoGasto())){
				
				
			// Si el pago sigue retenido, ningún cambio en el gasto implica cambio de estado.
				if(Checks.esNulo(gastoGestion.getMotivoRetencionPago())) {
					if(!Checks.esNulo(gasto.getGastoGestion().getEstadoAutorizacionHaya()) 
							|| (Checks.esNulo(gasto.getGastoGestion().getEstadoAutorizacionHaya()) && DDEstadoGasto.RETENIDO.equals(gasto.getEstadoGasto().getCodigo()))) {
						String error = validarAutorizacionGasto(gasto);
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

						//HREOS-3456:  hay supuestos en los que, aunque se haga constar una fecha de pago,
						//el gasto no debe posicionarse en estado pagado: 
						//1) Cuando se marque el check de "pagado por conexión Bankia"; 
						//2) Cuando se marque el check de "anticipo".
						if (gasto.getGastoDetalleEconomico() != null) {
							if ((gasto.getGastoDetalleEconomico().getAnticipo() == null
									|| gasto.getGastoDetalleEconomico().getAnticipo().equals(Integer.valueOf(0)))
									&& (gasto.getGastoDetalleEconomico().getPagadoConexionBankia() == null
											|| gasto.getGastoDetalleEconomico().getPagadoConexionBankia()
													.equals(Integer.valueOf(0)))) {

								codigo = DDEstadoGasto.PAGADO;
							}
						}
						
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
				
			}				
		}
		else {
			String valido = validarAutorizacionGasto(gasto);
			if(!codigo.equals(DDEstadoGasto.INCOMPLETO) && !codigo.equals(DDEstadoGasto.ANULADO) && !codigo.equals(DDEstadoGasto.RETENIDO) && !Checks.esNulo(valido)) {
				codigo = null;
			}
		}
		
		// Si tenemos definido un estado, lo búscamos y modificamos en el gasto
		if(!Checks.esNulo(codigo)) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", codigo);
			DDEstadoGasto estadoGasto = genericDao.get(DDEstadoGasto.class, filtro);
			gasto.setEstadoGasto(estadoGasto);
			return true;
		}
		
		return false;
		
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
	
	private void updateStatesGastosGestion(GastoProveedor gasto){
		//Si no esta sujeto a impuesto indirecto
		if(!Checks.esNulo(gasto.getGastoGestion().getGastoProveedor().getGestoria())){
			cambiarEstadosAutorizacionGasto(gasto, DDEstadoAutorizacionHaya.CODIGO_AUTORIZADO, DDEstadoAutorizacionPropietario.CODIGO_PENDIENTE);
		}
		//Si esta sujeto a impuesto indirecto tipo IVA
		else if(DDEstadoGasto.RECHAZADO_ADMINISTRACION.equals(gasto.getEstadoGasto().getCodigo())){
			cambiarEstadosAutorizacionGasto(gasto, DDEstadoAutorizacionHaya.CODIGO_PENDIENTE, null);
		}
		else{
			cambiarEstadosAutorizacionGasto(gasto, DDEstadoAutorizacionHaya.CODIGO_PENDIENTE, DDEstadoAutorizacionPropietario.CODIGO_RECHAZADO_CONTABILIDAD);
		}
		
	}
}
