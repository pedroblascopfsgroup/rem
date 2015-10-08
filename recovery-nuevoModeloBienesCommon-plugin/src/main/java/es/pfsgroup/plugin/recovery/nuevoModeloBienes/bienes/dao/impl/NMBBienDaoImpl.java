package es.pfsgroup.plugin.recovery.nuevoModeloBienes.bienes.dao.impl;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.hibernate.Query;
import org.hibernate.Session;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import es.capgemini.devon.hibernate.pagination.PaginationManager;
import es.capgemini.devon.pagination.Page;
import es.capgemini.pfs.bien.model.ProcedimientoBien;
import es.capgemini.pfs.bien.model.Bien;
import es.capgemini.pfs.contrato.dto.BusquedaContratosDto;
import es.capgemini.pfs.dao.AbstractEntityDao;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.HQLBuilder;
import es.pfsgroup.commons.utils.HibernateQueryUtils;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.bienes.NMBDtoBuscarBienes;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.bienes.NMBDtoBuscarClientes;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.bienes.dao.NMBBienDao;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBAdicionalBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBAdjudicacionBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBien;
import es.pfsgroup.plugin.recovery.nuevoModeloBienes.model.NMBBienCargas;
import es.pfsgroup.recovery.ext.api.multigestor.dao.EXTGrupoUsuariosDao;

@Repository("NMBBienDao")
public class NMBBienDaoImpl extends AbstractEntityDao<NMBBien, Long> implements NMBBienDao{

	@Resource
	private PaginationManager paginationManager;
	
	@Autowired
	private GenericABMDao genericDao;
	
	@Autowired
	private EXTGrupoUsuariosDao extGrupoUsuariosDao;

