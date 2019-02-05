package es.pfsgroup.plugin.rem.adapter;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import es.capgemini.devon.beans.Service;
import es.capgemini.devon.files.FileItem;
import es.capgemini.devon.files.WebFileItem;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.OrderType;
import es.pfsgroup.commons.utils.dao.abm.Order;
import es.pfsgroup.plugin.gestorDocumental.dto.documentos.CrearRelacionExpedienteDto;
import es.pfsgroup.plugin.rem.activo.ActivoManager;
import es.pfsgroup.plugin.rem.api.ActivoApi;
import es.pfsgroup.plugin.rem.gencat.GencatManager;
import es.pfsgroup.plugin.rem.gestorDocumental.api.GestorDocumentalAdapterApi;
import es.pfsgroup.plugin.rem.model.Activo;
import es.pfsgroup.plugin.rem.model.ComunicacionGencat;
import es.pfsgroup.plugin.rem.model.dd.DDTipoDocumentoComunicacion;


@Service
public class GencatAdapter {
	
	private static final String RELACION_TIPO_DOCUMENTO_EXPEDIENTE = "d-e";	
	private static final String OPERACION_ALTA = "Alta";	
	
	@Autowired
	private GencatManager gencatManager;
	
	@Autowired
	private GestorDocumentalAdapterApi gestorDocumentalAdapterApi;
	
	@Autowired
	private GenericAdapter genericAdapter;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private ActivoApi activoApi;
	
	@Autowired
	private ActivoManager activoManager;

	private String uploadDocumento(WebFileItem webFileItem, Activo activoEntrada, String matricula) throws Exception {

			Usuario usuarioLogado = genericAdapter.getUsuarioLogado();
			Activo activo = activoApi.get(Long.parseLong(webFileItem.getParameter("idEntidad")));

			Filter filtro = genericDao.createFilter(FilterType.EQUALS, "codigo", webFileItem.getParameter("tipo"));
			DDTipoDocumentoComunicacion tipoDocumento = genericDao.get(DDTipoDocumentoComunicacion.class, filtro);

			//Datos comunicación
			Filter filtroComunicacionIdActivo = genericDao.createFilter(FilterType.EQUALS, "activo.id", activo.getId());
			Filter filtroBorrado = genericDao.createFilter(FilterType.EQUALS, "auditoria.borrado", false);
			Order orderByFechaCrear = new Order(OrderType.DESC, "auditoria.fechaCrear");
			List <ComunicacionGencat> resultComunicacion = genericDao.getListOrdered(ComunicacionGencat.class, orderByFechaCrear, filtroComunicacionIdActivo, filtroBorrado);
			ComunicacionGencat comunicacionGencat = null;
			if (!Checks.esNulo(resultComunicacion) && !resultComunicacion.isEmpty()) {
				comunicacionGencat = resultComunicacion.get(0);
			}
						
			if (gestorDocumentalAdapterApi.modoRestClientActivado()) {
				
				if (!Checks.esNulo(tipoDocumento)) {
					Long idDocRestClient = gestorDocumentalAdapterApi.uploadDocumentoComunicacionGencat(comunicacionGencat, webFileItem, usuarioLogado.getUsername(), tipoDocumento.getMatricula());
					gencatManager.uploadDocumento(webFileItem, idDocRestClient,null,null,usuarioLogado,comunicacionGencat);
			
						CrearRelacionExpedienteDto crearRelacionExpedienteDto = new CrearRelacionExpedienteDto();
						crearRelacionExpedienteDto.setTipoRelacion(RELACION_TIPO_DOCUMENTO_EXPEDIENTE);
						String mat = tipoDocumento.getMatricula();
						if(!Checks.esNulo(mat)){
							String[] matSplit = mat.split("-");
							crearRelacionExpedienteDto.setCodTipoDestino(matSplit[0]);
							crearRelacionExpedienteDto.setCodClaseDestino(matSplit[1]);
						}
						crearRelacionExpedienteDto.setOperacion(OPERACION_ALTA);
						gestorDocumentalAdapterApi.crearRelacionActivosComunicacion(comunicacionGencat, idDocRestClient, activo, usuarioLogado.getUsername(),crearRelacionExpedienteDto);
						if(!Checks.esNulo(tipoDocumento.getTipoDocumentoActivo())) {
							webFileItem.putParameter("tipo", tipoDocumento.getTipoDocumentoActivo().getCodigo());
						}
					
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
			else {
				gencatManager.uploadDocumento(webFileItem, null, null, null, usuarioLogado,comunicacionGencat);
			}					
		return null;
	}
	
	public String upload(WebFileItem webFileItem) throws Exception {
		return uploadDocumento(webFileItem, null, null);

	}
	
}
