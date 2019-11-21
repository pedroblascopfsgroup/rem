package es.pfsgroup.plugin.rem.adapter;

import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.List;
import java.util.Properties;

import javax.annotation.Resource;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.exception.UserException;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.gestorDocumental.exception.GestorDocumentalException;
import es.pfsgroup.plugin.gestorDocumental.model.GestorDocumentalConstants;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.api.ActivoProyectoApi;
import es.pfsgroup.plugin.rem.gestorDocumental.api.Downloader;
import es.pfsgroup.plugin.rem.gestorDocumental.api.DownloaderFactoryApi;
import es.pfsgroup.plugin.rem.gestorDocumental.api.GestorDocumentalAdapterApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ActivoAgrupacionActivo;
import es.pfsgroup.plugin.rem.model.ActivoProyecto;
import es.pfsgroup.plugin.rem.model.AdjuntosProyecto;
import es.pfsgroup.plugin.rem.model.DtoAdjunto;
import es.pfsgroup.plugin.rem.model.DtoAdjuntoProyecto;
import es.pfsgroup.plugin.rem.model.dd.DDTipoAgrupacion;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoProyecto;


@Service
public class ProyectoAdapter {
	
	
	@Autowired
	private GestorDocumentalAdapterApi gestorDocumentalAdapterApi;
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private ActivoProyectoApi activoProyectoApi;
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Resource
	private Properties appProperties;
	
	@Autowired
	private DownloaderFactoryApi downloaderFactoryApi;
	
	protected static final Log logger = LogFactory.getLog(ProyectoAdapter.class);
	
	private static final String CONSTANTE_REST_CLIENT = "rest.client.gestor.documental.constante";
	
	public List<DtoAdjuntoProyecto> getAdjuntosProyecto(Long id)
			throws GestorDocumentalException, IllegalAccessException, InvocationTargetException {
		List<DtoAdjuntoProyecto> listaAdjuntos = new ArrayList<DtoAdjuntoProyecto>();

		Activo activo = activoProyectoApi.get(id);
		if (gestorDocumentalAdapterApi.modoRestClientActivado() && activo.getAgrupaciones() != null && !activo.getAgrupaciones().isEmpty()) {
			
			String codAgrupacion = null;
			Long idAgrupacion = null;
			
			for (ActivoAgrupacionActivo activoAgrupacionActivo : activo.getAgrupaciones()) { //Buscamos si el activo tiene agrupación de tipo Proyecto
				if (DDTipoAgrupacion.AGRUPACION_PROYECTO.equals(activoAgrupacionActivo.getAgrupacion().getTipoAgrupacion().getCodigo())) {
					codAgrupacion = activoAgrupacionActivo.getAgrupacion().getNumAgrupRem().toString();
					idAgrupacion = activoAgrupacionActivo.getAgrupacion().getId();
					break;
				}
			}
			
			if (!Checks.esNulo(codAgrupacion)) {
				try {

				listaAdjuntos = gestorDocumentalAdapterApi.getAdjuntosProyecto(codAgrupacion);
				
					for (DtoAdjuntoProyecto adj : listaAdjuntos) {
						AdjuntosProyecto adjuntosProyecto = activo.getAdjuntoProyectoGD(adj.getId());
						if (!Checks.esNulo(adjuntosProyecto)) {
							if (!Checks.esNulo(adjuntosProyecto.getTipoDocumentoProyecto())) {
								adj.setDescripcionTipo(adjuntosProyecto.getTipoDocumentoProyecto().getDescripcion());
							}
							adj.setContentType(adjuntosProyecto.getContentType());
							if (!Checks.esNulo(adjuntosProyecto.getAuditoria())) {
								adj.setGestor(adjuntosProyecto.getAuditoria().getUsuarioCrear());
							}
							adj.setTamanyo(adjuntosProyecto.getTamanyo());
							adj.setFechaDocumento(adjuntosProyecto.getFechaDocumento());
						}
					}
				}catch(GestorDocumentalException gex){
					ActivoProyecto proyecto =  genericDao.get(ActivoProyecto.class, genericDao.createFilter(FilterType.EQUALS, "id", idAgrupacion));
					
					Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
					if (GestorDocumentalException.CODIGO_ERROR_CONTENEDOR_NO_EXISTE
							.equals(gex.getCodigoError())) {
						Thread hilo = new Thread(
								gestorDocumentalAdapterApi.crearProyecto(activo, proyecto, usuarioLogado.getUsername(),GestorDocumentalConstants.CODIGO_CLASE_PROYECTO));
						hilo.run();
					}
				}
			}

		} else {
			listaAdjuntos = getAdjuntosProyecto(id, listaAdjuntos);
		}
		return listaAdjuntos;
	}
	
