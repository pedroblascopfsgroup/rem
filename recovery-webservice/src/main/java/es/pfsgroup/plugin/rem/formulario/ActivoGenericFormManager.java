package es.pfsgroup.plugin.rem.formulario;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.exception.UserException;
import es.capgemini.pfs.BPMContants;
import es.capgemini.pfs.diccionarios.DictionaryManager;
import es.capgemini.pfs.procesosJudiciales.TareaExternaManager;
import es.capgemini.pfs.procesosJudiciales.dao.TareaExternaValorDao;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.GenericFormItem;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.web.genericForm.DtoGenericForm;
import es.capgemini.pfs.web.genericForm.GenericForm;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
//import es.pfsgroup.plugin.rem.jbpm.JBPMProcessManagerApi;
import es.pfsgroup.framework.paradise.jbpm.JBPMProcessManagerApi;
import es.pfsgroup.plugin.rem.api.ActivoGenericFormManagerApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.PreciosApi;
import es.pfsgroup.plugin.rem.api.ResolucionComiteApi;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.formulario.dao.ActivoGenericFormItemDao;
import es.pfsgroup.plugin.rem.jbpm.activo.JBPMActivoScriptExecutorApi;
import es.pfsgroup.plugin.rem.jbpm.activo.JBPMActivoTramiteManagerApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ConfiguracionTarifa;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.PropuestaPrecio;
import es.pfsgroup.plugin.rem.model.Reserva;
import es.pfsgroup.plugin.rem.model.ResolucionComiteBankia;
import es.pfsgroup.plugin.rem.model.ResolucionComiteBankiaDto;
import es.pfsgroup.plugin.rem.model.TareaActivo;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.VBusquedaActivosTrabajoPresupuesto;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDComiteSancion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoResolucion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosReserva;
import es.pfsgroup.plugin.rem.model.dd.DDResolucionComite;
import es.pfsgroup.plugin.rem.model.dd.DDTipoResolucion;
import es.pfsgroup.plugin.rem.model.dd.DDTiposArras;
import es.pfsgroup.plugin.rem.oferta.OfertaManager;

@Service
public class ActivoGenericFormManager implements ActivoGenericFormManagerApi{

	public static final String TIPO_CAMPO_INFORMATIVO = "textinf";
	public static final String TIPO_CAMPO_FECHA = "datefield";
	public static final String TIPO_CAMPO_FECHA_MAX_TO_DAY = "datemaxtoday";
	public static final String TIPO_CAMPO_HORA = "timefield";
	public static final String TIPO_COMBOBOX_INICIAL = "comboboxinicial";
	public static final String TIPO_COMBOBOX_INICIAL_ED = "comboboxinicialedi";
	public static final String TIPO_CAMPO_NUMBER = "numberfield";
	public static final String NO_APLICA = "No aplica";
	public static final String TIPO_CAMPO_TEXTFIELD = "textfield";
	
    protected final Log logger = LogFactory.getLog(getClass());

    @Autowired
    private JBPMProcessManagerApi jbpmManager;
    
    @Autowired
    private JBPMActivoScriptExecutorApi jbpmScriptExecutorApi;
    
    @Autowired
    private JBPMActivoTramiteManagerApi jbpmActivoTramiteManagerApi;

    @Autowired
    private ActivoGenericFormItemDao genericFormItemDao;

    @Autowired
    private TareaExternaValorDao tareaExternaValorDao;

    @Autowired
    private TareaExternaManager tareaExternaManager;
    
    @Autowired
    private OfertaApi ofertaApi;
    
    @Autowired
    private ExpedienteComercialApi expedienteComercialApi;

    @Autowired
    private DictionaryManager dictionaryManager;

    @Autowired
    private GenericABMDao genericDao;
    
    @Autowired
	private PreciosApi preciosApi;

    @Autowired
	private TrabajoApi trabajoApi;
    
    
    @Autowired
    private ResolucionComiteApi resolucionComiteApi;
    
