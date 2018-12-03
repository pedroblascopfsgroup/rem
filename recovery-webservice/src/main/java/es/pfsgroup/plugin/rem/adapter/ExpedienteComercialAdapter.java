package es.pfsgroup.plugin.rem.adapter;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.gestorDocumental.dto.documentos.CrearRelacionExpedienteDto;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.rem.activo.ActivoManager;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ExpedienteComercialApi;
import es.pfsgroup.plugin.rem.gestorDocumental.api.GestorDocumentalAdapterApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.AdjuntoExpedienteComercial;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.ExpedienteComercial;
import es.pfsgroup.plugin.rem.model.dd.DDSubtipoDocumentoExpediente;

@Service
public class ExpedienteComercialAdapter {

	private static final String EXCEPTION_ACTIVO_NOT_FOUND_COD = "Error al obtener el activo, no existe";

	private static final String RELACION_TIPO_DOCUMENTO_EXPEDIENTE = "d-e";	
	private static final String OPERACION_ALTA = "Alta";	

	@Autowired
	private GestorDocumentalAdapterApi gestorDocumentalAdapterApi;
	
	@Autowired
	private ExpedienteComercialApi expedienteComercialApi;
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private ActivoManager activoManager;
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private GenericABMDao genericDao;
	
	
	protected static final Log logger = LogFactory.getLog(ActivoAdapter.class);
	
