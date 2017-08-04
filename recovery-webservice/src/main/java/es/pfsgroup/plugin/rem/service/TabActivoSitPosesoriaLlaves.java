package es.pfsgroup.plugin.rem.service;

import java.lang.reflect.InvocationTargetException;
import java.text.ParseException;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.devon.message.MessageService;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.framework.paradise.agenda.adapter.NotificacionAdapter;
import es.pfsgroup.framework.paradise.agenda.model.Notificacion;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.gestor.GestorExpedienteComercialManager;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoSituacionPosesoria;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoActivoSituacionPosesoria;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.TareaActivo;
import es.pfsgroup.plugin.rem.model.dd.DDEstadosExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloPosesorio;

@Component
public class TabActivoSitPosesoriaLlaves implements TabActivoService {

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private UtilDiccionarioApi diccionarioApi;
	
	@Autowired
	private OfertaApi ofertaApi;
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
    @Autowired
    private NotificacionAdapter notificacionAdapter;
    
    @Autowired 
    private GestorExpedienteComercialManager gestorExpedienteComercialManager;
    
	@Autowired
	private ActivoTramiteApi activoTramiteApi;
	
	@Autowired
	private GenericAdapter genericAdapter;   	
	
	@Resource
    MessageService messageServices;
	
	
	
	protected static final Log logger = LogFactory.getLog(TabActivoSitPosesoriaLlaves.class);
	
	public static final String AVISO_TITULO_MODIFICADAS_CONDICIONES_JURIDICAS = "activo.aviso.titulo.modificadas.condiciones.juridicas";
	public static final String AVISO_DESCRIPCION_MODIFICADAS_CONDICIONES_JURIDICAS = "activo.aviso.descripcion.modificadas.condiciones.juridicas";
	
	
	
	
	@Override
	public String[] getKeys() {
		return this.getCodigoTab();
	}

	@Override
	public String[] getCodigoTab() {
		return new String[]{TabActivoService.TAB_SIT_POSESORIA_LLAVES};
	}
	
	
	public DtoActivoSituacionPosesoria getTabData(Activo activo) throws IllegalAccessException, InvocationTargetException {

		DtoActivoSituacionPosesoria activoDto = new DtoActivoSituacionPosesoria();
		if (activo != null){
			BeanUtils.copyProperty(activoDto, "necesarias", activo.getLlavesNecesarias());
			BeanUtils.copyProperty(activoDto, "llaveHre", activo.getLlavesHre());
			BeanUtils.copyProperty(activoDto, "fechaRecepcionLlave", activo.getFechaRecepcionLlaves());
			BeanUtils.copyProperty(activoDto, "numJuegos", activo.getLlaves().size());
		}
		
		if (activo.getSituacionPosesoria() != null) {
			beanUtilNotNull.copyProperties(activoDto, activo.getSituacionPosesoria());
			if (activo.getSituacionPosesoria().getTipoTituloPosesorio() != null) {
				BeanUtils.copyProperty(activoDto, "tipoTituloPosesorioCodigo", activo.getSituacionPosesoria().getTipoTituloPosesorio().getCodigo());
			}
		}
		/*
		//Añadir al DTO los atributos de llaves también
		
		if (activo.getLlaves() != null) {
			for (int i = 0; i < activo.getLlaves().size(); i++)
			{
				try {

					ActivoLlave llave = activo.getLlaves().get(i);	
					BeanUtils.copyProperties(activoDto, llave);
				}
				catch (Exception e) {
					e.printStackTrace();
					return null;
				}
			}
		}*/
		
		return activoDto;
		
	}

	@Override
	public Activo saveTabActivo(Activo activo, WebDto webDto) {
	

		DtoActivoSituacionPosesoria dto = (DtoActivoSituacionPosesoria) webDto;
		
		try {
						
			if (activo.getSituacionPosesoria() == null) {
				
				activo.setSituacionPosesoria(new ActivoSituacionPosesoria());
				activo.getSituacionPosesoria().setActivo(activo);
				
			}
			
			if(!Checks.esNulo(dto.getOcupado()) && !BooleanUtils.toBoolean(dto.getOcupado())) {				
				dto.setConTitulo(null);				
			}
				
			beanUtilNotNull.copyProperties(activo.getSituacionPosesoria(), dto);
			
			activo.setSituacionPosesoria(genericDao.save(ActivoSituacionPosesoria.class, activo.getSituacionPosesoria()));
			
			if (dto.getTipoTituloPosesorioCodigo() != null) {
				
				DDTipoTituloPosesorio tipoTitulo = (DDTipoTituloPosesorio) 
						diccionarioApi.dameValorDiccionario(DDTipoTituloPosesorio.class,  new Long(dto.getTipoTituloPosesorioCodigo()));
	
				activo.getSituacionPosesoria().setTipoTituloPosesorio(tipoTitulo);
				
			}

			if (dto.getNecesarias()!=null)
			{
				activo.setLlavesNecesarias(dto.getNecesarias());
			}
			if (dto.getLlaveHre()!=null)
			{
				activo.setLlavesHre(dto.getLlaveHre());
			}
			
			if (dto.getFechaRecepcionLlave()!=null)
			{
				activo.setFechaRecepcionLlaves(dto.getFechaRecepcionLlave());
			}
			if (dto.getNumJuegos()!=null)
			{
				activo.setNumJuegosLlaves(Integer.valueOf(dto.getNumJuegos()));
			}

		} catch (IllegalAccessException e) {
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			e.printStackTrace();
		}
		
		return activo;
	}
	