    @Autowired
    private OfertaManager ofertaManager;

    
    /**
     * Genera un vector de valores de las tareas del idTramite
     * @param idTramite El trámite del cual se quiere extraer sus valores de tareas
     * @return Vector con los valores de los items de las tareas -> valores['TramiteIntereses']['fecha']
     */
    public Map<String, Map<String, String>> getValoresTareas(Long idTramite) {
        return jbpmActivoTramiteManagerApi.creaMapValores(idTramite);
    }
    
    /**
     * Obtiene un formulario dinamico a partir del id de una tarea Externa
     *
     * @param idTareaExterna
     * @return GenericForm
     */
    public GenericForm getForm(Long idTareaExterna) {
    	return this.get(idTareaExterna);
    }
    
    /**
     * Obtiene un formulario dinamico a partir del id de una tarea Externa
     *
     * @param idTareaExterna id. de la tarea externa
     * @return GenericForm devuelve el formulario asociado a la tarea externa.
     */
    public GenericForm get(Long idTareaExterna) {
        TareaExterna tareaExterna = tareaExternaManager.get(idTareaExterna);

        GenericForm form = new GenericForm();

        form.setView(tareaExterna.getTareaProcedimiento().getView());
        form.setErrorValidacion(validacionPreviaDeLaTarea(tareaExterna));
        // cambiar el dao por un manager
        // TareaNotificacion tarea = notificacionManager.get(id);
        form.setTareaExterna(tareaExterna);

        List<GenericFormItem> items = genericFormItemDao.getByIdTareaProcedimiento(tareaExterna.getTareaProcedimiento().getId());
        form.setItems(items);

        //obtenerValoresDeLosCombos(items);
        asignaValoresALosItems(items, tareaExterna); //Comentado para la demo, usa métodos de procedimientos.

        return form;
    }
    
    /**
     * Guarda los valores obtenidos del formulario genérico de tareas en bbdd y envía la señal de avanzar el trámite asociado a la tarea.
     *
     * @param dto dto con los datos que se guardan.
     */
    @Transactional
    public void saveValues(DtoGenericForm dto) {
        String[] valores = dto.getValues();
        TareaExterna tarea = dto.getForm().getTareaExterna();

        //TareaNotificacion tareaPadre = (TareaNotificacion) executor.execute(ComunBusinessOperation.BO_TAREA_MGR_GET, tarea.getTareaPadre().getId());

        //Procedimiento prc = tareaPadre.getProcedimiento();

        //List<TareaExternaValor> listaValores = new ArrayList<TareaExternaValor>();
        for (int i = 0; i < valores.length; i++) {
            GenericFormItem item = dto.getForm().getItems().get(i);
            TareaExternaValor valor = new TareaExternaValor();
            valor.setTareaExterna(tarea);
            valor.setNombre(item.getNombre());
            valor.setValor(valores[i]);
            //listaValores.add(valor);
            tareaExternaValorDao.saveOrUpdate(valor);

        }

        //Le insertamos los valores del formulario al BPM en una variable de Thread para que pueda recuperarlos
        jbpmManager.signalToken(tarea.getTokenIdBpm(), BPMContants.TRANSICION_AVANZA_BPM);
    }    
    
    /**
     * Lanza la señal de avanzar el BPM asociado al token. El BPM avanza por la transición que se le indica.
     * @param idToken
     * @param transitionName
     */
    public void signalToken(final Long idToken, final String transitionName) {
    	jbpmManager.signalToken(idToken, transitionName);

    }

