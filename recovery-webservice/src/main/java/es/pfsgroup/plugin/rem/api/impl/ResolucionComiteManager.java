package es.pfsgroup.plugin.rem.api.impl;

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
import es.pfsgroup.plugin.rem.api.OfertaApi;
import es.pfsgroup.plugin.rem.api.ResolucionComiteApi;
import es.pfsgroup.plugin.rem.model.ActivoTramite;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.ResolucionComiteBankia;
import es.pfsgroup.plugin.rem.model.dd.DDComiteSancion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoOferta;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoResolucion;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoDenegacionResolucion;
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
	private GenericABMDao genericDao;


	@Override
	public String managerName() {
		return "resolucionComiteManager";
	}

	BeanUtilNotNull beanUtilNotNull = new BeanUtilNotNull();

	
	
	

	@Override
	public HashMap<String, String> validateResolucionPostRequestData(ResolucionComiteDto resolucionComiteDto, Object jsonFields) throws Exception {
		HashMap<String, String> hashErrores = null;


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
						List<ActivoTramite> listaTramites = activoTramiteApi.getTramitesActivoTrabajoList(eco.getTrabajo().getId());
						if(Checks.esNulo(listaTramites) || listaTramites.size() == 0){
							hashErrores.put("ofertaHRE", "No se han podido obtener el trámite asociado a la oferta.");
							
						}else{
							ActivoTramite tramite = listaTramites.get(0);
							List<TareaProcedimiento> listaTareas = activoTramiteApi.getTareasActivasByIdTramite(tramite.getId());
							if(Checks.esNulo(listaTareas) || listaTareas.size() == 0){
								hashErrores.put("ofertaHRE", "El expediente asociado a la oferta se encuentra finalizado.");
								
							}else{
								for(int i=0;i< listaTareas.size(); i++){
									TareaProcedimiento tarea = listaTareas.get(i);
									if(!Checks.esNulo(tarea) && tarea.getCodigo().equalsIgnoreCase("T013_RatificacionComite") &&
											resolucionComiteDto.getCodigoResolucion().equalsIgnoreCase(DDEstadoResolucion.CODIGO_ERE_CONTRAOFERTA)){
										hashErrores.put("ofertaHRE", "La oferta no se puede volver a contraofertar.");
										break;
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
	@Transactional(readOnly = false)
	public ResolucionComiteBankia saveResolucionComite(ResolucionComiteDto resolucionComiteDto) throws Exception {
		ResolucionComiteBankia resol = null;

		resol = new ResolucionComiteBankia();
		beanUtilNotNull.copyProperties(resol, resolucionComiteDto);

		if (!Checks.esNulo(resolucionComiteDto.getOfertaHRE())) {
			Oferta oferta = (Oferta) genericDao.get(Oferta.class, genericDao.createFilter(FilterType.EQUALS, "numOferta", resolucionComiteDto.getOfertaHRE()));
			if (!Checks.esNulo(oferta)) {
				resol.setOferta(oferta);
			}
		}
		if (!Checks.esNulo(resolucionComiteDto.getCodigoComite())) {
			DDComiteSancion comite = (DDComiteSancion) genericDao.get(DDComiteSancion.class, genericDao.createFilter(FilterType.EQUALS, "codigo", resolucionComiteDto.getCodigoComite()));
			if (!Checks.esNulo(comite)) {
				resol.setComite(comite);
			}
		}
		if (!Checks.esNulo(resolucionComiteDto.getCodigoResolucion())) {
			DDEstadoResolucion estadoResol = (DDEstadoResolucion) genericDao.get(DDEstadoResolucion.class, genericDao.createFilter(FilterType.EQUALS, "codigo", resolucionComiteDto.getCodigoResolucion()));
			if (!Checks.esNulo(estadoResol)) {
				resol.setEstadoResolucion(estadoResol);
			}
		}
		if (!Checks.esNulo(resolucionComiteDto.getCodigoDenegacion())) {
			DDMotivoDenegacionResolucion motivoDenegacion = (DDMotivoDenegacionResolucion) genericDao.get(DDMotivoDenegacionResolucion.class, genericDao.createFilter(FilterType.EQUALS, "codigo", resolucionComiteDto.getCodigoDenegacion()));
			if (!Checks.esNulo(motivoDenegacion)) {
				resol.setMotivoDenegacion(motivoDenegacion);;
			}
		}
		
		resol = genericDao.save(ResolucionComiteBankia.class, resol);
		
		return resol;
	}
	

}
