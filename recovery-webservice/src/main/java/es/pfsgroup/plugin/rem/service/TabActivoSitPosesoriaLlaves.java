package es.pfsgroup.plugin.rem.service;

import java.lang.reflect.InvocationTargetException;
import java.util.Date;
import java.util.List;

import es.pfsgroup.plugin.rem.alaskaComunicacion.AlaskaComunicacionManager;
import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.lang.BooleanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import es.capgemini.devon.dto.WebDto;
import es.capgemini.pfs.users.UsuarioManager;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.api.ApiProxyFactory;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.activo.dao.ActivoDao;
import es.pfsgroup.plugin.rem.activo.dao.ActivoPatrimonioDao;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.jbpm.handler.notificator.impl.NotificatorServiceDesbloqExpCambioSitJuridica;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoCaixa;
import es.pfsgroup.plugin.rem.model.ActivoLlave;
import es.pfsgroup.plugin.rem.model.ActivoOferta;
import es.pfsgroup.plugin.rem.model.ActivoPatrimonio;
import es.pfsgroup.plugin.rem.model.ActivoSituacionPosesoria;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.DtoActivoSituacionPosesoria;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.HistoricoOcupadoTitulo;
import es.pfsgroup.plugin.rem.model.dd.DDCartera;
import es.pfsgroup.plugin.rem.model.dd.DDCesionSaneamiento;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoTecnicoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDServicerActivo;
import es.pfsgroup.plugin.rem.model.dd.DDSubcartera;
import es.pfsgroup.plugin.rem.model.dd.DDTipoEstadoAlquiler;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloActivoTPA;
import es.pfsgroup.plugin.rem.model.dd.DDTipoTituloPosesorio;
import es.pfsgroup.plugin.rem.thread.ConvivenciaAlaska;
import es.pfsgroup.plugin.rem.updaterstate.UpdaterStateApi;
import es.pfsgroup.recovery.api.UsuarioApi;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;
import org.springframework.ui.ModelMap;

