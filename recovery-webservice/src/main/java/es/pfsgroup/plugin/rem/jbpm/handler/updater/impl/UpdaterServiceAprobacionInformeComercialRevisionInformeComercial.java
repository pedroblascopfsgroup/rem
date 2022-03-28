package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.message.MessageService;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.activo.publicacion.dao.HistoricoFasePublicacionActivoDao;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoEstadoPublicacionApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoEstadosInformeComercialHistorico;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.HistoricoFasePublicacionActivo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoInformeComercial;
import es.pfsgroup.plugin.rem.model.dd.DDFasePublicacion;
import es.pfsgroup.plugin.rem.model.dd.DDSubfasePublicacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;
import es.pfsgroup.plugin.rem.notificacion.NotificationActivoManager;

@Component
public class UpdaterServiceAprobacionInformeComercialRevisionInformeComercial implements UpdaterService {

    @Autowired
    private GenericABMDao genericDao;

    @Autowired
    private GenericAdapter genericAdapter;
    
    @Autowired
    private ActivoApi activoApi;
    
    @Autowired
	private ActivoAdapter activoAdapter;
    
    @Autowired
    private ActivoEstadoPublicacionApi activoEstadoPublicacionApi;
    
    @Resource
    private MessageService messageService;
    
   @Autowired
   private HistoricoFasePublicacionActivoDao historicoFasePublicacionActivoDao;
   
   @Autowired
   private NotificationActivoManager notificationActivoManager;
    
    
    private static final String COMBO_ACEPTACION = "comboAceptacion";
	private static final String MOTIVO_DENEGACION = "motivoDenegacion";
	
	private static final String CODIGO_T011_REVISION_IC = "T011_RevisionInformeComercial";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {

		ActivoEstadosInformeComercialHistorico activoEstadosInformeComercialHistorico = new ActivoEstadosInformeComercialHistorico();
		Filter estadoInformeComercialFilter;
		boolean checkAcepta = false;
		boolean checkContinuaProceso = false;
		String motivoDenegacion = new String();

		
		Activo activo = tramite.getActivo();
		
		// Recoge todos los valores de la tarea porque el proceso esta condicionado a valores entre si
		for(TareaExternaValor valor :  valores){

			if(COMBO_ACEPTACION.equals(valor.getNombre())){				
				if(DDSiNo.SI.equals(valor.getValor()))
					checkAcepta = true;				
			}
			
			if(MOTIVO_DENEGACION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())){
				//Motivo de denegación (o rechazo) del cambio de tipologia del activo
				if(!Checks.esNulo(valor.getValor()))
					motivoDenegacion = valor.getValor();
			}
		}

		// Acepta / Rechaza el I.C.
		HistoricoFasePublicacionActivo histFasePub = historicoFasePublicacionActivoDao.getHistoricoFasesPublicacionActivoActualById(activo.getId());

