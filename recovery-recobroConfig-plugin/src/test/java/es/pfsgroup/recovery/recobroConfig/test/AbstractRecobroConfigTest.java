package es.pfsgroup.recovery.recobroConfig.test;

import java.util.Random;

/**
 * Clase abstracta para todos los test, contiene los métodos que hay que hacer antes y después de cada test
 * 
 * @author Diana
 *
 */

public abstract class AbstractRecobroConfigTest {
	
	protected Random random;
    /*
     * Métodos para inicializar cada test
     */
    public abstract void childBefore();

    public abstract void childAfter();

}
