package es.pfsgroup.plugin.rem.gestorDocumental.manager;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.plugin.gestorDocumental.api.GestorDocumentalApi;
import es.pfsgroup.plugin.gestorDocumental.api.GestorDocumentalExpedientesApi;
import es.pfsgroup.plugin.gestorDocumental.dto.documentos.BajaDocumentoDto;
import es.pfsgroup.plugin.gestorDocumental.dto.documentos.CabeceraPeticionRestClientDto;
import es.pfsgroup.plugin.gestorDocumental.dto.documentos.CrearDocumentoDto;
import es.pfsgroup.plugin.gestorDocumental.dto.documentos.DocumentosExpedienteDto;
import es.pfsgroup.plugin.gestorDocumental.dto.documentos.RecoveryToGestorDocAssembler;
import es.pfsgroup.plugin.gestorDocumental.dto.servicios.CrearGastoDto;
import es.pfsgroup.plugin.gestorDocumental.dto.servicios.RecoveryToGestorExpAssembler;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.gestorDocumental.model.DDTdnTipoDocumento;
import es.pfsgroup.plugin.gestorDocumental.model.GestorDocumentalConstants;
import es.pfsgroup.plugin.gestorDocumental.model.RespuestaGeneral;
import es.pfsgroup.plugin.gestorDocumental.model.documentos.RespuestaCrearDocumento;
import es.pfsgroup.plugin.gestorDocumental.model.documentos.RespuestaDescargarDocumento;
import es.pfsgroup.plugin.gestorDocumental.model.documentos.RespuestaDocumentosExpedientes;
import es.pfsgroup.plugin.gestorDocumental.model.servicios.RespuestaCrearExpediente;
import es.pfsgroup.plugin.recovery.coreextension.utils.api.UtilDiccionarioApi;
import es.pfsgroup.plugin.rem.gestorDocumental.api.Downloader;
import es.pfsgroup.plugin.rem.gestorDocumental.api.GestorDocumentalAdapterApi;
import es.pfsgroup.plugin.rem.gestorDocumental.dto.documentos.GestorDocToRecoveryAssembler;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.GastoProveedor;

@Service("gestorDocumentalAdapterManager")
public class GestorDocumentalAdapterManager implements GestorDocumentalAdapterApi, Downloader {
	
	protected static final Log logger = LogFactory.getLog(GestorDocumentalAdapterManager.class);
	
	@Override
	public String[] getKeys() {
		return new String[]{GESTOR_DOCUMENTAL};	}
	

	@Resource
	private Properties appProperties;
    
    @Autowired 
    private GestorDocumentalApi gestorDocumentalApi;
    
    @Autowired 
    private GestorDocumentalExpedientesApi gestorDocumentalExpedientesApi;
    
    @Autowired
    private UtilDiccionarioApi diccionarioApi;    
    
    private final String GESTOR_DOCUMENTAL = "GESTOR_DOC";
    
	@Override
	public List<DtoAdjunto> getAdjuntosActivo(Activo activo) throws GestorDocumentalException {
		RecoveryToGestorDocAssembler recoveryToGestorDocAssembler =  new RecoveryToGestorDocAssembler(appProperties);
		List<DtoAdjunto> list;		
		String codigoEstado = Checks.esNulo(activo.getEstadoActivo()) ? null : activo.getEstadoActivo().getCodigo();
		
		
		// FIXME Sin estado no podemos recuperar documentos, a no ser que hagamos la llamada 
		// que recupera todos los documentos del activo sin tener en cuenta el estado. 
		if(!Checks.esNulo(codigoEstado)) {
			CabeceraPeticionRestClientDto cabecera = recoveryToGestorDocAssembler.getCabeceraPeticionRestClient(activo.getNumActivo().toString(), GestorDocumentalConstants.CODIGO_TIPO_EXPEDIENTE_REO, codigoEstado);
			DocumentosExpedienteDto docExpDto = recoveryToGestorDocAssembler.getDocumentosExpedienteDto();
			RespuestaDocumentosExpedientes respuesta = null;
			respuesta = gestorDocumentalApi.documentosExpediente(cabecera, docExpDto);
			list = GestorDocToRecoveryAssembler.getListDtoAdjunto(respuesta);
			for (DtoAdjunto adjunto : list) {
				DDTdnTipoDocumento tipoDoc = (DDTdnTipoDocumento) diccionarioApi.dameValorDiccionarioByCod(DDTdnTipoDocumento.class, adjunto.getCodigoTipo());
				if (tipoDoc==null) {
					adjunto.setDescripcionTipo("");
				} else {
					adjunto.setDescripcionTipo(tipoDoc.getDescripcion());
				}			
			}
		} else {
			list = new ArrayList<DtoAdjunto>();
		}
		return list;
	}
	
	@Override
	public Long upload(Activo activo, WebFileItem webFileItem, String userLogin, String matricula) throws Exception {
		RecoveryToGestorDocAssembler recoveryToGestorDocAssembler =  new RecoveryToGestorDocAssembler(appProperties);
		String codigoEstado = Checks.esNulo(activo.getEstadoActivo()) ? null : activo.getEstadoActivo().getCodigo();
		Long respuesta = null;
		// FIXME Sin estado no podemos subir documentos. 
		if(!Checks.esNulo(codigoEstado)) {
			CabeceraPeticionRestClientDto cabecera = recoveryToGestorDocAssembler.getCabeceraPeticionRestClient(activo.getNumActivo().toString(), GestorDocumentalConstants.CODIGO_TIPO_EXPEDIENTE_REO, activo.getEstadoActivo().getCodigo());
			CrearDocumentoDto crearDoc = recoveryToGestorDocAssembler.getCrearDocumentoDto(webFileItem, userLogin, matricula);
			RespuestaCrearDocumento respuestaCrearDocumento = gestorDocumentalApi.crearDocumento(cabecera, crearDoc);
			respuesta =  new Long(respuestaCrearDocumento.getIdDocumento());
		}
		return respuesta;
	}
	