	public List<DtoAdjuntoProyecto> getAdjuntosProyecto(Long id, List<DtoAdjuntoProyecto> listaAdjuntos) throws IllegalAccessException, InvocationTargetException {
		Activo activo = activoApi.get(id);
		
		if (!Checks.esNulo(activo.getAgrupaciones()) && !Checks.estaVacio(activo.getAgrupaciones())) {
			
			Long codAgrupacion = null;
			Long idAgrupacion = null;
			
			for (ActivoAgrupacionActivo activoAgrupacionActivo : activo.getAgrupaciones()) { //Buscamos si el activo tiene agrupación de tipo Proyecto
				if (DDTipoAgrupacion.AGRUPACION_PROYECTO.equals(activoAgrupacionActivo.getAgrupacion().getTipoAgrupacion().getCodigo())) {
					codAgrupacion = activoAgrupacionActivo.getAgrupacion().getNumAgrupRem();
					idAgrupacion = activoAgrupacionActivo.getAgrupacion().getId();

					Filter filtro = genericDao.createFilter(FilterType.EQUALS, "agrupacion.id", idAgrupacion);
					Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
					List<AdjuntosProyecto> adjuntosProyecto = (List<AdjuntosProyecto>) genericDao.getList(AdjuntosProyecto.class, filtro, filtroBorrado);

					for (AdjuntosProyecto adjuntoProyecto : adjuntosProyecto) {
						DtoAdjuntoProyecto dto = new DtoAdjuntoProyecto();
						BeanUtils.copyProperties(dto, adjuntoProyecto);
						dto.setIdEntidad(activo.getId().toString());
						dto.setDescripcionTipo(adjuntoProyecto.getTipoDocumentoProyecto().getDescripcion());
						dto.setGestor(adjuntoProyecto.getAuditoria().getUsuarioCrear());
						dto.setCodProyecto(codAgrupacion.toString());

						listaAdjuntos.add(dto);
					}
				}
			}			
		}
		return listaAdjuntos;
	}	
	
	public String uploadDocumento(WebFileItem webFileItem, Activo activoEntrada, String matricula) throws Exception {
		Activo activo = activoProyectoApi.get(Long.parseLong(webFileItem.getParameter("idEntidad")));
		if (!Checks.esNulo(activo.getAgrupaciones()) && !Checks.estaVacio(activo.getAgrupaciones())) {
			boolean tieneAgrupacionProyecto = false;
			for (ActivoAgrupacionActivo agrupacion : activo.getAgrupaciones()) {
				if (DDTipoAgrupacion.AGRUPACION_PROYECTO.equals(agrupacion.getAgrupacion().getTipoAgrupacion().getCodigo())) {
					tieneAgrupacionProyecto = true;
					String codAgrupacion = agrupacion.getAgrupacion().getNumAgrupRem().toString();
					if (Checks.esNulo(activoEntrada)) {
						
						if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
							Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
			
							Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", webFileItem.getParameter("tipo"));
							DDTipoDocumentoProyecto tipoDocumento = (DDTipoDocumentoProyecto) genericDao.get(DDTipoDocumentoProyecto.class, filtro);
							Long idDocRestClient = gestorDocumentalAdapterApi.uploadDocumentoProyecto(codAgrupacion, webFileItem,
									usuarioLogado.getUsername(), tipoDocumento.getMatricula());
							activoProyectoApi.upload2(webFileItem, idDocRestClient);
						} else {
							activoProyectoApi.upload(webFileItem);
						}
					} else {
						if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
							Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
							Filter filtro = genericDao.createFilter(FilterType.EQUALS, "matricula", matricula);
							DDTipoDocumentoProyecto tipoDocumento = (DDTipoDocumentoProyecto) genericDao.get(DDTipoDocumentoProyecto.class, filtro);
			
							if (!Checks.esNulo(tipoDocumento)) {
								Long idDocRestClient = gestorDocumentalAdapterApi.uploadDocumentoProyecto(codAgrupacion, webFileItem, usuarioLogado.getUsername(), tipoDocumento.getMatricula());
								activoApi.uploadDocumento(webFileItem, idDocRestClient, activoEntrada, matricula);
							}
						} else {
							activoProyectoApi.uploadDocumento(webFileItem, null, activoEntrada, matricula);
						}
					}
				}
			}
			
			if (!tieneAgrupacionProyecto) {
				throw new Exception("El activo no está en una agrupación de tipo proyecto.");
			}			
		} else {
			throw new Exception("El activo no está en una agrupación de tipo proyecto.");
		}
		return null;
	}
		
	public String upload(WebFileItem webFileItem) throws Exception {
		return uploadDocumento(webFileItem, null, null);

	}
	
	public FileItem download(Long id,String nombreDocumento) throws UserException,Exception {
		FileItem result;
		if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
			String key = appProperties.getProperty(CONSTANTE_REST_CLIENT);
			Downloader dl = downloaderFactoryApi.getDownloader(key);
			result = dl.getFileItem(id,nombreDocumento);
		} else {
			result = activoProyectoApi.download(id);
		}
		if(result == null){
			throw new UserException("El fichero no existe");
		}
		return result;
	}
	
	@Transactional(readOnly = false)
	public boolean deleteAdjunto(DtoAdjunto dtoAdjunto) {
		boolean borrado = false;
		if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
			Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
			try {
				borrado = gestorDocumentalAdapterApi.borrarAdjunto(dtoAdjunto.getId(), usuarioLogado.getUsername());
			} catch (Exception e) {
				logger.error("Error en ProyectoAdapter", e);
			}
		} else {
			borrado = activoProyectoApi.deleteAdjunto(dtoAdjunto);
		}
		return borrado;
	}

}