    @Override
	public Page buscarBienesPaginados(NMBDtoBuscarBienes dto, Usuario usuLogado) {
    	if (dto.getSort()!=null){
    		if (dto.getSort().equals("poblacion")){
    			dto.setSort("loc.poblacion");    			
    		}else if (dto.getSort().equals("refCatastral")) {
    			dto.setSort("infr.referenciaCatastralBien");
    		} else if (dto.getSort().equals("superficie")) {
    			dto.setSort("infr.superficie");
    		} else {
    			if (dto.getSort().equals("tipo")) dto.setSort("tipoBien.descripcion");
        		dto.setSort(NAME_OF_ENTITY_NMB.concat(".").concat(dto.getSort()));    			
    		}
    	}
    	return paginationManager.getHibernatePage(getHibernateTemplate(), generarHQLBuscarBienesPaginados(dto,usuLogado), dto);
	}

    
	private String generarHQLBuscarBienesPaginados(NMBDtoBuscarBienes dto, Usuario usuLogado) {
        StringBuffer hql = new StringBuffer();
        
        hql.append(" SELECT distinct ".concat(NAME_OF_ENTITY_NMB));
        hql.append(" FROM  NMBBien ".concat(NAME_OF_ENTITY_NMB).concat(" LEFT JOIN "));
        hql.append("	  ".concat(NAME_OF_ENTITY_NMB).concat(".NMBpersonas bieper LEFT JOIN "));
        hql.append("	  ".concat(NAME_OF_ENTITY_NMB).concat(".localizaciones loc LEFT JOIN "));
        hql.append("	  ".concat(NAME_OF_ENTITY_NMB).concat(".informacionRegistral infr LEFT JOIN "));
        hql.append("	  ".concat(NAME_OF_ENTITY_NMB).concat(".valoraciones val LEFT JOIN "));
        hql.append("	  ".concat(NAME_OF_ENTITY_NMB).concat(".contratos biecnt LEFT JOIN "));
        hql.append("	  ".concat(NAME_OF_ENTITY_NMB).concat(".procedimientos prcbie LEFT JOIN"));
        hql.append("	  ".concat("prcbie").concat(".procedimiento prc LEFT JOIN "));
        hql.append("	  ".concat("prc").concat(".asunto asu "));
        hql.append(" WHERE 1=1 AND ");
        hql.append("      ".concat(NAME_OF_ENTITY_NMB).concat(".auditoria.borrado = 0 "));
        
        if(dto.isSolvenciaNoEncontrada()){
        	hql.append(" AND ".concat(NAME_OF_ENTITY_NMB).concat(".solvenciaNoEncontrada = true "));
        }
        if (dto.getId() != null){
        	hql.append(" AND ".concat(NAME_OF_ENTITY_NMB).concat(".id = ".concat(dto.getId().toString())));
        }
 
        if (!Checks.esNulo(dto.getPoblacion())){
            hql.append(" AND UPPER(loc.poblacion) LIKE '%".concat(dto.getPoblacion().toUpperCase()).concat("%')"));
        }
        	
        if (!Checks.esNulo(dto.getCodPostal())){
        	hql.append(" AND loc.codPostal = '".concat(dto.getCodPostal()).concat("'"));
        }

        if (!Checks.esNulo(dto.getIdTipoBien())){
        	hql.append(" AND ".concat(NAME_OF_ENTITY_NMB).concat(".tipoBien.id = '".concat(dto.getIdTipoBien()).concat("'")));
        }

        if (dto.getValorDesde() != null) {
        	hql.append(" AND ".concat(NAME_OF_ENTITY_NMB).concat(".valorActual >= ".concat(dto.getValorDesde().toString())));
        }
        
        if (dto.getValorHasta() != null) {
        	hql.append(" AND ".concat(NAME_OF_ENTITY_NMB).concat(".valorActual <= ".concat(dto.getValorHasta().toString())));
        }
        
        if (!Checks.esNulo(dto.getNumContrato())){
        	String numCntTrim = dto.getNumContrato().replaceAll(" ", ""); //No funcionaba el trim()
        	//Quito los "0" por delante del nro. contrato
        	for (int i=0;i<numCntTrim.length();i++) {
        		char charCnt = numCntTrim.charAt(i); 
        		if (charCnt != '0') {
        			numCntTrim = numCntTrim.substring(i, numCntTrim.length());
        			break;
        		}
        	}
        	hql.append(" AND UPPER(biecnt.contrato.nroContrato) like '%".concat(numCntTrim.toUpperCase()).concat("%'"));
        }
        
        if (!Checks.esNulo(dto.getNifPrimerTitular())){
        	hql.append(" AND '".concat(dto.getNifPrimerTitular().toUpperCase()).concat("'"));
        	hql.append("	IN (SELECT UPPER(cp.persona.docId) FROM biecnt.contrato.contratoPersona cp ");
        	hql.append("  		WHERE cp.tipoIntervencion.titular = 1) ");
        }
        
        if (!Checks.esNulo(dto.getCodCliente())){
        	hql.append(" AND bieper.persona.codClienteEntidad = ".concat(dto.getCodCliente()));
        }
        
        if (!Checks.esNulo(dto.getNifCliente())){
        	hql.append(" AND UPPER(bieper.persona.docId) = '".concat(dto.getNifCliente().toUpperCase()).concat("'"));
        }
        
        
        //Nuevos filtros datos del bien

        if (dto.getNumActivo() != null){
        	hql.append(" AND ".concat(NAME_OF_ENTITY_NMB).concat(".numeroActivo = '").concat(dto.getNumActivo().toString()).concat("'"));
        }
        if (dto.getNumRegistro() != null){
        	hql.append(" AND ".concat(NAME_OF_ENTITY_NMB).concat(".codigoInterno = ".concat(dto.getNumRegistro().toString())));
        }
        if (!Checks.esNulo(dto.getReferenciaCatastral())){
        	hql.append(" AND UPPER(infr.referenciaCatastralBien) = '".concat(dto.getReferenciaCatastral().toString().toUpperCase()).concat("'"));
        }
        if (dto.getSubtipoBien() != null){
        	//TODO
        }
        if (dto.getTasacionDesde() != null){
        	hql.append(" AND val.valorTasacionExterna >= ".concat(dto.getTasacionDesde().toString()));
        }
        if (dto.getTasacionHasta() != null){
        	hql.append(" AND val.valorTasacionExterna <= ".concat(dto.getTasacionHasta().toString()));
        }
        if (dto.getTipoSubastaDesde() != null){
        	hql.append(" AND ".concat(NAME_OF_ENTITY_NMB).concat(".tipoSubasta >= ".concat(dto.getTipoSubastaDesde().toString())));
        }
        if (dto.getTipoSubastaHasta() != null){
        	hql.append(" AND ".concat(NAME_OF_ENTITY_NMB).concat(".tipoSubasta <= ".concat(dto.getTipoSubastaHasta().toString())));
        }
        
        //filtros pestaña localizacion        
        if (!Checks.esNulo(dto.getDireccion())){
            hql.append(" AND UPPER(loc.direccion) LIKE '%".concat(dto.getDireccion().toUpperCase()).concat("%')"));
        }  
        if (!Checks.esNulo(dto.getProvincia())){
            hql.append(" AND UPPER(loc.provincia.descripcion) LIKE '%".concat(dto.getProvincia().toUpperCase()).concat("%')"));
        }  
        if (!Checks.esNulo(dto.getLocalidad())) {
            hql.append(" AND UPPER(loc.poblacion) LIKE '%".concat(dto.getLocalidad().toUpperCase()).concat("%')"));
        }        	
        if (!Checks.esNulo(dto.getCodigoPostal())){
        	hql.append(" AND loc.codPostal = '".concat(dto.getCodigoPostal()).concat("'"));
        }
        
        if (usuLogado.getUsuarioExterno()) {
        	hql.append(hqlFiltroEsGestorAsunto(usuLogado));
        }
        
        if(!Checks.esNulo(dto.getNumFinca())) {
            hql.append(" AND UPPER( infr.numFinca) = '".concat(dto.getNumFinca().toString().toUpperCase()).concat("'"));    	
        }

        hqlFiltroCargas(dto, hql);

/*      if (!emtpyString(dto.getCodCliente())){
    		hql.append(" AND bieper IN ( SELECT bieper FROM NMBPersonasBien WHERE bieper.persona.codClienteEntidad = ".concat(dto.getCodCliente()).concat(")"));
    	}
*/      
        return hql.toString();
	}
	