	@Override
	public List<DtoAdjunto> getAdjuntosGasto(String numGasto) throws GestorDocumentalException {
		RecoveryToGestorDocAssembler recoveryToGestorDocAssembler =  new RecoveryToGestorDocAssembler(appProperties);
		List<DtoAdjunto> list;		
		
		CabeceraPeticionRestClientDto cabecera = recoveryToGestorDocAssembler.getCabeceraPeticionRestClient(numGasto, GestorDocumentalConstants.CODIGO_TIPO_EXPEDIENTE_REO, GestorDocumentalConstants.CODIGO_CLASE_GASTO);
		DocumentosExpedienteDto docExpDto = recoveryToGestorDocAssembler.getDocumentosExpedienteDto();
		RespuestaDocumentosExpedientes respuesta = null;
		respuesta = gestorDocumentalApi.documentosExpediente(cabecera, docExpDto);
		list = GestorDocToRecoveryAssembler.getListDtoAdjunto(respuesta);
		for (DtoAdjunto adjunto : list) {
			DDTdnTipoDocumento tipoDoc = (DDTdnTipoDocumento) diccionarioApi.dameValorDiccionarioByCod(DDTdnTipoDocumento.class, adjunto.getCodigoTipo());
			if (tipoDoc==null) {
				adjunto.setDescripcionTipo("");
			} else {
				adjunto.setDescripcionTipo(tipoDoc.getDescripcion());
			}			
		}

		return list;
	}
	
	// TODO Refactorizar con metodo anterior.
	@Override
	public Long uploadDocumentoGasto(GastoProveedor gasto, WebFileItem webFileItem, String userLogin, String matricula) throws Exception {
		RecoveryToGestorDocAssembler recoveryToGestorDocAssembler =  new RecoveryToGestorDocAssembler(appProperties);
		Long respuesta = null;

		CabeceraPeticionRestClientDto cabecera = recoveryToGestorDocAssembler.getCabeceraPeticionRestClient(gasto.getNumGastoHaya().toString(), GestorDocumentalConstants.CODIGO_TIPO_EXPEDIENTE_REO, GestorDocumentalConstants.CODIGO_CLASE_GASTO);
		CrearDocumentoDto crearDoc = recoveryToGestorDocAssembler.getCrearDocumentoDto(webFileItem, userLogin, matricula);
		RespuestaCrearDocumento respuestaCrearDocumento = gestorDocumentalApi.crearDocumento(cabecera, crearDoc);
		respuesta =  new Long(respuestaCrearDocumento.getIdDocumento());
		
		return respuesta;
	}

	@Override
	public FileItem getFileItem(Long idDocumento) {
		RecoveryToGestorDocAssembler recoveryToGestorDocAssembler =  new RecoveryToGestorDocAssembler(appProperties);
		BajaDocumentoDto login = recoveryToGestorDocAssembler.getDescargaDocumentoDto();
		RespuestaDescargarDocumento respuesta = null;
		FileItem fileItem = null;
		try {
			respuesta = gestorDocumentalApi.descargarDocumento(idDocumento, login);
			fileItem = GestorDocToRecoveryAssembler.getFileItem(respuesta);
		} catch (IOException e) {
			e.printStackTrace();
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return fileItem;
	}

	@Override
	public boolean borrarAdjunto(Long idDocumento, String usuarioLogado) {
		RecoveryToGestorDocAssembler recoveryToGestorDocAssembler =  new RecoveryToGestorDocAssembler(appProperties);
		BajaDocumentoDto login = recoveryToGestorDocAssembler.getBajaDocumentoDto(usuarioLogado);
		RespuestaGeneral respuesta = null;
		try {
			respuesta = gestorDocumentalApi.bajaDocumento(login, idDocumento.intValue());
		} catch (Exception e) {
			e.printStackTrace();
		}
		if(!Checks.esNulo(respuesta) && "".equals(respuesta.getCodigoError())) {
			return true;
		}
		return false;
	}

	
	@Override	
	public Integer crearGasto(GastoProveedor gasto,  String usuarioLogado) throws GestorDocumentalException {			
		
		SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
		String fechaGasto = !Checks.esNulo(gasto.getFechaEmision()) ? formatter.format(gasto.getFechaEmision()) : "";
		String idReo = !Checks.estaVacio(gasto.getGastoProveedorActivos()) ?  gasto.getGastoProveedorActivos().get(0).getActivo().getNumActivo().toString() : "";
		String cliente = !Checks.estaVacio(gasto.getGastoProveedorActivos()) ?  gasto.getGastoProveedorActivos().get(0).getActivo().getCartera().getDescripcion() : "";
		String descripcionExpediente = "Descripcion";	
		
		RecoveryToGestorExpAssembler recoveryToGestorAssembler =  new RecoveryToGestorExpAssembler(appProperties);
		CrearGastoDto crearGastoDto = recoveryToGestorAssembler.getCrearGastoDto(gasto.getNumGastoHaya().toString(), gasto.getNumGastoHaya().toString(), idReo, fechaGasto , cliente, descripcionExpediente, usuarioLogado);
		
		RespuestaCrearExpediente respuesta = gestorDocumentalExpedientesApi.crearGasto(crearGastoDto);
		
		Integer idExpediente = null;
		
		if(!Checks.esNulo(respuesta)) {
			idExpediente = respuesta.getIdExpediente();
		}
		
		return idExpediente;	
	}
	
	@Override
	public boolean modoRestClientActivado() {
		
		return gestorDocumentalApi.modoRestClientActivado();
		
	}

}
