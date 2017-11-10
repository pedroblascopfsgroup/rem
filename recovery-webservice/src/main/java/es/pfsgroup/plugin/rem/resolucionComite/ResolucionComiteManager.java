package es.pfsgroup.plugin.rem.resolucionComite;

import java.util.HashMap;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.pfs.procesosJudiciales.model.TareaProcedimiento;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.plugin.rem.api.ActivoTramiteApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.GestorActivoApi;
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.ResolucionComiteApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.ResolucionComiteBankia;
import es.pfsgroup.plugin.rem.model.ResolucionComiteBankiaDto;
import es.pfsgroup.plugin.rem.model.dd.DDComiteSancion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoResolucion;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoAnulacionExpediente;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoDenegacionResolucion;
import es.pfsgroup.plugin.rem.model.dd.DDPenitenciales;
import es.pfsgroup.plugin.rem.model.dd.DDTipoResolucion;
import es.pfsgroup.plugin.rem.resolucionComite.dao.ResolucionComiteDao;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi.TIPO_VALIDACION;
import es.pfsgroup.plugin.rem.rest.dto.ResolucionComiteDto;

@Service("resolucionComiteManager")
public class ResolucionComiteManager extends BusinessOperationOverrider<ResolucionComiteApi> implements ResolucionComiteApi{

	
	protected static final Log logger = LogFactory.getLog(ResolucionComiteManager.class);

	@Autowired
	private RestApi restApi;

	@Autowired
	private OfertaApi ofertaApi;
	
	@Autowired
	private ActivoTramiteApi activoTramiteApi;
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private GestorActivoApi gestorActivoApi;
	
	@Autowired
	private GenericABMDao genericDao;

	@Autowired
	private ResolucionComiteDao resolucionComiteDao;

	@Override
	public String managerName() {
		return "resolucionComiteManager";
	}

	BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();

	
	
	

