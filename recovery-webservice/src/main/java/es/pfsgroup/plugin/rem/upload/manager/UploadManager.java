package es.pfsgroup.plugin.rem.upload.manager;

import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.files.WebFileItem;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.bo.BusinessOperationOverrider;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.fileUpload.adapter.UploadAdapter;
import es.pfsgroup.plugin.rem.adapter.ActivoAdapter;
import es.pfsgroup.plugin.rem.adapter.ExpedienteComercialAdapter;
import es.pfsgroup.plugin.rem.adapter.GenericAdapter;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.api.GastoProveedorApi;
import es.pfsgroup.plugin.rem.api.GenericApi;
import es.pfsgroup.plugin.rem.api.TrabajoApi;
import es.pfsgroup.plugin.rem.api.UploadApi;
import es.pfsgroup.plugin.rem.expedienteComercial.dao.ExpedienteComercialDao;
import es.pfsgroup.plugin.rem.gestorDocumental.api.GestorDocumentalAdapterApi;
import es.pfsgroup.plugin.rem.logTrust.LogTrustAcceso;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.GastoProveedor;
import es.pfsgroup.plugin.rem.model.Trabajo;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoDocumentoExpediente;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoActivo;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoExpediente;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoGasto;
import es.pfsgroup.plugin.rem.rest.api.RestApi;

@Service("uploadManager")
public class UploadManager extends BusinessOperationOverrider<UploadApi> implements UploadApi {
	private final static String REST = "REST-USER";

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private RestApi restApi;
	@Override
	public String managerName() {
		return "uploadManager";
	}	
	@Resource
	Properties appProperties;
	
	@Autowired
	private ActivoApi activoApi;
	@Autowired
	private ActivoAdapter adapterActivo;

	@Autowired
	private TrabajoApi trabajoApi;

	@Autowired
	private ExpedienteComercialAdapter expedienteComercialAdapter;
	
	@Autowired
	private ExpedienteComercialDao expedienteComercialDao;
	
	@Autowired
	private GastoProveedorApi gastoProveedorApi;
	
	@Autowired
	private UploadAdapter uploadAdapter;
	
	@Autowired
	private GestorDocumentalAdapterApi gestorDocumentalAdapterApi;
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Override
	public Map <String , Object> validateAndUploadWebFileItem (WebFileItem webFileItem) throws Exception {
		Map <String, Map<String, Object>> map = new HashMap<String, Map<String, Object>>();
		if (VALIDATE_WEBFILE_ACTIVO.equals(webFileItem.getParameter("UploadAction"))) {
			map.put(VALIDATE_WEBFILE_ACTIVO, validateAndUploadWebFileItemActivo(webFileItem));
		}else if (VALIDATE_WEBFILE_TRABAJO.equals(webFileItem.getParameter("UploadAction"))) {
			map.put(VALIDATE_WEBFILE_TRABAJO, valdidateAndUploadWebFileItemTrabajo(webFileItem));			
		}else if(VALIDATE_WEBFILE_TRABAJO.equals(webFileItem.getParameter("UploadAction"))) {
			map.put(VALIDATE_WEBFILE_EXPEDIENTE, valdidateAndUploadWebFileItemExpedienteComercial(webFileItem));
		}else if (VALIDATE_WEBFILE_GASTO_PROOVEDOR.equals(webFileItem.getParameter("UploadAction"))){
			map.put(VALIDATE_WEBFILE_GASTO_PROOVEDOR, valdidateAndUploadWebFileItemGastoProovedor(webFileItem));
		}
		
		
		
		
		
		return map.get(webFileItem.getParameter("UploadAction"));
	}
	
	private Map<String, Object> validateAndUploadWebFileItemActivo(WebFileItem webFileItem){
		Map <String, Object> map = new HashMap<String, Object>();
		String error = null, descError = null;
		try {
			Activo activo = genericDao.get(Activo.class , genericDao.createFilter(FilterType.EQUALS,"numActivo", Long.parseLong(webFileItem.getParameter("numEntidadDto").trim())));
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo",  webFileItem.getParameter("tipo"));
			DDTipoDocumentoActivo tipoDocumento = genericDao.get(DDTipoDocumentoActivo.class, filtro);
			
			if(activo == null){
				error = RestApi.REST_MSG_UNKNOW_ENTITY;
				descError = "No existe el activo  [ " + webFileItem.getParameter("numEntidadDto") + " ]";
			}else if (tipoDocumento == null) {
				error = RestApi.REST_MSG_UNKNOWN_KEY;
				descError = "No existe este tipo de documento  [ " + webFileItem.getParameter("tipo") + " ]";
			}else if (tipoDocumento.getMatricula() == null) {
				error = RestApi.CODE_ERROR;
				descError = "No se ha encontrado asociada ninguna matricula al tipo de documento  [ " + webFileItem.getParameter("tipo") + " ]";
			}else{
				if (gestorDocumentalAdapterApi.modoRestClientActivado()){
					Long idDocRestClient = gestorDocumentalAdapterApi.upload(activo, webFileItem, "dgutierrez", tipoDocumento.getMatricula(), null);
					descError = activoApi.uploadDocumento(webFileItem, idDocRestClient, activo, tipoDocumento.getMatricula());
				}else {
					activoApi.uploadDocumento(webFileItem, null, activo, tipoDocumento.getMatricula());
				}
			}
			map.put("error",error);
			map.put("descError", descError);
			map.put("webFileItem", webFileItem);
			return map;
			
		}catch (Exception e) {
			descError = e.toString();
			String[] dumyArrayError = descError.split("\\:");
			if (dumyArrayError.length > 1) {
				descError = " ";
				for (Integer i = 0; i < dumyArrayError.length; i++) {
					if (i != 0) {
						descError = descError +" "+dumyArrayError[i];
					}
				}
			}
				
			map.put("error",RestApi.CODE_ERROR);
			map.put("descError", descError);
			map.put("webFileItem", webFileItem);
			
			return map;
		}
	}
	