	public void afterSaveTabActivo(Activo activo, WebDto dto) {
		
		DtoActivoSituacionPosesoria dtoSitPos = (DtoActivoSituacionPosesoria) dto;
		Oferta oferta = ofertaApi.getOfertaAceptadaByActivo(activo);
		Usuario destinatario = null;
		
		// Si el activo está asociado a un expediente, y si ha cambiado la fecha de posesión, o el activo pasa a estar ocupado con titulo
		if(!Checks.esNulo(oferta) && (!Checks.esNulo(dtoSitPos.getFechaTomaPosesion()) 
				|| (!Checks.esNulo(dtoSitPos.getConTitulo()) &&	BooleanUtils.toBoolean(dtoSitPos.getConTitulo())))) {
			
					ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(oferta.getId());
					
					// Buscamos el gestor responsable de Haya
					List<ActivoTramite> tramites = activoTramiteApi.getTramitesActivoTrabajoList(expediente.getTrabajo().getId());						
					
					for(TareaActivo tarea: tramites.get(0).getTareas()) {
						
						if(!tarea.getAuditoria().isBorrado() && Checks.esNulo(tarea.getFechaFin())
								&& genericAdapter.isGestorHaya(tarea.getUsuario())) {

							if(Checks.esNulo(destinatario)) {
								destinatario = tarea.getUsuario();
							}
														
						}
					}

					if (!Checks.esNulo(destinatario)) {														
						
						enviarNotificacionCambioSituacionLegalActivo(destinatario, activo);
					}
												
					// Si expediente ya ha sido aprobado avisamos al gestor de formalización
					if (DDEstadosExpedienteComercial.APROBADO.equals(expediente.getEstado().getCodigo())
							|| DDEstadosExpedienteComercial.RESERVADO.equals(expediente.getEstado().getCodigo())
							|| DDEstadosExpedienteComercial.VENDIDO.equals(expediente.getEstado().getCodigo())
							|| DDEstadosExpedienteComercial.ALQUILADO.equals(expediente.getEstado().getCodigo())
							|| DDEstadosExpedienteComercial.EN_DEVOLUCION.equals(expediente.getEstado().getCodigo())
							|| DDEstadosExpedienteComercial.BLOQUEO_ADM.equals(expediente.getEstado().getCodigo())) {
						
						Usuario gestorFormalizacion = gestorExpedienteComercialManager.getGestorByExpedienteComercialYTipo(expediente, "GFORM");
						
						if(!Checks.esNulo(gestorFormalizacion) && !gestorFormalizacion.equals(destinatario)) {
					
							enviarNotificacionCambioSituacionLegalActivo(gestorFormalizacion, activo);
						}
					}
			}
		
		
	}
	
	private void enviarNotificacionCambioSituacionLegalActivo(Usuario usuario, Activo activo) {
		
		Notificacion notificacion = new Notificacion();
		
		notificacion.setIdActivo(activo.getId());	
		
		String[] numActivo = {String.valueOf(activo.getNumActivo())};
		notificacion.setDescripcion(messageServices.getMessage(AVISO_DESCRIPCION_MODIFICADAS_CONDICIONES_JURIDICAS, numActivo));
		
		notificacion.setTitulo(messageServices.getMessage(AVISO_TITULO_MODIFICADAS_CONDICIONES_JURIDICAS));		
		notificacion.setDestinatario(usuario.getId());									
		
		try {
			
			notificacionAdapter.saveNotificacion(notificacion);
			logger.debug("ENVIO NOTIFICACION: [TITULO " + notificacion.getTitulo() + " | ACTIVO " + activo.getNumActivo() + "| DESTINATARIO " + usuario.getUsername() + " ]");
			
		} catch (ParseException e) {
				logger.error(e.getMessage());
		}
		
		
	}

}