	@Override
	public HashMap<String, String> validateResolucionPostRequestData(ResolucionComiteDto resolucionComiteDto, Object jsonFields) throws Exception {
		HashMap<String, String> hashErrores = null;
		Usuario usu = null;
		
		hashErrores = restApi.validateRequestObject(resolucionComiteDto, TIPO_VALIDACION.INSERT);	

		if (!Checks.esNulo(resolucionComiteDto.getCodigoResolucion())) {
			DDEstadoResolucion estadoResol = (DDEstadoResolucion) genericDao.get(DDEstadoResolucion.class, genericDao.createFilter(FilterType.EQUALS, "codigo", resolucionComiteDto.getCodigoResolucion()));
			
			if(!Checks.esNulo(resolucionComiteDto.getOfertaHRE())){
				Oferta ofr = ofertaApi.getOfertaByNumOfertaRem(resolucionComiteDto.getOfertaHRE());
				if(Checks.esNulo(ofr) || (!Checks.esNulo(ofr) && !ofr.getEstadoOferta().getCodigo().equalsIgnoreCase(DDEstadoOferta.CODIGO_ACEPTADA))){
					hashErrores.put("ofertaHRE", "La oferta no esta aceptada.");
					
				}else{
					ExpedienteComercial eco = expedienteComercialApi.expedienteComercialPorOferta(ofr.getId());
					if(Checks.esNulo(eco)){
						hashErrores.put("ofertaHRE", "La oferta no tiene expediente comercial asociado.");
						
					}else{
						
						Activo act = ofr.getActivoPrincipal();
						if(Checks.esNulo(act)){
							hashErrores.put("ofertaHRE", "No se ha podido obtener el activo asociado a la oferta.");
							
						}else{
						
							List<ActivoTramite> listaTramites = activoTramiteApi.getTramitesActivoTrabajoList(eco.getTrabajo().getId());
							if(Checks.esNulo(listaTramites) || listaTramites.size() == 0){
								hashErrores.put("ofertaHRE", "No se han podido obtener el trámite asociado a la oferta.");
								
							}else{
								ActivoTramite tramite = listaTramites.get(0);
								List<TareaProcedimiento> listaTareasActivas = activoTramiteApi.getTareasActivasByIdTramite(tramite.getId());
								if(Checks.esNulo(listaTareasActivas) || listaTareasActivas.size() == 0){
									hashErrores.put("ofertaHRE", "El expediente asociado a la oferta se encuentra finalizado.");
									
								}else{

									List<TareaProcedimiento> listaTareas = activoTramiteApi.getTareasByIdTramite(tramite.getId());
									for(int i=0;i< listaTareas.size(); i++){
										TareaProcedimiento tarea = listaTareas.get(i);						
										if(!Checks.esNulo(tarea)){
											if(tarea.getCodigo().equalsIgnoreCase("T013_ResolucionComite") || tarea.getCodigo().equalsIgnoreCase("T013_RatificacionComite")){
												usu = gestorActivoApi.userFromTarea(tarea.getCodigo(), tramite.getId());
												break;
											}
										}
									}
									
									if(Checks.esNulo(usu) && !Checks.esNulo(resolucionComiteDto.getDevolucion())){
										usu = gestorActivoApi.getGestorComercialActual(ofr.getActivoPrincipal(), "GCOM");
									}
									
									if(Checks.esNulo(usu)){
										hashErrores.put("ofertaHRE", "No se ha podido obtener el usuario al que se enviará la notificación.");
										
									}else{
									
//										for(int i=0;i< listaTareas.size(); i++){
//											TareaProcedimiento tarea = listaTareas.get(i);
//											if(!Checks.esNulo(tarea) && tarea.getCodigo().equalsIgnoreCase("T013_RatificacionComite") &&
//													resolucionComiteDto.getCodigoResolucion().equalsIgnoreCase(DDEstadoResolucion.CODIGO_ERE_CONTRAOFERTA)){
//												hashErrores.put("ofertaHRE", "La oferta no se puede volver a contraofertar.");
//												break;
//											}
//										}
									}
								}
							}
						}
					}	
				}
			}
			if (!Checks.esNulo(estadoResol)){
				if(estadoResol.getCodigo().equalsIgnoreCase(DDEstadoResolucion.CODIGO_ERE_CONTRAOFERTA) &&
				  Checks.esNulo(resolucionComiteDto.getImporteContraoferta())){
					hashErrores.put("importeContraoferta", "El importe de la contraoferta es obligatorio al ser la resolución una contraoferta.");						
				}
				if(!Checks.esNulo(resolucionComiteDto.getImporteContraoferta()) && !estadoResol.getCodigo().equalsIgnoreCase(DDEstadoResolucion.CODIGO_ERE_CONTRAOFERTA)){
					hashErrores.put("importeContraoferta", "La resolución no es una contraoferta.");					
				}
				if(!Checks.esNulo(resolucionComiteDto.getFechaAnulacion()) && !estadoResol.getCodigo().equalsIgnoreCase(DDEstadoResolucion.CODIGO_ERE_DENEGADA)){
					hashErrores.put("fechaAnulacion", "La resolución no es una denegación.");					
				}
				if(!Checks.esNulo(resolucionComiteDto.getCodigoDenegacion()) && !estadoResol.getCodigo().equalsIgnoreCase(DDEstadoResolucion.CODIGO_ERE_DENEGADA)){
					hashErrores.put("codigoDenegacion", "La resolución no es una denegación.");					
				}
				if(Checks.esNulo(resolucionComiteDto.getCodigoDenegacion()) && estadoResol.getCodigo().equalsIgnoreCase(DDEstadoResolucion.CODIGO_ERE_DENEGADA)){
					hashErrores.put("codigoDenegacion", RestApi.REST_MSG_MISSING_REQUIRED);					
				}
			}			
		}
		
		return hashErrores;
	}
	
	
	
	
	
	
	@Override
	public List<ResolucionComiteBankia> getResolucionesComiteByExpedienteTipoRes(ResolucionComiteBankiaDto resolDto) throws Exception {
		ResolucionComiteBankiaDto dtoParamsBusqueda = null;
		List<ResolucionComiteBankia> listaResol = null;
		
		if (Checks.esNulo(resolDto)) {
			throw new Exception("Error en los parámetros de entrada.");
		} 
				
		if(Checks.esNulo(resolDto.getExpediente())){
			throw new Exception("Error en los parámetros de entrada. Expediente obligatorio.");
		}
		
		if(Checks.esNulo(resolDto.getTipoResolucion())){
			throw new Exception("Error en los parámetros de entrada. Tipo de Resolucion obligatorio.");
		}
		
		//Obtenemos la lista de resoluciones por expediente y tipo (debería devolver sólo 1)
		dtoParamsBusqueda = new ResolucionComiteBankiaDto();
		dtoParamsBusqueda.setExpediente(resolDto.getExpediente());
		dtoParamsBusqueda.setTipoResolucion(resolDto.getTipoResolucion());	
		listaResol = resolucionComiteDao.getListaResolucionComite(dtoParamsBusqueda);

		return listaResol;		

	}
	
	
	
	
	
