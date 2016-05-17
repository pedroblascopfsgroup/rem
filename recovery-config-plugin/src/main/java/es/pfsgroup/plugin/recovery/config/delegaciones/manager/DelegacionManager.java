package es.pfsgroup.plugin.recovery.config.delegaciones.manager;

import java.text.ParseException;
import java.text.SimpleDateFormat;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import es.capgemini.devon.beans.Service;
import es.capgemini.pfs.auditoria.model.Auditoria;
import es.capgemini.pfs.users.domain.Usuario;
import es.pfsgroup.commons.utils.Checks;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.Filter;
import es.pfsgroup.commons.utils.dao.abm.GenericABMDao.FilterType;
import es.pfsgroup.plugin.recovery.config.delegaciones.api.DelegacionApi;
import es.pfsgroup.plugin.recovery.config.delegaciones.dto.DelegacionDto;
import es.pfsgroup.plugin.recovery.config.delegaciones.model.DDEstadoDelegaciones;
import es.pfsgroup.plugin.recovery.config.delegaciones.model.Delegacion;

@Service
public class DelegacionManager implements DelegacionApi {
	
	@Autowired
	private GenericABMDao genericDao;

	@Override
	public Delegacion convertDelegacionDtoTODelegacion(DelegacionDto dto) {
		
		Delegacion delegacion = new Delegacion();
		
		if(!Checks.esNulo(dto)){
			
			SimpleDateFormat frmt = new SimpleDateFormat("dd/MM/yyyy");
			
			if(!Checks.esNulo(dto.getId())){
				Filter filter = genericDao.createFilter(FilterType.EQUALS,"id", dto.getId());
				delegacion = genericDao.get(Delegacion.class, filter);
			}
			
			if(!Checks.esNulo(dto.getUsuarioOrigen())){
				Filter filter = genericDao.createFilter(FilterType.EQUALS,"id", dto.getUsuarioOrigen());
				Usuario usuario = genericDao.get(Usuario.class, filter);
				delegacion.setUsuarioOrigen(usuario);	
			}
			
			if(!Checks.esNulo(dto.getUsuarioDestino())){
				Filter filter = genericDao.createFilter(FilterType.EQUALS,"id", dto.getUsuarioDestino());
				Usuario usuario = genericDao.get(Usuario.class, filter);
				delegacion.setUsuarioDestino(usuario);	
			}
			
			if(!Checks.esNulo(dto.getFechaIniVigencia())){
				try {
					delegacion.setFechaIniVigencia(frmt.parse(dto.getFechaIniVigencia()));
				} catch (ParseException e) {
					e.printStackTrace();
				}
			}
			
			if(!Checks.esNulo(dto.getFechaFinVigencia())){
				try {
					delegacion.setFechaFinVigencia(frmt.parse(dto.getFechaFinVigencia()));
				} catch (ParseException e) {
					e.printStackTrace();
				}
			}

			if(!Checks.esNulo(dto.getEstado())){
				Filter filter = genericDao.createFilter(FilterType.EQUALS,"id", dto.getEstado());
				DDEstadoDelegaciones estado = genericDao.get(DDEstadoDelegaciones.class, filter);
				delegacion.setEstado(estado);
			}
			
		}
		
		return delegacion;
	}

	@Override
	@Transactional(readOnly = false)
	public void saveDelegacion(DelegacionDto dto) {
		
		Delegacion delegacion = convertDelegacionDtoTODelegacion(dto);
		Auditoria auditoria = Auditoria.getNewInstance();
		delegacion.setAuditoria(auditoria);
		Filter filter = genericDao.createFilter(FilterType.EQUALS,"codigo", DDEstadoDelegaciones.ACTIVA);
		DDEstadoDelegaciones estado = genericDao.get(DDEstadoDelegaciones.class, filter);
		delegacion.setEstado(estado);
		genericDao.save(Delegacion.class,delegacion);
		
	}

}
