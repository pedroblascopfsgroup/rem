package es.pfsgroup.plugin.rem.api.impl;

import java.util.HashMap;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.utils.BeanUtilNotNull;
import es.pfsgroup.plugin.rem.api.ResolucionComiteApi;
import es.pfsgroup.plugin.rem.clienteComercial.ClienteComercialManager;
import es.pfsgroup.plugin.rem.model.Oferta;
import es.pfsgroup.plugin.rem.model.ResolucionComiteBankia;
import es.pfsgroup.plugin.rem.model.dd.DDComiteSancion;
import es.pfsgroup.plugin.rem.model.dd.DDEstadoResolucion;
import es.pfsgroup.plugin.rem.model.dd.DDMotivoDenegacionResolucion;
import es.pfsgroup.plugin.rem.rest.api.RestApi;
import es.pfsgroup.plugin.rem.rest.api.RestApi.TIPO_VALIDACION;
import es.pfsgroup.plugin.rem.rest.dto.ResolucionComiteDto;

@Service("resolucionComiteManager")
public class ResolucionComiteManager extends BusinessOperationOverrider<ResolucionComiteApi> implements ResolucionComiteApi{

	
	protected static final Log logger = LogFactory.getLog(ClienteComercialManager.class);

	@Autowired
	private RestApi restApi;

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
			if (!Checks.esNulo(estadoResol)){
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