	@Override
	public ResolucionComiteBankiaDto getResolucionComiteBankiaDtoFromResolucionComiteDto(ResolucionComiteDto resolucionComiteDto) throws Exception{
		ResolucionComiteBankiaDto resolDto = null;
		
		resolDto = new ResolucionComiteBankiaDto();
		beanUtilNotNull.copyProperties(resolDto, resolucionComiteDto);
		
		if (!Checks.esNulo(resolucionComiteDto.getOfertaHRE())) {
			Oferta oferta = (Oferta) genericDao.get(Oferta.class, genericDao.createFilter(FilterType.EQUALS, "numOferta", resolucionComiteDto.getOfertaHRE()));
			if (!Checks.esNulo(oferta)) {
				ExpedienteComercial eco = expedienteComercialApi.expedienteComercialPorOferta(oferta.getId());
				if (!Checks.esNulo(eco)) {
					resolDto.setExpediente(eco);
				}
			}
		}
		if (!Checks.esNulo(resolucionComiteDto.getCodigoComite())) {
			DDComiteSancion comite = (DDComiteSancion) genericDao.get(DDComiteSancion.class, genericDao.createFilter(FilterType.EQUALS, "codigo", resolucionComiteDto.getCodigoComite()));
			if (!Checks.esNulo(comite)) {
				resolDto.setComite(comite);
			}
		}
		if (!Checks.esNulo(resolucionComiteDto.getCodigoResolucion())) {
			DDEstadoResolucion estadoResol = (DDEstadoResolucion) genericDao.get(DDEstadoResolucion.class, genericDao.createFilter(FilterType.EQUALS, "codigo", resolucionComiteDto.getCodigoResolucion()));
			if (!Checks.esNulo(estadoResol)) {
				resolDto.setEstadoResolucion(estadoResol);
			}
		}
		if (!Checks.esNulo(resolucionComiteDto.getCodigoDenegacion())) {
			DDMotivoDenegacionResolucion motivoDenegacion = (DDMotivoDenegacionResolucion) genericDao.get(DDMotivoDenegacionResolucion.class, genericDao.createFilter(FilterType.EQUALS, "codigo", resolucionComiteDto.getCodigoDenegacion()));
			if (!Checks.esNulo(motivoDenegacion)) {
				resolDto.setMotivoDenegacion(motivoDenegacion);;
			}
		}	
		if (!Checks.esNulo(resolucionComiteDto.getCodigoTipoResolucion())) {
			DDTipoResolucion tipoResolucion = (DDTipoResolucion) genericDao.get(DDTipoResolucion.class, genericDao.createFilter(FilterType.EQUALS, "codigo", resolucionComiteDto.getCodigoTipoResolucion()));
			if (!Checks.esNulo(tipoResolucion)) {
				resolDto.setTipoResolucion(tipoResolucion);
			}
		}
		
		if (!Checks.esNulo(resolucionComiteDto.getCodigoAnulacion())) {
			DDMotivoAnulacionExpediente motivoAnulacion = (DDMotivoAnulacionExpediente) genericDao.get(DDMotivoAnulacionExpediente.class, genericDao.createFilter(FilterType.EQUALS, "codigo", resolucionComiteDto.getCodigoAnulacion()));
			if (!Checks.esNulo(motivoAnulacion)) {
				resolDto.setMotivoAnulacionExpediente(motivoAnulacion);
			}
		}
		
		if (!Checks.esNulo(resolucionComiteDto.getPenitenciales())) {
			DDPenitenciales penitenciales = (DDPenitenciales) genericDao.get(DDPenitenciales.class, genericDao.createFilter(FilterType.EQUALS, "codigo", resolucionComiteDto.getPenitenciales()));
			if (!Checks.esNulo(penitenciales)) {
				resolDto.setPenitenciales(penitenciales);
			}
		}
		
		return resolDto;
	}
	
	
	
	
	
