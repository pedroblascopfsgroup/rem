package es.pfsgroup.plugin.recovery.sidhiweb.infoJudicial.dao.impl;

import java.util.List;

import org.hibernate.Query;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.recovery.sidhiweb.infoJudicial.dao.SIDHIAccionJudicialDao;
import es.pfsgroup.plugin.recovery.sidhiweb.infoJudicial.dto.SIDHIAccionJudicialDto;
import es.pfsgroup.plugin.recovery.sidhiweb.infoJudicial.dto.SIDHIDtoBuscarAcciones;
import es.pfsgroup.plugin.recovery.sidhiweb.infoJudicial.model.SIDHIAccionJudicial;
import es.pfsgroup.plugin.recovery.sidhiweb.infoJudicial.model.SIDHIDatEacEstadoAccion;

@Repository("SIDHIAccionJudicialDao")
public class SIDHIAccionJudicialDaoImpl extends AbstractEntityDao<SIDHIAccionJudicial, Long> implements SIDHIAccionJudicialDao{

	@Autowired
	private GenericABMDao genericDao;

	@Override
	public Page findAccionesByIdAsunto(SIDHIDtoBuscarAcciones dto) {
		HQLBuilder hb = new HQLBuilder("from SIDHIAccionJudicial acc");
		hb.appendWhere("acc.auditoria.borrado=false and acc.idAccion!=null");
		
		HQLBuilder.addFiltroIgualQue(hb, "acc.iter.procedimiento.asunto.id", dto.getIdAsunto());
		
		hb.orderBy("fechaAccion", HQLBuilder.ORDER_DESC);
		
		return HibernateQueryUtils.page(this, hb, dto);
	}

	@Override
	public Page findAccionesByIdExpediente(SIDHIDtoBuscarAcciones dto) {
		HQLBuilder hb = new HQLBuilder("from SIDHIAccionJudicial acc");
		hb.appendWhere("acc.auditoria.borrado=false and acc.idAccion!=null");
		
		HQLBuilder.addFiltroIgualQue(hb, "acc.iter.procedimiento.asunto.expediente.id", dto.getIdExpediente());
		
		//hb.orderBy("id", HQLBuilder.ORDER_ASC);
		
		return HibernateQueryUtils.page(this, hb, dto);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<SIDHIAccionJudicial> getAccionJudicial( SIDHIAccionJudicialDto dto ){
		
		HQLBuilder hb = new HQLBuilder("from SIDHIAccionJudicial acc");

		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "acc.tipoJuicio", dto.getTipoJuicio());
		HQLBuilder.addFiltroIgualQue(hb, "acc.estadoProcesal.id", dto.getEstadoProcesal());
		HQLBuilder.addFiltroIgualQue(hb, "acc.codigoInterfaz", dto.getCodInterfaz());
		HQLBuilder.addFiltroIgualQueSiNotNull(hb, "acc.subestadoProcesal.id", dto.getSubestadoProcesal());
		
		return HibernateQueryUtils.list(this, hb);
	}
	
	public void updateAccionJudicial( SIDHIAccionJudicial accionJudicial ){
		
		SIDHIAccionJudicial objAccionJudicial = new SIDHIAccionJudicial();
		
		objAccionJudicial.setCodigoInterfaz(accionJudicial.getCodigoInterfaz());
		objAccionJudicial.setEstadoAccion(accionJudicial.getEstadoAccion());
		objAccionJudicial.setEstadoProcesal(accionJudicial.getEstadoProcesal());
		objAccionJudicial.setFechaAccion(accionJudicial.getFechaAccion());
		objAccionJudicial.setId(accionJudicial.getId());
		objAccionJudicial.setIdAccion(accionJudicial.getIdAccion());
		objAccionJudicial.setIter(accionJudicial.getIter());
		objAccionJudicial.setProcesada(accionJudicial.getProcesada());
		objAccionJudicial.setSubestadoProcesal(accionJudicial.getSubestadoProcesal());
		objAccionJudicial.setTipoJuicio(accionJudicial.getTipoJuicio());
		objAccionJudicial.setValores(accionJudicial.getValores());
		
		genericDao.update(SIDHIAccionJudicial.class, accionJudicial);
	}

}
