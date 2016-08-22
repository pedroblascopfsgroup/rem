package es.pfsgroup.framework.paradise.bulkUpload.dao.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.framework.paradise.bulkUpload.dao.MSVFicheroDao;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVDocumentoMasivo;
import es.pfsgroup.framework.paradise.bulkUpload.model.MSVProcesoMasivo;

@Repository("FicheroDao")
public class MSVFicheroDaoImpl extends AbstractEntityDao<MSVDocumentoMasivo, Long> implements MSVFicheroDao {


	@Autowired
	private GenericABMDao genericDao;
	
	
	@Override
	public MSVDocumentoMasivo crearNuevoDocumentoMasivo() {
		return new MSVDocumentoMasivo();
	}

	@Override
	public String obtenerErrores(Long idFichero) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public MSVProcesoMasivo alta() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public MSVProcesoMasivo update(String idProceso, String nuevoEstado) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String eliminarArchivo(Long idProceso,MSVDocumentoMasivo documentoMasivo ) {
		MSVDocumentoMasivo archivoEliminar=genericDao.get(MSVDocumentoMasivo.class, genericDao.createFilter(FilterType.EQUALS, "id", documentoMasivo.getId()));
		if(archivoEliminar.getAuditoria().isBorrado()){
			return "ok";
		}else{
			return "no borrado";
		}
	}

	@Override
	public MSVDocumentoMasivo findByIdProceso(long idProceso) {
		HQLBuilder hb = new HQLBuilder("from MSVDocumentoMasivo doc");
		hb.appendWhere(Auditoria.UNDELETED_RESTICTION);
		HQLBuilder.addFiltroIgualQue(hb, "doc.procesoMasivo.id", idProceso);
		
		return HibernateQueryUtils.uniqueResult(this, hb);
	}
}