	@Override
	@Transactional(readOnly = false)
	public ResolucionComiteBankia saveOrUpdateResolucionComite(ResolucionComiteDto resolucionComiteDto) throws Exception{
		ResolucionComiteBankiaDto resolDto = null;
		List<ResolucionComiteBankia> listaResol = null;
		ResolucionComiteBankia resolucionBankia = null;
		
		resolDto = this.getResolucionComiteBankiaDtoFromResolucionComiteDto(resolucionComiteDto);
		if(Checks.esNulo(resolDto)){
			throw new Exception("Se ha producido un error en la búsqueda de resoluciones.");
		}
		
		//Obtenemos la lista de resoluciones por expediente y tipo si existe
		listaResol = this.getResolucionesComiteByExpedienteTipoRes(resolDto);
		if(Checks.esNulo(listaResol) || (!Checks.esNulo(listaResol) && listaResol.size()==0)){
			//Si no existen resoluciones por expediente y tipo, se crea nueva
			resolucionBankia = this.saveResolucionComite(resolDto, resolucionComiteDto.getOfertaHRE());
		}else{
			//Si ya existen resoluciones por expediente y tipo, se marcan como borradas
			if(!Checks.esNulo(listaResol) && listaResol.size()>0){
				for(int i = 0; i< listaResol.size(); i++){					
					resolucionComiteDao.delete(listaResol.get(i));
				}
			}
			//Si ya existe, se borra y se inserta una nueva
			resolucionBankia = this.saveResolucionComite(resolDto, resolucionComiteDto.getOfertaHRE());
		}

		return resolucionBankia;
	}
	

	
	

	@Override
	@Transactional(readOnly = false)
	public ResolucionComiteBankia saveResolucionComite(ResolucionComiteBankiaDto resolDto, Long numOferta) throws Exception {
		ResolucionComiteBankia resol = null;

		
		resol = new ResolucionComiteBankia();
		Oferta ofr = null;
		if(!Checks.esNulo(numOferta)) {
			ofr = ofertaApi.getOfertaByNumOfertaRem(numOferta);
		}
		beanUtilNotNull.copyProperties(resol, resolDto);

		
		if (!Checks.esNulo(resolDto.getExpediente())) {
			resol.setExpediente(resolDto.getExpediente());			
		}
		if (!Checks.esNulo(resolDto.getComite())) {
			resol.setComite(resolDto.getComite());
		}
		if (!Checks.esNulo(resolDto.getEstadoResolucion())) {
			resol.setEstadoResolucion(resolDto.getEstadoResolucion());
		}
		if (!Checks.esNulo(resolDto.getMotivoDenegacion())) {
			resol.setMotivoDenegacion(resolDto.getMotivoDenegacion());	
		}	
		if (!Checks.esNulo(resolDto.getTipoResolucion())) {
			resol.setTipoResolucion(resolDto.getTipoResolucion());			
		}
		if(!Checks.esNulo(resolDto.getMotivoAnulacionExpediente())){
			resol.setMotivoAnulacion(resolDto.getMotivoAnulacionExpediente());
		}		
		if(!Checks.esNulo(resolDto.getPenitenciales())){
			resol.setPenitenciales(resolDto.getPenitenciales());
		}
		if(!Checks.esNulo(resolDto.getFechaComite())){
			resol.setFechaResolucion(resolDto.getFechaComite());
		}
		if(!Checks.esNulo(ofr)) {
			if(!Checks.esNulo(resol.getImporteContraoferta())) {
				ofr.setImporteContraOferta(resol.getImporteContraoferta());
				genericDao.save(Oferta.class, ofr);
				ExpedienteComercial expediente = expedienteComercialApi.expedienteComercialPorOferta(ofr.getId());
				if(!Checks.esNulo(expediente)) {
					// Actualizar honorarios para el nuevo importe de contraoferta.
					expedienteComercialApi.actualizarHonorariosPorExpediente(expediente.getId());
		
					// Actualizamos la participación de los activos en la oferta;
					expedienteComercialApi.updateParticipacionActivosOferta(ofr);
					expedienteComercialApi.actualizarImporteReservaPorExpediente(expediente);
				}
			}
			resol = genericDao.save(ResolucionComiteBankia.class, resol);
		}
		return resol;
	}
	
	

}