		Filter faseFiltro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDFasePublicacion.CODIGO_FASE_III_PENDIENTE_INFORMACION);
		DDFasePublicacion faseTres = genericDao.get(DDFasePublicacion.class, faseFiltro);
		
		if(checkAcepta){
			
			//Si acepta el informe comercial, hay que cambiar el informe comercial, aunque no se continue con el proceso de publicación.
			// Consideracion de datos iguales entre activo e I.C.
			if(!activoApi.checkTiposDistintos(activo)){
				// Iguales :------------
				// 1.) Se acepta I.C.
				estadoInformeComercialFilter = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoInformeComercial.ESTADO_INFORME_COMERCIAL_ACEPTACION);
				activoEstadosInformeComercialHistorico.setEstadoInformeComercial(genericDao.get(DDEstadoInformeComercial.class, estadoInformeComercialFilter));
				Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
				String personaLogada = usuarioLogado.getNombre() + " " + usuarioLogado.getApellidos();
				activoEstadosInformeComercialHistorico.setResponsableCambio(personaLogada);
				activoEstadosInformeComercialHistorico.setFecha(new Date());
				activo.getInfoComercial().setFechaAceptacion(new Date());
				activo.getInfoComercial().setFechaRechazo(null);
				
				// Si continua con proceso publicacion
				if(checkContinuaProceso){
					
					// 2.) Se realiza una comprobacion que verifique si el activo YA esta publicado.
					//     Si esta publicado, NO se vuelven a realizar las operaciones de publicacion.
					//     Se deja todo como esta y se avanza la tarea normalmente. 
					//     Esto evita provocar la excepcion al llamar al procedure y por tanto bloquear la tarea por estar publicado.
					
					if(!activoEstadoPublicacionApi.isPublicadoVentaByIdActivo(activo.getId())) {
						// 3.) Se marca activo como publicable, porque en el tramite se han cumplido todos los requisitos
						activo.setFechaPublicable(new Date());
						activoApi.saveOrUpdate(activo);

						//Comprobamos que tenga precio para publicar
						if(activoApi.getDptoPrecio(activo)){
							// 3.) Se publica el activo, quitando la validacion de Informe Comercial, puesto que se ha aceptado antes
							//activoEstadoPublicacionApi.validarPublicacionTramiteYPublicar(activo.getId());
						}
					}
				} else {
					// Si NO continua con proceso publicacion, no se cambian datos
				}
			} else {
				// Distintos :----------
				// No se cambian datos, se lanza siguiente tarea de correccion I.C.
			}
			
			//cambiamos de fase
			
		}else{
				// Ha rechazado I.C.
				estadoInformeComercialFilter = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoInformeComercial.ESTADO_INFORME_COMERCIAL_RECHAZO);
				activoEstadosInformeComercialHistorico.setEstadoInformeComercial(genericDao.get(DDEstadoInformeComercial.class, estadoInformeComercialFilter));
				Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
				String personaLogada = usuarioLogado.getNombre() + " " + usuarioLogado.getApellidos();
				activoEstadosInformeComercialHistorico.setResponsableCambio(personaLogada);
				activoEstadosInformeComercialHistorico.setFecha(new Date());
				activoEstadosInformeComercialHistorico.setMotivo(motivoDenegacion);
				activo.getInfoComercial().setFechaRechazo(new Date());
				activo.getInfoComercial().setFechaAceptacion(null);
					
				// El tramite NO puede des-publicar activos, solo sirve para publicar
				// activo.setFechaPublicable(null);
				
				// Se termina el tramite
				
				//SE ENVIA CORREO NOTIFICACION
				
				
				if(!Checks.esNulo(activo)) {
					String asunto = "Revisar el informe comercial enviado del activo "+activo.getNumActivo();
					String cuerpo = "";
					ArrayList<String> mailsPara = new ArrayList<String>();
					ArrayList<String> mailsCC = new ArrayList<String>();
					if(!Checks.esNulo(histFasePub)) {
						if(!(DDFasePublicacion.CODIGO_FASE_III_PENDIENTE_INFORMACION.equals(histFasePub.getFasePublicacion().getCodigo()))){
							histFasePub.setFechaFin(new Date());
							genericDao.save(HistoricoFasePublicacionActivo.class, histFasePub);
							
							HistoricoFasePublicacionActivo nuevaFase = new HistoricoFasePublicacionActivo();
							Filter subfaseFiltro = genericDao.createFilter(FilterType.EQUALS, "codigo", DDSubfasePublicacion.CODIGO_DEVUELTO);
							DDSubfasePublicacion subfaseDevuelto = genericDao.get(DDSubfasePublicacion.class, subfaseFiltro);
							
							nuevaFase.setActivo(activo);
							nuevaFase.setUsuario(genericAdapter.getUsuarioLogado());
							nuevaFase.setFasePublicacion(faseTres);
							nuevaFase.setSubFasePublicacion(subfaseDevuelto);
							nuevaFase.setFechaInicio(new Date());
							
							genericDao.save(HistoricoFasePublicacionActivo.class, nuevaFase);
						}
						
						cuerpo = String.format("El informe comercial correspondiente al activo "+activo.getNumActivo()
						+" ha sido rechazado, por lo que, rogamos que lo revise, y realice las modificaciones necesarias para subsanarlo. Posteriormente, proceda de nuevo a su envío.");
						
						if(!Checks.esNulo(activo.getInfoComercial()) 
								&& !Checks.esNulo(activo.getInfoComercial().getMediadorInforme())) {
							mailsPara.add(activo.getInfoComercial().getMediadorInforme().getEmail());
						}
						
						if(!Checks.estaVacio(mailsPara) || !Checks.estaVacio(mailsCC)) {
							notificationActivoManager.sendMailFasePublicacion(activo, asunto,cuerpo,mailsPara,mailsCC);
						}
					}
				}
		}
		
		
		//Si han habido cambios en el historico, los persistimos.
		if(!Checks.esNulo(activoEstadosInformeComercialHistorico) && !Checks.esNulo(activoEstadosInformeComercialHistorico.getEstadoInformeComercial())){
			if(Checks.esNulo(activoEstadosInformeComercialHistorico.getAuditoria())){
				Auditoria auditoria = new Auditoria();
				auditoria.setUsuarioCrear(genericAdapter.getUsuarioLogado().getUsername());
				auditoria.setFechaCrear(new Date());
				activoEstadosInformeComercialHistorico.setAuditoria(auditoria);
			}else{
				activoEstadosInformeComercialHistorico.getAuditoria().setUsuarioCrear(genericAdapter.getUsuarioLogado().getUsername());
				activoEstadosInformeComercialHistorico.getAuditoria().setFechaCrear(new Date());
			}
			activoEstadosInformeComercialHistorico.setActivo(activo);
			genericDao.save(ActivoEstadosInformeComercialHistorico.class, activoEstadosInformeComercialHistorico);
		}
		
		//Si han habido cambios en el activo, lo persistimos
		if(!Checks.esNulo(activo)){
			//actualizamos el informemediador para que se envie el cambio de estado
			if(!Checks.esNulo(activo.getInfoComercial())){
				activo.getInfoComercial().getAuditoria().setFechaModificar(new Date());
				if(!Checks.esNulo(genericAdapter.getUsuarioLogado())){
					activo.getInfoComercial().getAuditoria().setUsuarioModificar(genericAdapter.getUsuarioLogado().getUsername());
				}
			}
			
			activoApi.saveOrUpdate(activo);
		}
		
		
		activoAdapter.actualizarEstadoPublicacionActivo(activo.getId());
		
		if(!Checks.esNulo(activo) && !Checks.esNulo(activo.getTipoActivo()) && DDTipoActivo.COD_VIVIENDA.equals(activo.getTipoActivo().getCodigo())
				&& !Checks.esNulo(activo.getInfoComercial()) && !Checks.esNulo(activo.getInfoComercial().getFechaAceptacion())){
			activoApi.calcularRatingActivo(activo.getId());
		}
	}

	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T011_REVISION_IC};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