	private Map<String, Object> valdidateAndUploadWebFileItemTrabajo(WebFileItem webFileItem){
			Map <String, Object> map = new HashMap<String, Object>();
			String error = null, descError = null;
			try {
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo",  webFileItem.getParameter("tipo"));
				DDTipoDocumentoActivo tipoDocumento = genericDao.get(DDTipoDocumentoActivo.class, filtro);
				Trabajo trabajo = genericDao.get(Trabajo.class , genericDao.createFilter(FilterType.EQUALS,"numTrabajo",  Long.parseLong(webFileItem.getParameter("numEntidadDto").trim())));
				if(trabajo == null) {
					error = RestApi.REST_MSG_UNKNOW_ENTITY;
					descError = "No existe el trabajo  [ " + webFileItem.getParameter("numEntidadDto") + " ]";
				}else if (tipoDocumento == null) {
					error = RestApi.REST_MSG_UNKNOWN_KEY;
					descError = "No existe este tipo de documento  [ " + webFileItem.getParameter("tipo") + " ]";
				}else if (tipoDocumento.getMatricula() == null) {
					error = RestApi.CODE_ERROR;
					descError = "No se ha encontrado asociada ninguna matricula al tipo de documento  [ " + webFileItem.getParameter("tipo") + " ]";
				}else{
					webFileItem.putParameter("idEntidad", trabajo.getId().toString());
					descError = trabajoApi.upload(webFileItem);
				}
				
				if (!Checks.esNulo(descError)) error = RestApi.CODE_ERROR;
				map.put("error",error); 
				map.put("descError", descError);
				map.put("webFileItem", webFileItem);
				
				return map;
				
			}catch (Exception e) {
				descError = e.toString();
				String[] dumyArrayError = descError.split("\\:");
				if (dumyArrayError.length > 1) {
					descError = " ";
					for (Integer i = 0; i < dumyArrayError.length; i++) {
						if (i != 0) {
							descError = descError +" "+dumyArrayError[i];
						}
					}
				}
					
				map.put("error",RestApi.CODE_ERROR);
				map.put("descError", descError);
				map.put("webFileItem", webFileItem);
				
				return map;
		}
	}
	
