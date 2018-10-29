package es.pfsgroup.plugin.rem.updaterstate;

import java.util.ArrayList;
import java.util.List;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import org.apache.commons.lang.BooleanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoTareaExternaApi;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoTrabajo;
import es.pfsgroup.plugin.rem.model.ActivoValoraciones;
import es.pfsgroup.plugin.rem.model.PerimetroActivo;
import es.pfsgroup.plugin.rem.model.TareaActivo;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosReserva;
import es.pfsgroup.plugin.rem.model.dd.DDSituacionComercial;
import es.pfsgroup.plugin.rem.model.dd.DDTipoPrecio;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTrabajo;

@Service("updaterStateManager")
public class UpdaterStateManager implements UpdaterStateApi{

	public static final String CODIGO_CHECKING_INFORMACION = "T001_CheckingInformacion";
	public static final String CODIGO_CHECKING_ADMISION = "T001_CheckingDocumentacionAdmision";
	public static final String CODIGO_CHECKING_GESTION = "T001_CheckingDocumentacionGestion";
	
	@Autowired
	private ActivoTareaExternaApi activoTareaExternaApi;
	
	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private ActivoAdapter activoAdapterApi;
	
	@Autowired
	private UtilDiccionarioApi utilDiccionarioApi;
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private TrabajoApi trabajoApi;
	
	@Autowired
	private GestorActivoApi gestorActivoApi;
	
	@Override
	public Boolean getStateAdmision(Activo activo) {
		return Checks.esNulo(activo.getAdmision()) ? false :  activo.getAdmision();
	}

