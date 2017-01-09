package es.pfsgroup.plugin.rem.updaterstate;

import javax.annotation.Resource;

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
import es.pfsgroup.plugin.rem.model.dd.DDEstadoAutorizacionHaya;
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
		
		if(Checks.esNulo(gasto.getPropietario())) {
			error = messageServices.getMessage(VALIDACION_PROPIETARIO);
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
		
		if(Checks.esNulo(gasto.getGastoDetalleEconomico()) || Checks.esNulo(gasto.getGastoDetalleEconomico().getImporteTotal())) {
			error = messageServices.getMessage(VALIDACION_IMPORTE_TOTAL);
			return error;
		}
		
		if(Checks.esNulo(gasto.getGastoInfoContabilidad()) || Checks.esNulo(gasto.getGastoInfoContabilidad().getCuentaContable())) {
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
		
		if(Checks.estaVacio(gasto.getAdjuntos())) {
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
					
					// Si estado es INCOMPLETO, comprobamos si ya no lo está para pasarlo a pendiente.
					if(DDEstadoGasto.INCOMPLETO.equals(gasto.getEstadoGasto().getCodigo())) {
						String error = validarAutorizacionGasto(gasto);
						if(Checks.esNulo(error)) {
							codigo = DDEstadoGasto.PENDIENTE;
						}				
					} else if((DDEstadoAutorizacionHaya.CODIGO_PENDIENTE.equals(gasto.getGastoGestion().getEstadoAutorizacionHaya().getCodigo())
							|| DDEstadoAutorizacionHaya.CODIGO_RECHAZADO.equals(gasto.getGastoGestion().getEstadoAutorizacionHaya().getCodigo())) 
							&& genericAdapter.isProveedor(usuario)) {
							codigo = DDEstadoGasto.SUBSANADO;
						
					}
				}
			}				
		}
		
		// Si tenemos definido un estado, lo búscamos y modificamos en el gasto
		if(!Checks.esNulo(codigo)) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", codigo);
			DDEstadoGasto estadoGasto = (DDEstadoGasto) genericDao.get(DDEstadoGasto.class, filtro);
			gasto.setEstadoGasto(estadoGasto);
			return true;
		}
		
		return false;
		
	}

}
