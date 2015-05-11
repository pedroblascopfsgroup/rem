package es.capgemini.pfs.test.ruleengine.bean.json;

import es.capgemini.pfs.test.ruleengine.bean.ArquetipoTest;
import es.capgemini.pfs.test.ruleengine.bean.Arquetipo_Test_Constants;

/**
 * @author lgiavedo
 *
 */
public class ArquetipoTest2 extends ArquetipoTest {

    public ArquetipoTest2() {
        id = 2L;
        name = "Arquetipo Test II";
        priority = 2L;
        value = "1";
        definitionRule = "{type:'and', rules :[" //
                + "        {type:'compare1', title:'Hombre?', ruleId:"
                + Arquetipo_Test_Constants.DD_RULE_PER_SEXO
                + ", operator: 'equal', values: ['2']}"// 
                + "        ,{type:'or', rules :[" //
                + "            {type:'compare2', operator:'between', title:'Riesgo Persona entre 20-80', ruleId:"
                + Arquetipo_Test_Constants.DD_RULE_PER_RIESGO_2
                + ", values : ['20','80']}" //
                + "            ,{type:'compare1', title:'Riesgo Movimiento > 50', operator:'greaterThan', ruleId:"
                + Arquetipo_Test_Constants.DD_RULE_MOV_RIESGO + ", values : ['50']}" //
                + "        ]}" //
                + "]}";

    }

}