	@Transactional(readOnly = false)
	public List<DtoAdjunto> getAdjuntosExpedienteComercial(Long id)	throws GestorDocumentalException{
		
		List<DtoAdjunto> listaAdjuntos = new ArrayList<DtoAdjunto>();
		Usuario usuario = genericAdapter.getUsuarioLogado();
		
		if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
			ExpedienteComercial expedienteComercial = expedienteComercialApi.findOne(id);
			try {
				listaAdjuntos = gestorDocumentalAdapterApi.getAdjuntosExpedienteComercial(expedienteComercial);
				for (DtoAdjunto adj : listaAdjuntos) {
					AdjuntoExpedienteComercial adjuntoExpedienteComercial = expedienteComercial.getAdjuntoGD(adj.getId());
					if (!Checks.esNulo(adjuntoExpedienteComercial)) {
						if (!Checks.esNulo(adjuntoExpedienteComercial.getTipoDocumentoExpediente())) {
							adj.setDescripcionTipo(adjuntoExpedienteComercial.getTipoDocumentoExpediente().getDescripcion());
						} 
						if(!Checks.esNulo(adjuntoExpedienteComercial.getSubtipoDocumentoExpediente())){
							adj.setDescripcionSubtipo(adjuntoExpedienteComercial.getSubtipoDocumentoExpediente().getDescripcion());
						}
						adj.setContentType(adjuntoExpedienteComercial.getContentType());
						if (!Checks.esNulo(adjuntoExpedienteComercial.getAuditoria())) {
							adj.setGestor(adjuntoExpedienteComercial.getAuditoria().getUsuarioCrear());
						}
						adj.setTamanyo(adjuntoExpedienteComercial.getTamanyo());
					}
				}
			} catch (GestorDocumentalException gex) {
				String[] error = gex.getMessage().split("-");
				if (error.length > 0 &&  (error[2].trim().contains(EXCEPTION_ACTIVO_NOT_FOUND_COD))) {
					
					Integer idExpediente;
					try{
						idExpediente = gestorDocumentalAdapterApi.crearExpedienteComercial(expedienteComercial,usuario.getUsername());
						logger.debug("GESTOR DOCUMENTAL [ crearExpediente para " + expedienteComercial.getNumExpediente() + "]: ID EXPEDIENTE RECIBIDO " + idExpediente);
					} catch (GestorDocumentalException gexc) {
						logger.error(gexc.getMessage(),gexc);
					}
					
				}
				throw gex;
			}			
		} else {
			listaAdjuntos = getAdjuntos(id, listaAdjuntos);
		}
		return listaAdjuntos;
	}

	public List<DtoAdjunto> getAdjuntos(Long idExpediente, List<DtoAdjunto> listaAdjuntos) {
		try {
			ExpedienteComercial expediente = expedienteComercialApi.findOne(idExpediente);

			for (AdjuntoExpedienteComercial adjunto : expediente.getAdjuntos()) {
				DtoAdjunto dto = new DtoAdjunto();
				BeanUtils.copyProperties(dto, adjunto);
				dto.setIdEntidad(expediente.getId());
				dto.setDescripcionTipo(adjunto.getTipoDocumentoExpediente().getDescripcion());
				dto.setDescripcionSubtipo(adjunto.getSubtipoDocumentoExpediente().getDescripcion());
				dto.setGestor(adjunto.getAuditoria().getUsuarioCrear());
				listaAdjuntos.add(dto);
			}

		} catch (Exception ex) {
			logger.error("error en expedienteComercialManager", ex);
		}
		return listaAdjuntos;
	}

	public String uploadDocumento(WebFileItem webFileItem, ExpedienteComercial expedienteComercialEntrada, String matricula) throws Exception {
		
		if (Checks.esNulo(expedienteComercialEntrada)) {
			if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
								
				ExpedienteComercial expedienteComercial = expedienteComercialApi.findOne(Long.parseLong(webFileItem.getParameter("idEntidad")));
				Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", webFileItem.getParameter("subtipo"));
				DDSubtipoDocumentoExpediente subtipoDocumento = (DDSubtipoDocumentoExpediente) genericDao.get(DDSubtipoDocumentoExpediente.class, filtro);
				if (!Checks.esNulo(subtipoDocumento)) {
					Long idDocRestClient = gestorDocumentalAdapterApi.uploadDocumentoExpedienteComercial(expedienteComercial, webFileItem, usuarioLogado.getUsername(), subtipoDocumento.getMatricula());
					expedienteComercialApi.uploadDocumento(webFileItem, idDocRestClient,null,null);
					String activos = webFileItem.getParameter("activos");
					String[] arrayActivos = null;
					
					if(activos != null && !activos.isEmpty()){
						arrayActivos = activos.split(",");
					}
					if(arrayActivos != null && arrayActivos.length > 0){
						CrearRelacionExpedienteDto crearRelacionExpedienteDto = new CrearRelacionExpedienteDto();
						crearRelacionExpedienteDto.setTipoRelacion(RELACION_TIPO_DOCUMENTO_EXPEDIENTE);
						String mat = subtipoDocumento.getMatricula();
						if(!Checks.esNulo(mat)){
							String[] matSplit = mat.split("-");
							crearRelacionExpedienteDto.setCodTipoDestino(matSplit[0]);
							crearRelacionExpedienteDto.setCodClaseDestino(matSplit[1]);
						}
						crearRelacionExpedienteDto.setOperacion(OPERACION_ALTA);
						
						gestorDocumentalAdapterApi.crearRelacionActivosExpediente(expedienteComercial, idDocRestClient, arrayActivos, usuarioLogado.getUsername(),crearRelacionExpedienteDto);
						if(!Checks.esNulo(subtipoDocumento.getTipoDocumentoActivo())) {
							webFileItem.putParameter("tipo", subtipoDocumento.getTipoDocumentoActivo().getCodigo());
						}
						for(int i = 0; i < arrayActivos.length; i++){
							Activo activoEntrada = activoApi.getByNumActivo(Long.parseLong(arrayActivos[i],10));
							//Según item HREOS-2379:
							//Adjuntar el documento a la tabla de adjuntos del activo, pero sin subir el documento realmente, sólo insertando la fila.
							File file = File.createTempFile("idDocRestClient["+idDocRestClient+"]", ".pdf");
							BufferedWriter out = new BufferedWriter(new FileWriter(file));
						    out.write("pfs");
						    out.close();					    
						    FileItem fileItem = new FileItem();
							fileItem.setFileName("idDocRestClient["+idDocRestClient+"]");
							fileItem.setFile(file);
							fileItem.setLength(file.length());			
							webFileItem.setFileItem(fileItem);
							activoManager.uploadDocumento(webFileItem, idDocRestClient, activoEntrada, matricula);
							file.delete();
						}
					}
										
				}
			} else {
				expedienteComercialApi.uploadDocumento(webFileItem, null,null,null);
			}
		} else {
			if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
				Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
				Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", webFileItem.getParameter("subtipo"));
				DDSubtipoDocumentoExpediente subtipoDocumento = (DDSubtipoDocumentoExpediente) genericDao.get(DDSubtipoDocumentoExpediente.class, filtro);
				if (!Checks.esNulo(subtipoDocumento)) {
					Long idDocRestClient = gestorDocumentalAdapterApi.uploadDocumentoExpedienteComercial(expedienteComercialEntrada, webFileItem,
							usuarioLogado.getUsername(), subtipoDocumento.getMatricula());
					expedienteComercialApi.uploadDocumento(webFileItem, idDocRestClient, expedienteComercialEntrada, matricula);
				}
			} else {
				expedienteComercialApi.uploadDocumento(webFileItem, null, expedienteComercialEntrada, matricula);
			}
		}
		return null;
	}

	public boolean deleteAdjunto(DtoAdjunto dtoAdjunto) {
		boolean borrado = false;
			if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
				Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
				try {
					borrado = gestorDocumentalAdapterApi.borrarAdjunto(dtoAdjunto.getId(), usuarioLogado.getUsername());
				} catch (Exception e) {
					e.printStackTrace();
				}
			} else {
				borrado = expedienteComercialApi.deleteAdjunto(dtoAdjunto);
			}
			return borrado;		
	}
}