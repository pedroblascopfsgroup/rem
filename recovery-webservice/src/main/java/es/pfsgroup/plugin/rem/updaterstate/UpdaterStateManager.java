package es.pfsgroup.plugin.rem.updaterstate;

import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoTareaExternaApi;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.PerimetroActivo;
import es.pfsgroup.plugin.rem.model.TareaActivo;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosReserva;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionComercial;
import es.pfsgroup.plugin.rem.model.dd.DDTipoComercializar;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPrecio;
import es.pfsgroup.plugin.rem.model.dd.DDTipoUsoDestino;

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
	
	@Autowired
	private GestorActivoApi gestorActivoApi;
	
	@Override
	public Boolean getStateAdmision(Activo activo) {
		return (Checks.esNulo(activo.getAdmision() ? false : activo.getAdmision()));
	}

	@Override
	public Boolean getStateGestion(Activo activo) {
		return (Checks.esNulo(activo.getGestion() ? false : activo.getGestion()));
	}

	@Override
	public void updaterStates(Activo activo) {
		this.updaterStateAdmision(activo);
		this.updaterStateGestion(activo);
		this.updaterStateDisponibilidadComercial(activo);
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
	
	@Override
	public void updaterStateTipoComercializacion(Activo activo) {
		PerimetroActivo perimetro = activoApi.getPerimetroByIdActivo(activo.getId());
		//Si el activo tiene activado el bloqueo para el cambio automático o No es comercializable, no hará nada
		if(!activo.getBloqueoTipoComercializacionAutomatico() && (Checks.esNulo(perimetro) || perimetro.getAplicaComercializar() == 1)) {
			String codigoTipoComercializacion = this.getCodigoTipoComercializacionFromActivo(activo); 
			
			//Si el tipoComercializacion calculado no es nulo y es distinto al actual del Activo, entonces...
			if(!Checks.esNulo(codigoTipoComercializacion) && !codigoTipoComercializacion.equals(activo.getTipoComercializar().getCodigo())) {
				
				HashMap<String,String> mapaComercial = new HashMap<String,String> ();
				mapaComercial.put(DDTipoComercializar.CODIGO_SINGULAR, "GCOMSIN");
				mapaComercial.put(DDTipoComercializar.CODIGO_RETAIL, "GCOMRET");
				
				//Comprobamos que se pueda realizar el cambio, analizando tareas activas comerciales y si hay gestor adecuado en el activo
				if(gestorActivoApi.existeGestorEnActivo(activo, mapaComercial.get(codigoTipoComercializacion))) {
					activo.setTipoComercializar((DDTipoComercializar)utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoComercializar.class,codigoTipoComercializacion));
					genericDao.update(Activo.class, activo);
					gestorActivoApi.actualizarTareas(activo.getId());
				}
				//Si no existe el gestor comercial adecuado, pero no hay tareas activas para dicho tipo, se puede realizar el cambio en el activo de tipo comercializar
				else if(!activoTareaExternaApi.existenTareasActivasByTramiteAndTipoGestor(activo, "T013", mapaComercial.get(codigoTipoComercializacion))) {
					
					activo.setTipoComercializar((DDTipoComercializar)utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoComercializar.class,codigoTipoComercializacion));
				}
			}
		}
	}
	
	/**
	 * (Activo en Promocion Obra Nueva o Asistida // Activo de 1ª o 2ª Residencia )-> Retail
	 * Cajamar: VNC <= 500000 -> Retail), en caso contrario -> Singular
	 * Sareb/Bankia: AprobadoVenta (si no hay, valorTasacion) <= 500000 -> Retail), en caso contrario -> Singular
	 * @param activo
	 * @return
	 */
	private String getCodigoTipoComercializacionFromActivo(Activo activo) {
		
		String codigoTipoComercializacion = null;
		
		if(activoApi.isIntegradoAgrupacionObraNuevaOrAsistida(activo))
			codigoTipoComercializacion = DDTipoComercializar.CODIGO_RETAIL;
		else if(DDTipoUsoDestino.TIPO_USO_PRIMERA_RESIDENCIA.equals(activo.getTipoUsoDestino()) ||
				DDTipoUsoDestino.TIPO_USO_SEGUNDA_RESIDENCIA.equals(activo.getTipoUsoDestino()))
			codigoTipoComercializacion = DDTipoComercializar.CODIGO_RETAIL;
		else 
		{
			Double importeLimite = (double) 500000;
			
			if(DDCartera.CODIGO_CARTERA_CAJAMAR.equals(activo.getCartera().getCodigo()))
			{
				Double valorVNC = activoApi.getImporteValoracionActivoByCodigo(activo, DDTipoPrecio.CODIGO_TPC_VALOR_NETO_CONT);
				if(!Checks.esNulo(valorVNC)) {
					if(valorVNC <= importeLimite)
						codigoTipoComercializacion = DDTipoComercializar.CODIGO_RETAIL;
					else
						codigoTipoComercializacion = DDTipoComercializar.CODIGO_SINGULAR;
				}
			} 
			else if(DDCartera.CODIGO_CARTERA_SAREB.equals(activo.getCartera().getCodigo()) ||
					DDCartera.CODIGO_CARTERA_BANKIA.equals(activo.getCartera().getCodigo())) 
			{
				importeLimite += 100000;
				Double valorActivo = activoApi.getImporteValoracionActivoByCodigo(activo, DDTipoPrecio.CODIGO_TPC_APROBADO_VENTA);
				
				if(Checks.esNulo(valorActivo))
					valorActivo = activoApi.getTasacionMasReciente(activo).getValoracionBien().getImporteValorTasacion().doubleValue();
				
				if(!Checks.esNulo(valorActivo)) {
					if(valorActivo <= importeLimite)
						codigoTipoComercializacion = DDTipoComercializar.CODIGO_RETAIL;
					else
						codigoTipoComercializacion = DDTipoComercializar.CODIGO_SINGULAR;
				}
			}
		}
		
		return codigoTipoComercializacion;
	}

}
