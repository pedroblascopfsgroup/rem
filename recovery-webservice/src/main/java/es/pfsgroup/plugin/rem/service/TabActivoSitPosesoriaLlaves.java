package es.pfsgroup.plugin.rem.service;

import java.lang.reflect.InvocationTargetException;
import java.util.List;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.dto.WebDto;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.activo.dao.ActivoPatrimonioDao;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.impl.NotificatorServiceDesbloqExpCambioSitJuridica;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoPatrimonio;
import es.pfsgroup.plugin.rem.model.ActivoSituacionPosesoria;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoActivoSituacionPosesoria;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivoTPA;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloPosesorio;

@Component
public class TabActivoSitPosesoriaLlaves implements TabActivoService {

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private UtilDiccionarioApi diccionarioApi;
	
	@Autowired
	private ActivoPatrimonioDao activoPatrimonioDao;
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;    
    
	@Autowired
	private ActivoTramiteApi activoTramiteApi;
	
	@Autowired
	private ActivoAdapter activoAdapter;
	
	@Autowired
	private NotificatorServiceDesbloqExpCambioSitJuridica notificatorServiceDesbloqueoExpediente;
	
	
	@Autowired
	private ActivoApi activoApi;
	
	protected static final Log logger = LogFactory.getLog(TabActivoSitPosesoriaLlaves.class);
	

	
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
			BeanUtils.copyProperty(activoDto, "tieneOkTecnico", activo.getTieneOkTecnico());
		}
		
		if (activo.getSituacionPosesoria() != null) {
			
			//fecha toma posesion
			activoApi.calcularFechaTomaPosesion(activo);
			beanUtilNotNull.copyProperties(activoDto, activo.getSituacionPosesoria());
			
			if (activo.getSituacionPosesoria().getTipoTituloPosesorio() != null) {
				BeanUtils.copyProperty(activoDto, "tipoTituloPosesorioCodigo", activo.getSituacionPosesoria().getTipoTituloPosesorio().getCodigo());
			}
			
			if (activo.getSituacionPosesoria().getConTitulo() != null) {
				BeanUtils.copyProperty(activoDto, "conTituloTPA", activo.getSituacionPosesoria().getConTitulo().getCodigo());
			}
			
			if(!Checks.esNulo(activo.getCartera())) {
				if(DDCartera.CODIGO_CARTERA_BANKIA.equals(activo.getCartera().getCodigo())) {
					if(!Checks.esNulo(activo.getSituacionPosesoria().getSitaucionJuridica())) {
						BeanUtils.copyProperty(activoDto, "situacionJuridica", activo.getSituacionPosesoria().getSitaucionJuridica().getDescripcion());
						BeanUtils.copyProperty(activoDto, "indicaPosesion", activo.getSituacionPosesoria().getSitaucionJuridica().getIndicaPosesion());
					}					
				} else {
					if (!Checks.esNulo(activo.getSituacionPosesoria().getFechaRevisionEstado())
							|| !Checks.esNulo(activo.getSituacionPosesoria().getFechaTomaPosesion())) {
						BeanUtils.copyProperty(activoDto, "indicaPosesion", 1);
					} else {
						BeanUtils.copyProperty(activoDto, "indicaPosesion", 0);
					}
				}
			}
			
			ActivoPatrimonio activoP = activoPatrimonioDao.getActivoPatrimonioByActivo(activo.getId());
			 
			 if(!Checks.esNulo(activoP)) {
				 if (!Checks.esNulo(activoP.getTipoEstadoAlquiler())) {
					 activoDto.setTipoEstadoAlquiler(activoP.getTipoEstadoAlquiler().getCodigo());
					 
				 }
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
		

		// HREOS-2761: Buscamos los campos que pueden ser propagados para esta pestaña
		 activoDto.setCamposPropagables(TabActivoService.TAB_SIT_POSESORIA_LLAVES);
		
		return activoDto;
		
	}

	@Override
	public Activo saveTabActivo(Activo activo, WebDto webDto) {
	

		DtoActivoSituacionPosesoria dto = (DtoActivoSituacionPosesoria) webDto;
		
		try {
			
			
			beanUtilNotNull.copyProperties(activo.getSituacionPosesoria(), dto);			
			if (activo.getSituacionPosesoria() == null) {
				
				activo.setSituacionPosesoria(new ActivoSituacionPosesoria());
				activo.getSituacionPosesoria().setActivo(activo);
				
			}
			
			if (!Checks.esNulo(dto.getOcupado()) && !BooleanUtils.toBoolean(dto.getOcupado()) && dto.getOcupado() == 0) {
				activo.getSituacionPosesoria().setConTitulo(null);
			} else  if (Checks.esNulo(dto.getOcupado()) && !Checks.esNulo(dto.getConTituloTPA())) {
				if (!Checks.esNulo(activo.getSituacionPosesoria().getOcupado()) && activo.getSituacionPosesoria().getOcupado() == 1) {
					Filter tituloActivo = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getConTituloTPA());
					DDTipoTituloActivoTPA tituloActivoTPA = genericDao.get(DDTipoTituloActivoTPA.class, tituloActivo);
					activo.getSituacionPosesoria().setConTitulo(tituloActivoTPA);
				}
			}
			
			beanUtilNotNull.copyProperties(activo.getSituacionPosesoria(), dto);

			if(!Checks.esNulo(dto.getFechaTomaPosesion())){
				activo.getSituacionPosesoria().setEditadoFechaTomaPosesion(true);
			}
//			if(!Checks.esNulo(dto.getIndicaPosesion())){
//				activo.getSituacionPosesoria().getSitaucionJuridica().setIndicaPosesion(dto.getIndicaPosesion());
//			}
			
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
			if (!Checks.esNulo(dto.getTieneOkTecnico())){
				activo.setTieneOkTecnico(dto.getTieneOkTecnico());
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
		//Oferta oferta = ofertaApi.getOfertaAceptadaByActivo(activo);
		List<ActivoOferta> ofertas = activo.getOfertas();

		// Si ha cambiado la situacion juridica
		if (!Checks.esNulo(dtoSitPos.getFechaTomaPosesion()) 
					|| (!Checks.esNulo(dtoSitPos.getConTituloTPA()) &&	BooleanUtils.toBoolean(dtoSitPos.getConTituloTPA()))) {
		
			for(ActivoOferta oferta : ofertas){
				// Si tiene expediente 
				if(!Checks.esNulo(oferta)) {
					ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(oferta.getPrimaryKey().getOferta().getId());
					
					if(!Checks.esNulo(expediente)){
						// Si esta bloqueado, lo desbloqueamos y notificamos
						if(!Checks.esNulo(expediente.getBloqueado()) && BooleanUtils.toBoolean(expediente.getBloqueado())) {
							
							expediente.setBloqueado(0);					
							genericDao.save(ExpedienteComercial.class, expediente);
							
							List<ActivoTramite> tramites = activoTramiteApi.getTramitesActivoTrabajoList(expediente.getTrabajo().getId());	
							if(!Checks.estaVacio(tramites)) {					
								notificatorServiceDesbloqueoExpediente.notificator(tramites.get(0));
							}
							/// sino, solamente avisamos
						} else {
							
							activoAdapter.enviarAvisosCambioSituacionLegalActivo(activo, expediente);					
						}
					}
				}
			}
		}		
		
	}
	
	

}
