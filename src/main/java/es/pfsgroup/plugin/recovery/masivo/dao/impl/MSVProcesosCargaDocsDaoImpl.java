package es.pfsgroup.plugin.recovery.masivo.dao.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.hibernate.HibernateUtils;
import es.pfsgroup.plugin.recovery.masivo.dao.MSVProcesosCargaDocsDao;
import es.pfsgroup.plugin.recovery.masivo.model.MSVDDEstadoProceso;
import es.pfsgroup.plugin.recovery.masivo.model.MSVProcesosCargaDocs;

@Repository("MSVProcesosCargaDocsDao")
public class MSVProcesosCargaDocsDaoImpl extends AbstractEntityDao<MSVProcesosCargaDocs, Long> implements MSVProcesosCargaDocsDao{

	@Autowired
	private GenericABMDao genericDao;

	@Override
	public boolean existeDocSinProcesar(String nombreDocumento) {
		HQLBuilder hb = new HQLBuilder("from MSVProcesosCargaDocs proc");
		HQLBuilder.addFiltroIgualQue(hb, "proc.descripcion", nombreDocumento);
		hb.appendWhere("proc.estadoProceso.codigo <> '" + MSVDDEstadoProceso.CODIGO_PROCESADO + "'");
		hb.appendWhere("proc.estadoProceso.codigo <> '" + MSVDDEstadoProceso.CODIGO_PROCESADO_CON_ERRORES + "'");
		
		return (Checks.esNulo(HibernateQueryUtils.uniqueResult(this, hb)) ? false : true);
	}
	
	@Override
	public MSVProcesosCargaDocs crearNuevoProceso() {
		return new MSVProcesosCargaDocs();
	}

	@Override
    public MSVProcesosCargaDocs get(Long idProceso) {
		MSVProcesosCargaDocs cargaDocs = super.get(idProceso);
        return cargaDocs;
    }
	
	@Override
	public MSVProcesosCargaDocs mergeAndGet(Long idProceso) {
		MSVProcesosCargaDocs proceso = super.get(idProceso);
		return HibernateUtils.merge(proceso);
	}
	

	@Override
	public void mergeAndUpdate(MSVProcesosCargaDocs proceso) {
		super.saveOrUpdate(HibernateUtils.merge(proceso));
	}
	
}
