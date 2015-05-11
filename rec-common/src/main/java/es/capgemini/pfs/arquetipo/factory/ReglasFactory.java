package es.capgemini.pfs.arquetipo.factory;

/**
 * Interface para que se implemente una factoria de validadores de reglas del arquetipo 
 * para indicar si la regla esta usada por alguna entidad que no le permita ser editada
 * Por ejemplo, las carteras de recobro.
 * @author carlos
 *
 */

public interface ReglasFactory {
	Boolean isReglaEditable(Long idRegla);
}
