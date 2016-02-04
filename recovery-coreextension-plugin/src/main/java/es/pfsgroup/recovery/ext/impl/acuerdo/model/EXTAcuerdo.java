package es.pfsgroup.recovery.ext.impl.acuerdo.model;

import javax.persistence.Entity;
import javax.persistence.Transient;

import org.hibernate.proxy.HibernateProxy;

import es.capgemini.pfs.acuerdo.model.Acuerdo;


/**
 * Esta clase esta deprecada. <br>
 * <b>Utilizar es.capgemini.pfs.acuerdo.model.Acuerdo</b><br>
 * 
 * @author cperez
 *
 */
@Entity
public class EXTAcuerdo extends Acuerdo {

	//***************ATENCIÓN NO METAIS NADA AQUI***************
	// USAR es.capgemini.pfs.acuerdo.model.Acuerdo

	@Transient
	public static EXTAcuerdo instanceOf(Acuerdo acuerdo) {
		EXTAcuerdo extAcuerdo = null;
		if (acuerdo == null) return null;
	    if (acuerdo instanceof HibernateProxy) {
	    	extAcuerdo = (EXTAcuerdo) ((HibernateProxy) acuerdo).getHibernateLazyInitializer()
	                .getImplementation();
	    } else if (acuerdo instanceof EXTAcuerdo){
	    	extAcuerdo = (EXTAcuerdo) acuerdo;
		}
		return extAcuerdo;
	}
}
