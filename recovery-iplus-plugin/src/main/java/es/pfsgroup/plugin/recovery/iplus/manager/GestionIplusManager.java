package es.pfsgroup.plugin.recovery.iplus.manager;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.bo.annotations.BusinessOperation;
import es.capgemini.devon.files.FileItem;
import es.capgemini.pfs.asunto.model.AdjuntoAsunto;
import es.capgemini.pfs.asunto.model.Asunto;
import es.capgemini.pfs.utils.ZipUtils;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.iplus.GestionIplusFacade;
import es.pfsgroup.plugin.recovery.iplus.model.MapeoTipoDocOrden;
import es.pfsgroup.recovery.ext.impl.asunto.model.EXTAsunto;

/**
 * Clase donde está toda la lógica de negocio para la gestión de Iplus
 * @author pedro
 *
 */
@Component
public class GestionIplusManager implements GestionIplusApi {

	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private GestionIplusFacade iplusFacade;
        
        @Autowired
        private ZipUtils zipUtils;
	
	@Override
	@BusinessOperation(PLUGIN_IPLUS_MAPEO_TIPODOC_NUMORDEN_BO)
	public int obtenerNumOrdenDeTipoDoc(String tipoDoc) {
		Filter f1 = genericDao.createFilter(FilterType.EQUALS, "tipoFichero.codigo", tipoDoc);
		MapeoTipoDocOrden m = genericDao.get(MapeoTipoDocOrden.class, f1);
		if (m != null && m.getNumOrden() != null) {
			return m.getNumOrden();
		} else {
			return 1;
		}
	}

	@Override
	@BusinessOperation(PLUGIN_IPLUS_MAPEO_NUMORDEN_TIPODOC_BO)
	public String obtenerTipoDocDeNumOrden(int numOrden) {
		Filter f1 = genericDao.createFilter(FilterType.EQUALS, "numOrden", numOrden);
		MapeoTipoDocOrden m = genericDao.get(MapeoTipoDocOrden.class, f1);
		if (m != null && m.getTipoFichero() != null && m.getTipoFichero().getCodigo() != null) {
			return m.getTipoFichero().getCodigo();
		} else {
			return "";
		}
	}

	@Override
	@BusinessOperation(PLUGIN_IPLUS_BAJAR_ADJUNTO_BO)
	public FileItem bajarAdjunto(Long idAsunto, String nombre, String descripcion) {
		
		System.out.println("[GestionIplusManager.bajarAdjunto] idAsunto: " + idAsunto + ", nombre: " + nombre + ", descripcion: " + descripcion);
		
		String idProcedi = obtenerIdAsuntoExterno(idAsunto);
		
		//FASE-1166 Intento de diagnostico error solo produccion (eliminar siguiente linea al resolver link)
		System.out.println("[GestionIplusManager.bajarAdjunto] idProcedi: " + idProcedi);
		
		FileItem fi = iplusFacade.abrirDocumento(idProcedi , nombre, descripcion);

		//FASE-1166 Intento de diagnostico error solo produccion (eliminar siguiente linea al resolver link)
		System.out.println("[GestionIplusManager.bajarAdjunto] fi (FileItem) (1): " + fi.toString() + ", Filename: " + fi.getFileName() + ", ContentType: "+fi.getContentType()+ ", Descripcion: " + descripcion);
		
		if (fi.getContentType() == null || "".equals(fi.getContentType())) {
			fi.setContentType("text/html");
		}
		fi.setFileName(descripcion);

		//FASE-1166 Intento de diagnostico error solo produccion (eliminar siguientes lineas al resolver link)
		System.out.println("[GestionIplusManager.bajarAdjunto] fi (FileItem) (2): " + fi.toString() + ", Filename: " + fi.getFileName() + ", ContentType: "+fi.getContentType()+ ", Descripcion: " + descripcion);
		System.out.println("[GestionIplusManager.bajarAdjunto] fi (FileItem) (3), File: " + fi.getFile().toString() + ", FileLength: " + fi.getLength());
		
		if (zipUtils.esDescargaZip(fi.getFileName())) {
            return zipUtils.zipFileItem(fi);
        } else {
            return fi;
        }
	}

	private String obtenerIdAsuntoExterno(Long id) {
		Filter f1 = genericDao.createFilter(FilterType.EQUALS, "id", id);
		EXTAsunto m = genericDao.get(EXTAsunto.class, f1);
		if (m != null && m.getCodigoExterno() != null && !m.getCodigoExterno().equals("")) {
			return m.getCodigoExterno();
		} else {
			return "0";
		}
	}

	@Override
	@BusinessOperation(PLUGIN_IPLUS_BORRAR_ADJUNTO_IPLUS_BO)
	public void borrarAdjuntoIplus(Long idAsunto, String nombre, String descripcion) {
		System.out.println("[GestionIplusManager.borrarAdjuntoIplus] idAsunto: " + idAsunto + ", nombre: " + nombre + ", descripcion: " + descripcion);
		String idProcedi = obtenerIdAsuntoExterno(idAsunto);
		iplusFacade.borrarDocumento(idProcedi, nombre, descripcion);
	}
	
    /**
     * delete un adjunto.
     * @param asuntoId long
     * @param adjuntoId long
     */
	@BusinessOperation(PLUGIN_IPLUS_BORRAR_ADJUNTO_BO)
    @Transactional(readOnly = false)
    public void borrarAdjunto(Long asuntoId, Long adjuntoId) {
		Filter f1 = genericDao.createFilter(FilterType.EQUALS, "id", asuntoId);
		EXTAsunto asunto = genericDao.get(EXTAsunto.class, f1);
        AdjuntoAsunto adj = asunto.getAdjunto(adjuntoId);
        if (adj == null) { return; }
        asunto.getAdjuntos().remove(adj);
        genericDao.save(Asunto.class,asunto);
    }

}