	@Override
	public Boolean getStateGestion(Activo activo) {
		return (Checks.esNulo(activo.getGestion()) ? false : activo.getGestion());
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
				Boolean fechasAdmision = (!Checks.esNulo(activo.getSituacionPosesoria()) && !Checks.esNulo(activo.getSituacionPosesoria().getSitaucionJuridica()) && BooleanUtils.toBoolean(activo.getSituacionPosesoria().getSitaucionJuridica().getIndicaPosesion())) 
										 || (!Checks.esNulo(activo.getTitulo()) && !Checks.esNulo(activo.getTitulo().getFechaInscripcionReg()) && !Checks.esNulo(activo.getSituacionPosesoria().getFechaTomaPosesion()) && !Checks.esNulo(activo.getFechaRevisionCarga()));
				activo.setAdmision(tareasAdmision && fechasAdmision);
			}
		}
	}
	
	private void updaterStateGestion(Activo activo){
		activo.setGestion(activo.getTieneOkTecnico());
	}
	
	@Override
	public void updaterStateDisponibilidadComercialAndSave(Long idActivo) {
		Activo activo = activoApi.get(idActivo);
		this.updaterStateDisponibilidadComercialAndSave(activo,false);
		
	}
	
	@Override
	@Transactional(readOnly = false)
	public void updaterStateDisponibilidadComercialAndSave(Activo activo) {
		this.updaterStateDisponibilidadComercial(activo);
		activoApi.saveOrUpdate(activo);
		activoAdapterApi.actualizarEstadoPublicacionActivo(activo.getId());
		this.updaterStateDisponibilidadComercialAndSave(activo,false);
	}

	@Override
	public void updaterStateDisponibilidadComercialAndSave(Activo activo, Boolean express) {
		if(express){
			String codigo = DDSituacionComercial.CODIGO_DISPONIBLE_VENTA_OFERTA;
			activo.setSituacionComercial((DDSituacionComercial)utilDiccionarioApi.dameValorDiccionarioByCod(DDSituacionComercial.class,codigo));
		}else{
			this.updaterStateDisponibilidadComercial(activo);
			activoApi.saveOrUpdate(activo);
		}

		activoAdapterApi.actualizarEstadoPublicacionActivo(activo.getId());
	}
	
	@Override
	@Transactional(readOnly = false)
	public void updaterStateDisponibilidadComercial(Activo activo) {
		
		String codigoSituacion = this.getCodigoSituacionComercialFromActivo(activo);
		
		if(!Checks.esNulo(codigoSituacion)) {
			activo.setSituacionComercial((DDSituacionComercial)utilDiccionarioApi.dameValorDiccionarioByCod(DDSituacionComercial.class,codigoSituacion));
		}
	}
	
	
	
	private String getCodigoSituacionComercialFromActivo(Activo activo) {
		
		String codigo = null;
		PerimetroActivo perimetro = activoApi.getPerimetroByIdActivo(activo.getId());
		
		if(activoApi.isActivoVendido(activo)) {
			codigo = DDSituacionComercial.CODIGO_VENDIDO;
		}
		else if(!Checks.esNulo(perimetro) && !Checks.esNulo(perimetro.getAplicaComercializar()) && perimetro.getAplicaComercializar() == 0) {
			codigo = DDSituacionComercial.CODIGO_NO_COMERCIALIZABLE;
		}
		else if(activoApi.isActivoConReservaByEstado(activo,DDEstadosReserva.CODIGO_FIRMADA)) {
			codigo = DDSituacionComercial.CODIGO_DISPONIBLE_VENTA_RESERVA;
		}
		else if(activoApi.isActivoConOfertaByEstado(activo,DDEstadoOferta.CODIGO_ACEPTADA)) {
			codigo = DDSituacionComercial.CODIGO_DISPONIBLE_VENTA_OFERTA;
		}
		else if(activoApi.getCondicionantesDisponibilidad(activo.getId()).getIsCondicionado()) {
			codigo = DDSituacionComercial.CODIGO_DISPONIBLE_CONDICIONADO;
		}
		else if (!Checks.esNulo(activo.getTipoComercializacion())) {
			int indexAux = Integer.parseInt(activo.getTipoComercializacion().getCodigo()); 
			switch(indexAux) {
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
		
		String codigoComercializacionActual = !Checks.esNulo(activo.getTipoComercializar()) ? activo.getTipoComercializar().getCodigo() : "";
		activoApi.calcularSingularRetailActivo(activo.getId());
		
		String activoModificado = activoApi.getCodigoTipoComercializarByActivo(activo.getId());
		String codigoComercializacionNuevo = !Checks.esNulo(activoModificado) ? activoModificado : "";
		
		if(!codigoComercializacionActual.equals(codigoComercializacionNuevo))
			gestorActivoApi.actualizarTareas(activo.getId());
		/*
		 * TODO: Se deja así, hasta que se definan los siguientes cambios por funconales.
		 *	
		PerimetroActivo perimetro = activoApi.getPerimetroByIdActivo(activo.getId());
		//Si el activo tiene activado el bloqueo para el cambio automático o No es comercializable, no hará nada
		if(!activo.getBloqueoTipoComercializacionAutomatico() && (Checks.esNulo(perimetro) || perimetro.getAplicaComercializar() == 1)) {
			String codigoTipoComercializacion = this.getCodigoTipoComercializacionFromActivo(activo); 
			
			//Si el tipoComercializacion calculado no es nulo y es distinto al actual del Activo, entonces...
			if(!Checks.esNulo(codigoTipoComercializacion) && !Checks.esNulo(activo.getTipoComercializar()) && !codigoTipoComercializacion.equals(activo.getTipoComercializar().getCodigo())) {
				
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
				else if(!activoTareaExternaApi.existenTareasActivasByTramiteAndTipoGestor(activo, ActivoTramiteApi.CODIGO_TRAMITE_COMERCIAL_VENTA, mapaComercial.get(codigoTipoComercializacion))) {
					
					activo.setTipoComercializar((DDTipoComercializar)utilDiccionarioApi.dameValorDiccionarioByCod(DDTipoComercializar.class,codigoTipoComercializacion));
				}
			}
		}*/
	}
	
	/**
	 * (Activo en Promocion Obra Nueva o Asistida // Activo de 1ª o 2ª Residencia )-> Retail
	 * Cajamar: VNC <= 500000 -> Retail), en caso contrario -> Singular
	 * Sareb/Bankia: AprobadoVenta (si no hay, valorTasacion) <= 500000 -> Retail), en caso contrario -> Singular
	 * @param activo
	 * @return
	 */
	@SuppressWarnings("unused")
	@Deprecated
	private String getCodigoTipoComercializacionFromActivo(Activo activo) {
		
		return activoApi.getCodigoTipoComercializacionFromActivo(activo);
	}	
	
	
	public String calcularParticipacionPorActivo(Activo activo_check){//
		return "100";
	}
	
	@SuppressWarnings("unused")
	public Double calcularParticipacionPorActivo(String codigoTipoTrabajo, List<Activo> activosLista, Activo activo_check){
		//Si algún parámetro es nulo, omitimos el procedimiento.
		if (codigoTipoTrabajo == null || activo_check == null) {
			return null;
		}

		//Si todos los argumentos son null, se devuelve un 100% de participación.
		if((activosLista == null || activosLista.size() == 0) && codigoTipoTrabajo == null && activo_check == null){
			return 100d;
		}

		if(activosLista == null || activosLista.size() == 0){
			return 100d;
		}

		try{
			//Si el tipo de trabajo es OBTENCION_DOCUMENTAL o ACTUACION_TECNICA.
			if ((DDTipoTrabajo.CODIGO_OBTENCION_DOCUMENTAL.equals(codigoTipoTrabajo)) || 
					(DDTipoTrabajo.CODIGO_ACTUACION_TECNICA.equals(codigoTipoTrabajo))) {

				Filter filtroActivoId = null, filtroValorNeto = null, filtroValorMinimo = null, filtroFSV = null, filtroVACBE = null, filtroPrecioTransferencia = null, filtroValorReferencia = null, filtroBorrado = null;
				ActivoValoraciones valorNeto = null, valorMinimo = null, fsv = null, vacbe = null, precioTransferencia = null, valorReferencia = null;		

				String cartera = activo_check.getCartera().getCodigo(), reglaSeleccionada = null;
				Boolean valorNetoNull = false, valorMinimoNull = false, valorFSVNull = false, valorVACBENull = false, valorPrecioTransferenciaNull = false, valorReferenciaNull = false;
				Double valorNetoTotal = 0d, valorMinimoTotal = 0d, fsvTotal = 0d, vacbeTotal = 0d, precioTransferenciaTotal = 0d, valorReferenciaTotal = 0d;
				Double valorNeto_act = 0d, valorMinimo_act = 0d, fsv_act = 0d, vacbe_act = 0d, precioTransferencia_act = 0d, valorReferencia_act = 0d;

				//Checkeamos la información de todos los activos en la lista.
				for (Activo activo : activosLista){
					filtroActivoId = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
					filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
					filtroValorNeto = genericDao.createFilter(FilterType.EQUALS, "tipoPrecio.codigo", DDTipoPrecio.CODIGO_TPC_VALOR_NETO_CONT);
					filtroValorMinimo = genericDao.createFilter(FilterType.EQUALS, "tipoPrecio.codigo", DDTipoPrecio.CODIGO_TPC_MIN_AUTORIZADO);
					filtroFSV = genericDao.createFilter(FilterType.EQUALS, "tipoPrecio.codigo", DDTipoPrecio.CODIGO_TPC_FSV_VENTA);
					filtroVACBE = genericDao.createFilter(FilterType.EQUALS, "tipoPrecio.codigo", DDTipoPrecio.CODIGO_TPC_VACBE);
					filtroPrecioTransferencia = genericDao.createFilter(FilterType.EQUALS, "tipoPrecio.codigo", DDTipoPrecio.CODIGO_TPC_PT);
					filtroValorReferencia = genericDao.createFilter(FilterType.EQUALS, "tipoPrecio.codigo", DDTipoPrecio.CODIGO_TPC_VALOR_REFERENCIA);

					// En este punto se deberían obtener un solo objeto de cada tipo, pero por adecuarlo a problemas de datos se prepara para varios.
					List<ActivoValoraciones> listado = genericDao.getList(ActivoValoraciones.class, filtroActivoId, filtroValorNeto, filtroBorrado);
					valorNeto = Checks.estaVacio(listado) ? null : listado.get(0);
					listado = genericDao.getList(ActivoValoraciones.class, filtroActivoId, filtroValorMinimo, filtroBorrado);
					valorMinimo = Checks.estaVacio(listado) ? null : listado.get(0);
					listado = genericDao.getList(ActivoValoraciones.class, filtroActivoId, filtroFSV, filtroBorrado);
					fsv = Checks.estaVacio(listado) ? null : listado.get(0);
					listado = genericDao.getList(ActivoValoraciones.class, filtroActivoId, filtroVACBE, filtroBorrado);
					vacbe = Checks.estaVacio(listado) ? null : listado.get(0);
					listado = genericDao.getList(ActivoValoraciones.class, filtroActivoId, filtroPrecioTransferencia, filtroBorrado);
					precioTransferencia = Checks.estaVacio(listado) ? null : listado.get(0);
					listado = genericDao.getList(ActivoValoraciones.class, filtroActivoId, filtroValorReferencia, filtroBorrado);
					valorReferencia = Checks.estaVacio(listado) ? null : listado.get(0);

					//Identificamos que comunes valores podemos utilizar.
					if(valorNeto == null){
						valorNetoNull = true;
					}else{
						valorNetoTotal = valorNetoTotal + valorNeto.getImporte();
					}
					if(valorMinimo == null){
						valorMinimoNull = true;
					}else{
						valorMinimoTotal = valorMinimoTotal + valorMinimo.getImporte();
					}
					if(fsv == null){
						valorFSVNull = true;
					}else{
						fsvTotal = fsvTotal + fsv.getImporte();
					}
					if(vacbe == null){
						valorVACBENull = true;
					}else{
						vacbeTotal = vacbeTotal + vacbe.getImporte();
					}
					if(precioTransferencia == null){
						valorPrecioTransferenciaNull = true;
					}else{
						precioTransferenciaTotal = precioTransferenciaTotal + precioTransferencia.getImporte();
					}
					if(valorReferencia == null){
						valorReferenciaNull = true;
					}else{
						valorReferenciaTotal = valorReferenciaTotal + valorReferencia.getImporte();
					}

					//Cuando se encuentre el activo que se va a checkear, se guarda su información para calcular luego la regla de tres.
					if(activo == activo_check){
						if(valorNeto == null){
							valorNeto_act = 0d;
						}else{
							valorNeto_act = valorNeto.getImporte();
						}
						if(valorMinimo == null){
							valorMinimo_act = 0d;
						}else{
							valorMinimo_act = valorMinimo.getImporte();
						}
						if(fsv == null){
							fsv_act = 0d;
						}else{
							fsv_act = fsv.getImporte();
						}
						if(vacbe == null){
							vacbe_act = 0d;
						}else{
							vacbe_act = vacbe.getImporte();
						}
						if(precioTransferencia == null){
							precioTransferencia_act = 0d;
						}else{
							precioTransferencia_act = precioTransferencia.getImporte();
						}
						if(valorReferencia == null){
							valorReferencia_act = 0d;
						}else{
							valorReferencia_act = valorReferencia.getImporte();
						}
					}
				}

				//Selección de la regla dependiendo de la cartera.
				/*
				 * ------------------Diccionario de reglas------------------
				 * A partes iguales = "00"
				 * Valor neto contable = DDTipoPrecio.CODIGO_TPC_VALOR_NETO_CONT
				 * Valor mínimo autorizado = DDTipoPrecio.CODIGO_TPC_MIN_AUTORIZADO
				 * First sale value = DDTipoPrecio.CODIGO_TPC_FSV_VENTA
				 * Valor actualizado contable banco España = DDTipoPrecio.CODIGO_TPC_VACBE
				 * Precio transferencia = DDTipoPrecio.CODIGO_TPC_PT
				 * Valor referencia = DDTipoPrecio.CODIGO_TPC_VALOR_REFERENCIA
				 */
				if(cartera.equals(DDCartera.CODIGO_CARTERA_CAJAMAR)){
					if(!valorNetoNull){
						reglaSeleccionada = DDTipoPrecio.CODIGO_TPC_VALOR_NETO_CONT;
					}else{
						if(!valorMinimoNull){
							reglaSeleccionada = DDTipoPrecio.CODIGO_TPC_MIN_AUTORIZADO;
						}else{
							if(!valorFSVNull){
								reglaSeleccionada = DDTipoPrecio.CODIGO_TPC_FSV_VENTA;
							}else{
								reglaSeleccionada = "00";
							}
						}
					}
				}else if(cartera.equals(DDCartera.CODIGO_CARTERA_SAREB) || cartera.equals(DDCartera.CODIGO_CARTERA_TANGO) || cartera.equals(DDCartera.CODIGO_CARTERA_GIANTS)){
					if(!valorPrecioTransferenciaNull){
							reglaSeleccionada = DDTipoPrecio.CODIGO_TPC_PT;
					}else{
						if(!valorVACBENull){
							reglaSeleccionada = DDTipoPrecio.CODIGO_TPC_VACBE;
						}else{
							if(!valorMinimoNull){
								reglaSeleccionada = DDTipoPrecio.CODIGO_TPC_MIN_AUTORIZADO;
							}else{
								if(!valorFSVNull){
									reglaSeleccionada = DDTipoPrecio.CODIGO_TPC_FSV_VENTA;
								}else{
									reglaSeleccionada = "00";
								}
							}
						}
					}
				}else if(cartera.equals(DDCartera.CODIGO_CARTERA_BANKIA)){
					if(!valorReferenciaNull){
						reglaSeleccionada = DDTipoPrecio.CODIGO_TPC_VALOR_REFERENCIA;
					}else{
						if(!valorMinimoNull){
							reglaSeleccionada = DDTipoPrecio.CODIGO_TPC_MIN_AUTORIZADO;
						}else{
							if(!valorFSVNull){
								reglaSeleccionada = DDTipoPrecio.CODIGO_TPC_FSV_VENTA;
							}else{
								reglaSeleccionada = "00";
							}
						}
					}
				}else{//Otras carteras (Ni Cajamar, ni Sareb, ni Bankia)
					if(!valorMinimoNull){
						reglaSeleccionada = DDTipoPrecio.CODIGO_TPC_MIN_AUTORIZADO;
					}else{
						if(!valorFSVNull){
							reglaSeleccionada = DDTipoPrecio.CODIGO_TPC_FSV_VENTA;
						}else{
							reglaSeleccionada = "00";
						}
					}
				}

				//Realización de la regla de tres para el activo a checkear según la regla seleccionada anteriormente.

				if(reglaSeleccionada.equals("00")){//A partes iguales.
					return (100d / activosLista.size());

				}else if(reglaSeleccionada.equals(DDTipoPrecio.CODIGO_TPC_VALOR_NETO_CONT)){//Valor neto contable.
					return ((valorNeto_act * 100d) / valorNetoTotal);

				}else if(reglaSeleccionada.equals(DDTipoPrecio.CODIGO_TPC_MIN_AUTORIZADO)){//Valor mínimo autorizado.
					return ((valorMinimo_act * 100d) / valorMinimoTotal);

				}else if(reglaSeleccionada.equals(DDTipoPrecio.CODIGO_TPC_FSV_VENTA)){//First sale value.
					return (fsv_act * 100d) / fsvTotal;

				}else if(reglaSeleccionada.equals(DDTipoPrecio.CODIGO_TPC_VACBE)){//Valor actualizado contable banco España.
					return (vacbe_act * 100d) / vacbeTotal;

				}else if(reglaSeleccionada.equals(DDTipoPrecio.CODIGO_TPC_PT)){//Precio transferencia.
					return (precioTransferencia_act * 100d) / precioTransferenciaTotal;

				}else if(reglaSeleccionada.equals(DDTipoPrecio.CODIGO_TPC_VALOR_REFERENCIA)){//Valor referencia.
					return (valorReferencia_act * 100d) / valorReferenciaTotal;

				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		//}//Si el tabajo no es ni de tipo OBTENCION_DOCUMENTAL ni de tipo ACTUACION_TECNICA. 

		return null;
	}

	@Transactional(readOnly = false)
	public void recalcularParticipacion(Long idTrabajo){
		if(idTrabajo == null){
			return;
		}

		try{
			Trabajo trabajo = trabajoApi.findOne(idTrabajo);
			String codigoTipoTrabajo = trabajo.getTipoTrabajo().getCodigo();
			List<ActivoTrabajo> activosTrabajoLista = trabajo.getActivosTrabajo();

			List<Activo> activosLista = new ArrayList<Activo>();
			for(ActivoTrabajo activoTrabajo : activosTrabajoLista){
				activosLista.add(activoTrabajo.getActivo());
			}

			Double participacion = null; 
			for(ActivoTrabajo activoTrabajo : activosTrabajoLista){
				participacion = calcularParticipacionPorActivo(codigoTipoTrabajo, activosLista, activoTrabajo.getActivo());

				if(participacion == null){
					participacion = (100d / activosLista.size());
				}

				activoTrabajo.setParticipacion(participacion.floatValue());

				genericDao.update(ActivoTrabajo.class, activoTrabajo);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public Double calcularParticipacionValorPorActivo(String codigoTipoTrabajo, Activo activo){
		Double valor= 0d;

		if ((DDTipoTrabajo.CODIGO_OBTENCION_DOCUMENTAL.equals(codigoTipoTrabajo)) || 
				(DDTipoTrabajo.CODIGO_ACTUACION_TECNICA.equals(codigoTipoTrabajo))) {

			Filter filtroActivoId = null, filtroValorNeto = null, filtroValorMinimo = null, filtroFSV = null, filtroVACBE = null, filtroPrecioTransferencia = null, filtroValorReferencia = null, filtroBorrado = null;
			ActivoValoraciones valorNeto = null, valorMinimo = null, fsv = null, vacbe = null, precioTransferencia = null, valorReferencia = null;		
			Double valorNeto_act = 0d, valorMinimo_act = 0d, fsv_act = 0d, vacbe_act = 0d, precioTransferencia_act = 0d, valorReferencia_act = 0d;

			//Checkeamos la información de todos los activos en la lista.
			
				filtroActivoId = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
				filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
				filtroValorNeto = genericDao.createFilter(FilterType.EQUALS, "tipoPrecio.codigo", DDTipoPrecio.CODIGO_TPC_VALOR_NETO_CONT);
				filtroValorMinimo = genericDao.createFilter(FilterType.EQUALS, "tipoPrecio.codigo", DDTipoPrecio.CODIGO_TPC_MIN_AUTORIZADO);
				filtroFSV = genericDao.createFilter(FilterType.EQUALS, "tipoPrecio.codigo", DDTipoPrecio.CODIGO_TPC_FSV_VENTA);
				filtroVACBE = genericDao.createFilter(FilterType.EQUALS, "tipoPrecio.codigo", DDTipoPrecio.CODIGO_TPC_VACBE);
				filtroPrecioTransferencia = genericDao.createFilter(FilterType.EQUALS, "tipoPrecio.codigo", DDTipoPrecio.CODIGO_TPC_PT);
				filtroValorReferencia = genericDao.createFilter(FilterType.EQUALS, "tipoPrecio.codigo", DDTipoPrecio.CODIGO_TPC_VALOR_REFERENCIA);

				// En este punto se deberían obtener un solo objeto de cada tipo, pero por adecuarlo a problemas de datos se prepara para varios.
				List<ActivoValoraciones> listado = genericDao.getList(ActivoValoraciones.class, filtroActivoId, filtroValorNeto, filtroBorrado);
				valorNeto = Checks.estaVacio(listado) ? null : listado.get(0);
				listado = genericDao.getList(ActivoValoraciones.class, filtroActivoId, filtroValorMinimo, filtroBorrado);
				valorMinimo = Checks.estaVacio(listado) ? null : listado.get(0);
				listado = genericDao.getList(ActivoValoraciones.class, filtroActivoId, filtroFSV, filtroBorrado);
				fsv = Checks.estaVacio(listado) ? null : listado.get(0);
				listado = genericDao.getList(ActivoValoraciones.class, filtroActivoId, filtroVACBE, filtroBorrado);
				vacbe = Checks.estaVacio(listado) ? null : listado.get(0);
				listado = genericDao.getList(ActivoValoraciones.class, filtroActivoId, filtroPrecioTransferencia, filtroBorrado);
				precioTransferencia = Checks.estaVacio(listado) ? null : listado.get(0);
				listado = genericDao.getList(ActivoValoraciones.class, filtroActivoId, filtroValorReferencia, filtroBorrado);
				valorReferencia = Checks.estaVacio(listado) ? null : listado.get(0);

				//Cuando se encuentre el activo que se va a checkear, se guarda su información para calcular luego la regla de tres.
					if(valorNeto == null){
						valorNeto_act = 0d;
					}else{
						valorNeto_act = valorNeto.getImporte();
					}
					if(valorMinimo == null){
						valorMinimo_act = 0d;
					}else{
						valorMinimo_act = valorMinimo.getImporte();
					}
					if(fsv == null){
						fsv_act = 0d;
					}else{
						fsv_act = fsv.getImporte();
					}
					if(vacbe == null){
						vacbe_act = 0d;
					}else{
						vacbe_act = vacbe.getImporte();
					}
					if(precioTransferencia == null){
						precioTransferencia_act = 0d;
					}else{
						precioTransferencia_act = precioTransferencia.getImporte();
					}
					if(valorReferencia == null){
						valorReferencia_act = 0d;
					}else{
						valorReferencia_act = valorReferencia.getImporte();
					}
					
					
					if(!valorNeto_act.equals(0d)){
						valor = valorNeto_act;
					}
					else if(!valorMinimo_act.equals(0d)){
						valor = valorMinimo_act;
					}
					else if(!fsv_act.equals(0d)){
						valor = fsv_act;
					}
					else if(!vacbe_act.equals(0d)){
						valor = vacbe_act;
					}
					else if(!precioTransferencia_act.equals(0d)){
						valor = precioTransferencia_act;
					}
					else if(!valorReferencia_act.equals(0d)){
						valor = valorReferencia_act;
					}else{
						valor= 0d;
					}
			}
		
		return valor;
		
		
	}

}