	private void hqlFiltroCargas(NMBDtoBuscarBienes dto,StringBuffer hql) {
		if (dto.getTotalCargasDesde()==null && dto.getTotalCargasHasta()==null) {
			return;
		}
		StringBuilder havingClause = new StringBuilder();
		
		if (dto.getTotalCargasDesde()!=null) {
			havingClause.append("SUM(CASE WHEN coalesce(reg.codigo,'')='ACT' THEN coalesce(carga.importeRegistral,0) ELSE 0 END + ")
			.append("CASE WHEN coalesce(eco.codigo,'')='ACT' THEN coalesce(carga.importeEconomico,0) ELSE 0 END) >= ")
			.append(dto.getTotalCargasDesde());
		}
		if (dto.getTotalCargasHasta()!=null) {
			if (havingClause.length()>0) havingClause.append(" AND ");
			havingClause.append("SUM(CASE WHEN coalesce(reg.codigo,'')='ACT' THEN coalesce(carga.importeRegistral,0) ELSE 0 END + ")
			.append("CASE WHEN coalesce(eco.codigo,'')='ACT' THEN coalesce(carga.importeEconomico,0) ELSE 0 END) <= ")
			.append(dto.getTotalCargasHasta());
		}
		
		hql.append(" AND (");
		if ((dto.getTotalCargasDesde()!=null && dto.getTotalCargasHasta()==null && dto.getTotalCargasDesde()<=0) || 
				(dto.getTotalCargasDesde()==null && dto.getTotalCargasHasta()!=null && dto.getTotalCargasHasta()>=0) ||
				(dto.getTotalCargasDesde()!=null && dto.getTotalCargasHasta()!=null && dto.getTotalCargasDesde()<=0 && dto.getTotalCargasHasta()>=0)) {
			hql.append(NAME_OF_ENTITY_NMB).append(".bienCargas is empty or ");
		}
		hql.append(NAME_OF_ENTITY_NMB).append(".id in (select bien.id from NMBBienCargas carga ")
			.append("join carga.bien bien ")
			.append("left join carga.situacionCargaEconomica eco ")
			.append("left join carga.situacionCarga reg ")
			.append("group by bien.id ")
			.append("having ");
		hql.append(havingClause);
		hql.append("))");
		
	}
	
	private String hqlFiltroEsGestorAsunto(Usuario usuLogado) {
		String monogestor = " (asu.id in (select a.id from Asunto a where a.gestor.usuario.id = "
				+ usuLogado.getId() + "))";
		//String multigestor = " (asu.id in (select gaa.asunto.id from EXTGestorAdicionalAsunto gaa where gaa.gestor.usuario.id = "+ +usuLogado.getId() + "))";
		
		List<Long> idsGrpUsuario = extGrupoUsuariosDao.buscaGruposUsuario(usuLogado);
		String multigestor = filtroGestorGrupo(idsGrpUsuario);
		if(!Checks.esNulo(multigestor)){
			return " and (" + monogestor + " or " + multigestor + ")";
		}
		else
			return " and ("+monogestor+")";
	}
	
	private String filtroGestorGrupo(List<Long> idsUsuariosGrupo) {
		if (idsUsuariosGrupo==null || idsUsuariosGrupo.size()==0)
			return "";
		
		StringBuilder hql = new StringBuilder();
		
		hql.append("(asu.id in (");
		hql.append("select gaa.asunto.id from EXTGestorAdicionalAsunto gaa  ");
		hql.append("where gaa.gestor.usuario.id IN (");
		
		StringBuilder idsUsuarios = new StringBuilder();
		for (Long idUsario : idsUsuariosGrupo) {
			idsUsuarios.append("," + idUsario.toString());
		}
		if (idsUsuarios.length()>1)
			hql.append(idsUsuarios.deleteCharAt(0).toString());
		
		hql.append(")))");
		return hql.toString();
	}

