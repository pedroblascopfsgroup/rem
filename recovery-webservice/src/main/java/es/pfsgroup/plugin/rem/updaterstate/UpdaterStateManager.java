package es.pfsgroup.plugin.rem.updaterstate;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoTareaExternaApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.GastoGestion;
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.plugin.rem.model.PerimetroActivo;
import es.pfsgroup.plugin.rem.model.TareaActivo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoGasto;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosReserva;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionComercial;

@Service("updaterStateManager")
public class UpdaterStateManager implements UpdaterStateApi{

	public static final String CODIGO_CHECKING_INFORMACION = "T001_CheckingInformacion";
	public static final String CODIGO_CHECKING_ADMISION = "T001_CheckingDocumentacionAdmision";
	public static final String CODIGO_CHECKING_GESTION = "T001_CheckingDocumentacionGestion";
	
	@Autowired
	ActivoTareaExternaApi activoTareaExternaApi;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;
	
	@Autowired
	private ActivoApi activoApi;
	
	@Override
	public Boolean getStateAdmision(Activo activo) {
		return activo.getAdmision();
	}

	@Override
	public Boolean getStateGestion(Activo activo) {
		return activo.getGestion();
	}

	@Override
	public void updaterStates(Activo activo) {
		this.updaterStateAdmision(activo);
		this.updaterStateGestion(activo);
		this.updaterStateDisponibilidadComercial(activo);
	}
	
	@Override
	public void updaterStates(GastoProveedor gasto, String codigo) {
		this.updaterStateGastoProveedor(gasto, codigo);
	}

	private void updaterStateAdmision(Activo activo){
		//En caso de que esté 'OK' no se modifica el estado.
		if(!this.getStateAdmision(activo)){
			TareaExterna tareaExternaDocAdmision = activoTareaExternaApi.obtenerTareasAdmisionByCodigo(activo, "T001_CheckingDocumentacionAdmision");
			if(!Checks.esNulo(tareaExternaDocAdmision)){
				TareaActivo tareaDocAdmision = (TareaActivo) tareaExternaDocAdmision.getTareaPadre();
			
				TareaExterna tareaExternaInfo = activoTareaExternaApi.obtenerTareasAdmisionByCodigo(activo, "T001_CheckingInformacion");
				TareaActivo tareaInfo = (TareaActivo) tareaExternaInfo.getTareaPadre();
		
				Boolean tareasAdmision = (!Checks.esNulo(tareaDocAdmision.getFechaFin()) && !Checks.esNulo(tareaInfo.getFechaFin()));
				Boolean fechasAdmision = (!Checks.esNulo(activo.getTitulo()) && !Checks.esNulo(activo.getTitulo().getFechaInscripcionReg()) && !Checks.esNulo(activo.getSituacionPosesoria().getFechaTomaPosesion()) && !Checks.esNulo(activo.getFechaRevisionCarga()));
				activo.setAdmision(tareasAdmision && fechasAdmision);
			}
		}
	}
	
	private void updaterStateGestion(Activo activo){
		//En caso de que esté 'OK' no se modifica el estado.
		if(!this.getStateGestion(activo)){
			TareaExterna tareaExternaDocGestion = activoTareaExternaApi.obtenerTareasAdmisionByCodigo(activo, "T001_CheckingDocumentacionGestion");
			if(!Checks.esNulo(tareaExternaDocGestion)){
				TareaActivo tareaDocGestion = (TareaActivo) tareaExternaDocGestion.getTareaPadre();
			
				activo.setGestion(!Checks.esNulo(tareaDocGestion.getFechaFin()));
			}
		}
	}
	
	@Override
	public void updaterStateDisponibilidadComercial(Activo activo) {
		
		String codigoSituacion = this.getCodigoSituacionComercialFromActivo(activo);
		
		if(!Checks.esNulo(codigoSituacion)) {
			activo.setSituacionComercial((DDSituacionComercial)utilDiccionarioApi.dameValorDiccionarioByCod(DDSituacionComercial.class,codigoSituacion));
		}
	}
	
	private String getCodigoSituacionComercialFromActivo(Activo activo) {
		
		String codigo = null;
		PerimetroActivo perimetro = activoApi.getPerimetroByIdActivo(activo.getId());
		
		if(!Checks.esNulo(perimetro) && !Checks.esNulo(perimetro.getAplicaComercializar()) && perimetro.getAplicaComercializar() == 0) {
			codigo = DDSituacionComercial.CODIGO_NO_COMERCIALIZABLE;
		}
		else if(activoApi.isActivoVendido(activo)) {
			codigo = DDSituacionComercial.CODIGO_VENDIDO;
		}
		else if(activoApi.isActivoConOfertaByEstado(activo,DDEstadoOferta.CODIGO_ACEPTADA)) {
			codigo = DDSituacionComercial.CODIGO_DISPONIBLE_VENTA_OFERTA;
		}
		else if(activoApi.isActivoConReservaByEstado(activo,DDEstadosReserva.CODIGO_FIRMADA)) {
			codigo = DDSituacionComercial.CODIGO_DISPONIBLE_VENTA_RESERVA;
		}
		else if(activoApi.getCondicionantesDisponibilidad(activo.getId()).isCondicionado()) {
			codigo = DDSituacionComercial.CODIGO_DISPONIBLE_CONDICIONADO;
		}
		else if (!Checks.esNulo(activo.getTipoComercializacion())) {
			switch(Integer.parseInt(activo.getTipoComercializacion().getCodigo())) {
				case 1:
					codigo = DDSituacionComercial.CODIGO_DISPONIBLE_VENTA;
					break;
				case 2:
					codigo = DDSituacionComercial.CODIGO_DISPONIBLE_VENTA_ALQUILER;
					break;
				case 3:
					codigo = DDSituacionComercial.CODIGO_DISPONIBLE_ALQUILER;
					break;
				default:
					break;
			}
		} else {
			codigo = DDSituacionComercial.CODIGO_DISPONIBLE_VENTA;
		}
		
		return codigo;
	}
	/**
	 * Función que actualiza el estado del gasto. 
	 * Si recibe código, busca el estado y lo inserta, sino, determina el estado en función
	 * de las situaciones indicadas por los datos del gasto recibido.
	 * @param gasto
	 * @param codigo
	 */
	private void updaterStateGastoProveedor(GastoProveedor gasto, String codigo) {
		
		// Si recibimos un estado, lo buscamos y lo seteamos
		if(!Checks.esNulo(codigo)) {
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", codigo);
			DDEstadoGasto estadoGasto = (DDEstadoGasto) genericDao.get(DDEstadoGasto.class, filtro);
			gasto.setEstadoGasto(estadoGasto);
		// Si no, iremos añadiendo situaciones que puedan modificar el estado
		} else {
			GastoGestion gastoGestion = gasto.getGastoGestion();
			
			if(!Checks.esNulo(gastoGestion) && !Checks.esNulo(gastoGestion.getFechaAnulacionGasto())) {
				codigo = DDEstadoGasto.ANULADO;
			}
			
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", codigo);
			DDEstadoGasto estadoGasto = (DDEstadoGasto) genericDao.get(DDEstadoGasto.class, filtro);
			gasto.setEstadoGasto(estadoGasto);
			
		}
		
	}

}
