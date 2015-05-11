package es.pfsgroup.recovery.ext.impl.multigestor.comparator;

import java.text.Collator;
import java.util.Comparator;

import es.capgemini.pfs.users.domain.Usuario;

/**
 * Comparador para ordenar una lista de {@link Usuario} por el campo
 * {@link Usuario#getApellidoNombre()}
 * 
 * @author manuel
 * 
 */
public class EXTUsuarioComparatorByApellidosNombre implements
		Comparator<Usuario> {

	private Collator collator;

	public EXTUsuarioComparatorByApellidosNombre(Collator collator) {
		this.collator = collator;
	}

	@Override
	public int compare(Usuario arg0, Usuario arg1) {

		if (arg0 == null || arg1 == null) {
			if (arg1 == null)
				return -1;
			if (arg0 == null)
				return 1;
			return 0;
		} else {
			return this.collator.compare(arg0.getApellidoNombre(),
					arg1.getApellidoNombre());
		}
	}

}