	@Override
	public Page buscarClientesPaginados(NMBDtoBuscarClientes dto) {
		HQLBuilder b = new HQLBuilder("from Persona");
		HQLBuilder.addFiltroLikeSiNotNull(b, "nombre", dto.getNombre(),true);
		HQLBuilder.addFiltroLikeSiNotNull(b, "apellido1", dto.getApellido1(),true);
		HQLBuilder.addFiltroLikeSiNotNull(b, "apellido2", dto.getApellido2(),true);
		HQLBuilder.addFiltroLikeSiNotNull(b, "docId", dto.getDocId(),true);
		
		return HibernateQueryUtils.page(this, b, dto);
	}
	
	@Override
	public Page buscarContratosPaginados(BusquedaContratosDto dto) {
		HQLBuilder b = new HQLBuilder("from Contrato");
		HQLBuilder.addFiltroLikeSiNotNull(b, "nroContrato", dto.getDescripcion() ,true);
		
		return HibernateQueryUtils.page(this, b, dto);
	}	

	@Override
	public void saveOrUpdateAdjudicados(NMBAdjudicacionBien adjudicacion) {
		
		if (adjudicacion.getIdAdjudicacion() != null) {
			Session session = getHibernateTemplate().getSessionFactory().getCurrentSession();
			session.merge(adjudicacion);
			
		} else {
			NMBBien bien = adjudicacion.getBien();
			bien.setAdjudicacion(adjudicacion);
			genericDao.save(NMBAdjudicacionBien.class, adjudicacion);
			this.update(bien);
			
		}
		
	}
	
	@Override
	public void saveOrUpdateAdicional(NMBAdicionalBien adicional) {
		
		if (adicional.getId() != null) {
			Session session = getHibernateTemplate().getSessionFactory().getCurrentSession();
			session.merge(adicional);
			
		} else {
			NMBBien bien = adicional.getBien();
			bien.setAdicional(adicional);;
			this.update(bien);
			
		}
	}
	
	@Override
	public void saveOrUpdateCarga(NMBBienCargas carga) {
		
		if (carga.getIdCarga() == null) {
			Session session = getHibernateTemplate().getSessionFactory().getCurrentSession();
			session.save(carga);			
		} else {
			genericDao.update(NMBBienCargas.class, carga);			
		}	
	}
	
	@Override
	public List<NMBBien> getBienesPorCodigoInterno(Long codigo) {
		List<NMBBien> listaBienes = new ArrayList<NMBBien>();
		HQLBuilder b = new HQLBuilder("select b from NMBBien b");
		b.appendWhere("b.codigoInterno=" + codigo);
		listaBienes = HibernateQueryUtils.list(this, b);
		return listaBienes;
	}
	
	@Override
	public List<NMBBien> getBienesPorId(Long id) {
		List<NMBBien> listaBienes = new ArrayList<NMBBien>();
		HQLBuilder b = new HQLBuilder("select b from NMBBien b");
		b.appendWhere("b.id=" + id);
		listaBienes = HibernateQueryUtils.list(this, b);
		return listaBienes;
	}

	@Override
	public List<ProcedimientoBien> getBienesPorProcedimientos(List<Long> idsProcedimiento) {
    	Query q = getHibernateTemplate()
                .getSessionFactory()
                .getCurrentSession()
                .createQuery("from ProcedimientoBien pb where pb.procedimiento.id in (:ids)");
        q.setParameterList("ids", idsProcedimiento);
        return q.list();
		
	}
	
	@Override
	public List<NMBBien> getBienesPorNumFincaActivo(String numFinca, String numActivo) {
		List<NMBBien> listaBienes = new ArrayList<NMBBien>();
		StringBuilder sb = new StringBuilder();
		sb.append(" select infoRegBien.bien from NMBInformacionRegistralBien infoRegBien ");
		sb.append(" where 1=1 ");
		if(!Checks.esNulo(numFinca)) {
			sb.append(" and infoRegBien.numFinca = '" + numFinca + "' ");
		}
		if(!Checks.esNulo(numActivo)) {
			sb.append(" and infoRegBien.bien.numeroActivo='" + numActivo + "' ");
		}
		Query q = getSession().createQuery(sb.toString());	
		listaBienes = q.list();
		return listaBienes;
	}
	
	@Override
	public List<Bien> getSolvenciasDeUnProcedimiento(Long idProcedimiento){
		List<Bien> listaBienes = new ArrayList<Bien>();
		
		StringBuilder sb = new StringBuilder();
    	sb.append(" SELECT distinct bien ");
    	sb.append(" FROM ProcedimientoPersona prcPer ");
    	sb.append(" LEFT JOIN prcPer.persona.bienes bien");
    	sb.append(" WHERE 1=1 ");
    	sb.append(" AND bien.auditoria.borrado = 0 ");
    	sb.append(" AND prcPer.procedimiento.id = ").append(idProcedimiento);
    	
		Query q = getSession().createQuery(sb.toString());	
		listaBienes = q.list();
		return listaBienes;
	}
	
}