	private Map<String, Object> valdidateAndUploadWebFileItemExpedienteComercial(WebFileItem webFileItem){
		Map <String, Object> map = new HashMap<String, Object>();
		String error = null, descError = null;
		try {
			ExpedienteComercial expedienteComercial = genericDao.get(ExpedienteComercial.class, genericDao
					.createFilter(FilterType.EQUALS, "numExpediente", Long.parseLong(webFileItem.getParameter("numEntidadDto").trim())));
			
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", webFileItem.getParameter("subtipo"));
			DDSubtipoDocumentoExpediente subTipoDocumento = genericDao.get(DDSubtipoDocumentoExpediente.class, filtro);
			
			Filter filtroTipo = genericDao.createFilter(FilterType.EQUALS, "codigo", webFileItem.getParameter("tipo"));
			DDTipoDocumentoExpediente tipoDocumento = (DDTipoDocumentoExpediente) genericDao.get(DDTipoDocumentoExpediente.class, filtroTipo);
			
			if(Checks.esNulo(expedienteComercial)){
				error = RestApi.REST_MSG_UNKNOW_ENTITY;
				descError = "No existe el expediente [ " + webFileItem.getParameter("numEntidadDto").trim() + " ]";
			}else if (Checks.esNulo(tipoDocumento)) {
				error = RestApi.REST_MSG_UNKNOWN_KEY;
				descError = "No existe el tipo de documento [ " + webFileItem.getParameter("tipo").trim()+" ]";
			}else if (Checks.esNulo(subTipoDocumento)) {
				error = RestApi.REST_MSG_UNKNOWN_KEY;
				descError = "No existe el subtipo de documento [ " + webFileItem.getParameter("subtipo").trim() + " ]"; 
			}else if (tipoDocumento.getId() != subTipoDocumento.getTipoDocumentoExpediente().getId()){
				error = RestApi.REST_MSG_UNKNOWN_KEY;
				descError = "El codigo subtipo de documento [ " + webFileItem.getParameter("subtipo").trim() + " ] no pertenece al codigo tipo de documento [ "+webFileItem.getParameter("tipo") +" ]"; 
			}else {
				if (!(expedienteComercialDao.hayDocumentoSubtipo(expedienteComercial.getId(), tipoDocumento.getId(), subTipoDocumento.getId()) > 0
					&&(DDSubtipoDocumentoExpediente.CODIGO_PRE_CONTRATO.equals(subTipoDocumento.getCodigo()) 
							|| DDSubtipoDocumentoExpediente.CODIGO_PRE_LIQUIDACION_ITP.equals(subTipoDocumento.getCodigo()) 
							|| DDSubtipoDocumentoExpediente.CODIGO_CONTRATO.equals(subTipoDocumento.getCodigo())
							|| DDSubtipoDocumentoExpediente.CODIGO_LIQUIDACION_ITP.equals(subTipoDocumento.getCodigo())
							|| DDSubtipoDocumentoExpediente.CODIGO_FIANZA.equals(subTipoDocumento.getCodigo())
							|| DDSubtipoDocumentoExpediente.CODIGO_JUSTIFICANTE_INGRESOS.equals(subTipoDocumento.getCodigo())
							|| DDSubtipoDocumentoExpediente.CODIGO_AVAL_BANCARIO.equals(subTipoDocumento.getCodigo())))) {
					if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
						String usuario = "dgutierrez";
						if (!Checks.esNulo(subTipoDocumento)) {
							Long idDocRestClient = gestorDocumentalAdapterApi.uploadDocumentoExpedienteComercial(expedienteComercial, webFileItem,
									usuario, subTipoDocumento.getMatricula());
							descError = expedienteComercialApi.uploadDocumento(webFileItem, idDocRestClient, expedienteComercial, subTipoDocumento.getMatricula());
						}
					} else {
						descError = expedienteComercialApi.uploadDocumento(webFileItem, null, expedienteComercial, subTipoDocumento.getMatricula());
					}
				}else {
					error = RestApi.CODE_ERROR;
					descError = "Error, solo se puede insertar 1 documento de este subtipo " + webFileItem.getParameter("subtipo").trim();
				}
			}
			
			if (!Checks.esNulo(descError)) error = RestApi.CODE_ERROR;
			map.put("error",error); 
			map.put("descError", descError);
			map.put("webFileItem", webFileItem);
			
			return map;
			
		}catch (Exception e) {
			descError = e.toString();
			String[] dumyArrayError = descError.split("\\:");
			if (dumyArrayError.length > 1) {
				descError = " ";
				for (Integer i = 0; i < dumyArrayError.length; i++) {
					if (i != 0) {
						descError = descError +" "+dumyArrayError[i];
					}
				}
			}
				
			map.put("error",RestApi.CODE_ERROR);
			map.put("descError", descError);
			map.put("webFileItem", webFileItem);
			
			return map;
		}
	}
	
	private Map<String, Object> valdidateAndUploadWebFileItemGastoProovedor(WebFileItem webFileItem){
		Map <String, Object> map = new HashMap<String, Object>();
		String error = null, descError = null;
		try {
			GastoProveedor gastoProovedor = genericDao.get(GastoProveedor.class, genericDao.createFilter(FilterType.EQUALS, "numGastoHaya", Long.parseLong(webFileItem.getParameter("numEntidadDto").trim())));
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", webFileItem.getParameter("tipo"));
			DDTipoDocumentoGasto tipoDocumento = (DDTipoDocumentoGasto) genericDao.get(DDTipoDocumentoGasto.class, filtro);

			if(Checks.esNulo(gastoProovedor)){
				error = RestApi.REST_MSG_UNKNOW_ENTITY;
				descError = "No existe el proveedor [ " + webFileItem.getParameter("numEntidadDto").trim() + " ]";
			}else if (Checks.esNulo(tipoDocumento)) {
				error = RestApi.REST_MSG_UNKNOW_KEY;
				descError = "No existe el tipo de documento [ " + webFileItem.getParameter("tipo").trim() + " ]";
			} else{
				if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
					Long idDocRestClient = gestorDocumentalAdapterApi.uploadDocumentoGasto(gastoProovedor, webFileItem, "dgutierrez", tipoDocumento.getMatricula());
					gastoProveedorApi.createAdjuntoGasto(webFileItem, gastoProovedor, idDocRestClient);
				}else {
					gastoProveedorApi.createAdjuntoGasto(webFileItem, gastoProovedor, null);
				}			
			}
			
			if (!Checks.esNulo(descError)) error = RestApi.CODE_ERROR;
			map.put("error",error); 
			map.put("descError", descError);
			map.put("webFileItem", webFileItem);
			
			return map;
			
		}catch (Exception e) {
			descError = e.toString();
			String[] dumyArrayError = descError.split("\\:");
			if (dumyArrayError.length > 1) {
				descError = " ";
				for (Integer i = 0; i < dumyArrayError.length; i++) {
					if (i != 0) {
						descError = descError +" "+dumyArrayError[i];
					}
				}
			}
				
			map.put("error",RestApi.CODE_ERROR);
			map.put("descError", descError);
			map.put("webFileItem", webFileItem);
			
			return map;
		}
	}
}