import javax.annotation.Resource;

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
	private ActivoDao activoDao;
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private UpdaterStateApi updaterState;

	@Autowired
	private AlaskaComunicacionManager alaskaComunicacionManager;
	
	@Autowired
	private UsuarioManager usuarioManager;

	@Resource(name = "entityTransactionManager")
	private PlatformTransactionManager transactionManager;
	
	@Autowired
	private ApiProxyFactory proxyFactory;
	
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
			BeanUtils.copyProperty(activoDto, "fechaPrimerAnillado", activo.getFechaRecepcionLlaves());
			BeanUtils.copyProperty(activoDto, "numJuegos", activo.getLlaves().size());
			BeanUtils.copyProperty(activoDto, "tieneOkTecnico", activo.getTieneOkTecnico());
		}
		
		if (activo.getSituacionPosesoria() != null) {
			
			//fecha toma posesion
			activoApi.calcularFechaTomaPosesion(activo);
			beanUtilNotNull.copyProperties(activoDto, activo.getSituacionPosesoria());
			
			if (!Checks.esNulo(activo.getSituacionPosesoria().getTipoTituloPosesorio())) {
				BeanUtils.copyProperty(activoDto, "tipoTituloPosesorioCodigo", activo.getSituacionPosesoria().getTipoTituloPosesorio().getCodigo());
			}
			
			if(DDCartera.CODIGO_CARTERA_BANKIA.equals(activo.getCartera().getCodigo())){
				
				if(!Checks.esNulo(activo.getSituacionPosesoria().getFechaUltCambioTapiado())) {
					activoDto.setDiasTapiado(calculodiasCambiosActivo(activo.getSituacionPosesoria().getFechaUltCambioTapiado()));
				}
			}
			
			if (!Checks.esNulo(activo.getSituacionPosesoria().getConTitulo())) {
				BeanUtils.copyProperty(activoDto, "conTituloCodigo", activo.getSituacionPosesoria().getConTitulo().getCodigo());
				BeanUtils.copyProperty(activoDto, "conTituloDescripcion", activo.getSituacionPosesoria().getConTitulo().getDescripcion());
				
				if(DDCartera.CODIGO_CARTERA_BANKIA.equals(activo.getCartera().getCodigo())){
					if(!Checks.esNulo(activo.getSituacionPosesoria().getFechaUltCambioTit())) {
						activoDto.setDiasCambioTitulo(calculodiasCambiosActivo(activo.getSituacionPosesoria().getFechaUltCambioTit()));
					}
				}
			}
			
			if(!Checks.esNulo(activo.getCartera())) {
				if(DDCartera.CODIGO_CARTERA_BANKIA.equals(activo.getCartera().getCodigo())) {
					if(!Checks.esNulo(activo.getSituacionPosesoria().getSitaucionJuridica())) {
						BeanUtils.copyProperty(activoDto, "situacionJuridica", activo.getSituacionPosesoria().getSitaucionJuridica().getDescripcion());
						BeanUtils.copyProperty(activoDto, "indicaPosesion", activo.getSituacionPosesoria().getSitaucionJuridica().getIndicaPosesion());
						
						if(!Checks.esNulo(activo.getSituacionPosesoria().getFechaUltCambioPos())) {
							activoDto.setDiasCambioPosesion(calculodiasCambiosActivo(activo.getSituacionPosesoria().getFechaUltCambioPos()));
						}
					}					
				} else if(DDCartera.CODIGO_CARTERA_CERBERUS.equals(activo.getCartera().getCodigo()) && 
						(DDSubcartera.CODIGO_APPLE_INMOBILIARIO.equals(activo.getSubcartera().getCodigo())
						||DDSubcartera.CODIGO_DIVARIAN_ARROW_INMB.equals(activo.getSubcartera().getCodigo())
						||DDSubcartera.CODIGO_DIVARIAN_REMAINING_INMB.equals(activo.getSubcartera().getCodigo()))
						||DDCartera.CODIGO_CARTERA_SAREB.equals(activo.getCartera().getCodigo()) &&
						activo.getAdjNoJudicial() != null) {
					if (activo.getAdjNoJudicial().getFechaPosesion() != null) {
						BeanUtils.copyProperty(activoDto, "indicaPosesion", 1);
					}else {
						BeanUtils.copyProperty(activoDto, "indicaPosesion", 0);
						}	
					}
					else{
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
			 
			 if(activo.getSituacionPosesoria()!=null) {
				 //TAPIADO
				 if(activo.getSituacionPosesoria().getAccesoTapiado()!=null) {
					 activoDto.setAccesoTapiado(activo.getSituacionPosesoria().getAccesoTapiado());
				 }
				 if(activo.getSituacionPosesoria().getFechaAccesoTapiado()!=null) {
					 activoDto.setFechaAccesoTapiado(activo.getSituacionPosesoria().getFechaAccesoTapiado());
				 }
				 //ANTIOCUPA
				 if(activo.getSituacionPosesoria().getAccesoAntiocupa()!=null) {
					 activoDto.setAccesoAntiocupa(activo.getSituacionPosesoria().getAccesoAntiocupa());
				 }
				 if(activo.getSituacionPosesoria().getFechaAccesoAntiocupa()!=null) {
					 activoDto.setFechaAccesoAntiocupa(activo.getSituacionPosesoria().getFechaAccesoAntiocupa());
				 }
				 
				 //ALARMA
				 if(activo.getSituacionPosesoria().getConAlarma()!=null) {
					 activoDto.setTieneAlarma(activo.getSituacionPosesoria().getConAlarma());
				 }
				 if(activo.getSituacionPosesoria().getFechaInstalacionAlarma()!=null) {
					 activoDto.setFechaInstalacionAlarma(activo.getSituacionPosesoria().getFechaInstalacionAlarma());
				 }
				 if(activo.getSituacionPosesoria().getFechaDesinstalacionAlarma()!=null) {
					 activoDto.setFechaDesinstalacionAlarma(activo.getSituacionPosesoria().getFechaDesinstalacionAlarma());
				 }				 
				 //VIGILANCIA
				 
				 if(activo.getSituacionPosesoria().getConVigilancia()!=null) {
					 activoDto.setTieneVigilancia(activo.getSituacionPosesoria().getConVigilancia());
				 }
				 if(activo.getSituacionPosesoria().getFechaInstalacionVigilancia()!=null) {
					 activoDto.setFechaInstalacionVigilancia(activo.getSituacionPosesoria().getFechaInstalacionVigilancia());
				 }
				 if(activo.getSituacionPosesoria().getFechaDesinstalacionVigilancia()!=null) {
					 activoDto.setFechaDesinstalacionVigilancia(activo.getSituacionPosesoria().getFechaDesinstalacionVigilancia());
				 }
				 
			 }
		}
		
		Filter filtroFechaNotNull = genericDao.createFilter(FilterType.NOTNULL, "fechaRecepcion");
		Filter filtro = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
		Order order = new Order(OrderType.DESC,"fechaRecepcion");
		List<ActivoLlave> lista = genericDao.getListOrdered(ActivoLlave.class , order, filtro, filtroFechaNotNull);
		if (lista != null && !lista.isEmpty() && lista.get(0) != null) {
			activoDto.setFechaRecepcionLlave(lista.get(0).getFechaRecepcion());
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
		if(!Checks.esNulo(activo) && activoDao.isActivoMatriz(activo.getId())) {	
			activoDto.setCamposPropagablesUas(TabActivoService.TAB_SIT_POSESORIA_LLAVES);
		}else {
			// Buscamos los campos que pueden ser propagados para esta pestaña
			activoDto.setCamposPropagables(TabActivoService.TAB_SIT_POSESORIA_LLAVES);
		}
		if(activo.getSituacionPosesoria()!=null && activo.getSituacionPosesoria().getSpsPosesionNeg()!=null) {		
		activoDto.setPosesionNegociada(activo.getSituacionPosesoria().getSpsPosesionNeg() ? "1" : "0");
		}
		
		if(activo.getSituacionPosesoria().getSpsPosesionNeg() != null)
			activoDto.setPosesionNegociada(activo.getSituacionPosesoria().getSpsPosesionNeg() ? "1" : "0");
		
		if (activo != null && activo.getId() != null ) {
			activoDto.setPerteneceActivoREAM(activoDao.perteneceActivoREAM(activo.getId()));
		}
		
		if (activo != null) {
			ActivoCaixa actCaixa = genericDao.get(ActivoCaixa.class, genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId()));
			if (actCaixa != null) {
				if (actCaixa.getNecesariaFuerzaPublica() != null) {
					activoDto.setNecesariaFuerzaPublica(actCaixa.getNecesariaFuerzaPublica() ? "1" : "0");
				}
			}
		}
			
		Filter filtroCaixa = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
		ActivoCaixa activoCaixa = genericDao.get(ActivoCaixa.class, filtroCaixa);
		
		if (activoCaixa != null) {
			if (activoCaixa.getEstadoTecnico() != null) {
				activoDto.setEstadoTecnicoCodigo(activoCaixa.getEstadoTecnico().getCodigo());
				activoDto.setEstadoTecnicoDescripcion(activoCaixa.getEstadoTecnico().getDescripcion());
			}
			
			if (activoCaixa.getFechaEstadoTecnico() != null) {
				activoDto.setFechaEstadoTecnico(activoCaixa.getFechaEstadoTecnico());
			}
		}
		
		ActivoSituacionPosesoria activoSitPosesoria = genericDao.get(ActivoSituacionPosesoria.class, filtroCaixa);
		if (activoSitPosesoria != null) {
				activoDto.setVertical(activoSitPosesoria.getVertical());			
		}
	
		return activoDto;
		
	}

	@Override
	public Activo saveTabActivo(Activo activo, WebDto webDto) {
		
		TransactionStatus transaction = transactionManager.getTransaction(new DefaultTransactionDefinition());
	
		DtoActivoSituacionPosesoria dto = (DtoActivoSituacionPosesoria) webDto;
		ActivoSituacionPosesoria activoSituacionPosesoria = activo.getSituacionPosesoria();

		if (activoSituacionPosesoria == null) {
			activo.setSituacionPosesoria(new ActivoSituacionPosesoria());
			activo.getSituacionPosesoria().setActivo(activo);
		}
		
		if(activoSituacionPosesoria != null) {
			Usuario usu = proxyFactory.proxy(UsuarioApi.class).getUsuarioLogado();
			if (!Checks.esNulo(dto.getOcupado())) {
				activoSituacionPosesoria.setOcupado(dto.getOcupado());
				activoSituacionPosesoria.setUsuarioModificarOcupado(usu.getUsername());
				activoSituacionPosesoria.setFechaModificarOcupado(new Date());
			}
			
			Filter filtroActivoId = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
			Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "borrado", false);
			ActivoPatrimonio activoPatrimonio = genericDao.get(ActivoPatrimonio.class, filtroActivoId, filtroBorrado);
			DDTipoEstadoAlquiler tipoEstadoAlquiler = null;
			
			if (!Checks.esNulo(dto.getOcupado()) && !BooleanUtils.toBoolean(dto.getOcupado()) && dto.getOcupado() == 0) {
				activoSituacionPosesoria.setConTitulo(null);
				activoSituacionPosesoria.setUsuarioModificarConTitulo(usu.getUsername());
				activoSituacionPosesoria.setFechaModificarConTitulo(new Date());
				activoSituacionPosesoria.setFechaUltCambioTit(new Date());
				tipoEstadoAlquiler = genericDao.get(DDTipoEstadoAlquiler.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoEstadoAlquiler.ESTADO_ALQUILER_LIBRE));
			} else  if (!Checks.esNulo(dto.getConTituloCodigo())) {
				activoSituacionPosesoria.setUsuarioModificarConTitulo(usu.getUsername());
				activoSituacionPosesoria.setFechaModificarConTitulo(new Date());
				Filter tituloActivo = genericDao.createFilter(FilterType.EQUALS, "codigo", dto.getConTituloCodigo());
				DDTipoTituloActivoTPA tituloActivoTPA = genericDao.get(DDTipoTituloActivoTPA.class, tituloActivo);
				activoSituacionPosesoria.setConTitulo(tituloActivoTPA);
				activoSituacionPosesoria.setFechaUltCambioTit(new Date());
				if (DDTipoTituloActivoTPA.tipoTituloSi.equals(tituloActivoTPA.getCodigo())) {
					tipoEstadoAlquiler = genericDao.get(DDTipoEstadoAlquiler.class, genericDao.createFilter(FilterType.EQUALS, "codigo", DDTipoEstadoAlquiler.ESTADO_ALQUILER_ALQUILADO));
				}
			}
			
			if ((!Checks.esNulo(dto.getOcupado()) && dto.getOcupado() == 1 && DDTipoTituloActivoTPA.tipoTituloNo.equals(dto.getConTituloCodigo())) ||
				(!Checks.esNulo(activoSituacionPosesoria.getOcupado()) && activoSituacionPosesoria.getOcupado() == 1 && DDTipoTituloActivoTPA.tipoTituloNo.equals(dto.getConTituloCodigo()))) {
				activoApi.crearRegistroFaseHistorico(activo);
			}		
			
			if (!Checks.esNulo(dto.getOcupado()) || !Checks.esNulo(dto.getConTituloCodigo())) {
					if(activo != null && activoSituacionPosesoria!=null && usu!=null) {
						HistoricoOcupadoTitulo hist = new HistoricoOcupadoTitulo(activo,activoSituacionPosesoria,usu,HistoricoOcupadoTitulo.COD_SIT_POS,null);
						genericDao.save(HistoricoOcupadoTitulo.class, hist);
					}					
			}	
			
			if (!Checks.esNulo(activoPatrimonio) && !Checks.esNulo(tipoEstadoAlquiler)) {
				activoPatrimonio.setTipoEstadoAlquiler(tipoEstadoAlquiler);
				genericDao.update(ActivoPatrimonio.class, activoPatrimonio);
			}

			if(!Checks.esNulo(dto.getFechaTomaPosesion())){
				activoSituacionPosesoria.setEditadoFechaTomaPosesion(true);
				activoSituacionPosesoria.setFechaUltCambioPos(new Date());
			}
			
			if (dto.getTipoTituloPosesorioCodigo() != null) {
				
				DDTipoTituloPosesorio tipoTitulo = (DDTipoTituloPosesorio) 
						diccionarioApi.dameValorDiccionario(DDTipoTituloPosesorio.class,  new Long(dto.getTipoTituloPosesorioCodigo()));
				
				if(!Checks.esNulo(tipoTitulo)) {
					activoSituacionPosesoria.setTipoTituloPosesorio(tipoTitulo);
				}
					
			}
			
			if(!Checks.esNulo(dto.getFechaVencTitulo())) {
				activoSituacionPosesoria.setFechaVencTitulo(dto.getFechaVencTitulo());
			}
			
			if(!Checks.esNulo(dto.getRentaMensual())) {
				activoSituacionPosesoria.setRentaMensual(Float.parseFloat(dto.getRentaMensual()));
			}
			
			if(!Checks.esNulo(dto.getFechaTitulo())) {
				activoSituacionPosesoria.setFechaTitulo(dto.getFechaTitulo());
			}
			
			if(dto.getFechaAccesoTapiado() != null){
				activoSituacionPosesoria.setFechaAccesoTapiado(dto.getFechaAccesoTapiado());
			}
			
			if(dto.getFechaAccesoAntiocupa() != null){
				activoSituacionPosesoria.setFechaAccesoAntiocupa(dto.getFechaAccesoAntiocupa());
			}
			
			if(dto.getAccesoTapiado() != null){
				activoSituacionPosesoria.setAccesoTapiado(dto.getAccesoTapiado());
				if(dto.getAccesoTapiado() == 0){
					activoSituacionPosesoria.setFechaAccesoTapiado(null);
				}
				activoSituacionPosesoria.setFechaUltCambioTapiado(new Date());
			}
			
			if(dto.getAccesoAntiocupa() != null){
				activoSituacionPosesoria.setAccesoAntiocupa(dto.getAccesoAntiocupa());
				if(dto.getAccesoAntiocupa() == 0){
					activoSituacionPosesoria.setFechaAccesoAntiocupa(null);
				}
			}
			
			if(dto.getPosesionNegociada() != null) {
				activoSituacionPosesoria.setSpsPosesionNeg("1".equals(dto.getPosesionNegociada()));
			}
			
			if(dto.getTieneAlarma()!=null) {
				activoSituacionPosesoria.setConAlarma(dto.getTieneAlarma());					
			}
			if(dto.getFechaDesinstalacionAlarma()!=null) {
				activoSituacionPosesoria.setFechaDesinstalacionAlarma(dto.getFechaDesinstalacionAlarma());
			}
			if(dto.getFechaInstalacionAlarma()!=null) {
				activoSituacionPosesoria.setFechaInstalacionAlarma(dto.getFechaInstalacionAlarma());
			}
			if(dto.getTieneAlarma()!=null && activoSituacionPosesoria.getFechaDesinstalacionAlarma()!=null) {
				if(dto.getTieneAlarma()==1) {
					activoSituacionPosesoria.setConAlarma(dto.getTieneAlarma());
					activoSituacionPosesoria.setFechaDesinstalacionAlarma(null);
				}
			}
			
			if(dto.getTieneVigilancia()!=null) {
				activoSituacionPosesoria.setConVigilancia(dto.getTieneVigilancia());
			}
			if(dto.getFechaDesinstalacionVigilancia()!=null) {
				activoSituacionPosesoria.setFechaDesinstalacionVigilancia(dto.getFechaDesinstalacionVigilancia());
			}
			if(dto.getFechaInstalacionVigilancia()!=null) {
				activoSituacionPosesoria.setFechaInstalacionVigilancia(dto.getFechaInstalacionVigilancia());
			}
			
			if(dto.getTieneVigilancia()!=null && activoSituacionPosesoria.getFechaDesinstalacionVigilancia()!=null) {
				if(dto.getTieneVigilancia()==1) {
					activoSituacionPosesoria.setConVigilancia(dto.getTieneVigilancia());
					activoSituacionPosesoria.setFechaDesinstalacionVigilancia(null);
				}
			}
			
		}
		
		activo.setSituacionPosesoria(genericDao.save(ActivoSituacionPosesoria.class, activoSituacionPosesoria));
		
		if (dto.getNecesarias()!=null)
		{
			activo.setLlavesNecesarias(dto.getNecesarias());
		}
		if (dto.getLlaveHre()!=null)
		{
			activo.setLlavesHre(dto.getLlaveHre());
		}
		
		//HREOS-9069
		if (dto.getFechaPrimerAnillado()!=null)
		{
			activo.setFechaRecepcionLlaves(dto.getFechaPrimerAnillado());
		}
			
		if (dto.getNumJuegos()!=null)
		{
			activo.setNumJuegosLlaves(Integer.valueOf(dto.getNumJuegos()));
		}
		if (!Checks.esNulo(dto.getTieneOkTecnico())){
			activo.setTieneOkTecnico(dto.getTieneOkTecnico());
		}
		//HREOS-7085 - establecer campo “Servicer”
		String codCS = (!Checks.esNulo(activo.getCesionSaneamiento())) ? activo.getCesionSaneamiento().getCodigo() : null;
		String codTitulo = null;
		
		if(activo.getSituacionPosesoria().getConTitulo() != null) {
			codTitulo= activo.getSituacionPosesoria().getConTitulo().getCodigo();
		}		
		
		if(DDCesionSaneamiento.CODIGO_CMS_SANEADO_ALTAMIRA.equals(codCS) 
				|| DDCesionSaneamiento.CODIGO_CMS_SANEADO_Y_COMERCIALIZADO_ALTAMIRA.equals(codCS) 
				|| DDCesionSaneamiento.CODIGO_CMS_SANEADO_INTRUM.equals(codCS) 
				|| DDCesionSaneamiento.CODIGO_CMS_SANEADO_Y_COMERCIALIZADO_INTRUM.equals(codCS) ) {
			
			if((activo.getSituacionPosesoria().getOcupado() == 0 && !Checks.esNulo(activo.getSituacionPosesoria().getFechaTomaPosesion()))
					|| activo.getSituacionPosesoria().getOcupado() == 1 
							&& DDTipoTituloActivoTPA.tipoTituloSi.equals(codTitulo) 
							&& !Checks.esNulo(activo.getSituacionPosesoria().getFechaTomaPosesion()) ) {
				
				Filter filtroServicerActivo = genericDao.createFilter(FilterType.EQUALS, "codigo", DDServicerActivo.CODIGO_SRA_HAYA);
				DDServicerActivo servicerActivo = genericDao.get(DDServicerActivo.class, filtroServicerActivo);
				activo.setServicerActivo(servicerActivo);
			}
		}
		
		transactionManager.commit(transaction);

		if(activo != null && dto.getPosesionNegociada() != null && "1".equals(dto.getPosesionNegociada())){
			Thread llamadaAsincrona = new Thread(new ConvivenciaAlaska(activo.getId(), new ModelMap(), usuarioManager.getUsuarioLogado().getUsername()));
			llamadaAsincrona.start();
		}

		if (activo != null) {
			ActivoCaixa actCaixa = genericDao.get(ActivoCaixa.class, genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId()));
			if (actCaixa != null) {
				if (dto.getNecesariaFuerzaPublica() != null && "0".equals(dto.getNecesariaFuerzaPublica())) {
					actCaixa.setNecesariaFuerzaPublica(false);					
				}else if(dto.getNecesariaFuerzaPublica() != null && "1".equals(dto.getNecesariaFuerzaPublica())) {
					actCaixa.setNecesariaFuerzaPublica(true);
				}
				genericDao.save(ActivoCaixa.class, actCaixa);
			}
		}
		
		Filter filtroCaixa = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
		ActivoCaixa activoCaixa = genericDao.get(ActivoCaixa.class, filtroCaixa);
		
		if (activoCaixa != null) {
			if (dto.getEstadoTecnicoCodigo() != null) {
				Filter filtroEstadoTecnico = genericDao.createFilter(FilterType.EQUALS, "codigo",
						dto.getEstadoTecnicoCodigo());
				DDEstadoTecnicoActivo estadoTecnico = genericDao.get(DDEstadoTecnicoActivo.class, filtroEstadoTecnico);
				activoCaixa.setEstadoTecnico(estadoTecnico);
				if (!dto.getEstadoTecnicoDescripcion().isEmpty() || !dto.getEstadoTecnicoDescripcion().equals("")) {
					activoCaixa.setFechaEstadoTecnico(new Date());
				} else {
					activoCaixa.setFechaEstadoTecnico(null);
				}
			} else if(activoCaixa.getEstadoTecnico().getDescripcion() != null) {
				activoCaixa.getFechaEstadoTecnico();
			} else {
				activoCaixa.setFechaEstadoTecnico(null);
			}
		}
		
		return activo;
	}
	
	public void afterSaveTabActivo(Activo activo, WebDto dto) {
		
		DtoActivoSituacionPosesoria dtoSitPos = (DtoActivoSituacionPosesoria) dto;
		//Oferta oferta = ofertaApi.getOfertaAceptadaByActivo(activo);
		List<ActivoOferta> ofertas = activo.getOfertas();

		// Si ha cambiado la situacion juridica
		if (!Checks.esNulo(dtoSitPos.getFechaTomaPosesion()) 
					|| (!Checks.esNulo(dtoSitPos.getConTituloCodigo()) &&	DDTipoTituloActivoTPA.tipoTituloSi.equals(dtoSitPos.getConTituloCodigo()))) {
		
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
		
		if (activoDao.isUnidadAlquilable(activo.getId())) {
			activoApi.cambiarSituacionComercialActivoMatriz(activo.getId());
		}
	}
	
	public Integer calculodiasCambiosActivo(Date fechaIni){
		
		Boolean cumpleCond = Boolean.FALSE;
		Date fechaInicial=fechaIni;
		Date fechaFinal=new Date();
		return (int) ((fechaFinal.getTime()-fechaInicial.getTime())/86400000);

	} 
	

}
