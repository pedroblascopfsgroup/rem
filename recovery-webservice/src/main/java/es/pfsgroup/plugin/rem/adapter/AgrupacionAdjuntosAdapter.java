package es.pfsgroup.plugin.rem.adapter;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import org.apache.commons.beanutils.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.exception.UserException;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.plugin.gestorDocumental.dto.documentos.CrearRelacionExpedienteDto;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.rem.api.ActivoAdjuntosAgrupacionApi;
import es.pfsgroup.plugin.rem.gestorDocumental.api.Downloader;
import es.pfsgroup.plugin.rem.gestorDocumental.api.DownloaderFactoryApi;
import es.pfsgroup.plugin.rem.gestorDocumental.api.GestorDocumentalAdapterApi;
import es.pfsgroup.plugin.rem.model.ActivoAdjuntoAgrupacion;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacion;
import es.pfsgroup.plugin.rem.model.ComunicacionGencat;
import es.pfsgroup.plugin.rem.model.DtoAdjuntoAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoComunicacion;


@Service
public class AgrupacionAdjuntosAdapter {
	
	private static final String RELACION_TIPO_DOCUMENTO_EXPEDIENTE = "d-e";	
	private static final String OPERACION_ALTA = "Alta";	
	
	@Autowired
	private GestorDocumentalAdapterApi gestorDocumentalAdapterApi;
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Resource
	private Properties appProperties;
	
	@Autowired
	private DownloaderFactoryApi downloaderFactoryApi;
	
	@Autowired
	private ActivoAdjuntosAgrupacionApi activoAdjuntosAgrupacionApi;
	
	private static final String CONSTANTE_REST_CLIENT = "rest.client.gestor.documental.constante";
	//TODO: Revisar que se está copiando bien
	public List<DtoAdjuntoAgrupacion> getAdjuntosAgrupacion(Long idAgrupacion)throws GestorDocumentalException, IllegalAccessException, InvocationTargetException {
		List<DtoAdjuntoAgrupacion> listaAdjuntos = new ArrayList<DtoAdjuntoAgrupacion>();
		
		Filter fAgrupacion = genericDao.createFilter(FilterType.EQUALS, "agrupacion.id", idAgrupacion);
		ActivoAgrupacion agrupacion = genericDao.get(ActivoAgrupacion.class,fAgrupacion);
		
		if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
			//return null;
			 try {
				listaAdjuntos = gestorDocumentalAdapterApi.getAdjuntoAgrupacion(idAgrupacion);
			} catch (GestorDocumentalException gex) {
				String[] error = gex.getMessage().split("-");
				if (error.length > 0 &&  (error[2].trim().contains("Error al obtener el activo, no existe"))) {
					Usuario usuario = genericAdapter.getUsuarioLogado();
					Integer idExp;
				/*	try{
						idExp = gestorDocumentalAdapterApi.crearContenedorComunicacionGencat(comunicacionGencat,usuario.getUsername());
						logger.debug("GESTOR DOCUMENTAL [ crearExpediente para " + comunicacionGencat.getId() + "]: ID EXPEDIENTE RECIBIDO " + idExp);
					} catch (GestorDocumentalException gexc) {
						gexc.printStackTrace();
						logger.debug(gexc.getMessage());
					}*/

				}
				try {
					throw gex;
				} catch (GestorDocumentalException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		} else {
			listaAdjuntos = creaListaAdjuntosAgrupacion(idAgrupacion, listaAdjuntos);
		}
		return listaAdjuntos;
	}
	
	public List<DtoAdjuntoAgrupacion> creaListaAdjuntosAgrupacion(Long idAgrupacion, List<DtoAdjuntoAgrupacion> listaAdjuntos) throws IllegalAccessException, InvocationTargetException {

			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "agrupacion.id", idAgrupacion);
			List<ActivoAdjuntoAgrupacion> adjuntosAgrupacion = genericDao.getList(ActivoAdjuntoAgrupacion.class, filtro);

			for (ActivoAdjuntoAgrupacion adjuntoAgrupacion : adjuntosAgrupacion) {
				DtoAdjuntoAgrupacion dto = new DtoAdjuntoAgrupacion();
				//TODO: REVISAR PROPIEDADES
				BeanUtils.copyProperties(dto, adjuntoAgrupacion);
				listaAdjuntos.add(dto);
			}

		return listaAdjuntos;
	}
	
	
	public String uploadDocumento(WebFileItem webFileItem) throws Exception {
			Filter fAgrupacion = genericDao.createFilter(FilterType.EQUALS, "agrupacion.id", Long.parseLong(webFileItem.getParameter("idAgrupacion")));
			ActivoAgrupacion agrupacion = genericDao.get(ActivoAgrupacion.class,fAgrupacion);
			Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", webFileItem.getParameter("tipo"));
			DDTipoDocumentoAgrupacion tipoDocumento = genericDao.get(DDTipoDocumentoAgrupacion.class, filtro);
			String idDocumento = null;
			
		
		if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
			//return null;
			
			
			if (!Checks.esNulo(tipoDocumento)) {
				Long idDocRestClient = gestorDocumentalAdapterApi.uploadDocumentoAgrupacionAdjunto(agrupacion, webFileItem, usuarioLogado.getUsername(), tipoDocumento.getMatricula());
				idDocumento = activoAdjuntosAgrupacionApi.uploadDocumento(webFileItem, idDocRestClient,agrupacion,null,usuarioLogado);
		
					CrearRelacionExpedienteDto crearRelacionExpedienteDto = new CrearRelacionExpedienteDto();
					crearRelacionExpedienteDto.setTipoRelacion(RELACION_TIPO_DOCUMENTO_EXPEDIENTE);
					String mat = tipoDocumento.getMatricula();
					if(!Checks.esNulo(mat)){
						String[] matSplit = mat.split("-");
						crearRelacionExpedienteDto.setCodTipoDestino(matSplit[0]);
						crearRelacionExpedienteDto.setCodClaseDestino(matSplit[1]);
					}
					
					crearRelacionExpedienteDto.setOperacion(OPERACION_ALTA);

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
					activoAdjuntosAgrupacionApi.uploadDocumento(webFileItem, idDocRestClient,agrupacion,null,usuarioLogado);
					file.delete();
			}
		} else {
			activoAdjuntosAgrupacionApi.uploadDocumento(webFileItem, null,agrupacion,null,usuarioLogado);
		}
		
		return null;
	}
	
	public FileItem download(Long id,String nombreDocumento) throws UserException,Exception {
		String key = appProperties.getProperty(CONSTANTE_REST_CLIENT);
		Downloader dl = downloaderFactoryApi.getDownloader(key);
		FileItem result = dl.getFileItemPromocion(id,nombreDocumento);
		if(result == null){
			throw new UserException("El fichero no existe");
		}
		return result;
	}

}
