package es.pfsgroup.plugin.rem.jbpm.handler.updater.impl;

import es.capgemini.devon.message.MessageService;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.procesosJudiciales.model.DDSiNo;
import es.capgemini.pfs.procesosJudiciales.model.TareaExterna;
import es.capgemini.pfs.procesosJudiciales.model.TareaExternaValor;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoEstadoPublicacionApi;
import es.pfsgroup.plugin.rem.jbpm.handler.updater.UpdaterService;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoEstadosInformeComercialHistorico;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoInformeComercial;
import es.pfsgroup.plugin.rem.model.dd.DDTipoActivo;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import javax.annotation.Resource;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Component
public class UpdaterServiceAprobacionInformeComercialAPCorreccionDatos implements UpdaterService {

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
        
    
    private static final String COMBO_ACEPTACION = "comboAceptacion";
	private static final String MOTIVO_DENEGACION = "motivoRechazo";
	
	private static final String CODIGO_T011_AP_CORRECCION = "T011_AnalisisPeticionCorreccion";

	SimpleDateFormat ft = new SimpleDateFormat("yyyy-MM-dd");
	
	public void saveValues(ActivoTramite tramite, TareaExterna tareaExternaActual, List<TareaExternaValor> valores) {
		ActivoEstadosInformeComercialHistorico activoEstadosInformeComercialHistorico = new ActivoEstadosInformeComercialHistorico();
		Filter estadoInformeComercialFilter;
		Activo activo = tramite.getActivo();
		ArrayList<Long> idActivoActualizarPublicacion = new ArrayList<Long>();

		//Se asocia el activo al historico
		if(!Checks.esNulo(activo))
			activoEstadosInformeComercialHistorico.setActivo(activo);

		for(TareaExternaValor valor :  valores){
			if(COMBO_ACEPTACION.equals(valor.getNombre())){
				if(DDSiNo.NO.equals(valor.getValor())){
					// En caso de que se deniegue se prepara un historico estado rechazado con fecha rechazo y motivo
					estadoInformeComercialFilter = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoInformeComercial.ESTADO_INFORME_COMERCIAL_RECHAZO);
					activoEstadosInformeComercialHistorico.setEstadoInformeComercial(genericDao.get(DDEstadoInformeComercial.class, estadoInformeComercialFilter));
					activoEstadosInformeComercialHistorico.setFecha(new Date());
					activo.getInfoComercial().setFechaRechazo(new Date());
					activo.getInfoComercial().setFechaAceptacion(null);

				} else {
					// 0.) En caso de que se acepte se prepara un historico estado aceptado con fecha aceptado
					estadoInformeComercialFilter = genericDao.createFilter(FilterType.EQUALS, "codigo", DDEstadoInformeComercial.ESTADO_INFORME_COMERCIAL_ACEPTACION);
					activoEstadosInformeComercialHistorico.setEstadoInformeComercial(genericDao.get(DDEstadoInformeComercial.class, estadoInformeComercialFilter));
					activoEstadosInformeComercialHistorico.setFecha(new Date());
					activo.getInfoComercial().setFechaAceptacion(new Date());
					activo.getInfoComercial().setFechaRechazo(null);

					// 1.) Se realiza una comprobación que verifique si el activo YA esta publicado.
					//     Si está publicado, NO se vuelven a realizar las operaciones de publicación.
					//     Se deja todo como esta y se avanza la tarea.
					//     Esto evita provocar la excepción al llamar al procedure y por tanto bloquear la tarea por estar publicado.
					if (!activoEstadoPublicacionApi.isPublicadoVentaByIdActivo(activo.getId())) {
						// 2.) Se marca activo como publicable, por que en el trámite se han cumplido todos los requisitos.
						activo.setFechaPublicable(new Date());
						activoApi.saveOrUpdate(activo);

						// 3.) Actualizar estado publicación del activo.
						//activoAdapter.actualizarEstadoPublicacionActivo(activo.getId());
						idActivoActualizarPublicacion.add(activo.getId());
					}
				}
			}

			if(MOTIVO_DENEGACION.equals(valor.getNombre()) && !Checks.esNulo(valor.getValor())){
				//Motivo de denegación (o rechazo) del cambio de tipologia del activo
				if(!Checks.esNulo(activoEstadosInformeComercialHistorico) && !Checks.esNulo(valor.getValor()))
					activoEstadosInformeComercialHistorico.setMotivo(valor.getValor());
			}
		}

		//Si han habido cambios en el historico, lo persistimos.
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
		
		activoAdapter.actualizarEstadoPublicacionActivo(idActivoActualizarPublicacion,true);
		
		if(!Checks.esNulo(activo) && !Checks.esNulo(activo.getTipoActivo()) && DDTipoActivo.COD_VIVIENDA.equals(activo.getTipoActivo().getCodigo())
				&& !Checks.esNulo(activo.getInfoComercial()) && !Checks.esNulo(activo.getInfoComercial().getFechaAceptacion())){
			activoApi.calcularRatingActivo(activo.getId());
		}
	}


	public String[] getCodigoTarea() {
		return new String[]{CODIGO_T011_AP_CORRECCION};
	}

	public String[] getKeys() {
		return this.getCodigoTarea();
	}

}
