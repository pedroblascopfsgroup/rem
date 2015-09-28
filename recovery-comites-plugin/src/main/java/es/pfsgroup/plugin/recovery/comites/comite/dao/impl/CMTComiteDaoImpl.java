package es.pfsgroup.plugin.recovery.comites.comite.dao.impl;

import org.springframework.stereotype.Repository;

import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.Conversiones;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.plugin.recovery.comites.comite.dao.CMTComiteDao;
import es.pfsgroup.plugin.recovery.comites.comite.dto.CMTDtoBusquedaComite;
import es.pfsgroup.plugin.recovery.comites.comite.model.CMTComite;

@Repository("CMTComiteDao")
public class CMTComiteDaoImpl extends AbstractEntityDao<CMTComite, Long> implements CMTComiteDao{

	@Override
	public Page findComites(CMTDtoBusquedaComite dto) {
		//HQLBuilder hb= new HQLBuilder("from CMTComite cmt");
		HQLBuilder hb = null;
		if(Checks.esNulo(dto.getItinerario())){
			hb = new HQLBuilder(
			"select distinct cmt from CMTComite cmt left join cmt.puestosComites p");
		}else{
			hb = new HQLBuilder(
			"select distinct cmt from CMTComIti citi left join citi.comite cmt left join cmt.puestosComites p");
			hb.appendWhere("citi.auditoria.borrado=0");
		}
		
		//HQLBuilder hb = new HQLBuilder(
		//"select distinct cmt from CMTComite cmt left join cmt.itinerarios iti");
		
		//HQLBuilder hb = new HQLBuilder(
		//		"select  cmt " +
		//		"from CMTComite cmt " +
		//		"						inner join CMTComIti comiti" +
		//		" where cmt.id=comiti.comite.id"  ); 
				
		
		
		hb.appendWhere("cmt.auditoria.borrado=0");
		
		HQLBuilder.addFiltroLikeSiNotNull(hb, "cmt.nombre", dto.getNombre(),true);
		
		HQLBuilder.addFiltroBetweenSiNotNull(hb, "cmt.atribucionMinima", dto.getAtribucionMinima(), dto.getAtribucionMaxima());
		
		HQLBuilder.addFiltroBetweenSiNotNull(hb, "cmt.atribucionMaxima", dto.getAtribucionMinima(), dto.getAtribucionMaxima());
		
		HQLBuilder.addFiltroWhereInSiNotNull(hb, "p.perfil", Conversiones.createLongCollection(dto.getPerfiles(), ","));
		
		HQLBuilder.addFiltroLikeSiNotNull(hb, "citi.itinerario.id", dto.getItinerario());
		
		
		HQLBuilder.addFiltroWhereInSiNotNull(hb, "cmt.zona.id", Conversiones.createLongCollection(dto.getCentros(), ","));
		
		return HibernateQueryUtils.page(this, hb, dto);
	}

	@Override
	public CMTComite createNewComite() {
		CMTComite comite= new CMTComite();
		//comite.setId(getLastId()+1);
		return comite;
	}
	
	public Long getLastId(){
		HQLBuilder b = new HQLBuilder("select max(id) from Comite");
		return (Long) getSession().createQuery(b.toString()).uniqueResult();
	}

}