    /** Ejecuta la validación definida en la tarea. El script debe devolver null para continuar, o un string indicando el error a mostrar
     * @param tareaExterna
     */
    private String validacionPreviaDeLaTarea(TareaExterna tareaExterna) {
        String script = tareaExterna.getTareaProcedimiento().getScriptValidacion();

        //script = "!isEmbargosConFechaSolicitud() ? 'Antes de realizar la tarea es necesario marcar los bienes con fecha de solicitud de embargo' : null";
        //script = "isEmbargosConFechaDecreto() && !isEmbargosConFechaRegistro() ? 'Antes de realizar la tarea es necesario marcar los bienes con fecha de registro de embargo' : null";

        if (!StringUtils.isBlank(script)) {
            Long idTareaExterna = tareaExterna.getId();
            //Long idProcedimiento = tareaExterna.getTareaPadre().getProcedimiento().getId();
            Long idTramite = ((TareaActivo) tareaExterna.getTareaPadre()).getTramite().getId();

            //            Map<String, Object> params = jbpmUtils.creaContextoParaScript(idProcedimiento, idTareaExterna);
            //
            //            String scriptAmpliado = params.get(BPMContants.FUNCIONES_GLOBALES_SCRIPT) + script;
            //            return (String) evaluator.evaluate(scriptAmpliado, params);

            String result = null;
            try {
                result = (String) jbpmScriptExecutorApi.evaluaScript(idTramite, idTareaExterna, tareaExterna.getTareaProcedimiento().getId(), null,
                        script);
            } catch (Exception e) {
                throw new UserException("Error en el script de validación [" + script + "] para la tarea: " + idTareaExterna + " del trámite: "
                        + idTramite);
            }
            return result;
        }
        return null;
    }

    
    //TODO: Hay que refactorizar este método.
    private void asignaValoresALosItems(List<GenericFormItem> items, TareaExterna tareaExterna) {
        List<TareaExternaValor> valores = tareaExterna.getValores();
        for (GenericFormItem item : items) {

            //Recuperamos el valor guardado de la pantalla
            String valorGuardado = getValueFrom(valores, item.getNombre());

            //Si tiene valor guardado, le seteamos ese valor
            if (valorGuardado != null)
                item.setValue(valorGuardado);
            //Si no tiene valor guardado, comprobamos si es algún campo con carga inicial, y le seteamos el valor correspondiente
            else{
            	if(item.getType().equals(TIPO_CAMPO_INFORMATIVO))
            	{
            		if(item.getNombre().equals("saldoDisponible"))
            		{
            			SimpleDateFormat dfAnyo = new SimpleDateFormat("yyyy");
            			String ejercicioActual = dfAnyo.format(new Date());
            			
            			// El saldo disponible debe ser el del activo, para el ejercicio actual
            			// Si no hay saldo disponible en ejercicio actual, se muestra 0€
            			Filter filtroActivo = genericDao.createFilter(FilterType.EQUALS, "idActivo", ((TareaActivo) tareaExterna.getTareaPadre()).getActivo().getId().toString());
            			Filter filtroEjercicio = genericDao.createFilter(FilterType.EQUALS, "ejercicio", ejercicioActual);
            			List<VBusquedaActivosTrabajoPresupuesto> lista = genericDao.getList(VBusquedaActivosTrabajoPresupuesto.class, filtroActivo, filtroEjercicio);
            			if(!Checks.estaVacio(lista))
            				item.setValue(lista.get(0).getSaldoDisponible() + "€");
            			else
            				item.setValue("0€");

            		}
            		if(item.getNombre().equals("nombrePropuesta"))
            		{
            			ActivoTramite tramite = ((TareaActivo) tareaExterna.getTareaPadre()).getTramite();
            			PropuestaPrecio propuesta = preciosApi.getPropuestaByTrabajo(tramite.getTrabajo().getId());
            			if(!Checks.esNulo(propuesta)) {
	            			String nombrePropuesta = propuesta.getNombrePropuesta();
	            		    if(!Checks.esNulo(nombrePropuesta))
	            		    	item.setValue(nombrePropuesta);
            			}
            		}
            	}
            	if(item.getType().equals(TIPO_CAMPO_INFORMATIVO))
            	{
            		if(item.getNombre().equals("comite"))
            		{
            			Oferta ofertaAceptada = ofertaApi.tareaExternaToOferta(tareaExterna);
            			if (!Checks.esNulo(ofertaAceptada)) {
            				ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
            				if (!Checks.esNulo(expediente)){
            					if(trabajoApi.checkFormalizacion(tareaExterna)){
            						String codigoComite = null;
			            			if(trabajoApi.checkBankia(tareaExterna)){
										try {
											if(!expediente.getOferta().getVentaDirecta()){
												codigoComite = expedienteComercialApi.consultarComiteSancionador(expediente.getId());
											}else{
												codigoComite = DDComiteSancion.CODIGO_HAYA_SAREB;
											}
										}
										catch (Exception e) {
											logger.error("error consultado comite", e);
										}
										if(!Checks.esNulo(codigoComite))
											item.setValue(expedienteComercialApi.comiteSancionadorByCodigo(codigoComite).getDescripcion());
			            			} else if(trabajoApi.checkLiberbank(tareaExterna)) {
			            				DDComiteSancion comite = ofertaManager.calculoComiteLiberbank(ofertaAceptada);
			            				if(!Checks.esNulo(comite)) {
			            					codigoComite = comite.getCodigo();
			            				}
			            				if(!Checks.esNulo(codigoComite)) {
											item.setValue(expedienteComercialApi.comiteSancionadorByCodigo(codigoComite).getDescripcion());
			            				}
			            			}else {
			            				if(!Checks.esNulo(expediente.getComiteSancion()))
			            					item.setValue(expediente.getComiteSancion().getDescripcion());
				            		}
            					}else{
            						item.setValue(NO_APLICA);
            					}
            				}
            			}
            		}
            		if(item.getNombre().equals("cartera")){
            			Oferta ofertaAceptada = ofertaApi.tareaExternaToOferta(tareaExterna);
            			if(!Checks.esNulo(ofertaAceptada)){
            				if(!Checks.estaVacio(ofertaAceptada.getActivosOferta())){
            					ActivoOferta activoOferta = ofertaAceptada.getActivosOferta().get(0);
								if(!Checks.esNulo(activoOferta)){
	            					Activo activo = activoOferta.getPrimaryKey().getActivo();
	            					item.setValue(activo.getCartera().getDescripcion());
								}
            				}
            			}
            			ofertaAceptada.getActivosOferta().get(0);
            		}
            		if(item.getNombre().equals("numIncremento")){
            			if(trabajoApi.checkSuperaPresupuestoActivoTarea(tareaExterna)){
	            			ActivoTramite tramite = ((TareaActivo) tareaExterna.getTareaPadre()).getTramite();
	            			Trabajo trabajo = tramite.getTrabajo();
	            			item.setValue(String.valueOf(trabajoApi.getExcesoPresupuestoActivo(trabajo)));
            			}
            		}
            		if(item.getNombre().equals("tipoArras")){
            			Oferta ofertaAceptada = ofertaApi.tareaExternaToOferta(tareaExterna);
            			if (!Checks.esNulo(ofertaAceptada)) {
            				ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
            				if (!Checks.esNulo(expediente)){
            					Reserva reserva = expediente.getReserva();
            					if(!Checks.esNulo(reserva)){
            						DDTiposArras tipoArras = reserva.getTipoArras();
            						if(!Checks.esNulo(tipoArras)){
            							item.setValue(tipoArras.getDescripcion());
            						}
            					}
            				}
            			}	
            		}
            		if(item.getNombre().equals("estadoReserva")){
            			Oferta ofertaAceptada = ofertaApi.tareaExternaToOferta(tareaExterna);
            			if (!Checks.esNulo(ofertaAceptada)) {
            				ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
            				if (!Checks.esNulo(expediente)){
            					Reserva reserva = expediente.getReserva();
            					if(!Checks.esNulo(reserva)){
            						DDEstadosReserva estadoReserva = reserva.getEstadoReserva();
            						if(!Checks.esNulo(estadoReserva)){
            							item.setValue(estadoReserva.getDescripcion());
            						}
            					}
            				}
            			}	
            		}
            		if(item.getNombre().equals("importeContraoferta")){
            			Oferta ofertaAceptada = ofertaApi.tareaExternaToOferta(tareaExterna);
            			if(!Checks.esNulo(ofertaAceptada)){
            				if(DDCartera.CODIGO_CARTERA_BANKIA.equals(ofertaAceptada.getActivoPrincipal().getCartera().getCodigo())) {
	            				ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
	            				if(!Checks.esNulo(expediente)){
	            					ResolucionComiteBankiaDto resolDto = new ResolucionComiteBankiaDto();
	            					resolDto.setExpediente(expediente);
	            					Filter filtroTipoResolucion = null;
	            					//if(tareaExterna.getTareaProcedimiento().getCodigo().equals("T013_RespuestaOfertante")) {
	            						filtroTipoResolucion = genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoResolucion.CODIGO_TIPO_RESOLUCION);
//	            					}else {
//	            						filtroTipoResolucion = genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoResolucion.CODIGO_TIPO_RATIFICACION);
//	            					}
	            					DDTipoResolucion tipoResolucion = genericDao.get(DDTipoResolucion.class, filtroTipoResolucion);
	            					
	            					resolDto.setTipoResolucion(tipoResolucion);
	            					
	            					try{
	            						List<ResolucionComiteBankia> listaResoluciones = resolucionComiteApi.getResolucionesComiteByExpedienteTipoRes(resolDto);
	            						
	            						if(!Checks.estaVacio(listaResoluciones)){
	            							ResolucionComiteBankia resolucionComite = listaResoluciones.get(0);
	            							if(!Checks.esNulo(resolucionComite.getImporteContraoferta()))
	            								item.setValue(resolucionComite.getImporteContraoferta().toString());
	            						}
	            					} catch (Exception e){
	            						logger.error("error",e);
	            					}
	            				}
            				}else {
            					item.setValue(ofertaAceptada.getImporteContraOferta().toString());
            				}
            			}
            		}
            	}
            	if(item.getType().equals(TIPO_CAMPO_TEXTFIELD))
            	{
            		if(item.getNombre().equals("tieneReserva")){
            			Boolean reserva = ofertaApi.checkReserva(tareaExterna);
            			if(reserva){
            				item.setValue(DDSiNo.SI);
            			}else{
            				item.setValue(DDSiNo.NO);
            			}
            		}
            	}
            	if(item.getType().equals(TIPO_CAMPO_FECHA))
            	{
            		if(item.getNombre().equals("fechaFirma") && tareaExterna.getTareaProcedimiento().getCodigo().equals("T013_ObtencionContratoReserva")){
            			Oferta ofertaAceptada = ofertaApi.tareaExternaToOferta(tareaExterna);
            			if (!Checks.esNulo(ofertaAceptada)) {
            				ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
            				
            				SimpleDateFormat formatoFecha = new SimpleDateFormat("yyyy-MM-dd");
                			if(!Checks.esNulo(expediente.getReserva().getFechaFirma())){
                				item.setValue(formatoFecha.format(expediente.getReserva().getFechaFirma()));
                			}
            			}            			
            		}
            		
            		if(item.getNombre().equals("fechaIngreso") && tareaExterna.getTareaProcedimiento().getCodigo().equals("T013_DocumentosPostVenta")){
            			Oferta ofertaAceptada = ofertaApi.tareaExternaToOferta(tareaExterna);
            			if (!Checks.esNulo(ofertaAceptada)) {
            				ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
            				
            				SimpleDateFormat formatoFecha = new SimpleDateFormat("yyyy-MM-dd");
                			if(!Checks.esNulo(expediente.getFechaContabilizacionPropietario())){
                				item.setValue(formatoFecha.format(expediente.getFechaContabilizacionPropietario()));
                			}
            			}            			
            		}
            		
            		if(item.getNombre().equals("fechaTope"))
            		{
            			ActivoTramite tramite = ((TareaActivo) tareaExterna.getTareaPadre()).getTramite();
            			Trabajo trabajo = tramite.getTrabajo();
            			Date fecha = trabajo.getFechaTope();
            			SimpleDateFormat formatoFecha = new SimpleDateFormat("yyyy-MM-dd");
            			if(!Checks.esNulo(fecha))
            				item.setValue(formatoFecha.format(fecha));
            		}
            		if(item.getNombre().equals("fechaConcreta"))
            		{
            			ActivoTramite tramite = ((TareaActivo) tareaExterna.getTareaPadre()).getTramite();
            			Trabajo trabajo = tramite.getTrabajo();
            			Date fecha = trabajo.getFechaHoraConcreta();
            		    SimpleDateFormat formatoFecha = new SimpleDateFormat("yyyy-MM-dd");
            		    if(!Checks.esNulo(fecha))
            		    	item.setValue(formatoFecha.format(fecha));
            		}
            		if(item.getNombre().equals("fechaGeneracion"))
            		{
            			ActivoTramite tramite = ((TareaActivo) tareaExterna.getTareaPadre()).getTramite();
            			PropuestaPrecio propuesta = preciosApi.getPropuestaByTrabajo(tramite.getTrabajo().getId());
            			if(!Checks.esNulo(propuesta)) {
	            			Date fecha = propuesta.getFechaEmision();
	            		    SimpleDateFormat formatoFecha = new SimpleDateFormat("yyyy-MM-dd");
	            		    if(!Checks.esNulo(fecha))
	            		    	item.setValue(formatoFecha.format(fecha));
            			}
            		}
            		if(item.getNombre().equals("fechaRespuesta"))
            		{
            			Oferta ofertaAceptada = ofertaApi.tareaExternaToOferta(tareaExterna);
            			if(!Checks.esNulo(ofertaAceptada)){
            				ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
            				if(!Checks.esNulo(expediente)){
            					
            					ResolucionComiteBankiaDto resolDto = new ResolucionComiteBankiaDto();
            					resolDto.setExpediente(expediente);
            					
        						Filter filtroTipoResolucion = genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoResolucion.CODIGO_TIPO_RESOLUCION);
            					DDTipoResolucion tipoResolucion = genericDao.get(DDTipoResolucion.class, filtroTipoResolucion);
            					resolDto.setTipoResolucion(tipoResolucion);           					
            					
								try {
									List<ResolucionComiteBankia> listaResoluciones = resolucionComiteApi.getResolucionesComiteByExpedienteTipoRes(resolDto);
									
									if(!Checks.estaVacio(listaResoluciones)){
										ResolucionComiteBankia resolucionComite = listaResoluciones.get(0);
										
										Date fecha = resolucionComite.getFechaResolucion();
				            		    SimpleDateFormat formatoFecha = new SimpleDateFormat("yyyy-MM-dd");
				            		    if(!Checks.esNulo(fecha))
				            		    	item.setValue(formatoFecha.format(fecha));
									}
								} catch (Exception e) {
									logger.error("error",e);
								}
            				}
            			}
            		}
            		
            	}
            	if(item.getType().equals(TIPO_CAMPO_FECHA_MAX_TO_DAY))
            	{
            		if(item.getTareaProcedimiento().getCodigo().equals("T004_EleccionProveedorYTarifa") 
            				&& item.getNombre().equals("fechaEmision")){
            			Date fecha = new Date();
            			SimpleDateFormat formatoFecha = new SimpleDateFormat("yyyy-MM-dd");
            			item.setValue(formatoFecha.format(fecha));
            		}
            	}
            	if(item.getType().equals(TIPO_CAMPO_HORA))
            	{
            		if(item.getNombre().equals("horaConcreta"))
            		{
            			ActivoTramite tramite = ((TareaActivo) tareaExterna.getTareaPadre()).getTramite();
            			Trabajo trabajo = tramite.getTrabajo();
            			Date fecha = trabajo.getFechaHoraConcreta();
            			SimpleDateFormat formatoHora = new SimpleDateFormat("HH:mm");
            		    if(!Checks.esNulo(fecha))
            		    	item.setValue(formatoHora.format(fecha));
            		}
            	}
            	if(item.getType().equals(TIPO_COMBOBOX_INICIAL))
            	{
            		if(item.getNombre().equals("comboTarifa"))
            		{
            			ActivoTramite tramite = ((TareaActivo) tareaExterna.getTareaPadre()).getTramite();
            			Trabajo trabajo = tramite.getTrabajo();
            			trabajo.getActivo().getCartera();
            			Filter filtroSubtipoTrabajo = genericDao.createFilter(FilterType.EQUALS, "subtipoTrabajo", trabajo.getSubtipoTrabajo());
            			Filter filtroCartera = genericDao.createFilter(FilterType.EQUALS, "cartera", trabajo.getActivo().getCartera());
            			if(!genericDao.getList(ConfiguracionTarifa.class, filtroSubtipoTrabajo, filtroCartera).isEmpty() || trabajo.getEsTarifaPlana()){
            				item.setValue(DDSiNo.SI);
            			}else {
            				item.setValue(DDSiNo.NO);
            			}  
            			
            			
            		}
            		
            		if(item.getNombre().equals("comboConflicto"))
            		{
            			Oferta ofertaAceptada = ofertaApi.tareaExternaToOferta(tareaExterna);
            			if (!Checks.esNulo(ofertaAceptada)) {
            				ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
            				if (!Checks.esNulo(expediente)){
            					if(!Checks.esNulo(expediente.getConflictoIntereses())) {            						
            						if(BooleanUtils.toBoolean(expediente.getConflictoIntereses())) {
            							item.setValue(DDSiNo.SI);
            						} else {
            							item.setValue(DDSiNo.NO);
            						}
            					}
            				}
            			}
            		}
            		
            		if(item.getNombre().equals("comboRiesgo"))
            		{
            			Oferta ofertaAceptada = ofertaApi.tareaExternaToOferta(tareaExterna);
            			if (!Checks.esNulo(ofertaAceptada)) {
            				ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
            				if (!Checks.esNulo(expediente)){
            					if(!Checks.esNulo(expediente.getRiesgoReputacional())) {            						
            						if(BooleanUtils.toBoolean(expediente.getRiesgoReputacional())) {
            							item.setValue(DDSiNo.SI);
            						} else {
            							item.setValue(DDSiNo.NO);
            						}
            					}
            				}
            			}
            		}            		
            		
            			
            	}
            	if(item.getType().equals(TIPO_COMBOBOX_INICIAL_ED))
            	{
            		if(item.getNombre().equals("comboResolucion") || item.getNombre().equals("comboRatificacion"))
            		{
            			Oferta ofertaAceptada = ofertaApi.tareaExternaToOferta(tareaExterna);
            			if(!Checks.esNulo(ofertaAceptada)){
            				ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
            				if(!Checks.esNulo(expediente)){
            					//Filter filtroExpediente = genericDao.createFilter(FilterType.EQUALS, "expediente.id", expediente.getId());
            					
            					ResolucionComiteBankiaDto resolDto = new ResolucionComiteBankiaDto();
            					resolDto.setExpediente(expediente);
            					Filter filtroTipoResolucion = genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoResolucion.CODIGO_TIPO_RESOLUCION);
            					
            					DDTipoResolucion tipoResolucion = genericDao.get(DDTipoResolucion.class, filtroTipoResolucion);
            					
            					resolDto.setTipoResolucion(tipoResolucion);
            					
								try {
									List<ResolucionComiteBankia> listaResoluciones = resolucionComiteApi.getResolucionesComiteByExpedienteTipoRes(resolDto);
									
									if(!Checks.estaVacio(listaResoluciones)){
										ResolucionComiteBankia resolucionComite = listaResoluciones.get(0);
										item.setValue(this.getMapaEREtoRCO().get(resolucionComite.getEstadoResolucion().getCodigo()));
									}
								} catch (Exception e) {
									logger.error("error",e);
								}
            					
            					//ResolucionComiteBankia resolucion = genericDao.get(ResolucionComiteBankia.class, filtroExpediente);

            				}
            			}
            		}   
            		
	        		if(item.getNombre().equals("comiteSuperior"))
	        		{
	        			Oferta ofertaAceptada = ofertaApi.tareaExternaToOferta(tareaExterna);
	        			if (!Checks.esNulo(ofertaAceptada)) {
	        				ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
	        				if (!Checks.esNulo(expediente)){
	        					if(trabajoApi.checkFormalizacion(tareaExterna)){
			            			if(trabajoApi.checkBankia(tareaExterna)){

			            				if(!Checks.esNulo(expediente.getComiteSancion()))
			            					item.setValue(expediente.getComiteSancion().getDescripcion());
			            			}
	        					}else{
	        						item.setValue(NO_APLICA);
	        					}
		            		}
	            		}
	            	}
            	}
            	if(item.getType().equals(TIPO_CAMPO_NUMBER))
            	{
            		if(item.getNombre().equals("numImporteContra"))
            		{
            			Oferta ofertaAceptada = ofertaApi.tareaExternaToOferta(tareaExterna);
            			if(!Checks.esNulo(ofertaAceptada)){
            				ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofertaAceptada.getId());
            				if(!Checks.esNulo(expediente)){
            					ResolucionComiteBankiaDto resolDto = new ResolucionComiteBankiaDto();
            					resolDto.setExpediente(expediente);
            					
            					Filter filtroTipoResolucion = genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoResolucion.CODIGO_TIPO_RESOLUCION);
            					DDTipoResolucion tipoResolucion = genericDao.get(DDTipoResolucion.class, filtroTipoResolucion);
            					
            					resolDto.setTipoResolucion(tipoResolucion);
            					
            					try{
            						List<ResolucionComiteBankia> listaResoluciones = resolucionComiteApi.getResolucionesComiteByExpedienteTipoRes(resolDto);
            						
            						if(!Checks.estaVacio(listaResoluciones)){
            							ResolucionComiteBankia resolucionComite = listaResoluciones.get(0);
            							if(!Checks.esNulo(resolucionComite.getImporteContraoferta()))
            								item.setValue(resolucionComite.getImporteContraoferta().toString());
            						}
            					} catch (Exception e){
            						logger.error("error",e);
            					}
            				}
            			}
            		}
            	}
            }
        }
    }
    

    /** Obtiene el valor del elemento por nombre de la lista de valores
     * @param valores
     * @param nombre
     * @return
     */
    private String getValueFrom(List<TareaExternaValor> valores, String nombre) {
    	if (nombre != null){
	        for (TareaExternaValor valor : valores) {
	            if (nombre.equals(valor.getNombre())) { return valor.getValor(); }
	        }
    	}
        return null;
    }
    
    /**
     * Obtiene los valores que necesita un combo para configurarse a partir de
     * una businessoperation
     *
     * @param items
     */
    @SuppressWarnings({ "unused", "rawtypes" })
    private void obtenerValoresDeLosCombos(List<GenericFormItem> items) {
        List values;
        for (GenericFormItem item : items) {
            if (StringUtils.isNotBlank(item.getValuesBusinessOperation())) {
                values = dictionaryManager.getList(item.getValuesBusinessOperation());
            } else {
                values = new ArrayList();
            }
            item.setValues(values);
        }
    }
    
	private HashMap<String,String> getMapaEREtoRCO() {
		
		HashMap<String,String> mapa = new HashMap<String,String>();
		
		mapa.put(DDEstadoResolucion.CODIGO_ERE_APROBADA, DDResolucionComite.CODIGO_APRUEBA);
		mapa.put(DDEstadoResolucion.CODIGO_ERE_CONTRAOFERTA, DDResolucionComite.CODIGO_CONTRAOFERTA);
		mapa.put(DDEstadoResolucion.CODIGO_ERE_DENEGADA, DDResolucionComite.CODIGO_RECHAZA);
		
		return mapa;
	}
	
	@SuppressWarnings("unused")
	private HashMap<String,String> getMapaEREtoSiNo() {
		HashMap<String,String> mapa = new HashMap<String,String>();
		
		mapa.put(DDEstadoResolucion.CODIGO_ERE_APROBADA, DDSiNo.SI);
		mapa.put(DDEstadoResolucion.CODIGO_ERE_DENEGADA, DDSiNo.NO);
		
		return mapa;
	}
}
