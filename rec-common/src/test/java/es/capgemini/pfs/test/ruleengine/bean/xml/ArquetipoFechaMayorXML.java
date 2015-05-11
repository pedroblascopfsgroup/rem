package es.capgemini.pfs.test.ruleengine.bean.xml;

import es.capgemini.pfs.test.ruleengine.bean.ArquetipoTest;
import es.capgemini.pfs.test.ruleengine.bean.Arquetipo_Test_Constants;

/**
 * @author lgiavedo
 *
 */
public class ArquetipoFechaMayorXML extends ArquetipoTest {

    public ArquetipoFechaMayorXML() {
        id = 1L;
        name = "Arquetipo Fecha Creacion Contrato Menor < 20/12/1900";
        priority = 1L;
        value = "1";
        //definitionRule = "{type:'compare1', title:'Fecha Creacion < 20/12/1900', ruleId:"+Arquetipo_Test_Constants.DD_RULE_CNT_FECHA_CREACION+", operator: 'lessThan', values: ['20/12/1900']}";//
        definitionRule = "<rule type=\"compare1\" title=\"Fecha creacion &lt;20/12/1900\" ruleid=\""
                + Arquetipo_Test_Constants.DD_RULE_CNT_FECHA_CREACION + "\" operator=\"greaterThan\" values=\"[20/12/1900]\" />";
    }

}